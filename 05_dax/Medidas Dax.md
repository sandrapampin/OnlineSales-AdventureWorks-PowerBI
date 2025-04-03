Medidas Dax.Medidas

# Medidas DAX

## 1️ Análisis de ventas y rentabilidad.
**###**📌 Objetivo: Evaluar la rentabilidad general y por segmentos de negocio.

*Total ventas online*
```dax
TotalVentasOnline = SUM(FactVentas[TotalPedidoLinea])
```

*Ventas con promoción y sin promoción*
```dax
VentasConPromocion = 
CALCULATE (
    SUM (FactVentas[CantidadPedido]),
    FILTER (
        DimPromocion,
        DimPromocion[TipoDescuento] <> "No Discount"
    )
)
```
```dax
VentasSinPromocion = 
CALCULATE (
    SUM (FactVentas[CantidadPedido]),
    FILTER (
        DimPromocion,
        DimPromocion[TipoDescuento] = "No Discount"
    )
)
```


*Beneficio*
```dax
Beneficio = [Ventas]-[Coste]
```

*Coste* 
```dax
Coste = 
    SUMX('FactVentas',FactVentas[CantidadPedido] *RELATED('DimProducto'[CosteEstandar]))
```

*Margen*
```dax
Margen = [Beneficio]/[Ventas]

```
*Median ticket online por pedido*
```dax
MedianaTicketPorPedido = 
MEDIANX(
    VALUES(FactVentas[IDVenta]), 
    CALCULATE(SUM(FactVentas[TotalPedidoLinea]))
)
```
*Ventas*
```dax
Ventas = 
SUMX(FactVentas, FactVentas[CantidadPedido] * FactVentas[PrecioUnidad])
```
*Ventas Last Year*
```dax
VentasLastYear = 
CALCULATE(
        [Ventas], 
        SAMEPERIODLASTYEAR(DimCalendario[Date])
)
```

*Variación ventas*
```dax
VariacionVentas = [Ventas]-[VentasLastYear]
```

```dax
VariacionVentas% = 
VAR VentasActuales = [Ventas]
VAR VariacionVentas = [VariacionVentas]
RETURN
    IF(
        NOT(ISBLANK(VentasActuales)) && VentasActuales <> 0 && NOT(ISBLANK(VariacionVentas)),
        VariacionVentas / VentasActuales,
        BLANK()
    )
```

```dax
VariacionVentasColor = 
IF(
    [VariacionVentas] < 0, 
    "#ff4d4d",  --  Rojo (variación negativa)
    IF(
        [VariacionVentas] >= 0 && [VariacionVentas] <= 10, 
        "#FFA500",  -- Naranja (entre 0% y 10%)
        "#00cc00"  --  Verde (+10%)
    )
)
```
```dax
VentasPorCategoria = CALCULATE(
    SUM(FactVentas[TotalPedidoLinea]),
    ALLEXCEPT(DimProducto, DimProducto[NombreCategoria])
)
```

*Cantidad de pedidos*
```dax
CantidadPedidos = 
CALCULATE(
    DISTINCTCOUNT(FactVentas[IDVenta]),
    ALLEXCEPT(DimCliente, DimCliente[IDCliente])
)
```



## 2 Análisis de clientes y fidelización
**###**📌 Objetivo: Optimizar estrategias de fidelización, estrategias de lead fríos (recuperación) e incentivos para cada segmento.

*Total clientes*
```dax
TotalClientes = DISTINCTCOUNT(FactVentas[IDCliente])
```

*Clientes Activos que han realizado compras en los últimos 360 días*
```dax
ClientesActivos = 
VAR FechaLimite = [FechaMax] - 360
RETURN 
CALCULATE(
    DISTINCTCOUNT(DimCliente[IDCliente]),
    FILTER(
        DimCliente,
        CALCULATE(
            MAX(FactVentas[FechaPedido])
        ) >= FechaLimite
    )
)
```

*Clientes Fríos que no han comprado en de 400 días*
```dax
ClientesFrios = 
VAR FechaLimite = [FechaMax] - 400
RETURN 
CALCULATE(
    DISTINCTCOUNT(DimCliente[IDCliente]),
    FILTER(
        DimCliente,
        [FechaUltimaCompra] <= FechaLimite
    )
)
```

*Clientes Loyal: segmentación en base a frecuencia de compra y ticket*
```dax
ClienteLoyal = 
COALESCE(
    CALCULATE(
        DISTINCTCOUNT(DimCliente[IDCliente]),
        FILTER(DimCliente, 
            [FrecuenciaComprasPorCliente] >= 1 &&
            [TotalVentasOnline] >= 1500 && [TotalVentasOnline] < 5000 &&
            NOT ([FrecuenciaComprasPorCliente] > 10 && [TotalVentasOnline] > 1500) -- Excluir VIP
        )
    ),
    0
)
```

*Clientes Recurrentes: segmentación en base a frecuencia de compra y ticket*
```dax
ClienteRecurrente = 
COALESCE(
    CALCULATE(
    DISTINCTCOUNT(DimCliente[IDCliente]),
    FILTER(DimCliente, 
        [FrecuenciaComprasPorCliente] > 1 &&
        [TotalVentasOnline] >= 1 && [TotalVentasOnline] < 1500 &&
        NOT ([FrecuenciaComprasPorCliente] > 10 && [TotalVentasOnline] > 1500) && -- Excluir VIP
        NOT ([FrecuenciaComprasPorCliente] >= 1 && [TotalVentasOnline] >= 1500 && [TotalVentasOnline] < 5000) -- Excluir Loyal
    )
),0
)
```

*Clientes VIP: segmentación en base a frecuencia de compra y ticket*
```dax
ClienteVIP = 
COALESCE(
    CALCULATE(
    DISTINCTCOUNT(DimCliente[IDCliente]),
    FILTER(DimCliente, 
        [FrecuenciaComprasPorCliente] > 8 && [TotalVentasOnline] > 1500
    )
),0
)
```

*Clientes sin clasificar*
```dax
ClientesNoClasificados = 
[TotalClientes] - ([ClienteLoyal] + [ClienteRecurrente] + [ClienteVIP])
```

*Edad promedio de clientes*
```dax
EdadPromedioClientes = 
VAR ClientesValidos = FILTER(
    DimCliente,
    NOT(ISBLANK(DimCliente[FechaNacimiento]))
)
RETURN 
    AVERAGEX(
        ClientesValidos,
        DATEDIFF(DimCliente[FechaNacimiento], [FechaMax], YEAR)
    )
```

*Ingresos por rango edad*
```dax
IngresosPorRangoEdad = 
SUMX(
    VALUES(DimCliente[EdadRango]), 
    CALCULATE(SUM(FactVentas[TotalPedidoLinea]))
)
```

*Ingresos promedio cliente*
```dax
IngresosPromedioCliente = MEDIANX(
    VALUES(DimCliente[IDCliente]),
    CALCULATE(SUM(FactVentas[TotalPedidoLinea]))
)
```

*Frecuencia de compra: análisis lealtad y recencia*
```dax
FrecuenciaCompra = 
DIVIDE([DuraciónComoCliente], [CantidadPedidos], 0)
```

*Duración como cliente: análisis lealtad y recencia*
```dax
DuraciónComoCliente = 
DATEDIFF([ClientePrimeraCompra], [ClienteUltimaCompra], DAY)
```

*Fecha última compra:análisis lealtad y recencia*
```dax
FechaUltimaCompra = 
CALCULATE(
    MAX(FactVentas[FechaPedido]),
    ALLEXCEPT(DimCliente, DimCliente[IDCliente])
)
```

*Ingresos según segmento cliente: rendimiento en términos de revenue*
```dax
IngresosLoyal = 
CALCULATE(
    SUM(FactVentas[TotalPedidoLinea]),
    FILTER(DimCliente, 
        [FrecuenciaComprasPorCliente] >= 1 &&
        [TotalVentasOnline] >= 1500 && [TotalVentasOnline] < 5000 &&
        NOT ([FrecuenciaComprasPorCliente] > 10 && [TotalVentasOnline] > 1500) -- Excluir VIP
    )
)
```
```dax
IngresosRecurrente = 
CALCULATE(
    SUM(FactVentas[TotalPedidoLinea]),
    FILTER(DimCliente, 
        [FrecuenciaComprasPorCliente] > 1 &&
        [TotalVentasOnline] >= 1 && [TotalVentasOnline] < 1500 &&
        NOT ([FrecuenciaComprasPorCliente] > 10 && [TotalVentasOnline] > 1500) && -- Excluir VIP
        NOT ([FrecuenciaComprasPorCliente] >= 1 && [TotalVentasOnline] >= 1500 && [TotalVentasOnline] < 5000) -- Excluir Loyal
    )
)

```

```dax
IngresosVIP = 
CALCULATE(
    SUM(FactVentas[TotalPedidoLinea]),
    FILTER(DimCliente, 
        [FrecuenciaComprasPorCliente] > 10 && [TotalVentasOnline] > 1500
    )
)
```


*Clientes con email promocional*
```dax
ClientesConEmailPromo = 
CALCULATE(
    COUNTROWS(DimCliente),
    FILTER(DimCliente, 
        DimCliente[EmailsPromocionales] IN {"SiEmailsPromoAW", "SiEmailsPromoAWySocios"}
    )
)
```
```dax
ClientesSinEmailPromo = 
CALCULATE(
    COUNTROWS(DimCliente),
    FILTER(DimCliente, 
        DimCliente[EmailsPromocionales] IN {"NoEmailsPromo"}
    )
)
```

*Clientes con/sin hijos*
```dax
VentasClientesHijos = 
CALCULATE(
    SUM(FactVentas[TotalPedidoLinea]),
    FILTER(
        DimCliente, 
        VALUE(DimCliente[Totalhijos]) > 1
    )
)
```
```dax
VentasClientesSinHijos = 
CALCULATE(
    SUM(FactVentas[TotalPedidoLinea]),
    FILTER(
        DimCliente, 
        VALUE(DimCliente[Totalhijos]) = 0
    )
)
```

*Ingresos por género*
```dax
IngresosHombres = 
CALCULATE(
    SUM(FactVentas[TotalPedidoLinea]),
    DimCliente[Genero] = "Hombre"
)

IngresosHombres% = DIVIDE([IngresosHombres],[TotalVentasOnline])
```
```dax
IngresosMujeres = 
CALCULATE(
    SUM(FactVentas[TotalPedidoLinea]),
    DimCliente[Genero] = "Mujer"
)

IngresosMujeres% = DIVIDE([IngresosMujeres],[TotalVentasOnline])
```

## 3 Efectividad promociones
**###**📌 Objetivo: Determinar qué promociones generan más ingresos y ajustar estrategias (fase 2 implementación mejoras)

*Duración media promociones*
```dax
DuracionMediaPromociones = 
AVERAGEX(
    FILTER(DimPromocion, DimPromocion[CategoriaPromo] = "Customer"),
    DATEDIFF(DimPromocion[FechaInicioPromo], DimPromocion[FechaFinPromo], DAY)
)
```

*Efectividad de campañas*
```dax
EfectividadCampaña = 
VAR TotalVentas = SUM (FactVentas[CantidadPedido])
VAR VentasPromo = [VentasConPromocion]
RETURN 
    DIVIDE (VentasPromo, TotalVentas, 0)
```

*Conversión de promociones sobre ventas*
```dax
ConversionPromocionesSobreVentas = 
DIVIDE([VentasConPromocion], SUM(FactVentas[IDPedidoVenta]), 0)
```

*Descuento promedio*
```dax
DescuentoPromedio = 
CALCULATE(
    AVERAGE(DimPromocion[DescuentoPorcentaje]),
    DimPromocion[CategoriaPromo] = "Customer"
)
```


## 4 Análisis productos:
**###**📌 Objetivo: Analizar rendimiento de productos en función de categoría y precio

*Total productos vendidos*
```dax
NTotalProductosVendidosOnline = SUM(FactVentas[CantidadPedido])
```

*Total productos vendidos LY*
```dax
NTotalProductosVendidosOnlineLY = 
CALCULATE(
    SUM(FactVentas[CantidadPedido]),
    SAMEPERIODLASTYEAR(DimCalendario[Fecha])
)
```

*Outliers de precio*
```dax
EsOutlierPrecio = 
VAR P25 = PERCENTILEX.INC(FILTER(ALL(DimProducto), DimProducto[PrecioVenta] > 0), DimProducto[PrecioVenta], 0.25)
VAR P75 = PERCENTILEX.INC(FILTER(ALL(DimProducto), DimProducto[PrecioVenta] > 0), DimProducto[PrecioVenta], 0.75)
VAR IQR = P75 - P25
VAR LimiteInferior = P25 - (1.5 * IQR)
VAR LimiteSuperior = P75 + (1.5 * IQR)

RETURN 
IF(
    SELECTEDVALUE(DimProducto[PrecioVenta]) < LimiteInferior ||
    SELECTEDVALUE(DimProducto[PrecioVenta]) > LimiteSuperior,
    "Outlier",
    "Normal"
)
```
*Ventas por categoría*
```dax
NumVentasAccesorios = 
CALCULATE(
    SUM(FactVentas[CantidadPedido]),
    DimProducto[NombreCategoria] = "Accesorios"
)
```
```dax
NumVentasBicicletas = 
CALCULATE(
    SUM(FactVentas[CantidadPedido]),
    DimProducto[NombreCategoria] = "Bicicletas"
)
```

```dax
NumVentasRopa = 
CALCULATE(
    SUM(FactVentas[CantidadPedido]),
    DimProducto[NombreCategoria] = "Ropa"
)
```

*Precio máximo por producto*
```dax
PrecioMaxProducto = 
CALCULATE(
    MAX(FactVentas[PrecioUnidad]),  -- Usar PrecioUnidad si se refiere al precio real de venta
    ALLEXCEPT(DimProducto, DimProducto[IDProducto])  -- Mantener el filtro por producto
)
```

*Precio mínimo por producto*
```dax
PrecioMinProducto = 
CALCULATE(
    MIN(FactVentas[PrecioUnidad]),  -- Usar PrecioUnidad si se refiere al precio real de venta
    ALLEXCEPT(DimProducto, DimProducto[IDProducto])  -- Mantener el filtro por producto
)
```

*Rango de productos según precio*
```dax
ProductosMas1000 = 
CALCULATE(
    COUNT(DimProducto[IDProducto]),
    DimProducto[PrecioVenta] >= 1000
)
```

```dax
ProductosMenos1000 = 
CALCULATE(
    COUNT(DimProducto[IDProducto]),
    DimProducto[PrecioVenta] >= 100 &&  DimProducto[PrecioVenta] < 1000
)
```

```dax
ProductosMenos100 = 
CALCULATE(
    COUNT(DimProducto[IDProducto]),
    DimProducto[PrecioVenta] <= 100
)
```

*Ventas según rango de precios*
```dax
VentasMas1000 = 
CALCULATE(
    SUM(FactVentas[TotalPedidoLinea]),
    FactVentas[PrecioUnidad] >= 1000
)
```

```dax
VentasMenos1000 = 
CALCULATE(
    SUM(FactVentas[TotalPedidoLinea]),
    FactVentas[PrecioUnidad] >= 100 && FactVentas[PrecioUnidad] < 1000
)
```

```dax
VentasMenos100 = 
CALCULATE(
    SUM(FactVentas[TotalPedidoLinea]),
    FactVentas[PrecioUnidad] <= 100
)
```


## 5 Análisis predictivos con ML:
**###**📌 Objetivo: predecir el gasto medio por cliente en los próximos 3 meses

*Histórico gasto por cliente*
```dax
HistoricoGastoCliente = 
VAR __gasto = SUM(FactVentas[TotalPedidoLinea])
RETURN IF (ISBLANK(__gasto),0, __gasto)
```

*Predicción gasto a 3 meses*
```dax
PrediccionGasto3meses = 
VAR __pred = CALCULATE(SUM(prediccionescomprasclientes[FutureSpend]), ALLEXCEPT(prediccionescomprasclientes, prediccionescomprasclientes[IDCliente]))
RETURN IF (ISBLANK(__pred), 0, __pred)
```
