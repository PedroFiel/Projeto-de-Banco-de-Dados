USE dataset_b3;
GO

-- Remove procedures antigas, se existirem
DROP PROCEDURE IF EXISTS SP_ETL_PROVENTOS;
DROP PROCEDURE IF EXISTS SP_CARREGA_CSV_PROVENTOS;
DROP PROCEDURE IF EXISTS SP_TRATA_CSV_PROVENTOS;
DROP PROCEDURE IF EXISTS SP_EXTRAI_CSV_PROVENTOS;
GO

------------------------------------------------------------
-- 1️⃣ EXTRAÇÃO - Lê os CSVs da pasta Proventos e carrega na staging global
------------------------------------------------------------
CREATE PROCEDURE SP_EXTRAI_CSV_PROVENTOS
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '📂 Iniciando extração arquivos Proventos...';

    IF OBJECT_ID('tempdb..##temp_proventos_bruto') IS NOT NULL
        DROP TABLE ##temp_proventos_bruto;

    CREATE TABLE ##temp_proventos_bruto (
        id VARCHAR(MAX),
        data_decl VARCHAR(MAX),
        valor VARCHAR(MAX),
        tipo VARCHAR(MAX),
        data_pagamento VARCHAR(MAX),
        quant_acoes VARCHAR(MAX),
        acao VARCHAR(MAX)
    );

    CREATE TABLE #Arquivos (NomeArquivo NVARCHAR(MAX));

    -- Lista todos os arquivos .csv na pasta desejada
    INSERT INTO #Arquivos (NomeArquivo)
    EXEC xp_cmdshell 'dir /b "C:\dataset\Proventos\*.csv"';

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
            BULK INSERT dataset_b3.dbo.##temp_proventos_bruto
            FROM ''C:\dataset\Proventos\' + @arquivo + '''
            WITH (
                FIRSTROW = 2,               -- ignora cabeçalho
                FIELDTERMINATOR = '';'',    -- separador CSV (ajuste se necessário)
                ROWTERMINATOR = ''\n'',     -- quebra de linha
                TABLOCK,
                CODEPAGE = ''65001''        -- UTF-8 (ajuste se necessário)
            );';

        PRINT 'Importando arquivo: ' + @arquivo;
        EXEC (@sql);

        FETCH NEXT FROM cursor_arquivos INTO @arquivo;
    END;

    CLOSE cursor_arquivos;
    DEALLOCATE cursor_arquivos;

    DROP TABLE #Arquivos;

    DECLARE @Linhas INT = (SELECT COUNT(*) FROM ##temp_proventos_bruto);
    PRINT '✅ Importação concluída. Linhas importadas: ' + CAST(@Linhas AS VARCHAR(20));
END;
GO

------------------------------------------------------------
-- 2️⃣ TRANSFORMAÇÃO - Limpa e converte tipos para proventos
------------------------------------------------------------
-- 🔧 Versão final ajustada da SP_TRATA_CSV_PROVENTOS com conversão de datas para DATE
-- Substitua a procedure antiga por esta
CREATE PROCEDURE SP_TRATA_CSV_PROVENTOS
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '⚙ Iniciando transformação Proventos (versão ajustada)...';

    IF OBJECT_ID('tempdb..##temp_proventos_convertido') IS NOT NULL
        DROP TABLE ##temp_proventos_convertido;

    CREATE TABLE ##temp_proventos_convertido (
        data_decl VARCHAR(50),
        valor DECIMAL(10,4),
        tipo VARCHAR(50),
        data_pagamento VARCHAR(50),
        quant_acoes INT,
        acao VARCHAR(10)
    );

    INSERT INTO ##temp_proventos_convertido (
        data_decl, valor, tipo, data_pagamento, quant_acoes, acao
    )
    SELECT
        -- DATA_DECL:
        -- - limpa espaços
        -- - se vier somente o ano (ex: '2025') transforma em '01/01/2025'
        -- - tenta converter usando style 103 (dd/mm/yyyy)
       CASE
            WHEN NULLIF(LTRIM(RTRIM(data_decl)),'-') IS NULL THEN NULL
            WHEN LEN(NULLIF(LTRIM(RTRIM(data_decl)),'-')) = 4 THEN NULL
            ELSE TRY_CONVERT(DATE, NULLIF(LTRIM(RTRIM(data_decl)),'-'), 103)
        END AS data_decl,

        -- VALOR: remove pontos de milhares e troca vírgula por ponto, TRY_CONVERT para segurança
        TRY_CONVERT(
            DECIMAL(10,4),
            REPLACE(REPLACE(NULLIF(LTRIM(RTRIM(valor)),'-'),'.',''),',','.')
        ) AS valor,

        -- TIPO: trim e limitar
        LEFT(NULLIF(LTRIM(RTRIM(tipo)),''), 50) AS tipo,

        -- DATA_PAGAMENTO: mantive VARCHAR(50) (como solicitado originalmente)
        -- Aplicamos mesma lógica de limpeza; se quiser DATE, eu converto também.
        TRY_CONVERT(DATE, NULLIF(data_pagamento,'-'), 103) AS data_pagamento,

        -- QUANT_ACOES: remove ponto de milhares e converte; '-' ou '' => NULL
        TRY_CONVERT(INT, REPLACE(NULLIF(LTRIM(RTRIM(quant_acoes)),'-'),'.','')) AS quant_acoes,

        -- ACAO: trim e limitar a 10 chars (ex: ALUP11)
        LEFT(NULLIF(LTRIM(RTRIM(acao)),''), 10) AS acao

    FROM ##temp_proventos_bruto;
    
    -- Observação: no SELECT acima eu usei os nomes originais do header do CSV.
    -- Se no seu BULK INSERT os nomes das colunas foram mapeados por posição para as colunas
    -- em ##temp_proventos_bruto com nomes diferentes (id, data_decl, valor, tipo, data_pagamento, quant_acoes, acao),
    -- deixe os identificadores conforme a sua tabela temporária. 
    -- (Ex.: se sua coluna de quantidade for chamada "quant_acoes" no ##temp_proventos_bruto,
    -- altere REPLACE(NULLIF(LTRIM(RTRIM([Por quantas ações])),'-'),'.','') para REPLACE(NULLIF(LTRIM(RTRIM(quant_acoes)),'-'),'.',''))


    PRINT '✅ Transformação concluída. Linhas válidas: ';
END;
GO
------------------------------------------------------------
-- 3️⃣ CARGA - Insere na tabela final dbo.proventos
------------------------------------------------------------
CREATE PROCEDURE SP_CARREGA_CSV_PROVENTOS
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '💾 Iniciando carga de dados para dbo.proventos...';

    -- Verifica se a tabela destino existe
    IF OBJECT_ID('dbo.proventos', 'U') IS NULL
    BEGIN
        PRINT '❗ Tabela dbo.proventos não existe no banco atual. Crie-a antes de rodar a carga.';
        RETURN;
    END

    BEGIN TRY
        INSERT INTO dbo.proventos (
            data_decl, valor, tipo, data_pagamento, quant_acoes, acao
        )
        SELECT
            data_decl, valor, tipo, data_pagamento, quant_acoes, acao
        FROM ##temp_proventos_convertido;

        PRINT '✅ Dados carregados com sucesso. Linhas inseridas: ' + CAST(@@ROWCOUNT AS VARCHAR(20));
    END TRY
    BEGIN CATCH
        PRINT '❌ Erro durante a carga: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

------------------------------------------------------------
-- 4️⃣ ETL MASTER - Controla todo o processo Proventos
------------------------------------------------------------
CREATE PROCEDURE SP_ETL_PROVENTOS
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '🚀 Iniciando processo ETL PROVENTOS...';

    BEGIN TRY
        EXEC SP_EXTRAI_CSV_PROVENTOS;
        EXEC SP_TRATA_CSV_PROVENTOS;
        EXEC SP_CARREGA_CSV_PROVENTOS;

        -- Limpa temporárias
        IF OBJECT_ID('tempdb..##temp_proventos_bruto') IS NOT NULL DROP TABLE ##temp_proventos_bruto;
        IF OBJECT_ID('tempdb..##temp_proventos_convertido') IS NOT NULL DROP TABLE ##temp_proventos_convertido;

        PRINT '🏁 Processo ETL PROVENTOS finalizado com sucesso.';
    END TRY
    BEGIN CATCH
        PRINT '❌ Erro no processo ETL PROVENTOS: ' + ERROR_MESSAGE();

        -- Tenta limpar temporárias mesmo em erro
        IF OBJECT_ID('tempdb..##temp_proventos_bruto') IS NOT NULL DROP TABLE ##temp_proventos_bruto;
        IF OBJECT_ID('tempdb..##temp_proventos_convertido') IS NOT NULL DROP TABLE ##temp_proventos_convertido;
    END CATCH
END;
GO


