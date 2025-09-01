# Descrição das colunas dos Fatos Relevantes

## Pasta -> FatosRelevantes/

## Estrutura dos Dados

Esta pasta contém **488 arquivos CSV**, um para cada empresa listada na B3, com informações sobre fatos relevantes e comunicados ao mercado registrados na CVM (Comissão de Valores Mobiliários).

## Colunas

- (1) **Index (sem nome)**:

1. Descrição -> Índice sequencial do registro no arquivo CSV. :white_check_mark:
2. Tipo(type) -> integer

- (2) **Acao**:

1. Descrição -> Código da ação/papel da empresa (ex: VALE3, PETR4, BBAS3).
2. Tipo(type) -> varchar(10)

- (3) **Data**:

1. Descrição -> Data de publicação do fato relevante no formato DD/MM/AAAA.
2. Tipo(type) -> date

- (4) **Hora**:

1. Descrição -> Horário de publicação do fato relevante no formato HH:MM.
2. Tipo(type) -> time

- (5) **Descrição**:

1. Descrição -> Título/resumo do fato relevante ou comunicado ao mercado.
2. Tipo(type) -> text

- (6) **Link**:

1. Descrição -> URL direta para o documento oficial no site da CVM (rad.cvm.gov.br).
2. Tipo(type) -> varchar(500)

## Informações Adicionais

### **Fonte dos Dados**
- **Sistema CVM**: Todos os links apontam para documentos oficiais no sistema RAD (Radiografia Atualizada de Dados) da CVM
- **Tipo de Documento**: IPE (Informações Periódicas e Eventuais)
- **Período**: Dados atualizados até agosto de 2025