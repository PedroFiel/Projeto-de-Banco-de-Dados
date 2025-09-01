# Descrição das Colunas - Séries Temporais de Preços

## Pasta -> Precos/

## Estrutura dos Dados

Esta pasta contém **407 arquivos CSV**, um para cada empresa listada na B3, com séries temporais diárias de preços e indicadores técnicos. Cada arquivo possui **346 linhas** representando aproximadamente 1 ano e 4 meses de dados de negociação (abril/2024 a agosto/2025).

## Colunas

### **Identificação Temporal**

- (1) **Date**:

1. Descrição -> Data de referência da cotação no formato AAAA-MM-DD.
2. Tipo(type) -> date

### **Dados OHLCV (Open, High, Low, Close, Volume)**

- (2) **Close** (Fechamento):

1. Descrição -> Preço de fechamento da ação na data de referência (em R$).
2. Tipo(type) -> decimal(10,6)

- (3) **High** (Máxima):

1. Descrição -> Preço máximo atingido pela ação durante o pregão (em R$).
2. Tipo(type) -> decimal(10,6)

- (4) **Low** (Mínima):

1. Descrição -> Preço mínimo atingido pela ação durante o pregão (em R$).
2. Tipo(type) -> decimal(10,6)

- (5) **Open** (Abertura):

1. Descrição -> Preço de abertura da ação no início do pregão (em R$).
2. Tipo(type) -> decimal(10,6)

- (6) **Volume**:

1. Descrição -> Quantidade total de ações negociadas no pregão.
2. Tipo(type) -> bigint

### **Indicadores de Retorno**

- (7) **ret** (Retorno Diário):

1. Descrição -> Retorno percentual diário da ação (formato decimal: 1.09 = 1.09%).
2. Tipo(type) -> decimal(8,4)

- (8) **tret** (Retorno Total Acumulado):

1. Descrição -> Retorno percentual acumulado desde o início da série.
2. Tipo(type) -> decimal(10,4)

- (9) **Returns** (Retorno Normalizado):

1. Descrição -> Retorno diário em formato decimal normalizado para cálculos.
2. Tipo(type) -> decimal(15,12)

- (10) **Target** (Retorno Futuro):

1. Descrição -> Retorno esperado do próximo período (usado para modelagem preditiva).
2. Tipo(type) -> decimal(15,12)

### **Indicadores Técnicos**

- (11) **Vol** (Volatilidade):

1. Descrição -> Medida de volatilidade histórica da ação (desvio padrão dos retornos).
2. Tipo(type) -> decimal(15,12)

- (12) **MM20** (Média Móvel 20 períodos):

1. Descrição -> Média móvel simples dos últimos 20 pregões (indicador de tendência).
2. Tipo(type) -> decimal(10,6)

- (13) **Detrend** (Série Destendenciada):

1. Descrição -> Série de preços com tendência removida (análise de ciclos).
2. Tipo(type) -> decimal(10,6)

## Informações Adicionais

### **Fonte dos Dados**
- **Website**: [dadosdemercado.com.br](https://www.dadosdemercado.com.br/acoes)
- **Período**: Abril de 2024 a Agosto de 2025
- **Cobertura**: 407 empresas com negociação ativa na B3
- **Frequência**: Dados diários de pregão