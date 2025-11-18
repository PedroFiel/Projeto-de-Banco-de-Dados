USE dataset_b3;
GO

-- Remove procedures antigas, se existirem
DROP PROCEDURE IF EXISTS SP_ETL_TRIMESTRE;
DROP PROCEDURE IF EXISTS SP_CARREGA_CSV_TRIMESTRE;
DROP PROCEDURE IF EXISTS SP_TRATA_CSV_TRIMESTRE;
DROP PROCEDURE IF EXISTS SP_EXTRAI_CSV_TRIMESTRE;
GO


------------------------------------------------------------
-- ⿡ EXTRAÇÃO - Lê o CSV e carrega na staging global
------------------------------------------------------------
CREATE PROCEDURE SP_EXTRAI_CSV_TRIMESTRE
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '📂 Iniciando extração do arquivo: ';

    IF OBJECT_ID('tempdb..##temp_trimestre_bruto') IS NOT NULL
        DROP TABLE ##temp_trimestre_bruto;

    CREATE TABLE ##temp_trimestre_bruto (
        id_linha                VARCHAR(MAX),
        data_referencia         VARCHAR(MAX),
        demonstracao_financeira VARCHAR(MAX),
        release_resultados      VARCHAR(MAX),
        acao                    VARCHAR(MAX)
    );

CREATE TABLE #Arquivos (NomeArquivo NVARCHAR(MAX));

-- Lista todos os arquivos .csv na pasta desejada
INSERT INTO #Arquivos (NomeArquivo)
EXEC xp_cmdshell 'dir /b "C:\dataset\Trimestre\*.csv"';

-- Remove linhas nulas (resultantes do DIR)
DELETE FROM #Arquivos WHERE NomeArquivo IS NULL;

-- =====================================================
-- LOOP PARA FAZER BULK INSERT DE CADA ARQUIVO
-- =====================================================
DECLARE @arquivo NVARCHAR(MAX), 
        @sql NVARCHAR(MAX);

DECLARE cursor_arquivos CURSOR FOR
SELECT NomeArquivo FROM #Arquivos;

OPEN cursor_arquivos;
FETCH NEXT FROM cursor_arquivos INTO @arquivo;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @sql = '
        BULK INSERT dataset_b3.dbo.##temp_trimestre_bruto
        FROM ''C:\dataset\Trimestre\' + @arquivo + '''
        WITH (
            FIRSTROW = 2,               -- ignora cabeçalho
            FIELDTERMINATOR = '';'',    -- separador CSV
            ROWTERMINATOR = ''\n'',     -- quebra de linha
            TABLOCK,
            CODEPAGE = ''65001''-- encoding padrão Windows
        );';

    PRINT 'Importando arquivo: ' + @arquivo;
    EXEC (@sql);

    FETCH NEXT FROM cursor_arquivos INTO @arquivo;
END;

CLOSE cursor_arquivos;
DEALLOCATE cursor_arquivos;

DROP TABLE #Arquivos;

PRINT '✅ Importação concluída com sucesso!';

    DECLARE @Linhas INT = (SELECT COUNT(*) FROM ##temp_trimestre_bruto);
    PRINT '📥 Linhas extraídas: ' + CAST(@Linhas AS VARCHAR(MAX));
END;
GO
------------------------------------------------------------
-- ⿢ TRANSFORMAÇÃO - Limpa e converte tipos
------------------------------------------------------------
CREATE PROCEDURE SP_TRATA_CSV_TRIMESTRE
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '⚙️ Iniciando transformação dos dados de Trimestre ...';

    -- Remove se já existir
    IF OBJECT_ID('tempdb..##temp_trimestre_convertido') IS NOT NULL
        DROP TABLE ##temp_trimestre_convertido;

    -- Cria tabela temporária global convertida com tipos adequados
    CREATE TABLE ##temp_trimestre_convertido (
        data_referencia         DATE,
        demonstracao_financeira VARCHAR(MAX),
        release_resultados      VARCHAR(MAX),
        acao                    VARCHAR(MAX)
    );

    INSERT INTO ##temp_trimestre_convertido (
        data_referencia, demonstracao_financeira, release_resultados, acao
    )
    SELECT
        TRY_CONVERT(DATE, NULLIF(data_referencia, ''), 103) AS data_referencia,
    
        NULLIF(demonstracao_financeira, '') AS demonstracao_financeira,
        NULLIF(release_resultados, '') AS release_resultados,
    
        NULLIF(acao, '') AS acao

    FROM ##temp_trimestre_bruto;

    PRINT '✅ Transformação de TRIMESTRE RELEVANTES concluída.';
END;
GO

------------------------------------------------------------
-- ⿣ CARGA - Insere na tabela final
------------------------------------------------------------
CREATE PROCEDURE SP_CARREGA_CSV_TRIMESTRE
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '💾 Iniciando carga de dados para dbo.trimestre...';

    INSERT INTO dbo.demonstracoes_trimestrais (
        data_referencia, demonstracao_financeira, release_resultados, acao
    )
    SELECT * FROM ##temp_trimestre_convertido;

    PRINT '✅ Dados carregados com sucesso.';
END;
GO


------------------------------------------------------------
-- ⿤ ETL MASTER - Controla todo o processo
------------------------------------------------------------
CREATE PROCEDURE SP_ETL_TRIMESTRE
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '🚀 Iniciando processo ETL TRIMESTRE_relevantes...';

    BEGIN TRY
        EXEC SP_EXTRAI_CSV_TRIMESTRE;
        EXEC SP_TRATA_CSV_TRIMESTRE;
        EXEC SP_CARREGA_CSV_TRIMESTRE;

        -- Limpa temporárias
        IF OBJECT_ID('tempdb..##temp_trimestre_bruto') IS NOT NULL DROP TABLE ##temp_trimestre_bruto;
        IF OBJECT_ID('tempdb..##temp_trimestre_convertido') IS NOT NULL DROP TABLE ##temp_trimestre_convertido;

        PRINT '🏁 Processo ETL finalizado com sucesso.';
    END TRY
    BEGIN CATCH
        PRINT '❌ Erro no processo ETL: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


