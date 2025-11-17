USE dataset_b3;
GO

-- Remove procedures antigas, se existirem

    PRINT 'Atualizando dados tabela';

DROP PROCEDURE IF EXISTS SP_ETL_HISTORICO;
DROP PROCEDURE IF EXISTS SP_CARREGA_CSV_HISTORICO;
DROP PROCEDURE IF EXISTS SP_TRATA_CSV_HISTORICO;
DROP PROCEDURE IF EXISTS SP_EXTRAI_CSV_HISTORICO;
GO


------------------------------------------------------------
-- ⿡ EXTRAÇÃO - Lê o CSV e carrega na staging global
------------------------------------------------------------
CREATE PROCEDURE SP_EXTRAI_CSV_HISTORICO
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '📂 Iniciando extração do arquivo: ';

/* ===== CONFIGURAÇÃO: ajuste este caminho se necessário ===== */
DECLARE @FolderPath NVARCHAR(400) = N'C:\dataset\Historico\'; -- pasta com os arquivos .csv

/* ===== PREPARA STAGING ===== */
/* tabela temporária onde cada arquivo é importado (colunas conforme layout do CSV) */
IF OBJECT_ID('tempdb..##temp_monthly_bruto') IS NOT NULL
    DROP TABLE ##temp_monthly_bruto;

CREATE TABLE ##temp_monthly_bruto (
    [ANO] VARCHAR(MAX),
    [JAN] VARCHAR(MAX),
    [FEB] VARCHAR(MAX),
    [MAR] VARCHAR(MAX),
    [APR] VARCHAR(MAX),
    [MAY] VARCHAR(MAX),
    [JUN] VARCHAR(MAX),
    [JUL] VARCHAR(MAX),
    [AUG] VARCHAR(MAX),
    [SEP] VARCHAR(MAX),
    [OCT] VARCHAR(MAX),
    [NOV] VARCHAR(MAX),
    [DEC] VARCHAR(MAX),
    [EOY] VARCHAR(MAX)
);

/* tabela final consolidada (com TICKER mais as colunas) */
IF OBJECT_ID('tempdb..##temp_monthly_all') IS NOT NULL
    DROP TABLE ##temp_monthly_all;

CREATE TABLE ##temp_monthly_all (
    ACAO VARCHAR(50),
    [ANO] VARCHAR(MAX),
    [JAN] VARCHAR(MAX),
    [FEB] VARCHAR(MAX),
    [MAR] VARCHAR(MAX),
    [APR] VARCHAR(MAX),
    [MAY] VARCHAR(MAX),
    [JUN] VARCHAR(MAX),
    [JUL] VARCHAR(MAX),
    [AUG] VARCHAR(MAX),
    [SEP] VARCHAR(MAX),
    [OCT] VARCHAR(MAX),
    [NOV] VARCHAR(MAX),
    [DEC] VARCHAR(MAX),
    [EOY] VARCHAR(MAX)
);

/* ===== Lista arquivos ===== */
CREATE TABLE #Arquivos (NomeArquivo NVARCHAR(400));

DECLARE @arquivopath NVARCHAR(400) = N'dir /b "' + @FolderPath + '*.csv"';

select @arquivopath

INSERT INTO #Arquivos (NomeArquivo)
EXEC xp_cmdshell @arquivopath 

DELETE FROM #Arquivos WHERE NomeArquivo IS NULL;

/* ===== Loop por arquivo: bulk insert + inserir ticker ===== */
DECLARE @arquivo NVARCHAR(400),
        @fullpath NVARCHAR(800),
        @ticker NVARCHAR(100),
        @sql NVARCHAR(MAX),
        @fileExists INT,
        @errMsg NVARCHAR(4000);

DECLARE cursor_arquivos CURSOR FOR
SELECT NomeArquivo FROM #Arquivos;

OPEN cursor_arquivos;
FETCH NEXT FROM cursor_arquivos INTO @arquivo;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @fullpath = @FolderPath + @arquivo;

    -- nome do ticker sem extensão
    SET @ticker = LEFT(@arquivo, CASE WHEN CHARINDEX('.', @arquivo) > 0 THEN CHARINDEX('.', @arquivo) - 1 ELSE LEN(@arquivo) END);

    -- verifica existência
    EXEC master..xp_fileexist @fullpath, @fileExists OUTPUT;
    IF @fileExists <> 1
    BEGIN
        PRINT 'Arquivo inexistente/inacessivel: ' + ISNULL(@arquivo,'(NULL)');
        FETCH NEXT FROM cursor_arquivos INTO @arquivo;
        CONTINUE;
    END

    -- limpa staging bruto antes do import (garante que só tem linhas do arquivo atual)
    TRUNCATE TABLE ##temp_monthly_bruto;

    -- BULK INSERT para a tabela temporária bruta
    SET @sql = N'
        BULK INSERT tempdb..##temp_monthly_bruto
        FROM N''' + REPLACE(@fullpath,'''','''''') + N'''
        WITH (
            FIRSTROW = 2,                 -- pula cabeçalho
            FIELDTERMINATOR = '';'',
            ROWTERMINATOR = ''\n'',
            TABLOCK,
            CODEPAGE = ''65001'',
            MAXERRORS = 0
        );';

    PRINT 'Tentando BULK INSERT: ' + @arquivo;
    BEGIN TRY
        EXEC sp_executesql @sql;
    END TRY
    BEGIN CATCH
        SET @errMsg = ERROR_MESSAGE();
        PRINT 'ERRO no BULK para ' + @arquivo + ' -> ' + ISNULL(@errMsg,'(vazio)');
        -- continua com o próximo arquivo
        FETCH NEXT FROM cursor_arquivos INTO @arquivo;
        CONTINUE;
    END CATCH

    -- insere na tabela consolidada adicionando o TICKER
    INSERT INTO ##temp_monthly_all (ACAO,[ANO],[JAN],[FEB],[MAR],[APR],[MAY],[JUN],[JUL],[AUG],[SEP],[OCT],[NOV],[DEC],[EOY])
    SELECT
        @ticker,[ANO],[JAN],[FEB],[MAR],[APR],[MAY],[JUN],[JUL],[AUG],[SEP],[OCT],[NOV],[DEC],[EOY]
    FROM ##temp_monthly_bruto;

    PRINT 'Arquivo processado: ' + @arquivo + ' (TICKER=' + @ticker + ')';

    FETCH NEXT FROM cursor_arquivos INTO @arquivo;
END

CLOSE cursor_arquivos;
DEALLOCATE cursor_arquivos;

DROP TABLE #Arquivos;

PRINT '✅ Importação concluída com sucesso!';

    DECLARE @Linhas INT = (SELECT COUNT(*) FROM ##temp_monthly_all);
    PRINT '📥 Linhas extraídas: ' + CAST(@Linhas AS VARCHAR(MAX));
END;
GO
------------------------------------------------------------
-- ⿢ TRANSFORMAÇÃO - Limpa e converte tipos
------------------------------------------------------------
CREATE PROCEDURE SP_TRATA_CSV_HISTORICO
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '⚙ Iniciando transformação dos dados...';

    IF OBJECT_ID('tempdb..##temp_historico_convertido') IS NOT NULL
        DROP TABLE ##temp_historico_convertido;

    CREATE TABLE ##temp_historico_convertido (
            acao VARCHAR(50),
            ano INT,
            jan DECIMAL(20,2),
            feb DECIMAL(20,2),
            mar DECIMAL(20,2),
            apr DECIMAL(20,2),
            may DECIMAL(20,2),
            jun DECIMAL(20,2),
            jul DECIMAL(20,2),
            aug DECIMAL(20,2),
            sep DECIMAL(20,2),
            oct DECIMAL(20,2),
            nov DECIMAL(20,2),
            [dec] DECIMAL(20,2),
            eoy DECIMAL(20,2)
    );

    INSERT INTO ##temp_historico_convertido (
        acao, ano, jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, [dec], eoy)
    SELECT
        ACAO,
        TRY_CONVERT(INT, NULLIF(ANO,'')) AS ano,
        TRY_CONVERT(DECIMAL(20,4),
                REPLACE(NULLIF(JAN,'-'),'%','') 
        ) / 100.0 AS jan,
        TRY_CONVERT(DECIMAL(20,4),
                REPLACE(NULLIF(FEB,'-'),'%','') 
        ) / 100.0 AS feb,
        TRY_CONVERT(DECIMAL(20,4),
                REPLACE(NULLIF(MAR,'-'),'%','') 
        ) / 100.0 AS mar,
        TRY_CONVERT(DECIMAL(20,4),
                REPLACE(NULLIF(APR,'-'),'%','') 
        ) / 100.0 AS apr,
        TRY_CONVERT(DECIMAL(20,4),
                REPLACE(NULLIF(MAY,'-'),'%','') 
        ) / 100.0 AS may,
        TRY_CONVERT(DECIMAL(20,4),
                REPLACE(NULLIF(JUN,'-'),'%','') 
        ) / 100.0 AS jun,
        TRY_CONVERT(DECIMAL(20,4),
                REPLACE(NULLIF(JUL,'-'),'%','') 
        ) / 100.0 AS jul,
        TRY_CONVERT(DECIMAL(20,4),
                REPLACE(NULLIF(AUG,'-'),'%','') 
        ) / 100.0 AS aug,
        TRY_CONVERT(DECIMAL(20,4),
                REPLACE(NULLIF(SEP,'-'),'%','') 
        ) / 100.0 AS sep,
        TRY_CONVERT(DECIMAL(20,4),
               REPLACE(NULLIF(OCT,'-'),'%','') 
        ) / 100.0 AS oct,
        TRY_CONVERT(DECIMAL(20,4),
               REPLACE(NULLIF(NOV,'-'),'%','') 
        ) / 100.0 AS nov,
        TRY_CONVERT(DECIMAL(20,4),
                REPLACE(NULLIF([DEC],'-'),'%','') 
        ) / 100.0 AS [dec],
        TRY_CONVERT(DECIMAL(20,4),
                REPLACE(NULLIF(EOY,'-'),'%','') 
        ) / 100.0 AS eoy
    FROM ##temp_monthly_all;

    PRINT '✅ Transformação concluída.';
END;
GO

------------------------------------------------------------
-- ⿣ CARGA - Insere na tabela final
------------------------------------------------------------
CREATE PROCEDURE SP_CARREGA_CSV_HISTORICO
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '💾 Iniciando carga de dados para dbo.precos_diarios...';

    INSERT INTO dbo.historico (
        acao, ano, jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, [dec], eoy 
    )
    SELECT * FROM ##temp_historico_convertido;

    PRINT '✅ Dados carregados com sucesso.';
END;
GO


------------------------------------------------------------
-- ⿤ ETL MASTER - Controla todo o processo
------------------------------------------------------------
CREATE PROCEDURE SP_ETL_HISTORICO
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '🚀 Iniciando processo ETL PRECOS...';

    BEGIN TRY
        EXEC SP_EXTRAI_CSV_HISTORICO;
        EXEC SP_TRATA_CSV_HISTORICO;
        EXEC SP_CARREGA_CSV_HISTORICO;

        -- Limpa temporárias
        IF OBJECT_ID('tempdb..##temp_monthly_bruto') IS NOT NULL DROP TABLE ##temp_monthly_bruto;
        IF OBJECT_ID('tempdb..##temp_monthly_all') IS NOT NULL DROP TABLE ##temp_monthly_all;
        IF OBJECT_ID('tempdb..##temp_historico_convertido') IS NOT NULL DROP TABLE ##temp_historico_convertido;
        
        PRINT '🏁 Processo ETL finalizado com sucesso.';
    END TRY
    BEGIN CATCH
        PRINT '❌ Erro no processo ETL: ' + ERROR_MESSAGE();
    END CATCH
END;
GO