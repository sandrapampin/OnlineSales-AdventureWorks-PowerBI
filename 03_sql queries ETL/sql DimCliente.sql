WITH CiudadActual AS (
    SELECT
        c.CustomerID AS IDCliente,
		p.BusinessEntityID as IDPersona,
        CASE 
            WHEN EmailPromotion = 0 THEN 'NoEmailsPromo'
            WHEN EmailPromotion = 1 THEN 'SiEmailsPromoAW'
            WHEN EmailPromotion = 2 THEN 'SiEmailsPromoAWySocios'
            ELSE 'SinDatos' -- Para datos nulls
        END AS EmailsPromocionales,
        a.City as Ciudad,
        sp.Name AS EstadoProvincia,  
        sp.CountryRegionCode AS Pais, 
        p.Demographics.value('declare default element namespace 
           "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
           (/IndividualSurvey/DateFirstPurchase)[1]','date') as FechaPrimeraCompra,
        p.Demographics.value('declare default element namespace 
           "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
           (/IndividualSurvey/BirthDate)[1]','date') as FechaNacimiento,
        CASE 
            WHEN p.Demographics.value('declare default element namespace 
               "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
               (/IndividualSurvey/MaritalStatus)[1]','nvarchar(5)') = 'M' THEN 'Matrimonio'
            WHEN p.Demographics.value('declare default element namespace 
               "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
               (/IndividualSurvey/MaritalStatus)[1]','nvarchar(5)') = 'S' THEN 'SinPareja'
            ELSE 'Desconocido' -- para trabajar nulos
        END AS EstadoCivil,
        CASE 
            WHEN p.Demographics.value('declare default element namespace 
               "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
               (/IndividualSurvey/Gender)[1]','nvarchar(50)') = 'F' then 'Mujer'
            WHEN p.Demographics.value('declare default element namespace 
               "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
               (/IndividualSurvey/Gender)[1]','nvarchar(50)') = 'M' then 'Hombre'
            ELSE 'Otros'
        END as Genero,
        p.Demographics.value('declare default element namespace 
           "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
           (/IndividualSurvey/TotalChildren)[1]','integer') as Totalhijos,
        p.Demographics.value('declare default element namespace 
           "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
           (/IndividualSurvey/NumberChildrenAtHome)[1]','integer') as TotalhijosCasa,
        p.Demographics.value('declare default element namespace 
           "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
           (/IndividualSurvey/HomeOwnerFlag)[1]','nvarchar(50)') as Propietario,
        p.Demographics.value('declare default element namespace 
           "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
           (/IndividualSurvey/NumberCarsOwned)[1]','integer') as Vehículos,
        CASE
            WHEN p.Demographics.value('declare default element namespace 
               "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
               (/IndividualSurvey/YearlyIncome)[1]','nvarchar(50)') = 'greater than 100000' THEN 'Más de 100000'
            ELSE p.Demographics.value('declare default element namespace 
               "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
               (/IndividualSurvey/YearlyIncome)[1]','nvarchar(50)')
        END as RangoIngresosAnuales,
        ROW_NUMBER() OVER (PARTITION BY c.CustomerID ORDER BY a.ModifiedDate DESC) AS rn
    FROM
        Person.Person AS p
    LEFT JOIN Person.BusinessEntityAddress AS bea ON bea.BusinessEntityID = p.BusinessEntityID
    LEFT JOIN Person.Address AS a ON a.AddressID = bea.AddressID
    LEFT JOIN Person.StateProvince AS sp ON sp.StateProvinceID = a.StateProvinceID
    LEFT JOIN Sales.Customer AS c ON c.PersonID = p.BusinessEntityID
    LEFT JOIN Person.EmailAddress AS ea ON ea.BusinessEntityID = p.BusinessEntityID
    WHERE
        c.StoreID IS NULL
        AND p.PersonType = 'IN'
)

SELECT
    IDCliente,
	IDPersona,
    EmailsPromocionales,
    FechaPrimeraCompra,
    FechaNacimiento,
    EstadoCivil,
    Genero,
    Totalhijos,
    TotalhijosCasa,
    Propietario,
    Vehículos,
    RangoIngresosAnuales,
	Ciudad,
    EstadoProvincia,
    Pais
FROM CiudadActual
WHERE rn = 1; -- Filtra para seleccionar solo la ciudad más reciente para cada cliente
