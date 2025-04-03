SELECT   
    SpecialOfferID AS IDPromocion,
    Description AS Descripcion, 
    CAST(DiscountPct AS DECIMAL(10,2)) AS DescuentoPorcentaje,
    Type AS TipoDescuento, 
    Category AS CategoriaPromo,
    CAST(StartDate AS DATE) AS FechaInicioPromo,
    CAST(EndDate AS DATE) AS FechaFinPromo,
    MinQty AS CantidadMinimaPromo,
    COALESCE(MaxQty, 0) AS CantidadMaximaPromo,  -- Reemplaza NULL con 0
    DATEDIFF(DAY, StartDate, EndDate) AS DuracionPromo -- Calcula la duración en días
FROM [AdventureWorks2022].[Sales].[SpecialOffer];

