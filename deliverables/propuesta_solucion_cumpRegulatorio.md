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
