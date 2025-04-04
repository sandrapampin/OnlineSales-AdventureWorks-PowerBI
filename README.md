# OnlineSales-AdventureWorks-PowerBI

![dashboad Online Sales DHW PBI](https://github.com/sandrapampin/OnlineSales-AdventureWorks-PowerBI/blob/main/src/Cuadro-de-mando-OnlineSales.gif)

## Introducción
A continuación, se presentan los pasos empleados para el proyecto del Cuadro de Mando de ventas online de Adventure Works 2022:
*	Identificar necesidades de cliente.
*	Toma de requerimientos de cliente. 
*	Localizar fuentes de datos brutas, analizar tablas y revisión de su contenido e integridad.
*	Proporción de métricas y KPIs según necesidades cliente. 
*	Procesamiento de datos.
*	Integración de datos.
*	Optimizar el modelo de datos: una tabla de hechos y cinco de dimensiones.
*	Despliegue de herramientas de visualización acode a métricas.
*	Publicación en Power BI Service a través de puerta de enlace local.

### 🧰 Herramientas y lenguaje:
<!-- SQL Server / SSMS (texto representativo) -->
<img align="left" alt="SSMS" width="30px" style="padding-right:10px;" src="https://img.utdstc.com/icon/981/2d8/9812d89705787310adf08f0edf758921b8d551e8329c8d8c5eeabf4d06b08378:200"/> 

<!-- Visual Studio Community -->
<img align="left" alt="Visual Studio" width="30px" style="padding-right:10px;" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/visualstudio/visualstudio-plain.svg"/>

<!-- Integration Services (texto representativo) -->
<img align="left" alt="Integration Services" width="30px" style="padding-right:10px;" src="https://img.icons8.com/fluency/48/data-in-both-directions.png"/>

<!-- Power Query (no icon oficial, texto representativo) -->
<img align="left" alt="Power Query" width="30px" style="padding-right:10px;" src="https://img.icons8.com/color/48/database.png" />

<!-- DAX (texto representativo con Power BI icon) -->
<img align="left" alt="DAX" width="30px" style="padding-right:10px;" src="https://img.icons8.com/color/48/calculator.png"/>

<!-- Power BI -->
<img align="left" alt="Power BI" width="30px" style="padding-right:10px;" src="https://img.icons8.com/color/48/power-bi.png"/>

<!-- PySpark (no icon oficial, uso Python y Apache Spark combinado) -->
<img align="left" alt="PySpark" width="30px" style="padding-right:10px;" src="https://img.icons8.com/color/48/apache-spark.png"/>

<!-- Python -->
<img align="left" alt="Python" width="30px" style="padding-right:10px;" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/python/python-original.svg"/>

<!-- Visual Studio Code -->
<img align="left" alt="VS Code" width="30px" style="padding-right:10px;" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/vscode/vscode-original.svg"/>

<!-- Figma -->
<img align="left" alt="Figma" width="30px" style="padding-right:10px;" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/figma/figma-original.svg"/>

<!-- GitHub -->
<img align="left" alt="GitHub" width="30px" style="padding-right:10px;" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/github/github-original.svg"/>\

<br/>




> [!NOTE]
> Criterios y requerimientos cliente:
* Análisis de ventas y rentabilidad onli
* Segmentación de clientes para estrategias de retención y otras de recualificación.
* Rendimiento de productos y campañas

 
### Uso de data mart:
Un data mart es una versión específica del almacén de datos centrados en un tema o un área de negocio dentro de una organización. Son subconjuntos de datos con el propósito de ayudar a que un área específica dentro del negocio pueda tomar mejores decisiones.

### Ventajas de un data mart:
•	Una fuente única de verdad.
•	Acceso más rápido a los datos. 
•	Estadísticas más rápidas para toma de decisiones más rápida.
•	Implementación más sencilla y rápida.
•	Creación de una gestión de datos ágil y escalable.

### 📊 Objetivo del Data Mart y KPIs
El Data Mart de Ventas Online de AdventureWorks se ha diseñado para centralizar y optimizar el análisis de datos de ventas del canala online. Su propósito es habilitar la toma de decisiones estratégicas basadas en datos para aportar valor a negocio. 

- [ ] Evaluar las ventas online y el impacto de promociones en ventas.
- [ ] Optimizar la segmentación de clientes para estrategias de marketing (hábitos de compra y clientes con alto valor de vida útil -LTV-).
- [ ] Analizar la rentabilidad de productos (en función de categoría y rango precio) y definir estrategias de incremento de ticket medio.
- [ ] Identificar oportunidades de crecimiento y mejora operativa.


## Estructura y pasos del proyecto
- [x]	Problem Statement depending on the client's requirements.
- [x]	Data Discovery: Exploratory analysis: Detection of missing data, identification of atypical data (outliers) and classification of variables.
- [x]	Data Analysis using SQL in SSMS
- [x]	Data Cleaning and Data quality
- [x]	Data Warehouse (data mart) in SSID
- [x]	Data Cleaning & ETL 2 in Power Query
- [x] Build Dashboard according to business keys
- [x]	Skateholders' feedback
- [x]	Publish report with Power BI Service


## El flujo de trabajo 
![flujo de trabajo completo online sales AW](https://github.com/sandrapampin/OnlineSales-AdventureWorks-PowerBI/blob/939a45180cf3126ffa4a5f8ddc93a0177446bbf6/src/workflow%20with%20tools.png)

<!-- GIFpasos workflow-->
<img src="https://github.com/sandrapampin/OnlineSales-AdventureWorks-PowerBI/raw/939a45180cf3126ffa4a5f8ddc93a0177446bbf6/src/workflow.gif" width="431" height="360" alt="Workflow GIF"/> 

## Modelo de datos
Los datos están crudos y pueden contener errores, duplicados o valores nulos. A partir de aquí se desarrolla una fase de: limpieza de datos, integración de datos, transformación de datos, control de calidad del dato, segmentación y cambios. El modelo de datos representa y organiza los datos de manera optimizada para consultas analíticas y de alto rendimiento. El modelo en estrella nos asegura la consistencia del dato y una desnormalización controlada para los datos que requiere el cuadro de mandos.

•	Tabla de hechos: que contiene las medidas relevantes y numéricas del negocio.\
•	Tabla de dimensiones: que proporciona el contexto o atributos descriptivos para esos hechos. Cada una con una clave primaria que identifica de manera única cada fila.

###  Relación entre las tablas del modelo tabular
🔹 Estructura básica del modelo:
• FactVentas → Tabla de hechos que almacena las ventas online.\
• DimProducto, DimPromocion, DimCliente, DimGeografia, DimCalendario → Tablas de dimensiones con información descriptiva.

🔹 Claves primarias y foráneas
1️ Tabla de hechos: FactVentas
📌 Clave Primaria (PK)
• IDVenta → Identificador único de cada transacción de venta.\
📌 Claves Foráneas (FK)
• IDProducto → Relacionada con DimProducto(IDProducto)
• IDPromocion → Relacionada con DimPromocion(IDPromocion)
• IDCliente → Relacionada con DimCliente(IDCliente)
• IDGeografico → Relacionada con DimGeografia(IDGeografico)
• FechaPedido → Relacionada con DimCalendario(Fecha)


## ETL con SQL:
Uso de DQL (lenguaje de consulta), DML (lenguaje de manipulación) y DDL (lenguaje de definición) en SQL. Se han realizado y documentado en las siguientes páginas consultas básicas en SQL, funciones de agregación y agrupación, así como uniones entre tablas (left joins) y con tipo de relaciones (1:M). 

Además de DML para actualizar datos y DDL para creación y modificación de tablas del data warehouse revisando tanto los datatype como las constraints.
Uso de funciones de data cleaning como:
+	Missing values: COALESCE(), IFNULL() 
+	Duplicates: DISTINCT(), ROW_NUMBER () 
+	Data format: DATE_FORMAT() 
+	Numeric values: ROUND(), DECIMAL ()
+	Change data types: CAST(), CONVERT() 
+	Enforce data integrity: FOREIGN KEY () 
+ CASE WHEN 
+ CTEs (Common Table Expression) 

## Carga de datos: Data Warehouse con SSIS
La carga de datos (es una base de datos histórica AdventureWorks2022) transformados en el data warehouse, en sus tablas de destino AdventureWorksDHW. Se implementa con la herramienta  Visual Studio SSIS (SQL Server Integration Services) a través de Visual Studio Community con la creación de flujos de ETL con origen y destino OLE DB (mediante el SQL Server Agent) que además permite registrar errores y acciones específicas y almacenarlos en una tabla de logs.

![SSIS](https://github.com/sandrapampin/OnlineSales-AdventureWorks-PowerBI/blob/main/src/SSIS_3_destinationcolumns.png?raw=true)

### Creación de índices para optimización de consultas
Se aplican índices en columnas que se usan frecuentemente juntas en condiciones de filtro, como cliente y fecha de pedido. Esto reduce el tiempo de respuesta significativamente y mejora la velocidad de las operaciones de consulta. Aquí se ha optado por índices non-clustered para búsquedas específicas y que soporta más de uno por tabla pero solo sobre aquellas búsquedas más recurrentes, porque no se busca que tengan costo en escritura y ocupen espacio adicional.

![optimizacion indices consultas frecuentes](https://github.com/sandrapampin/OnlineSales-AdventureWorks-PowerBI/blob/main/src/sql_optimizacion%20consultas.png?raw=true)

Para garantizar esto último, se ha realiza una identificación de índices no utilizados al cabo de los días a través de “sys.dm_db_index_usage_stats” en SQL Server y se comprueban las consultas realizadas a través del Plan de Ejecución también de SQL Server para el uso eficiente de recursos 

## Power BI Desktop: conexión a DWH
![PowerBI conexión SQL](https://github.com/sandrapampin/OnlineSales-AdventureWorks-PowerBI/blob/main/src/PowerBI_conexionSQL.png?raw=true)


## ETL 2 en Power Query
ETL para estandarizar texto, limpiar posibles espacios, etc. Transformaciones sencillas en editor avanzado de Power Query.
![Transformacion dato Power Query](https://github.com/sandrapampin/OnlineSales-AdventureWorks-PowerBI/blob/main/src/PowerBI_transformaciondato.png?raw=true)

![Transformacion editor avanzado power query](https://github.com/sandrapampin/OnlineSales-AdventureWorks-PowerBI/blob/main/src/PowerBI_editoravanzado.png?raw=true)

Creación de DimCalendario con un script de DAX.

### Relaciones del modelo estrella
![Modelo Estrella dimensiones y hechos](https://github.com/sandrapampin/OnlineSales-AdventureWorks-PowerBI/blob/main/04_modelado%20dimensional/2_modelo%20dimensional%20estrella%20prediccion.png?raw=true)

### Medidas DAX
Uso de fórmulas DAX (Data Analaysis Expressions) para métricas personalizadas como promedios, ratios y KPIs relevantes. 

•	Funciones de agregación: SUMX, MEDIAN, AVERAGEX, DISTINCTCOUNT… \
•	Funciones de fecha y hora: DATEDIFF, SAMEPERIODLASTYEAR \
•	Función CALCULATE (para poder modificar filtros adicionales). Combinación con funciones como ALL, FILTER y RELATEDTABLE.\
•	Funciones lógicas: IF, AND, NOT…

Los datos extraídos de los datos se presentan de manera visual mediante gráficos, gráficos interactivos a través del uso de marcadores, tooltips y obtener detalles o drill through. La visualización es crucial para comunicar de manera efectiva la información al equipo interesado y que se puedan tomar decisiones informadas. 

### Diseño en Figma y accesibilidad WCAG 2.1 AA
Figma: diseño de iconos y fondos según área del cuadro de mando. Medidas: 1280x720px. 
![dashboad Online Sales DHW PBI](https://github.com/sandrapampin/OnlineSales-AdventureWorks-PowerBI/blob/939a45180cf3126ffa4a5f8ddc93a0177446bbf6/src/dashboard%20-1.png)

## Conclusiones:
Identificar oportunidades de crecimiento y mejora operativa.

✔ Evaluar las ventas online y el impacto de promociones en ventas:
-Impacto muy bajo de las promociones hasta ahora puntuales.\
-Alta dependencia de la categoría bicicletas.

✔ Optimizar la segmentación de clientes para estrategias de marketing (hábitos de compra y clientes con alto valor de vida útil -LTV-).\
-Insights útiles para trabajar los segmentos de clientes a corto-medio plazo\
-Información sobre los hábitos de compra para implementar recomendación de pares de productos y campañas. \
-Información sobre clientes y demografía para estrategias a medio-largo plazo. 

### Roadmap: próximas funcionalidades
- [ ] Análisis de demanda y gasto con modelos predictivos con Random Forest.
- [ ] Recomendación de pares de productos.
- [ ] Implementación para estrategia de carrito abandonado. 
- [ ] Enviar alertas en tiempo real con Power Automate.
- [ ] Accesos según rol para determinadas páginas.



## Conclusiones proyecto:
🔹El valor del conocimiento de negocio (y de cómo ayuda a desarrollar un proyecto con buena base). Sin preguntar para qué se quiere un KPI, se acaban midiendo cosas que no sirven para nada. Los gráficos deben estar alineados con las necesidades de negocio y aportar información útil (no de relleno).

🔹El propósito a la hora de empezar un proyecto debe ser realizarse una serie de preguntas: ¿qué problema resuelvo con estos datos? ¿qué decisiones se quieren tomar con eso? ¿realmente necesitas ese KPI?

🔹El Data Analytics es un proceso continuo. Se trata de monitorear tendencias, prever cambios, hacer recomendaciones y, sobre todo, agregar valor constantemente a los equipos y negocios.
