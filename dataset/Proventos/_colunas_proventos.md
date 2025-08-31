# Descrição das Colunas - Histórico de Proventos

## Pasta -> Proventos/

## Estrutura dos Dados

Esta pasta contém **435 arquivos CSV**, um para cada empresa listada na B3, com histórico completo de distribuição de proventos (dividendos, juros sobre capital próprio, bonificações, etc.). O número de registros varia significativamente por empresa, de 5 a 204 proventos históricos.

## Colunas

### **Identificação do Registro**

- (1) **Index (sem nome)**:

1. Descrição -> Índice sequencial do provento no histórico da empresa.
2. Tipo(type) -> integer

### **Informações Temporais**

- (2) **Data**:

1. Descrição -> Data de aprovação/declaração do provento no formato DD/MM/AAAA.
2. Tipo(type) -> date

- (5) **Data de Pagamento**:

1. Descrição -> Data efetiva de pagamento do provento aos acionistas (formato DD/MM/AAAA + espaços).
2. Tipo(type) -> varchar(50)

### **Informações Financeiras**

- (3) **Valor**:

1. Descrição -> Valor do provento por ação em Reais (formato decimal com vírgula).
2. Tipo(type) -> decimal(10,4)

- (6) **Por quantas ações**:

1. Descrição -> Proporção de ações que recebem o provento (geralmente 1 = para cada ação).
2. Tipo(type) -> integer

### **Classificação do Provento**

- (4) **Tipo**:

1. Descrição -> Tipo de provento distribuído pela empresa.
2. Tipo(type) -> varchar(50)

### **Identificação da Empresa**

- (7) **Acao**:

1. Descrição -> Código da ação na B3 (ex: VALE3, PETR4, WEGE3).
2. Tipo(type) -> varchar(10)

## Informações Adicionais

### **Fonte dos Dados**
- **Website**: [dadosdemercado.com.br](https://www.dadosdemercado.com.br/acoes)
- **Período**: Histórico desde início das operações de cada empresa
- **Cobertura**: 435 empresas com histórico de proventos na B3
- **Atualização**: Dados atualizados até agosto de 2025
