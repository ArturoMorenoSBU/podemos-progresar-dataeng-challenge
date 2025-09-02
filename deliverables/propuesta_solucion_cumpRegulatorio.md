### Arquitectura resiliente
- La arquitectura se basará en AWS.
1. Capa de ingesta
- AWS Kinesis para procesar y capturar los datos en tiempo real. Esto también actúa como bufer y desacopla las fuentes de datos del procesamiento. Protege de la perdida de datos si los sistemas posteriores no están disponibles.
- AWS Glue para la ingesta de datos batch o desde las bases de datos. 
2. Procesamiento y storage
- S3 como landing de los datos provenientes de Kinesis. S3 Como fuente de la verdad. En S3 se almacena tanto la Raw data como la data transformada según necesidades de negocio. 
- Si se necesitan transformaciones en tiempo real, una capa con Jobs de Glue sería ideal para este caso.
3. Análisis y Reporting.
- Los datos procesados se cargarán a Redshift para la generación del reporte diario. Esto proporciona gran escalabilidad y disponibilidad.
- Si se necesita realizar exploración de datos en el datalake de S3, se podrá usar Athena.
4. Orquestación
- Usaremos step functions. Así podremos integrar todos los servicios de manera casi nativa, definiremos dependencias y aseguraremos resiliencia en el pipeline.
- Si algo falla, StepFunctions puede hacer retries. Si la falla se mantiene, CloudWatch mandará l alerta
5. Estrategia de contingencia.
- El sistema tiene naturaleza desacoplada, por si algún servicio de procesamiento falla, los datos no se perderán y podrán ser procesados posteriormente.
- Capacidad de replayability al almacenar los datos raw en S3. Si hay una falla mayor, se pueden volver a procesar los datos.
- Alertas y monitoreo usando CloudWatch para los jobs de Glue y la disponibilidad de las fuentes de datos. SNS alertará sobre fallos para su intervención según la criticidad.
- En un caso extremo, se puede activar un proceso con Athena para consultar rápidamente los datos raw del día anterior en S3 y generar un reporte básico. Se prioriza el cumplimiento vs. la complejidad de los datos.
6. Validación e integridad
- En mi experiencia, validar los datos en puntos críticos del pipeline es una obligación.
- Comparar conteo de registros, agregaciones, etc. con las fuentes de datos.
- Catalogar los datos para su gestión en el datalake, además ayuda a validar el esquema y nos da linaje de los datos.
- Se pueden implementar pruebas unitarias (se pueden agregar a un flujo de CI/CD) para asegurar que los cambios en la arquitectura y/o código no introduzcan errores en los datos.
- En todos mis roles en financieras, las pruebas unitarias son componentes críticos.

### Decisiones críticas
1. ¿Cómo manejarías data faltante cerca del deadline?
- Si es estrictamente necesario cumplir con el documento completo tener un plan b para generar un reporte con Athena con la data raw en S3 (no es 100% fiable)
- Si es cerca del deadline lo más probable es que no nos daría tiempo de buscar solución para generar el reporte completo.
- StepFunctions + CloudWatch nos ayuda a encontrar una solución temprana y validar si estamos ingestando menos datos que de costumbre.
- Generar un reporte con los datos ingestados que se tienen. Como es un caso que puede suceder, tener un proceso para expedir un json de exceptions documentando la data faltante.
- Ser transparentes y notificar al regulador. El flujo de datos debe tener linaje y forma de documentar para demostrar que la data no ha sido manipulada.
- Una vez entregado el reporte incompleto (con ls banderas de los archivos faltantes), se trabaja en encontrar el root case del problema para entregar el reporte completo lo antes posible.
   
3. ¿Qué approach usarías para reconciliación y manejo de discrepancias?
   - 3 tipos de validaciones: De Origen, End-to-end y de Negocio.
   - Para la validación de origen se implementan validaciones simples en la capa de ingesta. Al leer la data en kinesis, se debe contar el número de transacciones y compararlo con un recuento que saquemos de las transacciones de las fuentes.
   - Para la validación end-to-end se ejecutaría una validación más compleja sobre Redshift después de la carga de datos. En GCP hay una herramienta que he usado que es suer útil para estos escenarios que es DVT (Data Validation Tool), pero su homologo en Redshift más cercano que encuentro sería Glue Jobs para comparar los datos procesados en redshift contra los datos raw en S3.
   - Por último validaciones críticas para el negocio y el reporte regulatorio. Verificar que las sumas de los creditos coincidan (entre otras agregaciones) o que las transacciones tengan un cliente válido.
   
4. Si has trabajado con reportes regulatorios, ¿qué lecciones has aprendido?
   - Data Gobernance es escencial: En Walmart los reportes que generaban la aplicación de auditoria tenían que adherirse al marco de gobierno de la empresa. Esto garantizaba la trazabilidad, la integridad, la confianza y la fácil auditoria de los datos.
   - Automatización e Idempotencia: La aplicación de auditoria de walmart no sólo ahorró tiempo, también el error humano por captura de datos. Los pipelines estaban construidos para poder ejecutarse sin el temor de duplicar o corromper datos.
   - Traducir los requisitos de los especialistas de conciliación al producto final de datos es una necesidad. Se debe trabajar de la mano.
   - Sé por experiencia que existen políticas de "Partial Delivery" para la entrega de documentos conciliatorios, por eso lo sugerí en el punto anterior. Definir y aprobar estas políticas desde el principio.
