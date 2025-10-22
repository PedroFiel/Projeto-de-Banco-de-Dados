USE dataset_b3;
GO

-- =====================================================
-- HABILITAÇÕES NECESSÁRIAS
-- =====================================================
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'xp_cmdshell', 1;
RECONFIGURE;
EXEC sp_configure 'Ad Hoc Distributed Queries', 1;
RECONFIGURE;

-- =====================================================
-- CRIA TABELA TEMPORÁRIA PARA LISTAR ARQUIVOS
-- =====================================================
CREATE TABLE #Arquivos (NomeArquivo NVARCHAR(4000));

-- Lista todos os arquivos .csv na pasta desejada
INSERT INTO #Arquivos (NomeArquivo)
EXEC xp_cmdshell 'dir /b "C:\dataset\Fatosrelevantes\*.csv"';

-- Remove linhas nulas (resultantes do DIR)
DELETE FROM #Arquivos WHERE NomeArquivo IS NULL;

-- =====================================================
-- LOOP PARA FAZER BULK INSERT DE CADA ARQUIVO
-- =====================================================
DECLARE @arquivo NVARCHAR(4000), 
        @sql NVARCHAR(MAX);

DECLARE cursor_arquivos CURSOR FOR
SELECT NomeArquivo FROM #Arquivos;

OPEN cursor_arquivos;
FETCH NEXT FROM cursor_arquivos INTO @arquivo;

DROP TABLE #Arquivos;

DROP TABLE temp_dados_gerais_bruto;

CREATE TABLE temp_dados_gerais_bruto (
  id VARCHAR(MAX),
  acao VARCHAR(MAX),
  data_dado VARCHAR(MAX ),
  hora VARCHAR(MAX),
  descricao VARCHAR(MAX),
  link VARCHAR(MAX),
    );

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @sql = '
        BULK INSERT dataset_b3.dbo.temp_dados_gerais_bruto
        FROM ''C:\dataset\Fatosrelevantes\' + @arquivo + '''
        WITH (
            FIRSTROW = 2,               -- ignora cabeçalho
            FIELDTERMINATOR = '';'',    -- separador CSV
            ROWTERMINATOR = ''\n'',     -- quebra de linha
            TABLOCK,
            CODEPAGE = ''ACP''          -- encoding padrão Windows
        );';

    PRINT 'Importando arquivo: ' + @arquivo;
    EXEC (@sql);

    FETCH NEXT FROM cursor_arquivos INTO @arquivo;
END;

CLOSE cursor_arquivos;
DEALLOCATE cursor_arquivos;

DROP TABLE #Arquivos;

PRINT '✅ Importação concluída com sucesso!';


