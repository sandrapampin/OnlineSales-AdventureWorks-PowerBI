CREATE TABLE DimCliente (
    IDCliente INT NOT NULL PRIMARY KEY,  -- CustomerID como PK
    IDPersona INT,
    EmailsPromocionales VARCHAR(22),
    FechaPrimeraCompra NVARCHAR(10), -- DE ORIGEN XML - xsd:string / Transformaci�n posterior a DATE
    FechaNacimiento NVARCHAR(10), -- DE ORIGEN XML - xsd:string / Transformaci�n posterior a DATE
    EstadoCivil VARCHAR(22),
    Genero VARCHAR(12),
    Totalhijos INT,
    TotalhijosCasa INT,
    Propietario NVARCHAR(50),  -- DE ORIGEN XML - xsd:string / Transformaci�n posterior a BIT valores booleanos (0 o 1)
    Veh�culos INT,
    RangoIngresosAnuales NVARCHAR(50),
    Ciudad NVARCHAR(50),
    EstadoProvincia NVARCHAR(50),
    Pais NVARCHAR(3) -- DE ORIGEN XML - xsd:string / Transformaci�n posterior seg�n c�digo pa�s a nombre
);



CREATE TABLE DimPromocion (
    IDPromocion INT NOT NULL PRIMARY KEY,  -- SpecialOfferID como PK
    Descripcion NVARCHAR(255),  -- Descripci�n de la promoci�n
    DescuentoPorcentaje DECIMAL(10,2),  -- Descuento en porcentaje
    TipoDescuento NVARCHAR(50),  -- Tipo de descuento
    CategoriaPromo NVARCHAR(50),  -- Categor�a de la promoci�n
    FechaInicioPromo DATE,  -- Fecha de inicio de la promoci�n
    FechaFinPromo DATE,  -- Fecha de finalizaci�n de la promoci�n
    CantidadMinimaPromo INT,  -- Cantidad m�nima de compra para la promoci�n
    CantidadMaximaPromo INT,  -- Cantidad m�xima de compra para la promoci�n
    DuracionPromo INT  -- Duraci�n de la promoci�n en d�as
);


-- Creaci�n de la tabla DimProducto
CREATE TABLE DimProducto (
    IDProducto INT NOT NULL PRIMARY KEY,  -- ProductID como PK
    Nombre NVARCHAR(255),  -- Nombre del producto
    NumProducto NVARCHAR(50),  -- N�mero de producto
    EsFabricado BIT,  -- Indica si es fabricado (1 = s�, 0 = no)
    Color NVARCHAR(50),  -- Color del producto
    CosteEstandar DECIMAL(10,2),  -- Coste est�ndar
    PrecioVenta DECIMAL(10,2),  -- Precio de venta
    Talla NVARCHAR(50),  -- Talla del producto
    Peso DECIMAL(10,2),  -- Peso del producto
    TipoTamano NVARCHAR(50),  -- Tipo de tama�o H,M,L
    GamaProducto NVARCHAR(50),  -- Gama del producto
    TipoGenero NVARCHAR(50),  -- Tipo de g�nero
    FechaInicioVenta DATE,  -- Fecha de inicio de la venta
    FechaFinVenta DATE,  -- Fecha de fin de la venta
    NombreSubcategoria NVARCHAR(255),  -- Nombre de la subcategor�a
    NombreCategoria NVARCHAR(255)  -- Nombre de la categor�a
);

CREATE TABLE FactVentas (
    IDVenta INT IDENTITY(1,1) NOT NULL PRIMARY KEY,  -- Clave primaria incremental
	IDPedidoVenta INT, -- SalesOrderID 
    IDPedidoVentaDetalle INT, --SalesOrderDetailID
    IDCliente INT,  -- CustomerID
    IDTerritorio INT,  -- TerritoryID
    IDEnvioDireccion INT,  -- ShipToAddressID
    IDProducto INT,  -- ProductID
    IDPromocion INT,  -- SpecialOfferID
    FechaPedido DATETIME,  -- OrderDate
    FechaVencimiento DATETIME,  -- DueDate
    FechaEnvio DATETIME,  -- ShipDate
    EstadoPedido tinyint,  -- Status
    NumVentaPedido NVARCHAR(50),  -- SalesOrderNumber
    SubTotal NUMERIC(10,2),  -- SubTotal
    Impuestos DECIMAL(10,2),  -- TaxAmt
    GastosEnvio DECIMAL(10,2),  -- Freight
    TotalAPagar DECIMAL(10,2),  -- TotalDue
    CantidadPedido INT,  -- OrderQty
    PrecioUnidad DECIMAL(10,2),  -- UnitPrice
    DescuentoPrecioUnidad DECIMAL(10,2),  -- UnitPriceDiscount
    TotalPedidoLinea DECIMAL(10,2)  -- LineTotal
);



CREATE TABLE DimGeografia (
    IDGeografico INT IDENTITY(1,1) PRIMARY KEY,  -- Clave primaria incremental
    IDTerritorio INT,  -- TerritoryID
    AddressID INT,  -- AddressID
    Region NVARCHAR(50),  -- Group (Region)
    Pais VARCHAR(100),  -- Pa�s con la traducci�n
    EstadoProvincia NVARCHAR(100),  -- StateProvince Name
    Ciudad NVARCHAR(100)  -- Ciudad
);


--ALTER TABLE FactVentas 
--ADD IDPedidoVentaDetalle INT NOT NULL;

ALTER TABLE FactVentas 
ADD CONSTRAINT FK_FactVentas_Cliente 
FOREIGN KEY (IDCliente) 
REFERENCES DimCliente (IDCliente);

ALTER TABLE FactVentas 
ADD CONSTRAINT FK_FactVentas_Promocion 
FOREIGN KEY (IDPromocion) 
REFERENCES DimPromocion (IDPromocion);

EXEC sp_help 'DimProducto'; --para comprobar si IDProducto estaba bien como PK UNIQUE

ALTER TABLE DimProducto
ADD CONSTRAINT UQ_DimProducto_IDProducto UNIQUE (IDProducto);

ALTER TABLE FactVentas 
ADD CONSTRAINT FK_FactVentas_Producto 
FOREIGN KEY (IDProducto) 
REFERENCES DimProducto (IDProducto);


--Indices para optimizaci�n de consultas 
--CREATE CLUSTERED INDEX IX_FactVentas_IDVenta 
--ON FactVentas(IDVenta);

CREATE NONCLUSTERED INDEX IX_FactVentas_IDCliente 
ON FactVentas(IDCliente);

CREATE NONCLUSTERED INDEX IX_FactVentas_IDProducto 
ON FactVentas(IDProducto);

CREATE NONCLUSTERED INDEX IX_FactVentas_IDPromocion 
ON FactVentas(IDPromocion);

CREATE NONCLUSTERED INDEX IX_FactVentas_IDTerritorio 
ON FactVentas(IDTerritorio);

CREATE NONCLUSTERED INDEX IX_FactVentas_FechaPedido 
ON FactVentas(FechaPedido);

CREATE CLUSTERED INDEX IX_DimProducto_IDProducto 
ON DimProducto(IDProducto);

CREATE NONCLUSTERED INDEX IX_FactVentas_Cliente_Fecha
ON FactVentas (IDCliente, FechaPedido);
