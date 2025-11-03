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

CREATE TABLE dados_financeiros (
  id INTEGER PRIMARY KEY,
  data_dado_inserido DATE,
  papel VARCHAR(10),
  tipo VARCHAR(255),
  empresa VARCHAR(255),
  setor VARCHAR(255),
  cotacao INTEGER,
  data_ult_cotacao DATE,
  min_52_sem INTEGER,
  max_52_sem INTEGER,
  vol_med_2m INTEGER,
  valor_mercado INTEGER,
  valor_firma DOUBLE PRECISION,
  ult_balanco_pro DOUBLE PRECISION,
  nr_acoes INTEGER,
  os_dia DOUBLE PRECISION,
  pl DOUBLE PRECISION,
  lpa DOUBLE PRECISION,
  pvp DOUBLE PRECISION,
  vpa DOUBLE PRECISION,
  p_ebit DOUBLE PRECISION,
  psr DOUBLE PRECISION,
  p_ativos DOUBLE PRECISION,
  p_cap_giro DOUBLE PRECISION,
  p_ativo_circ_liq DOUBLE PRECISION,
  ev_ebitda DOUBLE PRECISION,
  ev_ebit DOUBLE PRECISION,
  marg_bruta DOUBLE PRECISION,
  marg_ebit DOUBLE PRECISION,
  marg_liquida DOUBLE PRECISION,
  ebit_ativo DOUBLE PRECISION,
  roic DOUBLE PRECISION,
  roe DOUBLE PRECISION,
  cresc_rec_5a DOUBLE PRECISION,
  div_yield DOUBLE PRECISION,
  liquidez_corr DOUBLE PRECISION,
  ativo DOUBLE PRECISION,
  disponibilidades DOUBLE PRECISION,
  ativo_circulante DOUBLE PRECISION,
  div_bruta DOUBLE PRECISION,
  div_liquida DOUBLE PRECISION,
  patr_liquido DOUBLE PRECISION,
  lucro_liquido_12m DOUBLE PRECISION,
  lucro_liquido_3m DOUBLE PRECISION,
  CONSTRAINT fk_dadosfinanceiros_empresas
	FOREIGN KEY (papel)
    REFERENCES empresas(papel)
);

CREATE TABLE fatos_relevantes (
  id INTEGER PRIMARY KEY,
  acao VARCHAR(10),
  data DATE,
  hora TIME,
  descricao VARCHAR(500),
  link VARCHAR(500),
  CONSTRAINT fk_fatosrelevantes_empresas
	FOREIGN KEY (acao)
    REFERENCES empresas(papel)
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

CREATE TABLE historico_mensal (
  id INTEGER PRIMARY KEY,
  acao VARCHAR(10),
  ano INTEGER,
  mes INTEGER,
  CONSTRAINT fk_historicomensal_empresas
	FOREIGN KEY (acao)
    REFERENCES empresas(papel)
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

CREATE TABLE proventos (
  id INTEGER PRIMARY KEY,
  data_decl DATE,
  valor DECIMAL(10,4),
  tipo VARCHAR(50),
  data_pagamento VARCHAR(50),
  quant_acoes INTEGER,
  acao VARCHAR(10),
  CONSTRAINT fk_proventos_empresas
	FOREIGN KEY (acao)
    REFERENCES empresas(papel)
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