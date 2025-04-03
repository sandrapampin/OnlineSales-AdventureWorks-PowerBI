SELECT 
    soh.SalesOrderID AS IDPedidoVenta,
    sod.SalesOrderDetailID AS IDPedidoVentaDetalle,
    soh.CustomerID AS IDCliente,
    soh.TerritoryID AS IDTerritorio, 
    soh.ShipToAddressID AS IDEnvioDireccion,
    sod.ProductID AS IDProducto,
    sod.SpecialOfferID AS IDPromocion,
    soh.OrderDate AS FechaPedido,
    soh.DueDate AS FechaVencimiento,
    soh.ShipDate AS FechaEnvio,
    soh.Status AS EstadoPedido,
    soh.SalesOrderNumber AS NumVentaPedido, 
    CAST(soh.SubTotal AS DECIMAL(10,2)) AS SubTotal,
    CAST(soh.TaxAmt AS DECIMAL(10,2)) AS Impuestos,
    CAST(soh.Freight AS DECIMAL(10,2)) AS GastosEnvio,
    CAST(soh.TotalDue AS DECIMAL(10,2)) AS TotalAPagar,
    sod.OrderQty AS CantidadPedido,
    CAST(sod.UnitPrice AS DECIMAL(10,2)) AS PrecioUnidad,
    CAST(sod.UnitPriceDiscount AS DECIMAL(10,2)) AS DescuentoPrecioUnidad,
    CAST(sod.LineTotal AS DECIMAL(10,2)) AS TotalPedidoLinea
FROM [AdventureWorks2022].[Sales].[SalesOrderHeader] soh
JOIN [AdventureWorks2022].[Sales].[SalesOrderDetail] sod 
    ON soh.SalesOrderID = sod.SalesOrderID
WHERE 
    soh.OnlineOrderFlag = 1 
    AND soh.PurchaseOrderNumber IS NULL;
