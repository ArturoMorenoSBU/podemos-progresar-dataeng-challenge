
## Guía de Análisis de Rendimiento en Redshift

Esta guía es un documento de apoyo para las partes interesadas independientemente de su perfil y nivel técnico. Se busca una mejor comprensión del análisis de profiling sobre la tabla de Pagos Históricos.

### ¿Qué buscar en las tablas del sistema?

Enfoque / Tabla del sistema a consultar

* **Consultas lentas**: Identificar las `queries` que consumen más tiempo.  --> STL_QUERY
* **Contención de recursos**: Determinar si las consultas se están encolando debido a la configuración de WLM (Workload Management). --> STL_WLM_QUERY
* **Problemas de diseño de tabla**: Revisar si las tablas están bien optimizadas (`VACUUM`, `ANALYZE`, `DISTKEY`, `SORTKEY`). --> SVV_TABLE_INFO
* **Distribución de datos**: Evaluar si los datos están distribuidos de manera uniforme entre los nodos del clúster (`data skew`). --> SVV_TABLE_INFO
* **Eficacia de las `SORTKEYS`**: Verificar si las consultas están escaneando más datos de los necesarios. --> SVL_SCAN_SUMMARY

---

### Análisis de `Queries` y sus Propósitos

#### 1. Identificar consultas lentas

Esta `query` es tu punto de partida. Busca las **10 consultas más lentas** en términos de tiempo de ejecución (`elapsed`). Al filtrar por `userid > 1`, te centras en las consultas de usuarios.

* `SELECT query, elapsed, starttime, ...`: Selecciona el ID de la consulta, el tiempo que tardó, cuándo comenzó, el ID del proceso y una porción del texto de la consulta.
* `FROM stl_query`: Es la tabla principal de logs de consultas.
* `ORDER BY elapsed DESC`: Ordena las consultas de mayor a menor tiempo de ejecución.

#### 2. Verificar la contención de WLM

Si el problema no es la consulta en sí, podría ser que el **WLM** está encolando las `queries`. Esta `query` muestra cuánto tiempo las consultas pasaron en la cola (`queue_time`) versus el tiempo de ejecución (`exec_time`).

* `SELECT service_class, queue_time, exec_time, query`: Muestra la clase de servicio (cola de WLM), el tiempo en cola y el de ejecución.
* `FROM stl_wlm_query`: Esta tabla registra la actividad de las colas de WLM. Un `queue_time` alto indica que el WLM podría estar mal configurado.

#### 3. Evaluar el estado de las tablas

Una vez que identificas una tabla involucrada en una consulta lenta, analizas su estado de salud. 

* `SELECT "schema", "table", size, ...`: Muestra el tamaño de la tabla, la cantidad de filas, y datos clave de optimización.
* `FROM svv_table_info`: Esta vista (`System View`) es un resumen útil para el `profiling`.
* `unsorted_rows`: Muestra el número de filas que no están ordenadas según la `SORTKEY`, lo cual puede impactar el rendimiento.
* `stats_off`: Indica si las estadísticas de la tabla están desactualizadas, afectando el plan de ejecución del optimizador.

#### 4. Detectar `Data Skew`

`Data skew` ocurre cuando los datos de una tabla no se distribuyen de manera uniforme entre los nodos del clúster. Esto puede causar que algunos nodos trabajen mucho más que otros.

* `SELECT "table", skew_rows, unsorted_rows`: Muestra el `data skew`. Un valor alto en `skew_rows` significa que los datos están desequilibrados. Esto podría requerir rediseñar la tabla con una nueva **`DISTKEY`** (columna de distribución).

#### 5. Analizar la efectividad de las `SORTKEYS`

Esta `query` te ayuda a entender si tus `SORTKEYS` están funcionando bien. `Redshift` usa las `SORTKEYS` para saltar bloques de datos irrelevantes. 

* `SELECT rows_scanned, blocks_scanned, is_result_cache_hit`: Muestra cuántas filas y bloques de datos fueron escaneados. Si `blocks_scanned` es bajo en relación al total de bloques, la `SORTKEY` está funcionando.
* `FROM svl_scan_summary`: Proporciona un resumen de los escaneos de tablas. Un alto número de `blocks_scanned` puede significar que la `SORTKEY` no está optimizada para la consulta.

---

### Glosario de Términos Clave

* **`Data Skew`**: Distribución desigual de los datos entre los nodos de computación de Redshift, lo que provoca que ciertos nodos trabajen más que otros. Es un problema de rendimiento grave.
* **`DISTKEY` (Distribution Key)**: La columna de una tabla que Redshift usa para distribuir las filas entre los nodos. Una `DISTKEY` bien elegida ayuda a evitar el `data skew`.
* **`SORTKEY` (Sort Key)**: La columna por la que Redshift ordena físicamente los datos. Permite que el optimizador salte grandes porciones de datos durante un `query`, un concepto llamado **zone maps**.
* **`VACUUM`**: Comando que recupera el espacio de disco de las filas eliminadas y reordena las filas de una tabla para mantener la `SORTKEY` óptima.
* **`ANALYZE`**: Comando que actualiza las estadísticas de las tablas. El optimizador de consultas las usa para crear el plan de ejecución más eficiente.
* **`WLM` (Workload Management)**: Sistema de Redshift que gestiona los recursos del clúster, como la memoria y la concurrencia. Las `queries` se asignan a colas de WLM, y si están mal configuradas, pueden causar que las `queries` se encolen.
* **`STL_QUERY` y `SVV_TABLE_INFO`**: **Tablas de sistema** que almacenan metadatos sobre el rendimiento del clúster. Las tablas `STL_` son logs de eventos, mientras que las vistas `SVV_` son resúmenes de datos del sistema.

*** Referencias

- [https://docs.aws.amazon.com/redshift/latest/dg/best-practices.html]
- [https://docs.aws.amazon.com/redshift/latest/dg/c-optimizing-query-performance.html]
- [https://docs.aws.amazon.com/es_es/redshift/latest/dg/cm_chap_system-tables.html]
