### ¿Qué métricas clave monitorearías?
- Número de archivos subidos por sucursal.
- Latencia de ingesta.
- Profundidad del queue de SQS.
- Tasa de exito del procesamiento con lambda.
- Duración de las Lambda.
- Número de registros procesados.
- Registros en cuarentena — Monitorear la calidad de los datos y detectar registros inválidos.
### ¿Cómo detectarías anomalías (ej: una región deja de reportar)?
- Cuando hice mi examen de certificación de AWS hubo un escenario justo como este.
- Una forma de abordarlo es con un sistema de detección de anomalías heart beat.
- No se espera un fallo, se monitorea la ausencia de actividad.
- En nuestra base de datos, por ejemplo, Dynamo, podemos dejar una marca de tiempo.
- Una función lambda que ejecute cada 30 mins y consulte la tabla.
- Compararíamos la última marca con la hora actual.
- Si cierto cliente excede el umbral, podríamos catalogarlo como silencioso.
- Significa que podría experimentar problemas de actividad.
### Comparte ejemplos de dashboards o alertas que hayas implementado.
- Alertas en Slack y mail sobre procesos ETL/ELT/EL para retries, errores, cuellos de botella, credenciales etc.
- En Walmart fue necesaria la creación de un dashboard sobre datos en cuarentena - Esto para fundamentar un cambio en el data source.
