### Implementación práctica
1. Si has usado DataZone u otra plataforma similar, ¿cuál fue tu experiencia?
- Amex, BBVA y Walmart tienen un estricto marco de gobierno de datos que rige la calidad, integridad, seguridad y usabilidad de todo el ciclo de vida del dato.
- Son similares, al ser del giro financiero (en Walmart trabajé en la vertical de finanzas). En el marco de gobernanza se define la criticidad de los datos, su sensibilidad, cómo deben ser tratados, los estándares de procesamiento, almacenamiento de metadatos para auditoría y linaje, entre otros.
- De cerca me tocó ver la implementación del catálogo de datos de BBVA para su gobierno de datos, usando principalmente Glue Catalog, Glue Crawlers y AWS Datazone.
- Además de asegurar la integridad y privacidad de los datos, podíamos acceder fácilmente al contexto de las tablas.
- BBVA adoptó una arquitectura de datamesh para la parte analítica y de enriquecimiento de los datos. Entonces, con Datazone teníamos acceso a la información de las tablas sobre sus propietarios, sobre sus responsables, a qué producto pertenecía; si necesitábamos datos de cierto producto, sabíamos a quién solicitarlo o desde qué otro producto teníamos acceso.
  
2. ¿Qué retos encontraste en la adopción por parte de los usuarios?
- Del lado del desarrollo, se veía sobre todos en perfiles juniors una resistencia a la adopción del marco de gobernanza, al parecer un stopper a la agilidad en la entrega de los pipelines ya que primero se debe asegurar de cumplir los requerimientos de gobernanza para todas las fases de desarrollo. Como ejemplo, en Walmart nuestro DDL necesitaba ser autorizado para poder dar inicio al desarrollo. En BBVA se necesitaba la autorización de los owners para escribir en ciertas rutas del storage o el permiso para tomar data que estaban en otro producto. 
- Un reto como tal fue transmitir la importancia del marco de gobernanza y hacer que se cumpliera.
¿Cómo balanceaste governance con agilidad?
- Se tiene que sobresaltar el valor de la gobernanza, sobre todo en términos regulatorios, de compliance y de auditoría. Una vez que ves en una plataforma todo lo que necesitas para reconocieminto de tus datos y los dolores de cabeza que te evita, sabes que vale la pena pasar tiempo llenando el check list "burocrático" para el desarrollo.

### Data Quality en producción
1. Comparte ejemplos de reglas de calidad que hayas implementado
- Validaciones de esquema.
- Integridad referencial (entre bases SQL y NoSQL)
- Validaciones de completitud.
- Validaciones al detalle que necesita el negocio ( por ejemplo, al centavo para agregaciones y registros)
2. ¿Qué herramientas has usado (Great Expectations, Deequ, otras)?
- DVT (data validation tool) que ya tiene validaciones predefinidas. Es de gran utilidad para comprobar datos migrados en GCP.
- Glue Catalog para escribir/leer basado en un esquema.
- PySpark para validaciones en cada stage de procesamiento.
- Últimamente un agente de IA interno que lee el repositorio y te sugiere las pruebas de calidad, una vez definidas las pruebas y validadas por ti, las implementa.
3. ¿Cómo manejas excepciones y casos donde el negocio acepta datos imperfectos?
  - Clasificación de errores (errores críticos, warnings, etc).
  - Bots de Slack (u otro servicio de comunicación) para notificar errores y datos aceptados por el negocio.
  - Cuarentena de datos para no parar los pipelines. Los datos que no cumplen las normas de calidad son investigados y si es posible, corregidos.
  - Acuerdo de negocio para datos imperfectos y las circunstancias para aceptarlos. Como datos personales incompletos (podría ser que sólo se necesite el nombre y la identificación del cliente para hacer un pago, y campos como email o celular sean opcionales)
### ROI y lecciones aprendidas
1. ¿Cómo mediste el valor del gobierno de datos?
- Por ejemplo, en Walmart lo medí con la reducción de riesgo de multas por no alcanzar los lineamientos de compliance.
- Mejora en la eficiencia operativa al haber un estándar de desarrollo.
2. ¿Qué funcionó bien y qué cambiarías?
- Lo que funcionó es integrar la gobernanza como un proceso que acompaña al desarrollo y no un proceso independiente.
- Que la gobernanza llegue a los flujos de CI/CD. Cualquier cambio o nuevo desarrollo debe cumplir con los estándaares antes de llegar a producción
- Evitar que la gobernanza sea una caja negra.
- Actualizar la documentación de gobernanza y campañas de visibilidad del marco.
3. Recomendaciones para una empresa de nuestro tamaño.
- Empezar con lo esencial. Un producto mínimo viable en el marco de gobernanza. Primero hacerlo que funcione y después hacerlo "bien".
- validaciones en puntos críticos para el negocio (conteos, manejo de datos sensibles, integridad de datos, linaje, auditoria)
- En medida de lo posible, automatizar la detección de errores en procesos críticos.
- Implementar un catálogo de datos.
- Fomentar el marco de gobernanza en toda la empresa, no sólo en el equipo de datos.
