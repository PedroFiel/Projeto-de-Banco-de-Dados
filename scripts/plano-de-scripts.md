🛠️ Guia de Uso e Manutenção – ETL CSV → SQL Server
📌 1. Criação das tabelas finais

Arquivo: Script_Dados.sql

Este script cria as tabelas finais onde ficarão os dados consolidados.
Você roda uma vez só no início do projeto (ou quando precisar recriar a estrutura).

👉 Ponto de atenção:

Ajuste os nomes das colunas (Col1, Col2...) conforme a estrutura real dos seus CSVs.

Se os CSVs forem grandes, pode ser interessante usar tipos mais específicos (INT, DATE, DECIMAL(18,2), etc.) no lugar de VARCHAR(200).

📌 2. Criação das Stored Procedures (ETL por pasta)

Arquivo: ETL-procedure.sql

Aqui ficam todas as SPs de ETL (SP_DADOS_GERAIS, SP_HISTORICO, etc.).
Cada uma:

Recebe um arquivo .csv como parâmetro (@CAMINHO_CSV).

Carrega o CSV em uma tabela temporária (#STG_...).

Insere os dados tratados na tabela final correspondente.

👉 Pontos de atenção:

Colunas da staging table (#STG_...) precisam ser compatíveis com os CSVs.

Ajuste o separador no FIELDTERMINATOR (; ou ,).

Ajuste o encoding no CODEPAGE (ACP para Latin1, 65001 para UTF-8).

Se algum CSV tiver cabeçalho em mais de uma linha → troque FIRSTROW = 2 para o número certo.

📌 3. Loop para varrer as pastas e chamar SPs

Arquivo: Alter_load_data.sql

Este script faz o trabalho pesado:

Percorre todas as pastas dentro de dataset.

Para cada pasta, pega os .csv.

Chama a SP específica daquela pasta.

👉 Pontos de atenção:

O mapeamento de pasta → procedure está dentro do IF / ELSE IF.

Exemplo: pasta Historico → EXEC SP_ETL_HISTORICO.

Se você adicionar uma nova pasta no futuro, precisa:

Criar a tabela final.

Criar a SP de ETL.

Adicionar um ELSE IF no loop para chamar a nova SP.

📌 4. Fluxo de execução

Rodar Script_Dados.sql (apenas 1x, no início).

Rodar ETL-procedure.sql (sempre que criar/ajustar uma SP).

Rodar Alter_load_data.sql (toda vez que quiser carregar os dados novos).

📌 5. Boas práticas

✅ Organização de scripts: manter numerados ajuda a rodar na ordem certa.
✅ Logs: você pode incluir PRINT dentro das SPs para acompanhar o progresso.
✅ Validação: após cada carga, sempre rode um SELECT TOP 10 * FROM <tabela> para conferir se os dados entraram certo.
✅ Automatização: quando estiver estável, dá para agendar o script 03_run_etl_loop.sql no SQL Server Agent e rodar todo dia/semana automaticamente.