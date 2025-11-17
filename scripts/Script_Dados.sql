CREATE DATABASE dataset_b3;

USE dataset_b3;

CREATE TABLE setores (
  setor_id INTEGER PRIMARY KEY,
  nome_setor VARCHAR(255) NOT NULL,
  categoria_superior VARCHAR(255)
);

CREATE TABLE empresas (
  empresa_id INTEGER PRIMARY KEY,
  papel VARCHAR(10) UNIQUE NOT NULL,
  razao_social VARCHAR(255),
  cnpj VARCHAR(20),
  setor_id INTEGER,
  data_listagem DATE,
  CONSTRAINT fk_empresas_setores
	FOREIGN KEY (setor_id)
    REFERENCES setores(setor_id)
);

CREATE TABLE dbo.dados_financeiros (
    id_dados INT PRIMARY KEY NOT NULL,                        -- id do registro
    papel VARCHAR(50),                         -- código do ativo (ex: PETR4)
    tipo VARCHAR(50),                          -- tipo da ação (ON, PN, etc)
    empresa VARCHAR(200),                      -- nome da empresa
    setor VARCHAR(200),                        -- setor da empresa
    cotacao DECIMAL(18,2),                     -- cotação atual
    data_ult_cotacao DATE,                     -- data da última cotação
    min_52_sem DECIMAL(18,2),                  -- mínimo 52 semanas
    max_52_sem DECIMAL(18,2),                  -- máximo 52 semanas
    vol_med_2m BIGINT,                         -- volume médio 2 meses
    valor_mercado BIGINT,                      -- valor de mercado
    valor_firma BIGINT,                        -- valor da firma
    ult_balanco_pro DATE,                      -- data do último balanço
    nr_acoes BIGINT,                           -- número de ações
    os_dia DECIMAL(16,2),                                -- oscilação do dia
    pl DECIMAL(16,2),                          -- preço/lucro
    lpa DECIMAL(16,2),                         -- lucro por ação
    pvp DECIMAL(16,2),                         -- preço/valor patrimonial
    vpa DECIMAL(16,2),                         -- valor patrimonial por ação
    p_ebit DECIMAL(16,2),                      -- preço/EBIT
    psr DECIMAL(18,4),                         -- preço/receita
    p_ativos DECIMAL(18,4),                    -- preço/ativos
    p_cap_giro DECIMAL(18,4),                  -- preço/capital de giro
    p_ativo_circ_liq DECIMAL(18,4),            -- preço/ativo circulante líquido
    ev_ebitda DECIMAL(18,4),                   -- EV/EBITDA
    ev_ebit DECIMAL(18,4),                     -- EV/EBIT
    marg_bruta DECIMAL(10,2),                  -- margem bruta
    marg_ebit DECIMAL(10,4),                   -- margem EBIT
    marg_liquida DECIMAL(10,4),                -- margem líquida
    ebit_ativo DECIMAL(18,2),                  -- EBIT / Ativo
    roic DECIMAL(10,4),                        -- retorno sobre capital investido
    roe DECIMAL(10,4),                         -- retorno sobre patrimônio líquido
    cresc_rec_5a DECIMAL(10,4),                -- crescimento da receita em 5 anos
    div_yield DECIMAL(10,4),                   -- dividend yield
    liquidez_corr DECIMAL(18,4),               -- liquidez corrente
    ativo BIGINT NULL,
    disponibilidades BIGINT NULL,
    ativo_circulante BIGINT NULL,
    div_bruta BIGINT NULL,
    div_liquida BIGINT NULL,
    patr_liquido BIGINT NULL,
    lucro_liquido_12m BIGINT NULL,
    lucro_liquido_3m BIGINT NULL
);
GO


CREATE TABLE fatos_relevantes (
  acao VARCHAR (10),
  data_acao VARCHAR(10),
  hora TIME,
  descricao VARCHAR(MAX),
  link VARCHAR(MAX),
);

CREATE TABLE demonstracoes_trimestrais (
  id INTEGER PRIMARY KEY,
  data_referencia DATE,
  url_demonstracao VARCHAR(255),
  url_release VARCHAR(255),
  acao VARCHAR(10),
  CONSTRAINT fk_demonstracoestrimestrais_empresas
	FOREIGN KEY (acao)
    REFERENCES empresas(papel)
);

CREATE TABLE dbo.historico (
    acao VARCHAR(50) NOT NULL,
    ano    INT,
    jan    DECIMAL(20,4),
    feb    DECIMAL(20,4),
    mar    DECIMAL(20,4),
    apr    DECIMAL(20,4),
    may    DECIMAL(20,4),
    jun    DECIMAL(20,4),
    jul    DECIMAL(20,4),
    aug    DECIMAL(20,4),
    sep    DECIMAL(20,4),
    oct    DECIMAL(20,4),
    nov    DECIMAL(20,4),
    [dec]  DECIMAL(20,4),
    eoy    DECIMAL(20,4),
);


CREATE TABLE precos_diarios (
  id INTEGER PRIMARY KEY,
  acao VARCHAR(10),
  data_preco DATE,
  fechamento DECIMAL(10,6),
  maxima DECIMAL(10,6),
  minima DECIMAL(10,6),
  abertura DECIMAL(10,6),
  volume BIGINT,
  retorno_diario DECIMAL(8,4),
  retorno_acumulado DECIMAL(10,4),
  retorno_normalizado DECIMAL(15,12),
  retorno_futuro DECIMAL(15,12),
  volatilidade DECIMAL(15,12),
  mm20 DECIMAL(10,6),
  detrend DECIMAL(10,6),
  CONSTRAINT fk_precosdiarios_empresas
	FOREIGN KEY (acao)
    REFERENCES empresas(papel)
);

CREATE TABLE dbo.proventos (
    data_decl DATE NULL,                   -- Data da declaração do provento
    valor DECIMAL(10,4) NULL,              -- Valor unitário do provento (por ação)
    tipo VARCHAR(50) NULL,                 -- Tipo de provento (ex: DIVIDENDO, JCP)
    data_pagamento DATE NULL,              -- Data do pagamento efetivo
    quant_acoes INT NULL,                  -- Quantas ações base para o pagamento
    acao VARCHAR(10) NULL,                 -- Código do ativo (ex: ALUP11)

);

CREATE TABLE retornos_acumulados (
  id INTEGER PRIMARY KEY,
  acao VARCHAR(10),
  periodo_dias INTEGER,
  total_acumulado DECIMAL(8,2),
  CONSTRAINT fk_retornosacumulados_empresas
	FOREIGN KEY (acao)
    REFERENCES empresas(papel)
);

CREATE TABLE sites_ri (
  id INTEGER PRIMARY KEY,
  acao VARCHAR(10),
  site VARCHAR(255),
  CONSTRAINT fk_sitesri_empresas
	FOREIGN KEY (acao)
    REFERENCES empresas(papel)
);
----------
CREATE TABLE balancos_anuais (
  id INTEGER PRIMARY KEY,
  empresa_id INTEGER,
  ano INTEGER,
  link_balanco VARCHAR(255),
  link_demo_fin VARCHAR(255),
  CONSTRAINT fk_balancosanuais_empresas
	FOREIGN KEY (empresa_id)
    REFERENCES empresas(empresa_id)
);

CREATE TABLE indicadores_setoriais (
  id INTEGER PRIMARY KEY,
  setor_id INTEGER,
  data_referencia DATE,
  media_pl DOUBLE PRECISION,
  media_pvp DOUBLE PRECISION,
  media_div_yield DOUBLE PRECISION,
  sum_valor_mercado DOUBLE PRECISION,
  CONSTRAINT fk_indicadoressetoriais_setores
	FOREIGN KEY (setor_id)
    REFERENCES setores(setor_id)
);

CREATE TABLE cotacoes_setoriais (
  id INTEGER PRIMARY KEY,
  setor_id INTEGER,
  data DATE,
  valor_mercado_total DOUBLE PRECISION,
  retorno_setor_pct DOUBLE PRECISION,
  CONSTRAINT fk_cotacoessetoriais_setores
	FOREIGN KEY (setor_id)
    REFERENCES setores(setor_id)
);

CREATE TABLE dividendos_setoriais (
  id INTEGER PRIMARY KEY,
  setor_id INTEGER,
  ano INTEGER,
  total_proventos_valor DOUBLE PRECISION,
  total_proventos_quantidade INTEGER,
  CONSTRAINT fk_dividendossetoriais_setores
	FOREIGN KEY (setor_id)
    REFERENCES setores(setor_id)
);

CREATE TABLE fatos_setoriais (
  id INTEGER PRIMARY KEY,
  setor_id INTEGER,
  data DATE,
  tipo_evento VARCHAR(100),
  descricao VARCHAR(500),
  numero_empresas_afetadas INTEGER,
  CONSTRAINT fk_fatossetoriais_setores
	FOREIGN KEY (setor_id)
    REFERENCES setores(setor_id)
);