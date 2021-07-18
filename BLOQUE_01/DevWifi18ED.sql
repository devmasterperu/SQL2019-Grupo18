--CREATE DATABASE DEVWIFI18ED --Paso 1. Crear una BD

USE DEVWIFI18ED --Usar una BD --Paso 2. Usar la BD y copiar script de ERStudio
go

/*
 * ER/Studio 8.0 SQL Code Generation
 * Company :      DEV MASTER PERU
 * Project :      DEVWIFI_18ED.DM1
 * Author :       gmanriquev
 *
 * Date Created : Sunday, July 11, 2021 20:00:14
 * Target DBMS : Microsoft SQL Server 2008
 */

/* 
 * TABLE: Cliente 
 */

CREATE TABLE Cliente(
    codcliente        int             IDENTITY(1,1),
    codtipo           int             NOT NULL,
    numdoc            varchar(15)     NOT NULL,
    tipo_cliente      char(1)         NOT NULL,
    nombres           varchar(100)    NULL,
    ape_paterno       varchar(70)     NULL,
    ape_materno       varchar(70)     NULL,
    sexo              char(1)         NULL,
    fec_nacimiento    date            NULL,
    razon_social      varchar(300)    NULL,
    fec_inicio        date            NULL,
    direccion         varchar(300)    NOT NULL,
    email             varchar(254)    NOT NULL,
    codzona           int             NOT NULL,
    estado            bit             NOT NULL,
    CONSTRAINT PK8 PRIMARY KEY NONCLUSTERED (codcliente)
)
go



IF OBJECT_ID('Cliente') IS NOT NULL
    PRINT '<<< CREATED TABLE Cliente >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Cliente >>>'
go

/* 
 * TABLE: Contrato 
 */

CREATE TABLE Contrato(
    codplan             int              NOT NULL,
    codcliente          int              NOT NULL,
    fec_contrato        date             NOT NULL,
    fec_baja            date             NULL,
    periodo             char(1)          NOT NULL,
    preciosol           decimal(9, 2)    NOT NULL,
    iprouter            varchar(15)      NULL,
    ssis_red_wifi       varchar(100)     NULL,
    fec_registro        datetime         NOT NULL,
    fec_ultactualiza    datetime         NULL,
    estado              varchar(2)       NOT NULL,
    CONSTRAINT PK10 PRIMARY KEY NONCLUSTERED (codplan, codcliente, fec_contrato)
)
go


IF OBJECT_ID('Contrato') IS NOT NULL
    PRINT '<<< CREATED TABLE Contrato >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Contrato >>>'
go

/* 
 * TABLE: PlanInternet 
 */

CREATE TABLE PlanInternet(
    codplan        int              IDENTITY(1,1),
    nombre         varchar(100)     NOT NULL,
    precioref      decimal(9, 2)    NOT NULL,
    descripcion    varchar(150)     NULL,
    CONSTRAINT PK2 PRIMARY KEY NONCLUSTERED (codplan)
)
go



IF OBJECT_ID('PlanInternet') IS NOT NULL
    PRINT '<<< CREATED TABLE PlanInternet >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE PlanInternet >>>'
go

/* 
 * TABLE: Telefono 
 */

CREATE TABLE Telefono(
    tipo          varchar(4)     NOT NULL,
    numero        varchar(20)    NOT NULL,
    estado        bit            NOT NULL,
    codcliente    int            NOT NULL,
    CONSTRAINT PK9 PRIMARY KEY NONCLUSTERED (tipo, numero)
)
go



IF OBJECT_ID('Telefono') IS NOT NULL
    PRINT '<<< CREATED TABLE Telefono >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Telefono >>>'
go

/* 
 * TABLE: TipoDocumento 
 */

CREATE TABLE TipoDocumento(
    codtipo       int             IDENTITY(1,1),
    tipo_sunat    char(2)         NOT NULL,
    desc_larga    varchar(100)    NOT NULL,
    desc_corta    varchar(50)     NOT NULL,
    CONSTRAINT PK6 PRIMARY KEY NONCLUSTERED (codtipo)
)
go



IF OBJECT_ID('TipoDocumento') IS NOT NULL
    PRINT '<<< CREATED TABLE TipoDocumento >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE TipoDocumento >>>'
go

/* 
 * TABLE: Ubigeo 
 */

CREATE TABLE Ubigeo(
    codubigeo    int             IDENTITY(1,1),
    cod_dpto     char(2)         NOT NULL,
    cod_prov     char(2)         NOT NULL,
    cod_dto      char(2)         NOT NULL,
    nom_dpto     varchar(100)    NOT NULL,
    nom_prov     varchar(100)    NOT NULL,
    nom_dto      varchar(150)    NOT NULL,
    CONSTRAINT PK5 PRIMARY KEY NONCLUSTERED (codubigeo)
)
go



IF OBJECT_ID('Ubigeo') IS NOT NULL
    PRINT '<<< CREATED TABLE Ubigeo >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Ubigeo >>>'
go

/* 
 * TABLE: Zona 
 */

CREATE TABLE Zona(
    codzona      int            IDENTITY(1,1),
    nombre       varchar(100)   NOT NULL,
    estado       bit            NOT NULL,
    codubigeo    int            NOT NULL,
    CONSTRAINT PK7 PRIMARY KEY NONCLUSTERED (codzona)
)
go



IF OBJECT_ID('Zona') IS NOT NULL
    PRINT '<<< CREATED TABLE Zona >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Zona >>>'
go

/* 
 * TABLE: Cliente 
 */

ALTER TABLE Cliente ADD CONSTRAINT RefTipoDocumento3 
    FOREIGN KEY (codtipo)
    REFERENCES TipoDocumento(codtipo)
go

ALTER TABLE Cliente ADD CONSTRAINT RefZona4 
    FOREIGN KEY (codzona)
    REFERENCES Zona(codzona)
go


/* 
 * TABLE: Contrato 
 */

ALTER TABLE Contrato ADD CONSTRAINT RefPlanInternet7 
    FOREIGN KEY (codplan)
    REFERENCES PlanInternet(codplan)
go

ALTER TABLE Contrato ADD CONSTRAINT RefCliente8 
    FOREIGN KEY (codcliente)
    REFERENCES Cliente(codcliente)
go


/* 
 * TABLE: Telefono 
 */

ALTER TABLE Telefono ADD CONSTRAINT RefCliente6 
    FOREIGN KEY (codcliente)
    REFERENCES Cliente(codcliente)
go


/* 
 * TABLE: Zona 
 */

ALTER TABLE Zona ADD CONSTRAINT RefUbigeo2 
    FOREIGN KEY (codubigeo)
    REFERENCES Ubigeo(codubigeo)
go


