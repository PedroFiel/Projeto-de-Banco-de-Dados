USE dataset_b3;
GO

-- Remove procedures antigas, se existirem
DROP PROCEDURE IF EXISTS SP_ETL_DADOS_GERAIS;
DROP PROCEDURE IF EXISTS SP_CARREGA_CSV_DADOS_GERAIS;
DROP PROCEDURE IF EXISTS SP_TRATA_CSV_DADOS_GERAIS;
DROP PROCEDURE IF EXISTS SP_EXTRAI_CSV_DADOS_GERAIS;
GO


------------------------------------------------------------
-- 1️⃣ EXTRAÇÃO - Lê o CSV e carrega na staging global
------------------------------------------------------------
CREATE PROCEDURE SP_EXTRAI_CSV_DADOS_GERAIS
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '📂 Iniciando extração do arquivo: ';

    IF OBJECT_ID('tempdb..##temp_dados_gerais_bruto') IS NOT NULL
        DROP TABLE ##temp_dados_gerais_bruto;

    CREATE TABLE ##temp_dados_gerais_bruto (
        id VARCHAR(MAX),
        papel VARCHAR(MAX),
        tipo VARCHAR(MAX),
        empresa VARCHAR(MAX),
        setor VARCHAR(MAX),
        cotacao VARCHAR(MAX),
        data_ult_cotacao VARCHAR(MAX),
        min_52_sem VARCHAR(MAX),
        max_52_sem VARCHAR(MAX),
        vol_med_2m VARCHAR(MAX),
        valor_mercado VARCHAR(MAX),
        valor_firma VARCHAR(MAX),
        ult_balanco_pro VARCHAR(MAX),
        nr_acoes VARCHAR(MAX),
        os_dia VARCHAR(MAX),
        pl VARCHAR(MAX),
        lpa VARCHAR(MAX),
        pvp VARCHAR(MAX),
        vpa VARCHAR(MAX),
        p_ebit VARCHAR(MAX),
        psr VARCHAR(MAX),
        p_ativos VARCHAR(MAX),
        p_cap_giro VARCHAR(MAX),
        p_ativo_circ_liq VARCHAR(MAX),
        ev_ebitda VARCHAR(MAX),
        ev_ebit VARCHAR(MAX),
        marg_bruta VARCHAR(MAX),
        marg_ebit VARCHAR(MAX),
        marg_liquida VARCHAR(MAX),
        ebit_ativo VARCHAR(MAX),
        roic VARCHAR(MAX),
        roe VARCHAR(MAX),
        cresc_rec_5a VARCHAR(MAX),
        div_yield VARCHAR(MAX),
        liquidez_corr VARCHAR(MAX),
        ativo VARCHAR(MAX),
        disponibilidades VARCHAR(MAX),
        ativo_circulante VARCHAR(MAX),
        div_bruta VARCHAR(MAX),
        div_liquida VARCHAR(MAX),
        patr_liquido VARCHAR(MAX),
        lucro_liquido_12m VARCHAR(MAX),
        lucro_liquido_3m VARCHAR(MAX)
    );
CREATE TABLE #Arquivos (NomeArquivo NVARCHAR(MAX));

-- Lista todos os arquivos .csv na pasta desejada
INSERT INTO #Arquivos (NomeArquivo)
EXEC xp_cmdshell 'dir /b "C:\dataset\DadosGerais\*.csv"';

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
        BULK INSERT dataset_b3.dbo.##temp_dados_gerais_bruto
        FROM ''C:\dataset\DadosGerais\' + @arquivo + '''
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

    DECLARE @Linhas INT = (SELECT COUNT(*) FROM ##temp_dados_gerais_bruto);
    PRINT '📥 Linhas extraídas: ' + CAST(@Linhas AS VARCHAR(MAX));
END;
GO
------------------------------------------------------------
-- 2️⃣ TRANSFORMAÇÃO - Limpa e converte tipos
------------------------------------------------------------
CREATE PROCEDURE SP_TRATA_CSV_DADOS_GERAIS
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '⚙️ Iniciando transformação dos dados...';

    -- Remove se já existir
    IF OBJECT_ID('tempdb..##temp_dados_gerais_convertido') IS NOT NULL
        DROP TABLE ##temp_dados_gerais_convertido;

    -- Cria tabela temporária global convertida com tipos adequados
    CREATE TABLE ##temp_dados_gerais_convertido (
        id_dados INT PRIMARY KEY,
        papel VARCHAR(50),
        tipo VARCHAR(50),
        empresa VARCHAR(200),
        setor VARCHAR(200),
        cotacao DECIMAL(18,4),
        data_ult_cotacao DATE,
        min_52_sem DECIMAL(18,4),
        max_52_sem DECIMAL(18,4),
        vol_med_2m BIGINT,
        valor_mercado DECIMAL(20,2),
        valor_firma DECIMAL(20,2),
        ult_balanco_pro DATE,
        nr_acoes BIGINT,
        os_dia DECIMAL(18,2),
        pl DECIMAL(18,4),
        lpa DECIMAL(18,4),
        pvp DECIMAL(18,4),
        vpa DECIMAL(20,4),
        p_ebit DECIMAL(18,4),
        psr DECIMAL(18,4),
        p_ativos DECIMAL(18,4),
        p_cap_giro DECIMAL(18,4),
        p_ativo_circ_liq DECIMAL(18,4),
        ev_ebitda DECIMAL(18,4),
        ev_ebit DECIMAL(18,4),
        marg_bruta DECIMAL(10,4),
        marg_ebit DECIMAL(10,4),
        marg_liquida DECIMAL(10,4),
        ebit_ativo DECIMAL(18,4),
        roic DECIMAL(10,4),
        roe DECIMAL(10,4),
        cresc_rec_5a DECIMAL(10,4),
        div_yield DECIMAL(10,4),
        liquidez_corr DECIMAL(18,4),
        ativo DECIMAL(20,2),
        disponibilidades DECIMAL(20,2),
        ativo_circulante DECIMAL(20,2),
        div_bruta DECIMAL(20,2),
        div_liquida DECIMAL(20,2),
        patr_liquido DECIMAL(20,2),
        lucro_liquido_12m DECIMAL(20,2),
        lucro_liquido_3m DECIMAL(20,2)
    );

    INSERT INTO ##temp_dados_gerais_convertido (
        id_dados, papel, tipo, empresa, setor,
        cotacao, data_ult_cotacao, min_52_sem, max_52_sem, vol_med_2m,
        valor_mercado, valor_firma, ult_balanco_pro, nr_acoes, os_dia,
        pl, lpa, pvp, vpa, p_ebit, psr, p_ativos, p_cap_giro,
        p_ativo_circ_liq, ev_ebitda, ev_ebit, marg_bruta, marg_ebit,
        marg_liquida, ebit_ativo, roic, roe, cresc_rec_5a, div_yield,
        liquidez_corr, ativo, disponibilidades, ativo_circulante,
        div_bruta, div_liquida, patr_liquido, lucro_liquido_12m, lucro_liquido_3m
    )
    SELECT
        -- id
        TRY_CONVERT(INT, NULLIF(id, '-')) AS id,

        -- strings (trim)
        NULLIF(LTRIM(RTRIM(papel)), '') AS papel,
        NULLIF(LTRIM(RTRIM(tipo)), '') AS tipo,
        NULLIF(LTRIM(RTRIM(empresa)), '') AS empresa,
        NULLIF(LTRIM(RTRIM(setor)), '') AS setor,

        -- números e datas (pt-BR)
        TRY_CONVERT(DECIMAL(18,2),REPLACE(NULLIF(cotacao,'-'),',','.')) AS cotacao,

        TRY_CONVERT(DATE, NULLIF(data_ult_cotacao,'-'), 103) AS data_ult_cotacao,

        TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(min_52_sem,'-'),',','.') ) AS min_52_sem,
        TRY_CONVERT(DECIMAL(18,2), REPLACE(NULLIF(max_52_sem,'-'),',','.') ) AS max_52_sem,

        TRY_CONVERT(BIGINT, REPLACE(NULLIF(vol_med_2m,'-'),'.','')) AS vol_med_2m,

        TRY_CONVERT(BIGINT, REPLACE(NULLIF(valor_mercado,'-'),'.','')) AS valor_mercado,
        TRY_CONVERT(BIGINT, REPLACE(NULLIF(valor_firma,'-'),'.','')) AS valor_firma,

        TRY_CONVERT(DATE, NULLIF(ult_balanco_pro,'-'), 103) AS ult_balanco_pro,
        TRY_CONVERT(BIGINT, REPLACE(NULLIF(nr_acoes,'-'),'.','')) AS nr_acoes,
        TRY_CONVERT(DECIMAL(18,2), NULLIF(os_dia,'-')) AS os_dia,

        TRY_CONVERT(DECIMAL(16,2), NULLIF(pl,'-')) AS pl,
        TRY_CONVERT(DECIMAL(16,2), NULLIF(lpa,'-')) AS lpa,
        TRY_CONVERT(DECIMAL(16,2), NULLIF(pvp,'-')) AS pvp,
        TRY_CONVERT(DECIMAL(16,2), NULLIF(vpa,'-')) AS vpa,
        TRY_CONVERT(DECIMAL(16,2), NULLIF(p_ebit,'-')) AS p_ebit,

        TRY_CONVERT(DECIMAL(18,4), REPLACE(REPLACE(NULLIF(psr,'-'),'.',''),',','.') ) AS psr,
        TRY_CONVERT(DECIMAL(18,4), REPLACE(REPLACE(NULLIF(p_ativos,'-'),'.',''),',','.') ) AS p_ativos,
        TRY_CONVERT(DECIMAL(18,4), REPLACE(REPLACE(NULLIF(p_cap_giro,'-'),'.',''),',','.') ) AS p_cap_giro,
        TRY_CONVERT(DECIMAL(18,4), REPLACE(REPLACE(NULLIF(p_ativo_circ_liq,'-'),'.',''),',','.') ) AS p_ativo_circ_liq,
        TRY_CONVERT(DECIMAL(18,4), REPLACE(REPLACE(NULLIF(ev_ebitda,'-'),'.',''),',','.') ) AS ev_ebitda,
        TRY_CONVERT(DECIMAL(18,4), REPLACE(REPLACE(NULLIF(ev_ebit,'-'),'.',''),',','.') ) AS ev_ebit,

        TRY_CONVERT(DECIMAL(10,2), NULLIF(marg_bruta,'-')) AS marg_bruta,
        TRY_CONVERT(DECIMAL(10,4), REPLACE(REPLACE(NULLIF(marg_ebit,'-'),'.',''),',','.') ) AS marg_ebit,
        TRY_CONVERT(DECIMAL(10,4), REPLACE(REPLACE(NULLIF(marg_liquida,'-'),'.',''),',','.') ) AS marg_liquida,

        TRY_CONVERT(DECIMAL(18,2), NULLIF(ebit_ativo,'-')) AS ebit_ativo,
        TRY_CONVERT(DECIMAL(10,4), REPLACE(REPLACE(NULLIF(roic,'-'),'.',''),',','.') ) AS roic,
        TRY_CONVERT(DECIMAL(10,4), REPLACE(REPLACE(NULLIF(roe,'-'),'.',''),',','.') ) AS roe,

        TRY_CONVERT(DECIMAL(10,4), REPLACE(REPLACE(NULLIF(cresc_rec_5a,'-'),'.',''),',','.') ) AS cresc_rec_5a,
        TRY_CONVERT(DECIMAL(10,4), REPLACE(REPLACE(NULLIF(div_yield,'-'),'.',''),',','.') ) AS div_yield,
        TRY_CONVERT(DECIMAL(18,4), REPLACE(REPLACE(NULLIF(liquidez_corr,'-'),'.',''),',','.') ) AS liquidez_corr,

        TRY_CONVERT(BIGINT, REPLACE(NULLIF(ativo,'-'),'.','')) AS ativo,
        TRY_CONVERT(BIGINT, REPLACE(NULLIF(disponibilidades,'-'),'.','')) AS disponibilidades,
        TRY_CONVERT(BIGINT, REPLACE(NULLIF(ativo_circulante,'-'),'.','')) AS ativo_circulante,

        TRY_CONVERT(BIGINT, REPLACE(NULLIF(div_bruta,'-'),'.','')) AS div_bruta,
        TRY_CONVERT(BIGINT, REPLACE(NULLIF(div_liquida,'-'),'.','')) AS div_liquida,
        TRY_CONVERT(BIGINT, REPLACE(NULLIF(patr_liquido,'-'),'.','')) AS patr_liquido,

        TRY_CONVERT(BIGINT, REPLACE(NULLIF(lucro_liquido_12m,'-'),'.','')) AS lucro_liquido_12m,
        TRY_CONVERT(BIGINT, REPLACE(NULLIF(lucro_liquido_3m,'-'),'.','')) AS lucro_liquido_3m

    FROM ##temp_dados_gerais_bruto;

    PRINT '✅ Transformação concluída.';
END;
GO

------------------------------------------------------------
-- 3️⃣ CARGA - Insere na tabela final
------------------------------------------------------------
CREATE PROCEDURE SP_CARREGA_CSV_DADOS_GERAIS
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '💾 Iniciando carga de dados para dbo.dados_financeiros...';

    INSERT INTO dbo.dados_financeiros (
        id_dados, papel, tipo, empresa, setor,
        cotacao, data_ult_cotacao, min_52_sem, max_52_sem, vol_med_2m,
        valor_mercado, valor_firma, ult_balanco_pro, nr_acoes, os_dia,
        pl, lpa, pvp, vpa, p_ebit, psr, p_ativos, p_cap_giro,
        p_ativo_circ_liq, ev_ebitda, ev_ebit, marg_bruta, marg_ebit,
        marg_liquida, ebit_ativo, roic, roe, cresc_rec_5a, div_yield,
        liquidez_corr, ativo, disponibilidades, ativo_circulante,
        div_bruta, div_liquida, patr_liquido, lucro_liquido_12m, lucro_liquido_3m
    )
    SELECT * FROM ##temp_dados_gerais_convertido;

    PRINT '✅ Dados carregados com sucesso.';
END;
GO


------------------------------------------------------------
-- 4️⃣ ETL MASTER - Controla todo o processo
------------------------------------------------------------
CREATE PROCEDURE SP_ETL_DADOS_GERAIS
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '🚀 Iniciando processo ETL DADOS_GERAIS...';

    BEGIN TRY
        EXEC SP_EXTRAI_CSV_DADOS_GERAIS;
        EXEC SP_TRATA_CSV_DADOS_GERAIS;
        EXEC SP_CARREGA_CSV_DADOS_GERAIS;

        -- Limpa temporárias
        IF OBJECT_ID('tempdb..##temp_dados_gerais_bruto') IS NOT NULL DROP TABLE ##temp_dados_gerais_bruto;
        IF OBJECT_ID('tempdb..##temp_dados_gerais_convertido') IS NOT NULL DROP TABLE ##temp_dados_gerais_convertido;

        PRINT '🏁 Processo ETL finalizado com sucesso.';
    END TRY
    BEGIN CATCH
        PRINT '❌ Erro no processo ETL: ' + ERROR_MESSAGE();
    END CATCH
END;
GO