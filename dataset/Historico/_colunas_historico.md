# Descrição das Colunas - Histórico de Performance

## Pasta -> Historico/

## Estrutura dos Dados

Esta pasta contém **431 arquivos CSV**, um para cada empresa listada na B3, com dados históricos de performance mensal das ações desde o ano 2000. Os dados representam os retornos percentuais mensais e anuais de cada ação.

## Colunas

### **Identificação Temporal**

- (1) **Index (sem nome)**:

1. Descrição -> Ano de referência dos dados de performance (ex: 2000, 2001, 2024).
2. Tipo(type) -> integer

### **Retornos Mensais (%)**

- (2) **JAN** (Janeiro):

1. Descrição -> Retorno percentual da ação no mês de Janeiro.
2. Tipo(type) -> varchar(10) (formato: "XX.XX%")

- (3) **FEB** (Fevereiro):

1. Descrição -> Retorno percentual da ação no mês de Fevereiro.
2. Tipo(type) -> varchar(10) (formato: "XX.XX%")

- (4) **MAR** (Março):

1. Descrição -> Retorno percentual da ação no mês de Março.
2. Tipo(type) -> varchar(10) (formato: "XX.XX%")

- (5) **APR** (Abril):

1. Descrição -> Retorno percentual da ação no mês de Abril.
2. Tipo(type) -> varchar(10) (formato: "XX.XX%")

- (6) **MAY** (Maio):

1. Descrição -> Retorno percentual da ação no mês de Maio.
2. Tipo(type) -> varchar(10) (formato: "XX.XX%")

- (7) **JUN** (Junho):

1. Descrição -> Retorno percentual da ação no mês de Junho.
2. Tipo(type) -> varchar(10) (formato: "XX.XX%")

- (8) **JUL** (Julho):

1. Descrição -> Retorno percentual da ação no mês de Julho.
2. Tipo(type) -> varchar(10) (formato: "XX.XX%")

- (9) **AUG** (Agosto):

1. Descrição -> Retorno percentual da ação no mês de Agosto.
2. Tipo(type) -> varchar(10) (formato: "XX.XX%")

- (10) **SEP** (Setembro):

1. Descrição -> Retorno percentual da ação no mês de Setembro.
2. Tipo(type) -> varchar(10) (formato: "XX.XX%")

- (11) **OCT** (Outubro):

1. Descrição -> Retorno percentual da ação no mês de Outubro.
2. Tipo(type) -> varchar(10) (formato: "XX.XX%")

- (12) **NOV** (Novembro):

1. Descrição -> Retorno percentual da ação no mês de Novembro.
2. Tipo(type) -> varchar(10) (formato: "XX.XX%")

- (13) **DEC** (Dezembro):

1. Descrição -> Retorno percentual da ação no mês de Dezembro.
2. Tipo(type) -> varchar(10) (formato: "XX.XX%")

### **Performance Anual**

- (14) **EOY** (End of Year):

1. Descrição -> Retorno percentual acumulado da ação no ano completo.
2. Tipo(type) -> varchar(10) (formato: "XX.XX%")

## Informações Adicionais

### **Fonte dos Dados**
- **Website**: [dadosdemercado.com.br](https://www.dadosdemercado.com.br/acoes)
- **Período**: Dados históricos desde 2000 até 2025 (parcial)
- **Cobertura**: 431 empresas com histórico de negociação na B3