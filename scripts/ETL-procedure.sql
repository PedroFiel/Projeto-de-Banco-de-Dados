-- =========================================
-- DADOS GERAIS
-- =========================================

CREATE OR ALTER PROCEDURE SP_DADOS_GERAIS
    @CAMINHO_CSV VARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        ------------------------------------------------------
        -- 1️⃣ Limpa staging anterior, se existir
        ------------------------------------------------------
        IF OBJECT_ID('tempdb..#STG_DADOS_GERAIS') IS NOT NULL
            DROP TABLE #STG_DADOS_GERAIS;

        ------------------------------------------------------
        -- 2️⃣ Cria tabela staging (dados crus do CSV)
        ------------------------------------------------------
        CREATE TABLE #STG_DADOS_GERAIS
        (
            id VARCHAR(50),
            data_dado_inserido VARCHAR(50),
            papel VARCHAR(50),
            tipo VARCHAR(255),
            empresa VARCHAR(255),
            setor VARCHAR(255),
            cotacao VARCHAR(50),
            data_ult_cotacao VARCHAR(50),
            min_52_sem VARCHAR(50),
            max_52_sem VARCHAR(50),
            vol_med_2m VARCHAR(50),
            valor_mercado VARCHAR(50),
            valor_firma VARCHAR(50),
            ult_balanco_pro VARCHAR(50),
            nr_acoes VARCHAR(50),
            os_dia VARCHAR(50),
            pl VARCHAR(50),
            lpa VARCHAR(50),
            pvp VARCHAR(50),
            vpa VARCHAR(50),
            p_ebit VARCHAR(50),
            psr VARCHAR(50),
            p_ativos VARCHAR(50),
            p_cap_giro VARCHAR(50),
            p_ativo_circ_liq VARCHAR(50),
            ev_ebitda VARCHAR(50),
            ev_ebit VARCHAR(50),
            marg_bruta VARCHAR(50),
            marg_ebit VARCHAR(50),
            marg_liquida VARCHAR(50),
            ebit_ativo VARCHAR(50),
            roic VARCHAR(50),
            roe VARCHAR(50),
            cresc_rec_5a VARCHAR(50),
            div_yield VARCHAR(50),
            liquidez_corr VARCHAR(50),
            ativo VARCHAR(50),
            disponibilidades VARCHAR(50),
            ativo_circulante VARCHAR(50),
            div_bruta VARCHAR(50),
            div_liquida VARCHAR(50),
            patr_liquido VARCHAR(50),
            lucro_liquido_12m VARCHAR(50),
            lucro_liquido_3m VARCHAR(50)
        );

        ------------------------------------------------------
        -- 3️⃣ Importa CSV para staging
        ------------------------------------------------------
        BULK INSERT #STG_DADOS_GERAIS
        FROM @CAMINHO_CSV
        WITH
        (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            FIELDTERMINATOR = ';',  -- ajuste conforme seu CSV
            ROWTERMINATOR = '\n',
            CODEPAGE = '65001',     -- UTF-8
            TABLOCK
        );

        ------------------------------------------------------
        -- 4️⃣ Insere dados tratados na tabela final
        ------------------------------------------------------
        INSERT INTO DADOS_GERAIS
        (
            id, data_dado_inserido, papel, tipo, empresa, setor,
            cotacao, data_ult_cotacao, min_52_sem, max_52_sem, vol_med_2m,
            valor_mercado, valor_firma, ult_balanco_pro, nr_acoes, os_dia,
            pl, lpa, pvp, vpa, p_ebit, psr, p_ativos, p_cap_giro,
            p_ativo_circ_liq, ev_ebitda, ev_ebit, marg_bruta, marg_ebit,
            marg_liquida, ebit_ativo, roic, roe, cresc_rec_5a, div_yield,
            liquidez_corr, ativo, disponibilidades, ativo_circulante,
            div_bruta, div_liquida, patr_liquido, lucro_liquido_12m, lucro_liquido_3m
        )
        SELECT
            TRY_CAST(id AS INT),
            TRY_CONVERT(DATE, data_dado_inserido, 103),
            LTRIM(RTRIM(papel)),
            LTRIM(RTRIM(tipo)),
            LTRIM(RTRIM(empresa)),
            LTRIM(RTRIM(setor)),
            TRY_CAST(REPLACE(cotacao, ',', '.') AS FLOAT),
            TRY_CONVERT(DATE, data_ult_cotacao, 103),
            TRY_CAST(REPLACE(min_52_sem, ',', '.') AS FLOAT),
            TRY_CAST(REPLACE(max_52_sem, ',', '.') AS FLOAT),
            TRY_CAST(REPLACE(vol_med_2m, ',', '.') AS FLOAT),
            TRY_CAST(REPLACE(valor_mercado, ',', '.') AS FLOAT),
            TRY_CAST(REPLACE(valor_firma, ',', '.') AS FLOAT),
            TRY_CAST(REPLACE(ult_balanco_pro, ',', '.') AS FLOAT),
            TRY_CAST(REPLACE(nr_acoes, ',', '.') AS FLOAT),
            TRY_CAST(REPLACE(os_dia, ',', '.') AS FLOAT),
            TRY_CAST(REPLACE(pl, ',', '.') AS FLOAT),
            TRY_CAST(REPLACE(lpa, ',', '.') AS FLOAT),
            TRY_CAST(REPLACE(pvp, ',', '.') AS FLOAT),
            TRY_CAST(REPLACE(vpa, ',', '.') AS FLOAT),
            TRY_CAST(REPLACE(p_ebit, ',', '.') AS FLOAT),
            TRY_CAST(REPLACE(psr, ',', '.') AS FLOAT),
            TRY_CAST(REPLACE(p_ativos, ',', '.') AS FLOAT),
            TRY_CAST(REPLACE(p_cap_giro, ',', '.') AS FLOAT),
            TRY_CAST(REPLACE(p_ativo_circ_liq, ',', '.') AS FLOAT),
            TRY_CAST(REPLACE(ev_ebitda, ',', '.') AS FLOAT),
            TRY_CAST(REPLACE(ev_ebit, ',', '.') AS FLOAT),
            TRY_CAST(REPLACE(marg_bruta, ',', '.') AS FLOAT),
            TRY_CAST(REPLACE(marg_ebit, ',', '.') AS FLOAT),
            TRY_CAST(REPLACE(marg_liquida, ',', '.') AS FLOAT),
            TRY_CAST(REPLACE(ebit_ativo, ',', '.') AS FLOAT),
            TRY_CAST(REPLACE(roic, ',', '.') AS FLOAT),
            TRY_CAST(REPLACE(roe, ',', '.') AS FLOAT),
            TRY_CAST(REPLACE(cresc_rec_5a, ',', '.') AS FLOAT),
            TRY_CAST(REPLACE(div_yield, ',', '.') AS FLOAT),
            TRY_CAST(REPLACE(liquidez_corr, ',', '.') AS FLOAT),
            TRY_CAST(REPLACE(ativo, ',', '.') AS FLOAT),
            TRY_CAST(REPLACE(disponibilidades, ',', '.') AS FLOAT),
            TRY_CAST(REPLACE(ativo_circulante, ',', '.') AS FLOAT),
            TRY_CAST(REPLACE(div_bruta, ',', '.') AS FLOAT),
            TRY_CAST(REPLACE(div_liquida, ',', '.') AS FLOAT),
            TRY_CAST(REPLACE(patr_liquido, ',', '.') AS FLOAT),
            TRY_CAST(REPLACE(lucro_liquido_12m, ',', '.') AS FLOAT),
            TRY_CAST(REPLACE(lucro_liquido_3m, ',', '.') AS FLOAT)
        FROM #STG_DADOS_GERAIS;

        ------------------------------------------------------
        -- 5️⃣ Log de sucesso
        ------------------------------------------------------
        INSERT INTO B3_LOG (ProcedureName, FilePath, Status, Message)
        VALUES ('SP_DADOS_GERAIS', @CAMINHO_CSV, 'SUCESSO', 'Arquivo carregado e tratado com sucesso');

    END TRY
    BEGIN CATCH
        ------------------------------------------------------
        -- 6️⃣ Log de erro
        ------------------------------------------------------
        INSERT INTO ETL_LOG (ProcedureName, FilePath, Status, Message)
        VALUES ('SP_DADOS_GERAIS', @CAMINHO_CSV, 'ERRO', ERROR_MESSAGE());
    END CATCH
END;
GO

-- =========================================
-- FATOS RELEVANTES
-- =========================================

CREATE OR ALTER PROCEDURE SP_ETL_FATOS_RELEVANTES
    @CAMINHO_CSV VARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        ------------------------------------------------------
        -- 1️⃣ Remove staging anterior, se existir
        ------------------------------------------------------
        IF OBJECT_ID('tempdb..#STG_FATOS_RELEVANTES') IS NOT NULL
            DROP TABLE #STG_FATOS_RELEVANTES;

        ------------------------------------------------------
        -- 2️⃣ Cria tabela staging (dados crus do CSV)
        ------------------------------------------------------
        CREATE TABLE #STG_FATOS_RELEVANTES
        (
            id VARCHAR(50),
            acao VARCHAR(50),
            data VARCHAR(50),
            hora VARCHAR(50),
            descricao VARCHAR(1000),
            link VARCHAR(1000)
        );

        ------------------------------------------------------
        -- 3️⃣ Importa CSV na staging
        ------------------------------------------------------
        BULK INSERT #STG_FATOS_RELEVANTES
        FROM @CAMINHO_CSV
        WITH
        (
            FORMAT = 'CSV',
            FIRSTROW = 2,              -- ignora cabeçalho
            FIELDTERMINATOR = ';',     -- ajuste se for vírgula
            ROWTERMINATOR = '\n',
            CODEPAGE = '65001',        -- UTF-8 (ou 'ACP' para Latin1)
            TABLOCK
        );

        ------------------------------------------------------
        -- 4️⃣ Insere dados tratados na tabela final
        ------------------------------------------------------
        INSERT INTO FATOS_RELEVANTES
        (
            acao,
            data,
            hora,
            descricao,
            link
        )
        SELECT
            -- 🔹 Código da ação limpo
            UPPER(LTRIM(RTRIM(REPLACE(acao, '"', '')))) AS acao,

            -- 🔹 Conversão segura de data
            COALESCE(
                TRY_CONVERT(DATE, data, 103),  -- dd/mm/yyyy
                TRY_CONVERT(DATE, data, 23)    -- yyyy-mm-dd
            ) AS data,

            -- 🔹 Conversão de hora (remove segundos se necessário)
            TRY_CONVERT(TIME, hora) AS hora,

            -- 🔹 Limpeza de texto da descrição e link
            LTRIM(RTRIM(REPLACE(descricao, '"', ''))) AS descricao,
            LTRIM(RTRIM(REPLACE(link, '"', ''))) AS link
        FROM #STG_FATOS_RELEVANTES
        WHERE acao IS NOT NULL
          AND acao <> '';

        ------------------------------------------------------
        -- 5️⃣ Log de sucesso
        ------------------------------------------------------
        INSERT INTO B3_LOG (ProcedureName, FilePath, Status, Message)
        VALUES ('SP_FATOS_RELEVANTES', @CAMINHO_CSV, 'SUCESSO', 'Arquivo carregado e tratado com sucesso');

    END TRY
    BEGIN CATCH
        ------------------------------------------------------
        -- 6️⃣ Log de erro
        ------------------------------------------------------
        INSERT INTO B3_LOG (ProcedureName, FilePath, Status, Message)
        VALUES ('SP_FATOS_RELEVANTES', @CAMINHO_CSV, 'ERRO', ERROR_MESSAGE());
    END CATCH
END;
GO

