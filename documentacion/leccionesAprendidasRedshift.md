### Comparte alguna experiencia donde Redshift se comportó de forma inesperada
- Por suerte fue con una tabla no crítica sobre status de funcionamiento de ATMs.
- La tabla estaba dentro de mi backlog para el análisis de cumplimiento de requisitos estandar para tablas en redshift.
- Las consultas tenían un rendimiento "aceptable"; fue más un detalle revisando el esquema.
- Se omitió la asignación de SORTKEYS sobre la tabla, en un futuro aunque redshift sea optimizado como DW puede haber degradación en las consultas si no se particiona bloques de información.
### ¿Cómo lo resolviste y qué aprendiste?
- Se dio visibilidad a los dueños de la información para que se asignara una sortkey.
- Debe haber un proceso dentro de la gobernanza que sea un cortafuegos para evitar omiciones de buenas prácticas.
### ¿Qué recomendarías a alguien que recién empieza con Redshift?
- Entender a fondo su propósito y para qué es utilizado redshift.
- Saber que existen y saber usar herramientas dentro de redshift (como Query editor) para acercarse a consultas y diseños óptimos desde el inicio.
- Buscar foros o threads sobre las fallas, cuellos de botella y malas prácticas de redshift para evitarlos.
- Diseñar entorno a las consultas, no a los datos. Entender los requeriemintos de negocio para decisiones sobre DISTKEYS y SORTKEYS y demás diseño de tus tablas.
