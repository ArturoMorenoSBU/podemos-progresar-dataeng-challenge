### Describe brevemente un ETL complejo que hayas implementado
- Fue en mi paso por Walmart, construí un ETL que consolidaba las fuentes de diferentes fuentes. Hasta ahí todo Ok, el reto es que una de las fuentes que estaban empujando a los stakeholders para configurar era un PDF que cierto equipo sería encargado de cargar mensualmente y la precisión al centavo que requería la tabla final.
- El ETL se consolidó de forma correcta, los primeros runs fueron exitosos y los datos estaban mostrándose como debía gracias a diferentes validaciones a lo largo del ETL, comprobando singularidades, comprobación de agregaciones, comprobación de esquemas, entre otros.
- Fue bastante sencillo orquestar con airflow jobs de Spark que corrían sobre clústeres efímeros de Dataproc y su posterior carga a diferentes ubicaciones de Cloud Storage. Tengo bastante experiencia con estas tecnologías.
- Se cumplió con todo el marco de data gobernance para el desarrollo del proceso.
### ¿Qué problemas no anticipaste?
- Quise ser flexible al aceptar como fuente de datos un pdf que subiría un encargado a un bucket de Cloud Storage.
- Los responsables de subir el archivo fallaron un par de ocasiones y esto provocó que los datos finales no cumplieran con los criterios de aceptación sobre actualización de la tabla.
- Además, el pdf se construía un sistema interno que consolidaba varios flujos de SAP, por lo que el flujo falló en algunas ocasiones por falla en la comprobación del esquema de la información extraída del pdf.
- Al final se cambió el data source por una base de datos de postgres que era la base de la construcción del pdf.
### ¿Qué harías diferente hoy?
- Aplicar una regulación sobre las fuentes de datos aceptables para consumo.
- En un doloroso caso de no poder traer la data desde su sistema origen (restricciones por sensibilidad de datos, región, etc) poderlo traer desde una fuente no volátil y que el linaje de datos est´s muy bien documentado desde origen a esa fuente.
