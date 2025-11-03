USE dataset_b3;
GO

-- Remove procedures antigas, se existirem

    PRINT 'Atualizando dados tabela';

DROP PROCEDURE IF EXISTS SP_ETL_RIEMPRESAS;
DROP PROCEDURE IF EXISTS SP_CARREGA_CSV_RIEMPRESAS;
DROP PROCEDURE IF EXISTS SP_TRATA_CSV_RIEMPRESAS;
DROP PROCEDURE IF EXISTS SP_EXTRAI_CSV_RIEMPRESAS;
GO


------------------------------------------------------------
-- ⿡ EXTRAÇÃO - Lê o CSV e carrega na staging global
------------------------------------------------------------
CREATE PROCEDURE SP_EXTRAI_CSV_RIEMPRESAS
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '📂 Iniciando extração do arquivo: ';

    IF OBJECT_ID('tempdb..##temp_riempresas_bruto') IS NOT NULL
        DROP TABLE ##temp_riempresas_bruto;

    CREATE TABLE ##temp_riempresas_bruto (
        id VARCHAR(MAX),
        acao VARCHAR(MAX),
        url_site VARCHAR(MAX),
    );
CREATE TABLE #Arquivos (NomeArquivo NVARCHAR(40MAX));

-- Lista todos os arquivos .csv na pasta desejada
INSERT INTO #Arquivos (NomeArquivo)
EXEC xp_cmdshell 'dir /b "C:\dataset\RiEmpresas\*.csv"';

-- Remove linhas nulas (resultantes do DIR)
DELETE FROM #Arquivos WHERE NomeArquivo IS NULL;

-- =====================================================
-- LOOP PARA FAZER BULK INSERT DE CADA ARQUIVO
-- =====================================================
DECLARE @arquivo NVARCHAR(40MAX), 
        @sql NVARCHAR(MMAX);

DECLARE cursor_arquivos CURSOR FOR
SELECT NomeArquivo FROM #Arquivos;

OPEN cursor_arquivos;
FETCH NEXT FROM cursor_arquivos INTO @arquivo;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @sql = '
        BULK INSERT dataset_b3.dbo.##temp_riempresas_bruto
        FROM ''C:\dataset\RiEmpresas\' + @arquivo + '''
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

    DECLARE @Linhas INT = (SELECT COUNT(*) FROM ##temp_riempresas_bruto);
    PRINT '📥 Linhas extraídas: ' + CAST(@Linhas AS VARCHAR(MAX));
END;
GO
------------------------------------------------------------
-- ⿢ TRANSFORMAÇÃO - Limpa e converte tipos
------------------------------------------------------------
CREATE PROCEDURE SP_TRATA_CSV_RIEMPRESAS
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '⚙ Iniciando transformação dos dados...';

    IF OBJECT_ID('tempdb..##temp_riempresas_convertido') IS NOT NULL
        DROP TABLE ##temp_riempresas_convertido;

    CREATE TABLE ##temp_riempresas_convertido (
       

       
    );

    INSERT INTO ##temp_riempresas_convertido
    SELECT



    FROM ##temp_riempresas_bruto;

    PRINT '✅ Transformação concluída.';
END;
GO


------------------------------------------------------------
-- ⿣ CARGA - Insere na tabela final
------------------------------------------------------------
CREATE PROCEDURE SP_CARREGA_CSV_RIEMPRESAS
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '💾 Iniciando carga de dados para dbo.riempresas...';

    INSERT INTO dbo.sites_ri (
         
    )
    SELECT * FROM ##temp_riempresas_convertido;

    PRINT '✅ Dados carregados com sucesso.';
END;
GO


------------------------------------------------------------
-- ⿤ ETL MASTER - Controla todo o processo
------------------------------------------------------------
CREATE PROCEDURE SP_ETL_RIEMPRESAS
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '🚀 Iniciando processo ETL RIEMPRESAS...';

    BEGIN TRY
        EXEC SP_EXTRAI_CSV_RIEMPRESAS;
        EXEC SP_TRATA_CSV_RIEMPRESAS;
        EXEC SP_CARREGA_CSV_RIEMPRESAS;

        -- Limpa temporárias
        IF OBJECT_ID('tempdb..##temp_riempresas_bruto') IS NOT NULL DROP TABLE ##temp_riempresas_bruto;
        IF OBJECT_ID('tempdb..##temp_riempresas_convertido') IS NOT NULL DROP TABLE ##temp_riempresas_convertido;

        PRINT '🏁 Processo ETL finalizado com sucesso.';
    END TRY
    BEGIN CATCH
        PRINT '❌ Erro no processo ETL: ' + ERROR_MESSAGE();
    END CATCH
END;
GO