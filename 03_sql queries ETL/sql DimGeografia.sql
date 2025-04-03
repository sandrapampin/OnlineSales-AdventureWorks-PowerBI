-- Definir la tabla DimGeografia
SELECT
    --IDGeografico
	t.TerritoryID AS IDTerritorio,
    pa.AddressID, 
    t.[Group] AS Region,
    CASE 
        WHEN sp.CountryRegionCode = 'US' THEN 'Estados Unidos'
        WHEN sp.CountryRegionCode = 'CA' THEN 'Canadá'
        WHEN sp.CountryRegionCode = 'FR' THEN 'Francia'
        WHEN sp.CountryRegionCode = 'DE' THEN 'Alemania'
        WHEN sp.CountryRegionCode = 'AU' THEN 'Australia'
        WHEN sp.CountryRegionCode = 'GB' THEN 'Reino Unido'
        WHEN sp.CountryRegionCode = 'AS' THEN 'Samoa Americana'
        WHEN sp.CountryRegionCode = 'FM' THEN 'Micronesia'
        WHEN sp.CountryRegionCode = 'MH' THEN 'Islas Marshall'
        WHEN sp.CountryRegionCode = 'MP' THEN 'Islas Marianas del Norte'
        WHEN sp.CountryRegionCode = 'PW' THEN 'Palaos'
        WHEN sp.CountryRegionCode = 'VI' THEN 'Islas Vírgenes de USA'
        ELSE 'Desconocido'
    END AS País,
    sp.Name AS EstadoProvincia,
    pa.City AS Ciudad

FROM [AdventureWorks2022].[Sales].[SalesTerritory] t
JOIN [AdventureWorks2022].[Person].[StateProvince] sp
    ON t.TerritoryID = sp.TerritoryID
LEFT JOIN [AdventureWorks2022].[Person].[Address] pa
    ON sp.StateProvinceID = pa.StateProvinceID;
