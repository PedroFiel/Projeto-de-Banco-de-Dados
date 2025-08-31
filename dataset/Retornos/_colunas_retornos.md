# Descrição das Colunas - Retornos Acumulados por Período

## Pasta -> Retornos/

## Estrutura dos Dados

Esta pasta contém **4 arquivos CSV** com retornos acumulados de **404 empresas** listadas na B3, calculados para diferentes janelas temporais: 15, 30, 45 e 60 dias. Cada arquivo representa uma análise de performance de curto prazo das ações.

## Arquivos Disponíveis

### **Janelas Temporais de Análise**
- `retornos_acumulados_15d.csv` - Retornos acumulados em 15 dias
- `retornos_acumulados_30d.csv` - Retornos acumulados em 30 dias  
- `retornos_acumulados_45d.csv` - Retornos acumulados em 45 dias
- `retornos_acumulados_60d.csv` - Retornos acumulados em 60 dias

## Colunas

### **Identificação do Registro**

- (1) **Index (sem nome)**:

1. Descrição -> Índice sequencial da empresa no ranking de retornos.
2. Tipo(type) -> integer

### **Identificação da Empresa**

- (2) **Papel**:

1. Descrição -> Código da ação na B3 (ex: VALE3, PETR4, WEGE3).
2. Tipo(type) -> varchar(10)

### **Performance Financeira**

- (3) **Total_Acumulado**:

1. Descrição -> Retorno percentual acumulado da ação no período especificado.
2. Tipo(type) -> decimal(8,2)

## Informações Adicionais

### **Fonte dos Dados**
- **Website**: [dadosdemercado.com.br](https://www.dadosdemercado.com.br/acoes)
- **Período de referência**: Dados calculados até agosto de 2025
- **Cobertura**: 404 empresas ativas na B3
- **Metodologia**: Retornos calculados com base em preços de fechamento
