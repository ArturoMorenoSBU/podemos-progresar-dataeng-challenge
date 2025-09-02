### Orquestación con Step Functions
- Mi mayor experiencia en orquestación ha sido con Airflow, sobre todo en Cloud Composer de GCP.
- Esta es mi propuesta pensando cómo lo haría en airflow pero sobre StepFunctions.
- No es un lift and shift de airflow a StepFunctions, para el flujo consideré las ventajas y susos de StepFunctions.
1. Pasos en StepFunctions
- El pipeline de StepFunction se ejecutará a las 2am. Así tenemos un margen de tiempo para procesar los datos del día anterior.
- Se lanzará un Glue Job para procesar los datos de Kinesis y cargarlos en el datalake de S3.
- Cuando se terminen de cargar los datos, se lanzará otro Glue job para la transformación de los datos. Se leen los datos, se limpian, se enriquecen y se regresan a S3 en un formato optimizado como parquet.
- Usamos Lambda para realizar validaciones de integridad y calidad.
- Si la validación es exitosa, se ejecuta un tercer Glue Job para cargar los datos a Redshift.
- Se usa otra función lambda para ejecutar la consulta para armar el reporte. El output puede regresar a S3 para poder ser compartido mediante una URL con acceso o enviarse por email.
2. Reintentos y recuperación de errores.
- Cada paso del pipeline se puede configurar con retries. Por ejemplo, si hay errores en el flujo (problemas de red, por ejemplo), StepFunctions lo reintentará con un retardo exponencial.
- Se pueden definir diferentes comportamientos para distintos tipos de errores. Por ejemplo, si un trabajo de Glue falla debido a un error de validación de datos (un error de negocio), se puede dirigir a una rama de notificación en lugar de reintentarlo indefinidamente.
- Si una tarea falla repetidamente, StepFunctions puede notificar a través de SNS al equipo técnico.
- Se puede volver a ejecutar desde un checkpoint en el pipeline si un error necesita ser manejado de forma manual.
- El pipeline está diseñado para ejecutarse varias veces y traer el mismo resultado (idempotencia). Los Glue Jobs reescriben los archivos en particiones de S3 y los datos de Redshift; se garantiza que no hay duplicados ni datos corrompidos.
2. Estrategia de Rollback.
- S3 actúa como fuente de la verdad inmutable, entonces una estrategia tradicional de rollback no es necesaria.
- El sistema es idempotente. Glue reescribe en las particiones de S3 y en Redshift, entonces nos protegemos contra datos duplicados o corrompidos.
- Es un enfoque de retry y corrección.
