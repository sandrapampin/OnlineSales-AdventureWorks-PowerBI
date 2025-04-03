SELECT   
    p.ProductID AS IDProducto,
    p.Name AS Nombre, 
    p.ProductNumber AS NumProducto, 
    p.MakeFlag AS EsFabricado, 
    COALESCE(p.Color, 'NoColor') AS Color, 
    CAST(p.StandardCost AS DECIMAL(10,2)) AS CosteEstandar,
    CAST(p.ListPrice AS DECIMAL(10,2)) AS PrecioVenta,
    COALESCE(p.Size, 'SinTalla') AS Talla,
    COALESCE(p.Weight, 0) AS Peso,  -- Aquí se reemplazan los valores NULL por 0
    COALESCE(p.Class, 'SinTipo') AS TipoTamano,
    CASE 
        WHEN TRIM(p.ProductLine) = 'R' THEN 'CR'
        WHEN TRIM(p.ProductLine) = 'M' THEN 'MT'
        WHEN TRIM(p.ProductLine) = 'T' THEN 'UR'
        WHEN TRIM(p.ProductLine) = 'S' THEN 'ES'    
        ELSE 'SinGamaProducto' 
    END AS GamaProducto,   --El resto de la transformación se realiza en powerquery por limitetipodato
    CASE 
        WHEN TRIM(p.Style) = 'W' THEN 'M'
        WHEN TRIM(p.Style) = 'M' THEN 'H'
        WHEN TRIM(p.Style) = 'U' THEN 'U'
        ELSE 'SinGenero' 
    END AS TipoGenero, --El resto de la transformación se realiza en powerquery por limitetipodato
    CAST(p.SellStartDate AS DATE) AS FechaInicioVenta,
    CAST(p.SellEndDate AS DATE) AS FechaFinVenta,
    COALESCE(sc.Name, 'NoSubcategoria') AS NombreSubcategoria,
    COALESCE(
        CASE 
            WHEN c.Name = 'Accessories' THEN 'Accesorios'
            WHEN c.Name = 'Bikes' THEN 'Bicicletas'
            WHEN c.Name = 'Clothing' THEN 'Ropa'
            WHEN c.Name = 'Components' THEN 'Componentes'
            ELSE 'NoCategoria' 
        END, 'NoCategoria'
    ) AS NombreCategoria
FROM [AdventureWorks2022].[Production].[Product] p
LEFT JOIN [AdventureWorks2022].[Production].[ProductSubcategory] sc     ON p.ProductSubcategoryID = sc.ProductSubcategoryID
LEFT JOIN [AdventureWorks2022].[Production].[ProductCategory] c         ON sc.ProductCategoryID = c.ProductCategoryID;
