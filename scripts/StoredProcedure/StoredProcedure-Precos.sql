USE dataset_b3;
GO

-- Remove procedures antigas, se existirem

    PRINT 'Atualizando dados tabela';

DROP PROCEDURE IF EXISTS SP_ETL_PRECOS;
DROP PROCEDURE IF EXISTS SP_CARREGA_CSV_PRECOS;
DROP PROCEDURE IF EXISTS SP_TRATA_CSV_PRECOS;
DROP PROCEDURE IF EXISTS SP_EXTRAI_CSV_PRECOS;
GO


------------------------------------------------------------
-- ⿡ EXTRAÇÃO - Lê o CSV e carrega na staging global
------------------------------------------------------------
CREATE PROCEDURE SP_EXTRAI_CSV_PRECOS
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '📂 Iniciando extração do arquivo: ';

/* ===== CONFIGURAÇÃO: ajuste este caminho se necessário ===== */
DECLARE @FolderPath NVARCHAR(400) = N'C:\dataset\Precos\'; -- pasta com os arquivos .csv

/* ===== PREPARA STAGING ===== */
/* tabela temporária onde cada arquivo é importado (colunas conforme layout do CSV) */
IF OBJECT_ID('tempdb..##temp_monthly_bruto') IS NOT NULL
    DROP TABLE ##temp_monthly_bruto;

CREATE TABLE ##temp_monthly_bruto (
    data_preco VARCHAR(MAX),
    fechamento VARCHAR(MAX),
    maxima VARCHAR(MAX),
    minima VARCHAR(MAX),
    abertura VARCHAR(MAX),
    volume VARCHAR(MAX),
    retorno_diario VARCHAR(MAX),
    retorno_acumulado VARCHAR(MAX),
    retorno_normalizado VARCHAR(MAX),
    retorno_futuro VARCHAR(MAX),
    volatilidade VARCHAR(MAX),
    mm20 VARCHAR(MAX),
    detrend VARCHAR(MAX)
);

/* tabela final consolidada (com TICKER mais as colunas) */
IF OBJECT_ID('tempdb..##temp_monthly_all') IS NOT NULL
    DROP TABLE ##temp_monthly_all;

CREATE TABLE ##temp_monthly_all (
    acao VARCHAR(50),
    data_preco VARCHAR(MAX),
    fechamento VARCHAR(MAX),
    maxima VARCHAR(MAX),
    minima VARCHAR(MAX),
    abertura VARCHAR(MAX),
    volume VARCHAR(MAX),
    retorno_diario VARCHAR(MAX),
    retorno_acumulado VARCHAR(MAX),
    retorno_normalizado VARCHAR(MAX),
    retorno_futuro VARCHAR(MAX),
    volatilidade VARCHAR(MAX),
    mm20 VARCHAR(MAX),
    detrend VARCHAR(MAX)
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
    INSERT INTO ##temp_monthly_all (acao, data_preco, fechamento, maxima, minima, abertura, volume, retorno_diario, retorno_acumulado, retorno_normalizado, retorno_futuro, volatilidade, mm20, detrend)
    SELECT
        @ticker, data_preco, fechamento, maxima, minima, abertura, volume, retorno_diario, retorno_acumulado, retorno_normalizado, retorno_futuro, volatilidade, mm20, detrend
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
CREATE PROCEDURE SP_TRATA_CSV_PRECOS
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '⚙ Iniciando transformação dos dados...';

    IF OBJECT_ID('tempdb..##temp_precos_convertido') IS NOT NULL
        DROP TABLE ##temp_precos_convertido;

    CREATE TABLE ##temp_precos_convertido (
        acao                   VARCHAR(50),
        data_preco             DATE,
        fechamento             DECIMAL(20,10),
        maxima                 DECIMAL(20,10),
        minima                 DECIMAL(20,10),
        abertura               DECIMAL(20,10),
        volume                 BIGINT,
        retorno_diario         DECIMAL(20,4),
        retorno_acumulado      DECIMAL(20,4),
        retorno_normalizado    DECIMAL(20,10),
        retorno_futuro         DECIMAL(20,10),
        volatilidade           DECIMAL(20,4),
        mm20                   DECIMAL(20,10),
        detrend                DECIMAL(20,10)
    );

    INSERT INTO ##temp_precos_convertido (
        acao, data_preco, fechamento, maxima, minima, abertura, volume, retorno_diario, retorno_acumulado, retorno_normalizado, retorno_futuro, volatilidade, mm20, detrend
    )

    SELECT
        NULLIF(acao, '') AS acao,
    
        TRY_CONVERT(DATE, NULLIF(data_preco, '')) AS data_preco,
    
        TRY_CONVERT(DECIMAL(20,10), NULLIF(fechamento, '')) AS fechamento,
        TRY_CONVERT(DECIMAL(20,10), NULLIF(maxima, '')) AS maxima,
        TRY_CONVERT(DECIMAL(20,10), NULLIF(minima, '')) AS minima,
        TRY_CONVERT(DECIMAL(20,10), NULLIF(abertura, '')) AS abertura,
    
        TRY_CONVERT(BIGINT, NULLIF(volume, '')) AS volume,
    
        TRY_CONVERT(DECIMAL(20,4), NULLIF(retorno_diario, '')) AS retorno_diario,
        TRY_CONVERT(DECIMAL(20,4), NULLIF(retorno_acumulado, '')) AS retorno_acumulado,
        TRY_CONVERT(DECIMAL(20,10), NULLIF(retorno_normalizado, '')) AS retorno_normalizado,
        TRY_CONVERT(DECIMAL(20,10), NULLIF(retorno_futuro, '')) AS retorno_futuro,
    
        TRY_CONVERT(DECIMAL(20,4), NULLIF(volatilidade, '')) AS volatilidade,
        TRY_CONVERT(DECIMAL(20,10), NULLIF(mm20, '')) AS mm20,
        TRY_CONVERT(DECIMAL(20,10), NULLIF(detrend, '')) AS detrend
    
    FROM ##temp_monthly_all;

    PRINT '✅ Transformação concluída.';
END;
GO


------------------------------------------------------------
-- ⿣ CARGA - Insere na tabela final
------------------------------------------------------------
CREATE PROCEDURE SP_CARREGA_CSV_PRECOS
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '💾 Iniciando carga de dados para dbo.precos_diarios...';

    INSERT INTO dbo.precos_diarios (
        acao, data_preco, fechamento, maxima, minima, abertura, volume, retorno_diario, retorno_acumulado, retorno_normalizado, retorno_futuro, volatilidade, mm20, detrend 
    )
    SELECT * FROM ##temp_precos_convertido;

    PRINT '✅ Dados carregados com sucesso.';
END;
GO


------------------------------------------------------------
-- ⿤ ETL MASTER - Controla todo o processo
------------------------------------------------------------
CREATE PROCEDURE SP_ETL_PRECOS
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '🚀 Iniciando processo ETL PRECOS...';

    BEGIN TRY
        EXEC SP_EXTRAI_CSV_PRECOS;
        EXEC SP_TRATA_CSV_PRECOS;
        EXEC SP_CARREGA_CSV_PRECOS;

        -- Limpa temporárias
        IF OBJECT_ID('tempdb..##temp_precos_bruto') IS NOT NULL DROP TABLE ##temp_precos_bruto;
        IF OBJECT_ID('tempdb..##temp_precos_convertido') IS NOT NULL DROP TABLE ##temp_precos_convertido;

        PRINT '🏁 Processo ETL finalizado com sucesso.';
    END TRY
    BEGIN CATCH
        PRINT '❌ Erro no processo ETL: ' + ERROR_MESSAGE();
    END CATCH
END;
GO