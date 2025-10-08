-- =========================================
-- HISTORICO
-- =========================================
CREATE OR ALTER PROCEDURE SP_HISTORICO
    @CAMINHO_CSV VARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;

    IF OBJECT_ID('tempdb..#STG_HISTORICO') IS NOT NULL
        DROP TABLE #STG_HISTORICO;

    CREATE TABLE #STG_HISTORICO
    (
        Col1 VARCHAR(200),
        Col2 VARCHAR(200)
    );

    BULK INSERT #STG_HISTORICO
    FROM @CAMINHO_CSV
    WITH
    (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDTERMINATOR = ';',
        ROWTERMINATOR = '\n',
        CODEPAGE = 'ACP'
    );

    INSERT INTO HISTORICO (Col1, Col2)
    SELECT Col1, Col2
    FROM #STG_HISTORICO;
END
GO


-- =========================================
-- PREÇOS
-- =========================================
CREATE OR ALTER PROCEDURE SP_PRECOS
    @CAMINHO_CSV VARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;

    IF OBJECT_ID('tempdb..#STG_PRECOS') IS NOT NULL
        DROP TABLE #STG_PRECOS;

    CREATE TABLE #STG_PRECOS
    (
        Col1 VARCHAR(200),
        Col2 VARCHAR(200)
    );

    BULK INSERT #STG_PRECOS
    FROM @CAMINHO_CSV
    WITH
    (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDTERMINATOR = ';',
        ROWTERMINATOR = '\n',
        CODEPAGE = 'ACP'
    );

    INSERT INTO PRECOS (Col1, Col2)
    SELECT Col1, Col2
    FROM #STG_PRECOS;
END
GO


-- =========================================
-- PROVENTOS
-- =========================================
CREATE OR ALTER PROCEDURE SP_PROVENTOS
    @CAMINHO_CSV VARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;

    IF OBJECT_ID('tempdb..#STG_PROVENTOS') IS NOT NULL
        DROP TABLE #STG_PROVENTOS;

    CREATE TABLE #STG_PROVENTOS
    (
        Col1 VARCHAR(200),
        Col2 VARCHAR(200)
    );

    BULK INSERT #STG_PROVENTOS
    FROM @CAMINHO_CSV
    WITH
    (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDTERMINATOR = ';',
        ROWTERMINATOR = '\n',
        CODEPAGE = 'ACP'
    );

    INSERT INTO PROVENTOS (Col1, Col2)
    SELECT Col1, Col2
    FROM #STG_PROVENTOS;
END
GO


-- =========================================
-- RETORNOS
-- =========================================
CREATE OR ALTER PROCEDURE SP_RETORNOS
    @CAMINHO_CSV VARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;

    IF OBJECT_ID('tempdb..#STG_RETORNOS') IS NOT NULL
        DROP TABLE #STG_RETORNOS;

    CREATE TABLE #STG_RETORNOS
    (
        Col1 VARCHAR(200),
        Col2 VARCHAR(200)
    );

    BULK INSERT #STG_RETORNOS
    FROM @CAMINHO_CSV
    WITH
    (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDTERMINATOR = ';',
        ROWTERMINATOR = '\n',
        CODEPAGE = 'ACP'
    );

    INSERT INTO RETORNOS (Col1, Col2)
    SELECT Col1, Col2
    FROM #STG_RETORNOS;
END
GO


-- =========================================
-- RI EMPRESAS
-- =========================================
CREATE OR ALTER PROCEDURE SP_RI_EMPRESAS
    @CAMINHO_CSV VARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;

    IF OBJECT_ID('tempdb..#STG_RI_EMPRESAS') IS NOT NULL
        DROP TABLE #STG_RI_EMPRESAS;

    CREATE TABLE #STG_RI_EMPRESAS
    (
        Col1 VARCHAR(200),
        Col2 VARCHAR(200)
    );

    BULK INSERT #STG_RI_EMPRESAS
    FROM @CAMINHO_CSV
    WITH
    (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDTERMINATOR = ';',
        ROWTERMINATOR = '\n',
        CODEPAGE = 'ACP'
    );

    INSERT INTO RI_EMPRESAS (Col1, Col2)
    SELECT Col1, Col2
    FROM #STG_RI_EMPRESAS;
END
GO


-- =========================================
-- TRIMESTRE
-- =========================================
CREATE OR ALTER PROCEDURE SP_TRIMESTRE
    @CAMINHO_CSV VARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;

    IF OBJECT_ID('tempdb..#STG_TRIMESTRE') IS NOT NULL
        DROP TABLE #STG_TRIMESTRE;

    CREATE TABLE #STG_TRIMESTRE
    (
        Col1 VARCHAR(200),
        Col2 VARCHAR(200)
    );

    BULK INSERT #STG_TRIMESTRE
    FROM @CAMINHO_CSV
    WITH
    (
        FORMAT = 'CSV',
        FIRSTROW = 2,
        FIELDTERMINATOR = ';',
        ROWTERMINATOR = '\n',
        CODEPAGE = 'ACP'
    );

    INSERT INTO TRIMESTRE (Col1, Col2)
    SELECT Col1, Col2
    FROM #STG_TRIMESTRE;
END
GO
