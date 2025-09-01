### Assumptions
- Al haber problemas con las conectividad el enfoque será procesamiento por lotes (batch).
- Si se necesitara análisis real time o near real time para aplicaciones como detección de fraudes se necesitaría primero resolver los problemas de conexión (out of scope).
- Arquitectura enfocada en la fiabilidad en la conciliación de los datos en vez de la frecuencia de recolección de los datos en el Warehouse.

### Propón una solución considerando nuestras limitaciones de conectividad.
  1. Script de Python en cada sucursal con lógica de extracción incremental; Acceso total a toda la lógica como los retries y manejo de errores. Se puede conectar fácilmente a la base de datos con un simple conector. Escribir data en parquets o Avro.
  2. S3 como repositorio central, se podría usar como un data lake definiendo la sintaxis de las rutas. s3://podemosprogresar/<sucursal>/<fecha>
  3. Se configura un job de glue para el procesamiento de datos con una cadencia especifica (diario en la madrugada, semanal, mensual etc).
     - Este job haría todo el procesamiento de los datos (eliminación de duplicados, casteo de archivos, limpieza de datos)
     - Otro enfoque sería event-driven, usando lambda para ejecutar el job de glue cada vez que llegue un archivo.
     - En esta solución el propósito principal es la fiabilidad de los datos extraídos, entonces con el job periódico de glue está OK.
  4. Se pueden configurar varios jobs de glue para tratamiento de data según requiramos (ML, Análisis, etc)
  5. Funciones lambda que activen Glue jobs para transformaciones y enriquecimiento.
  6. Se cargan los datos curados en el warehouse con un modelado (big table o dimensional) según necesidades de negocio.
### Justifica la elección de servicios (DMS, Glue, Lambda, Kinesis, etc.)
- S3: Storage de alta escalabilidad y durabilidad, es multi-propósito por su naturaleza y su finción del ciclo de vida de objetos. Es la opción preferencial para storage de AWS.
- Glue: Es un servicio que no requiere gestión de infraestructura, su motor es Spark entonces se puede adopatr fácilmente, además ya he trabajado con él en otros proyectos y su catálogo y crawlers son de gran ayuda en el setup para su correcta clasificación.
- Lambda: Por experiencia, es de gran ayuda para orquestar flujos sin necesidad de usar otro servicio. Además es compatible con gran variedad de servicios como Glue.
- Redshift: Está diseñado para consultas complejas y de alto rendimiento que son esenciales para el análisis de riesgo y la generación de reportes
### ¿Cómo manejarías sucursales que están offline por varios días?
- Por experiencia, el job de python es la primera linea de defensa para asegurar que se retengan y carguen los datos a s3 una vez que haya conexión.
- Con un checkpoint y un enfoque incremental sólo se cargarían los datos desde el último registro exitoso cuando haya conexión.
- No se requeriria 200 scripts diferentes al usar un base code reutilizable para los datos necesarios de cada sucursal.
- Con el job de glue candelarizado y los event-drive jobs de Glue, asegurariamos tener la data de las sucursales disponibles en un marco de tiempo.
- Es super flexible si los requerimientos de negocio lo necesitan
### Un diagrama simple es suficiente (puede ser a mano)
