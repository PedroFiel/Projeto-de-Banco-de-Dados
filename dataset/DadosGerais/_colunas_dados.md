# Descrição das Colunas - Dados Gerais Financeiros

## Banco de Dados -> dados_financeiros

## Estrutura dos Dados

Esta tabela contém **43 colunas** com dados fundamentalistas e de mercado de **402 empresas** listadas na B3, organizadas por segmentos estratégicos (Saneamento, Bancos, Eletricidade, Telecomunicações, Commodities e Seguros).

## Colunas

### **Informações Básicas**

- (1) **data_dado_inserido**:

1. Descrição -> Data em que o dado foi inserido no banco de dados. :white_check_mark:
2. Tipo(type) -> date

- (2) **papel**:

1. Descrição -> Código da ação na B3 (ex: VALE3, PETR4, BBAS3).
2. Tipo(type) -> varchar(255)

- (3) **tipo**:

1. Descrição -> Tipo da ação (ON = Ordinária / PN = Preferencial / UNIT = Units).
2. Tipo(type) -> varchar(255)
3. Referência -> [Diferenças entre tipos de ações](https://comoinvestir.thecap.com.br/diferenca-entre-acoes-preferenciais-ordinarias-units/)

- (4) **empresa**:

1. Descrição -> Nome comercial/razão social da empresa.
2. Tipo(type) -> varchar(255)

- (5) **setor**:

1. Descrição -> Classificação setorial da empresa na B3.
2. Tipo(type) -> varchar(255)

### **Dados de Cotação e Mercado**

- (6) **cotacao**:

1. Descrição -> Cotação de fechamento da ação na data de referência.
2. Tipo(type) -> money

- (7) **data_ult_cotacao**:

1. Descrição -> Data do último pregão em que o ativo foi negociado.
2. Tipo(type) -> date

- (8) **min_52_sem**:

1. Descrição -> Menor cotação da ação nos últimos 12 meses (52 semanas).
2. Tipo(type) -> money

- (9) **max_52_sem**:

1. Descrição -> Maior cotação da ação nos últimos 12 meses (52 semanas).
2. Tipo(type) -> money

- (10) **vol_med(2m)**:

1. Descrição -> Volume médio de negociações da ação nos últimos 2 meses (em R$).
2. Tipo(type) -> money

- (11) **valor_mercado**:

1. Descrição -> Valor de mercado da empresa (Market Cap) = Preço da ação × Número total de ações.
2. Tipo(type) -> money

- (12) **valor_firma**:

1. Descrição -> Valor da firma (Enterprise Value) = Valor de mercado + Dívida líquida.
2. Tipo(type) -> money

- (13) **ult_balanco_pro**:

1. Descrição -> Data do último balanço processado/divulgado pela empresa.
2. Tipo(type) -> date

- (14) **nr_acoes**:

1. Descrição -> Número total de ações em circulação (ON + PN + UNIT).
2. Tipo(type) -> integer

- (15) **os_dia**:

1. Descrição -> Oscilação percentual da ação no dia da coleta dos dados.
2. Tipo(type) -> double precision

### **Indicadores de Valuation**

- (16) **pl** (Preço/Lucro):

1. Descrição -> Preço da ação dividido pelo lucro por ação (múltiplo de valuation).
2. Tipo(type) -> double precision

- (17) **lpa** (Lucro por Ação):

1. Descrição -> Lucro líquido dividido pelo número de ações em circulação.
2. Tipo(type) -> double precision

- (18) **pvp** (Preço/Valor Patrimonial):

1. Descrição -> Preço da ação dividido pelo valor patrimonial por ação.
2. Tipo(type) -> double precision

- (19) **vpa** (Valor Patrimonial por Ação):

1. Descrição -> Patrimônio líquido dividido pelo número total de ações.
2. Tipo(type) -> double precision

- (20) **p_ebit** (Preço/EBIT):

1. Descrição -> Preço da ação dividido pelo EBIT por ação.
2. Tipo(type) -> double precision

- (22) **psr** (Preço/Receita):

1. Descrição -> Preço da ação dividido pela receita líquida por ação.
2. Tipo(type) -> double precision

- (24) **p_ativos** (Preço/Ativos):

1. Descrição -> Preço da ação dividido pelos ativos totais por ação.
2. Tipo(type) -> double precision

- (26) **p_cap_giro** (Preço/Capital de Giro):

1. Descrição -> Preço da ação dividido pelo capital de giro por ação.
2. Tipo(type) -> double precision

- (28) **p_ativo_circ_liq** (Preço/Ativo Circulante Líquido):

1. Descrição -> Preço da ação dividido pelos ativos circulantes líquidos por ação.
2. Tipo(type) -> double precision

- (32) **ev_ebitda** (EV/EBITDA):

1. Descrição -> Enterprise Value dividido pelo EBITDA (múltiplo de valuation).
2. Tipo(type) -> double precision

- (34) **ev_ebit** (EV/EBIT):

1. Descrição -> Enterprise Value dividido pelo EBIT.
2. Tipo(type) -> double precision

### **Indicadores de Rentabilidade e Margens**

- (21) **marg_bruta** (Margem Bruta):

1. Descrição -> Lucro bruto dividido pela receita líquida (%).
2. Tipo(type) -> double precision

- (23) **marg_ebit** (Margem EBIT):

1. Descrição -> EBIT dividido pela receita líquida (%).
2. Tipo(type) -> double precision

- (25) **marg_liquida** (Margem Líquida):

1. Descrição -> Lucro líquido dividido pela receita líquida (%).
2. Tipo(type) -> double precision

- (27) **ebit_ativo** (EBIT/Ativo):

1. Descrição -> EBIT dividido pelos ativos totais (rentabilidade dos ativos).
2. Tipo(type) -> double precision

- (29) **roic** (Retorno sobre Capital Investido):

1. Descrição -> EBIT dividido pelo capital investido (ativos - fornecedores - caixa).
2. Tipo(type) -> double precision

- (31) **roe** (Retorno sobre Patrimônio Líquido):

1. Descrição -> Lucro líquido dividido pelo patrimônio líquido (%).
2. Tipo(type) -> double precision

- (35) **cres_rec(5a)** (Crescimento da Receita 5 anos):

1. Descrição -> Taxa de crescimento da receita líquida nos últimos 5 anos (%).
2. Tipo(type) -> double precision

### **Indicadores de Dividendos e Liquidez**

- (30) **div_yield** (Dividend Yield):

1. Descrição -> Dividendos pagos por ação dividido pelo preço da ação (%).
2. Tipo(type) -> double precision

- (33) **liquidez_corr** (Liquidez Corrente):

1. Descrição -> Ativo circulante dividido pelo passivo circulante (índice de liquidez).
2. Tipo(type) -> double precision

### **Dados Patrimoniais (em R$)**

- (36) **ativo**:

1. Descrição -> Total de ativos da empresa (bens, direitos e valores a receber).
2. Tipo(type) -> money

- (37) **disponibilidades**:

1. Descrição -> Caixa e equivalentes de caixa (recursos líquidos imediatos).
2. Tipo(type) -> money

- (38) **ativo_circulante**:

1. Descrição -> Ativos que podem ser convertidos em dinheiro em curto prazo (< 1 ano).
2. Tipo(type) -> money

- (39) **div_bruta** (Dívida Bruta):

1. Descrição -> Total das dívidas de curto e longo prazo + debêntures.
2. Tipo(type) -> money

- (40) **div_liquida** (Dívida Líquida):

1. Descrição -> Dívida bruta menos disponibilidades (se negativo = caixa líquido positivo).
2. Tipo(type) -> money

- (41) **patr_liquido** (Patrimônio Líquido):

1. Descrição -> Valor contábil pertencente aos acionistas (Ativos - Passivos).
2. Tipo(type) -> money

- (42) **lucro_liquido_12m**:

1. Descrição -> Lucro líquido acumulado dos últimos 12 meses.
2. Tipo(type) -> money

- (43) **lucro_liquido_3m**:

1. Descrição -> Lucro líquido dos últimos 3 meses (trimestre).
2. Tipo(type) -> money

## Informações Adicionais

### **Fonte dos Dados**
- **Website**: [dadosdemercado.com.br](https://www.dadosdemercado.com.br/acoes)
- **Período**: Dados atualizados até agosto de 2025
- **Cobertura**: 402 empresas de 6 segmentos estratégicos da B3
