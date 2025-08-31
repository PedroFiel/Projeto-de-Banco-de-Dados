# Descrição das Colunas - Sites de Relações com Investidores

## Arquivo -> ri_empresas.csv

## Estrutura dos Dados

Este arquivo contém **427 registros** mapeando os códigos das ações listadas na B3 com seus respectivos sites oficiais de Relações com Investidores (RI). O arquivo serve como diretório centralizado para acesso à informação institucional das empresas.

## Colunas

### **Identificação do Registro**

- (1) **Index (sem nome)**:

1. Descrição -> Índice sequencial do registro (0 a 426).
2. Tipo(type) -> integer

### **Identificação da Empresa**

- (2) **Acao**:

1. Descrição -> Código da ação na B3 (ex: VALE3, PETR4, WEGE3).
2. Tipo(type) -> varchar(10)

### **Informação Institucional**

- (3) **Site**:

1. Descrição -> URL oficial da área de Relações com Investidores da empresa.
2. Tipo(type) -> varchar(255)

## Informações Adicionais

### **Fonte dos Dados**
- **Website**: [dadosdemercado.com.br](https://www.dadosdemercado.com.br/acoes)
- **Atualização**: Dados atualizados até agosto de 2025
- **Cobertura**: 427 ações listadas na B3
- **Validação**: URLs verificadas e ativas
