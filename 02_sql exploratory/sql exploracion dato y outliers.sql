--Cálculo de IQR y Detección de Outliers en SQL Server
	--1 Percentiles P25 Y P75
	SELECT 
		PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY PrecioVenta) OVER () AS P25_Precio,
		PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY PrecioVenta) OVER () AS P75_Precio
	FROM DimProducto
	WHERE PrecioVenta > 0;
	
	--2 Calcular IQR
	WITH Percentiles AS (
		SELECT 
		    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY PrecioVenta) OVER() AS P25_Precio,
		    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY PrecioVenta) OVER () AS P75_Precio
		FROM DimProducto
		WHERE PrecioVenta > 0
		)
	SELECT 
	    P25_Precio,
	    P75_Precio,
	    P75_Precio - P25_Precio AS IQR_Precio
	FROM Percentiles;

	--3 Calcular límites superior e inferior
	WITH Percentiles AS (
	    SELECT 
			Nombre,
			PrecioVenta,
	        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY PrecioVenta) OVER() AS P25_Precio,
	        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY PrecioVenta) OVER () AS P75_Precio
	    FROM DimProducto
	    WHERE PrecioVenta > 0
	),
	IQR AS (
	    SELECT 
			Nombre,
			PrecioVenta,	
	        P25_Precio,
	        P75_Precio,
	        P75_Precio - P25_Precio AS IQR_Precio
	    FROM Percentiles
	)
	SELECT
		Nombre, 
		PrecioVenta,
	    P25_Precio, --69,99
	    P75_Precio, --1079,99
	    P75_Precio - P25_Precio AS IQR_Precio, --1010
	    P25_Precio - (1.5 * (P75_Precio - P25_Precio)) AS LimiteInferior_Precio, -- -1445,01
	    P75_Precio + (1.5 * (P75_Precio - P25_Precio)) AS LimiteSuperior_Precio -- 2594,99
	FROM IQR;


-- Integridad referencial: Verificar si hay productos sin ventas
SELECT 
    dp.Nombre, dp.NombreSubcategoria
FROM DimProducto dp
LEFT JOIN FactVentas fv ON dp.IDProducto = fv.IDProducto
WHERE fv.IDProducto IS NULL;
--Total de 374 productos sin ventas


--Rango de valores
SELECT 
    Nombre, PrecioVenta
FROM DimProducto
WHERE PrecioVenta < 5 OR PrecioVenta > 1500;
--Total de 244 productos fuera de ese rango