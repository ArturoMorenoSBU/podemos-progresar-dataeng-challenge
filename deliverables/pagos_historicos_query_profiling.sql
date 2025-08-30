-- 1. Primero se busca identificar el síntoma principal; si no sabemos qué está lento, no podemos identificar la causa.
SELECT query,
       elapsed,
       starttime,
       pid,
       substring(querytxt, 1, 100) AS querytxt, -- Se puede modificar dependiendo de qué tanto contexto necesitemos
       aborted
FROM   stl_query
WHERE  userid > 1 AND aborted = false
ORDER BY elapsed DESC
LIMIT 10;

-- 2. ¿Qué tal si el problema no es la tabla sino que las consultas están encoladas en el WLM? El problema podría ser la configuración del cluster y no la tabla en sí.

SELECT
    service_class,
    queue_time / 1000000 AS queue_seconds,
    exec_time / 1000000 AS exec_seconds,
    query
FROM
    stl_wlm_query
WHERE
    exec_time > 0
ORDER BY
    exec_seconds DESC
LIMIT 10;

-- 3. VACUUM y ANALYZE como aliados cuando el problema se acota a un problema con la tabla. Hacemos una vista general al estado de salud de la tabla.
SELECT "schema",
       "table",
       size,
       tbl_rows,
       unsorted_rows,
       stats_off,
       diststyle,
       sortkey1 AS sortkey_column,
       distkey AS distkey_column
FROM svv_table_info
WHERE "table" = 'pagos_historicos';
-- 4. Evaluar si los datos están repartidos de forma desigual en los nodos. Si hay Data Skew, lo óptimo sería un rediseño de la tabla para seleccionar una DISTKEY diferente.
SELECT
    "table",
    skew_rows,
    unsorted_rows
FROM
    svv_table_info
WHERE
    "schema" = 'public' AND "table" = 'pagos_historicos';
-- 5. ¿Las SORTKEYS están funcionando correctamente? ¿Redshift está leyendo más datos de los necesarios? ¿La tabla está optimizada para los ptrones de acceso?
SELECT
    userid,
    query,
    querytxt,
    starttime,
    endtime,
    rows_scanned,
    blocks_scanned,
    is_result_cache_hit
FROM
    svl_scan_summary
WHERE
    userid > 1
ORDER BY
    starttime DESC
LIMIT 10;
