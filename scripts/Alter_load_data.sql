-- Habilitar xp_cmdshell (caso não esteja ativo)
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'xp_cmdshell', 1;
RECONFIGURE;

-----------------------------------
-- Diretório raiz
-----------------------------------
DECLARE @RootPath VARCHAR(300) = 'C:\Users\niloo\Desktop\TESTE\Projeto-de-Banco-de-Dados\dataset\';

-- Tabelas temporárias
CREATE TABLE #Pastas (NomePasta VARCHAR(255));
CREATE TABLE #Arquivos (NomeArquivo VARCHAR(255));

-----------------------------------
-- 1) Pega todas as pastas dentro do diretório raiz
-----------------------------------
INSERT INTO #Pastas
EXEC xp_cmdshell 'dir /b /ad "C:\Users\niloo\Desktop\TESTE\Projeto-de-Banco-de-Dados\dataset\"';

DELETE FROM #Pastas WHERE NomePasta IS NULL;

-----------------------------------
-- 2) Loop pelas pastas
-----------------------------------
DECLARE @PastaAtual VARCHAR(255), @CaminhoPasta VARCHAR(500), @Arquivo VARCHAR(255), @CaminhoCompleto VARCHAR(600), @ComandoSQL NVARCHAR(1000);

DECLARE PastaCursor CURSOR FOR
    SELECT NomePasta FROM #Pastas;

OPEN PastaCursor;
FETCH NEXT FROM PastaCursor INTO @PastaAtual;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @CaminhoPasta = @RootPath + @PastaAtual + '\';

    PRINT '📂 Pasta atual: ' + @CaminhoPasta;

    -- Limpa lista de arquivos
    DELETE FROM #Arquivos;

    -- 2a) Pega todos os CSV dentro da pasta
    DECLARE @cmd NVARCHAR(1000);
    SET @cmd = 'dir /b "' + @CaminhoPasta + '*.csv"';
    INSERT INTO #Arquivos
    EXEC xp_cmdshell @cmd;

    -- 2b) Loop nos arquivos da pasta
    DECLARE ArquivoCursor CURSOR FOR
        SELECT NomeArquivo FROM #Arquivos;

    OPEN ArquivoCursor;
    FETCH NEXT FROM ArquivoCursor INTO @Arquivo;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @CaminhoCompleto = @CaminhoPasta + @Arquivo;

        PRINT '➡️ Processando: ' + @CaminhoCompleto;

        ------------------------------------------------------
        -- Mapeia a pasta para a Stored Procedure correspondente
        ------------------------------------------------------
        SET @ComandoSQL = NULL;

        IF @PastaAtual = '\DadosGerais'
            SET @ComandoSQL = N'EXEC SP_DADOS_GERAIS @CAMINHO_CSV = ''' + @CaminhoCompleto + '''';
        ELSE IF @PastaAtual = 'Historico'
            SET @ComandoSQL = N'EXEC SP_HISTORICO @CAMINHO_CSV = ''' + @CaminhoCompleto + '''';
        ELSE IF @PastaAtual = 'Precos'
            SET @ComandoSQL = N'EXEC SP_PRECOS @CAMINHO_CSV = ''' + @CaminhoCompleto + '''';
        ELSE IF @PastaAtual = 'Proventos'
            SET @ComandoSQL = N'EXEC SP_PROVENTOS @CAMINHO_CSV = ''' + @CaminhoCompleto + '''';
        ELSE IF @PastaAtual = 'Retornos'
            SET @ComandoSQL = N'EXEC SP_RETORNOS @CAMINHO_CSV = ''' + @CaminhoCompleto + '''';
        ELSE IF @PastaAtual = 'RiEmpresas'
            SET @ComandoSQL = N'EXEC SP_RI_EMPRESAS @CAMINHO_CSV = ''' + @CaminhoCompleto + '''';
        ELSE IF @PastaAtual = 'Trimestre'
            SET @ComandoSQL = N'EXEC SP_TRIMESTRE @CAMINHO_CSV = ''' + @CaminhoCompleto + '''';
        ELSE IF @PastaAtual = 'FatosRelevantes'
            SET @ComandoSQL = N'EXEC SP_FATOS_RELEVANTES @CAMINHO_CSV = ''' + @CaminhoCompleto + '''';

        -- Executa apenas se achou uma SP correspondente
        IF @ComandoSQL IS NOT NULL
            EXEC sp_executesql @ComandoSQL;

        FETCH NEXT FROM ArquivoCursor INTO @Arquivo;
    END

    CLOSE ArquivoCursor;
    DEALLOCATE ArquivoCursor;

    FETCH NEXT FROM PastaCursor INTO @PastaAtual;
END

CLOSE PastaCursor;
DEALLOCATE PastaCursor;

-- Limpeza
DROP TABLE #Pastas;
DROP TABLE #Arquivos;
