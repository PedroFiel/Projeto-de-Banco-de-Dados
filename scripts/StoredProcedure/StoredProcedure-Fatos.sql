USE dataset_b3;
GO

-- Remove procedures antigas, se existirem
DROP PROCEDURE IF EXISTS SP_ETL_FATOS;
DROP PROCEDURE IF EXISTS SP_CARREGA_CSV_FATOS;
DROP PROCEDURE IF EXISTS SP_TRATA_CSV_FATOS;
DROP PROCEDURE IF EXISTS SP_EXTRAI_CSV_FATOS;
GO


------------------------------------------------------------
-- ⿡ EXTRAÇÃO - Lê o CSV e carrega na staging global
------------------------------------------------------------
CREATE PROCEDURE SP_EXTRAI_CSV_FATOS
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '📂 Iniciando extração do arquivo: ';

    IF OBJECT_ID('tempdb..##temp_fatos_relevantes_bruto') IS NOT NULL
        DROP TABLE ##temp_fatos_relevantes_bruto;

    CREATE TABLE ##temp_fatos_relevantes_bruto (
        id VARCHAR(MAX),
        acao VARCHAR(MAX),
        data_acao VARCHAR(MAX),
        hora VARCHAR(MAX),
        descricao VARCHAR(MAX),
        link VARCHAR(MAX)
    );

CREATE TABLE #Arquivos (NomeArquivo NVARCHAR(MAX));

-- Lista todos os arquivos .csv na pasta desejada
INSERT INTO #Arquivos (NomeArquivo)
EXEC xp_cmdshell 'dir /b "C:\dataset\FatosRelevantes\*.csv"';

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
        BULK INSERT dataset_b3.dbo.##temp_fatos_relevantes_bruto
        FROM ''C:\dataset\FatosRelevantes\' + @arquivo + '''
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

    DECLARE @Linhas INT = (SELECT COUNT(*) FROM ##temp_fatos_relevantes_bruto);
    PRINT '📥 Linhas extraídas: ' + CAST(@Linhas AS VARCHAR(MAX));
END;
GO
------------------------------------------------------------
-- ⿢ TRANSFORMAÇÃO - Limpa e converte tipos
------------------------------------------------------------
CREATE PROCEDURE SP_TRATA_CSV_FATOS
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '⚙️ Iniciando transformação dos dados de FATOS RELEVANTES...';

    -- Remove se já existir
    IF OBJECT_ID('tempdb..##temp_fatos_relevantes_convertido') IS NOT NULL
        DROP TABLE ##temp_fatos_relevantes_convertido;

    -- Cria tabela temporária global convertida com tipos adequados
    CREATE TABLE ##temp_fatos_relevantes_convertido (
        acao VARCHAR(50),
        data_acao DATE,
        hora TIME(0),
        descricao VARCHAR(MAX),
        link VARCHAR(MAX)
    );

    /*
      Regras de limpeza aplicadas abaixo:
      - NULLIF(...,'') transforma strings vazias em NULL
      - REPLACE(..., CHAR(13), '') remove CR remanescente
      - LTRIM/RTRIM para remover espaços
      - TRY_CONVERT evita erro em linhas sujas e retorna NULL quando impossível converter
    */

    INSERT INTO ##temp_fatos_relevantes_convertido (
        acao, data_acao, hora, descricao, link
    )
    SELECT

        -- código da ação (ex: ADHM3)
        NULLIF(REPLACE(LTRIM(RTRIM(acao)), CHAR(13), ''), '') AS acao,

        -- data da ação (formato dd/MM/yyyy)
        TRY_CONVERT(DATE, REPLACE(NULLIF(LTRIM(RTRIM(data_acao)), ''), CHAR(13), ''), 103) AS data_acao,

        -- hora (HH:mm ou HH:mm:ss) - armazena como TIME(0)
        TRY_CONVERT(TIME(0), NULLIF(REPLACE(LTRIM(RTRIM(hora)), CHAR(8), ''), '')) AS hora,

        -- descrição livre (mantém texto grande)
        NULLIF(REPLACE(LTRIM(RTRIM(descricao)), CHAR(13), ''), '') AS descricao,

        -- link (URL) - pode ser NULL
        NULLIF(REPLACE(LTRIM(RTRIM(link)), CHAR(13), ''), '') AS link

    FROM ##temp_fatos_relevantes_bruto;

    PRINT '✅ Transformação de FATOS RELEVANTES concluída.';
END;
GO

------------------------------------------------------------
-- ⿣ CARGA - Insere na tabela final
------------------------------------------------------------
CREATE PROCEDURE SP_CARREGA_CSV_FATOS
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '💾 Iniciando carga de dados para dbo.fatos_relevantes...';

    INSERT INTO dbo.fatos_relevantes (
        acao, data_acao, hora, descricao, link
    )
    SELECT * FROM ##temp_fatos_relevantes_convertido;

    PRINT '✅ Dados carregados com sucesso.';
END;
GO


------------------------------------------------------------
-- ⿤ ETL MASTER - Controla todo o processo
------------------------------------------------------------
CREATE PROCEDURE SP_ETL_FATOS
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '🚀 Iniciando processo ETL fatos_relevantes...';

    BEGIN TRY
        EXEC SP_EXTRAI_CSV_FATOS;
        EXEC SP_TRATA_CSV_FATOS;
        EXEC SP_CARREGA_CSV_FATOS;

        -- Limpa temporárias
        IF OBJECT_ID('tempdb..##temp_fatos_relevantes_bruto') IS NOT NULL DROP TABLE ##temp_fatos_relevantes_bruto;
        IF OBJECT_ID('tempdb..##temp_fatos_relevantes_convertido') IS NOT NULL DROP TABLE ##temp_fatos_relevantes_convertido;

        PRINT '🏁 Processo ETL finalizado com sucesso.';
    END TRY
    BEGIN CATCH
        PRINT '❌ Erro no processo ETL: ' + ERROR_MESSAGE();
    END CATCH
END;
GO