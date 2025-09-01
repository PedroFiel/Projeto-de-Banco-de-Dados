# Descrição das Colunas - Demonstrações Financeiras Trimestrais

## Pasta -> Trimestre/

## Estrutura dos Dados

Esta pasta contém **488 arquivos CSV**, um para cada empresa listada na B3, com links para as demonstrações financeiras trimestrais e releases de resultados arquivados na CVM (Comissão de Valores Mobiliários). Os arquivos contêm histórico desde 2010 até 2025, com atualizações trimestrais.

## Colunas

### **Identificação do Registro**

- (1) **Index (sem nome)**:

1. Descrição -> Índice sequencial do registro (0 a N, ordem cronológica reversa).
2. Tipo(type) -> integer

### **Informações Temporais**

- (2) **Data Referência**:

1. Descrição -> Data de referência da demonstração financeira no formato DD/MM/AAAA.
2. Tipo(type) -> date

### **Links para Documentos**

- (3) **Demonstração Financeira**:

1. Descrição -> URL para a demonstração financeira completa no sistema da CVM.
2. Tipo(type) -> varchar(255)

- (4) **Release de Resultados**:

1. Descrição -> URL para o release de resultados (press release) no sistema da CVM.
2. Tipo(type) -> varchar(255)

### **Identificação da Empresa**

- (5) **Acao**:

1. Descrição -> Código da ação na B3 (ex: VALE3, PETR4, WEGE3).
2. Tipo(type) -> varchar(10)

## Informações Adicionais

### **Fonte dos Dados**
- **Website**: [dadosdemercado.com.br](https://www.dadosdemercado.com.br/acoes)
- **Sistema CVM**: rad.cvm.gov.br (ENET - Sistema de Envio de Informações)
- **Período**: 2010 a 2025 (histórico de 15 anos)
- **Frequência**: Trimestral (4 releases por ano)