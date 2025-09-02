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
  [Banco de conocimiento Experiencias Redshift](documentacion/experienciasRedshift.md)

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
[Estrategia para offline-first](deliverables/offline-first.md)
### 2. Pipeline de procesamiento serverless  
[AWS pipeline serverless](deliverables/pipeline_serverless.md)
### 3. Observabilidad y monitoreo  
[Estrategia metricas y monitoreo](deliverables/monitoreo_flujo_campo.md)


## 🚀 Ejercicio cuatro.

### Contexto del Problema
El regulador requiere un reporte consolidado diario a las 6am con todos los movimientos del día anterior. El incumplimiento implica multas significativas.
Consideraciones:
- Datos provienen de 15 sistemas diferentes
- Algunos sistemas se actualizan hasta las 4am
- Alta disponibilidad es crítica
- Precisión al centavo es mandatoria
- Capacidad de regenerar reportes históricos
### 1. Arquitectura resiliente
[Arquitectura resiliente AWS](deliverables/propuesta_solucion_cumpRegulatorio.md)
### 2. Orquestación con Step Functions 
[StepFunctions Propuesta](deliverables/step_functions_reporte_regulatorio.md)
### 3. Decisiones críticas
[Plan de contigencia y decisiones críticas](deliverables/decisiones_criticas_cumpReg.md)
