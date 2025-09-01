# Podemos Progresar

## 🚀 Ejercicio uno.

### Contexto del Problema
Nuestra tabla de pagos históricos ha crecido a **2 mil millones de registros**. Como resultado, los reportes críticos que antes se ejecutaban en **5 minutos** ahora tardan **45 minutos**, impactando significativamente la velocidad de las decisiones de negocio.

---

### 1. Diagnóstico Inicial

* **¿Cuáles serían tus primeros 5 queries para entender el problema?  
  [Queries profiling redshift](deliverables/pagos_historicos_query_profiling.sql).

* **¿Qué información buscarías en las tablas del sistema (STL_QUERY, etc.)?  
  [Guía profiling queries en Redshift](documentacion/guiaConsultasProfilingRedshift.md)
  
* **Si has enfrentado un caso similar, ¿qué descubriste que causaba el problema?  
  - Un caso extremo en Redshift que viví en un proyecto pasado donde una optimización de la tabla no era suficiente; a medida que trabajaba con una tabla de transacciones de millones de registros en Redshift, se consideró que la principal causa del bajo rendimiento no era la consulta en sí, sino un modelo de datos deficiente. El problema radicaba en la denormalización de la tabla, lo que obligaba al sistema a leer y procesar datos de texto repetidos en cada fila (como los identificadores de sucursales); esto volvía las ejecuciones sobre la tabla muy lentas. Se optó por migrar el modelo a uno dimensional (estrella), así los joins se hacían sobre las llaves subrogadas y las consultas las enfocamos a aprovechar la naturaleza de la arquitectura columnar de Redshift.

---

### 2. Propuesta de Solución  
[Propuesta de solución](deliverables/propuesta_ddl_historico_pagos.sql)


### 3. Manejo de casos edge  
[Banco de conocimiento Redshift](documentacion/leccionesAprendidasRedshift.md)

## 🚀 Ejercicio dos.

### Contexto
Necesitamos consolidar datos de 200 sucursales con bases MySQL locales. La conectividad es intermitente; los datos pueden llegar con días de retraso y ocasionalmente duplicados.

### 1. Diseño de arquitectura AWS  
[Propuesta de solución](deliverables/AWS_arq_sucursales_propuesta_v1.md)
### 2. Manejo de casos edge  
[Glue/PySpark Job](deliverables/casos_edge.py)
### 3. Experiencias y aprendizajes  
[Banco de conocimiento ETL](documentacion/experienciasETL.md)

## 🚀 Ejercicio tres.

### Contexto del Problema
Nuestros oficiales de crédito usan apps móviles en zonas rurales. Necesitamos capturar eventos (geolocalización, fotos de pagos, confirmaciones) con conectividad limitada o nula.

### 1. Estrategia offline-first
[Propuesta de solución](deliverables/AWS_arq_sucursales_propuesta_v1.md)
### 2. Pipeline de procesamiento serverless  
[Glue/PySpark Job](deliverables/casos_edge.py)
### 3. Observabilidad y monitoreo  
[Banco de conocimiento ETL](documentacion/experienciasETL.md)
