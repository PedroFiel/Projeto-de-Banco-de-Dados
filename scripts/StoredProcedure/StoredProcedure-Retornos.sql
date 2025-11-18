USE dataset_b3;
GO

-- Remove procedures antigas, se existirem

    PRINT 'Atualizando dados tabela';

DROP PROCEDURE IF EXISTS SP_ETL_RETORNO;
DROP PROCEDURE IF EXISTS SP_CARREGA_CSV_RETORNO;
DROP PROCEDURE IF EXISTS SP_TRATA_CSV_RETORNO;
DROP PROCEDURE IF EXISTS SP_EXTRAI_CSV_RETORNO;
GO


------------------------------------------------------------
-- ⿡ EXTRAÇÃO - Lê o CSV e carrega na staging global
------------------------------------------------------------
CREATE PROCEDURE SP_EXTRAI_CSV_RETORNO
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '📂 Iniciando extração do arquivo: ';

/* ===== CONFIGURAÇÃO: ajuste este caminho se necessário ===== */
DECLARE @FolderPath NVARCHAR(400) = N'C:\dataset\Retornos\'; -- pasta com os arquivos .csv

/* ===== PREPARA STAGING ===== */
/* tabela temporária onde cada arquivo é importado (colunas conforme layout do CSV) */
IF OBJECT_ID('tempdb..##temp_monthly_bruto') IS NOT NULL
    DROP TABLE ##temp_monthly_bruto;

CREATE TABLE ##temp_monthly_bruto (
    id_retorno VARCHAR(MAX),
    papel VARCHAR(MAX),
    acumulo_total VARCHAR(MAX)
);

/* tabela final consolidada (com TICKER mais as colunas) */
IF OBJECT_ID('tempdb..##temp_monthly_all') IS NOT NULL
    DROP TABLE ##temp_monthly_all;

CREATE TABLE ##temp_monthly_all (
    periodo_dias VARCHAR(MAX),
    id_retorno VARCHAR(MAX),
    papel VARCHAR(MAX),
    acumulo_total VARCHAR(MAX)
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
    INSERT INTO ##temp_monthly_all (periodo_dias, id_retorno, papel, acumulo_total)
    SELECT
        @ticker, id_retorno, papel, acumulo_total
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
CREATE PROCEDURE SP_TRATA_CSV_RETORNO
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '⚙ Iniciando transformação dos dados...';

    IF OBJECT_ID('tempdb..##temp_retorno_convertido') IS NOT NULL
        DROP TABLE ##temp_retorno_convertido;

    CREATE TABLE ##temp_retorno_convertido (
        periodo_dias VARCHAR(MAX),
        id_retorno INT,
        papel VARCHAR(MAX),
        acumulo_total DECIMAL(16,2)
    );

    INSERT INTO ##temp_retorno_convertido (
        periodo_dias, id_retorno, papel, acumulo_total
    )

    SELECT
        NULLIF(periodo_dias, '') as periodo_dias,
        TRY_CONVERT(INT, NULLIF(id_retorno, '')) as id_retorno,
        NULLIF(papel, '') as papel,
        TRY_CONVERT(DECIMAL(16,2), NULLIF(acumulo_total, '-')) as acumulo_total
    FROM ##temp_monthly_all;

    PRINT '✅ Transformação concluída.';
END;
GO


------------------------------------------------------------
-- ⿣ CARGA - Insere na tabela final
------------------------------------------------------------
CREATE PROCEDURE SP_CARREGA_CSV_RETORNO
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '💾 Iniciando carga de dados para dbo.retorno...';

    INSERT INTO dbo.retornos_acumulados (
        periodo_dias, papel, acumulo_total
    )
    SELECT periodo_dias, papel, acumulo_total FROM ##temp_retorno_convertido;

    PRINT '✅ Dados carregados com sucesso.';
END;
GO


------------------------------------------------------------
-- ⿤ ETL MASTER - Controla todo o processo
------------------------------------------------------------
CREATE PROCEDURE SP_ETL_RETORNO
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '🚀 Iniciando processo ETL RETORNO...';

    BEGIN TRY
        EXEC SP_EXTRAI_CSV_RETORNO;
        EXEC SP_TRATA_CSV_RETORNO;
        EXEC SP_CARREGA_CSV_RETORNO;

        -- Limpa temporárias
        IF OBJECT_ID('tempdb..##temp_retorno_bruto') IS NOT NULL DROP TABLE ##temp_retorno_bruto;
        IF OBJECT_ID('tempdb..##temp_retorno_convertido') IS NOT NULL DROP TABLE ##temp_retorno_convertido;

        PRINT '🏁 Processo ETL finalizado com sucesso.';
    END TRY
    BEGIN CATCH
        PRINT '❌ Erro no processo ETL: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
