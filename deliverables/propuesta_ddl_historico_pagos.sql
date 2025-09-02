CREATE TABLE pagos_historicos_optimizada
(
    id_pago         BIGINT PRIMARY KEY, -- Definida como PK para propósitos de documentación y gobernanza.
    id_prestamo     BIGINT,
    id_cliente      BIGINT,
    monto           DECIMAL(18, 2),
    fecha_pago      DATE,
    sucursal        VARCHAR(50) ENCODE ZSTD,
    status_pago     VARCHAR(20) ENCODE ZSTD,
    otros_datos     VARCHAR(256) ENCODE ZSTD
)
DISTSTYLE KEY
DISTKEY (id_cliente)
SORTKEY (fecha_pago, id_cliente);


-- Metadatos que residen en el esquema para el gobierno de datos. Útil para organizar metadata en DataZone. En mi paso por BBVA y WALMART los comentarios en las columnas de las tablas análiticas era crucial, no sólo era parte del marco de gobierno, también ayudaba al compliance y a los asuntos regulatorios.
COMMENT ON COLUMN pagos_historicos_optimizada.id_pago IS 'Identificador único y primario de cada transacción de pago. Origen: Sistema de pagos (PK).';
COMMENT ON COLUMN pagos_historicos_optimizada.id_prestamo IS 'Clave foránea que enlaza el pago con la tabla de préstamos. Origen: Sistema de préstamos.';
COMMENT ON COLUMN pagos_historicos_optimizada.id_cliente IS 'Clave de distribución (DISTKEY). Identificador del cliente. Utilizado para agrupar pagos de un mismo cliente en un nodo de cómputo. Origen: CRM.';
COMMENT ON COLUMN pagos_historicos_optimizada.monto IS 'Monto total del pago realizado. MXN. Formato: Decimal(18,2).';
COMMENT ON COLUMN pagos_historicos_optimizada.fecha_pago IS 'Fecha de la transacción del pago. Clave de ordenación (SORTKEY) y particionamiento. Formato: YYYY-MM-DD.';
COMMENT ON COLUMN pagos_historicos_optimizada.sucursal IS 'Sucursal donde se originó el pago. Clasificación: Dato Sensible (nivel 1).';
COMMENT ON COLUMN pagos_historicos_optimizada.status_pago IS 'Estado actual del pago (ej. pagado, pendiente). Mapeo de valores: (PAGADO, PENDIENTE, RECHAZADO).';
COMMENT ON COLUMN pagos_historicos_optimizada.otros_datos IS 'Campo genérico para información adicional del pago en formato de texto. Este campo podría ser refactorizado en el futuro.';

-- RAZONAMIENTO PARA DISTKEYS, SORTKEYS Y ENCODING

-- "id_cliente" como DISTKEY 
--   Para agrupar los registros por (pagos) de un mismo cliente en un mismo nodo, pensado para acelerar las operaciones de agregación y filtrado. Pensando que los reportes se centren en el comportamiento de los clientes.
--   No evita el data skew de forma inherente, pero por lo general los modelos de pago de financiación no tienen una gran varianza en plazo establecido. Por lo que los valores de pagos hechos por un cliente no acumularán una cantidad desproporcionada de registros.
--   Se pueden programar monitoreos regulares con consultas de diagnóstico para validar la distribución de los datos.
--   Si "id_cliente" resulta ser una elección poco eficiente para DISTKEY se debe rediseñar la tabla para escoger una DISTKEY nueva o considerar una migración a un modelamiento dimensional.


-- "fecha_pago" y "id_cliente" como SORTKEYS
--   Enfocado a reducir el I/O (operaciones de input y output)
--   Al enfocarse los reportes en algún periodo de tiempo y por ciertos IDs, Redshift puede dirigirse directamente a leer los bloques con información relevante y no escanear toda la tabla.

-- Encoding
-- ZSTD para equilibrio entre compresión y alta descomprensión. Es un encoding moderna y eficiente.
-- Otro encoding sería para escenarios más especificos como RAW, AZ64. etc

-- Consideraciones de negocio.
--   Se consideró un diseño de "bigTable" pensando en el tipo de preguntas que se necesitan responder; como montos de préstamos pagados en un intervalo de tiempo o segmentados por cliente y sucursal.
--   Al ser una tabla con información vital para el análisis se optó por una solución rápida. Un diseño dimensional podría significar mayor inversión de tiempo e ingeniería al diseñar, construir y poblar las tablas de facts y dim.
--   Si el negocio requiere un patrón de consultas mucho más frecuentes, el volumen de datos está proyectado a crecer masivamente y hay cruces con otra información, el enfoque dimensional se vuelve necesario.
