# Podemos Progresar

Este repositorio contiene las propuestas técnicas para resolver desafíos de ingeniería de datos, optimización y cumplimiento regulatorio, adaptadas a las necesidades de una microfinanciera como Podemos Progresar.

---

## 🚀 Ejercicio 1: Optimización de Redshift

**Objetivo:** Mejorar el rendimiento de los reportes críticos en una tabla histórica de pagos de 2 mil millones de registros, cuyo tiempo de ejecución ha pasado de 5 a 45 minutos.

### **1. Diagnóstico Inicial**

* **Queries de Diagnóstico:** 
    * [Queries de profiling en Redshift](deliverables/pagos_historicos_query_profiling.sql)
* **Información de Tablas del Sistema:** 
    * [Guía de consultas para profiling en Redshift](documentacion/guiaConsultasProfilingRedshift.md)
* **Casos de la Vida Real:** 
    * [Banco de conocimiento sobre experiencias con Redshift](documentacion/experienciasRedshift.md)

### **2. Propuesta de Solución**

* [Propuesta de DDL para optimizar la tabla](deliverables/propuesta_ddl_historico_pagos.sql)

### **3. Manejo de Casos Extremos**

* [Banco de conocimiento y lecciones aprendidas con Redshift](documentacion/leccionesAprendidasRedshift.md)

---

## 🚀 Ejercicio 2: ETL Incremental con Restricciones Reales

**Objetivo:** Consolidar datos de 200 bases de datos MySQL locales, con conectividad intermitente, retrasos y duplicados.

### **1. Diseño de Arquitectura en AWS**

* [Propuesta de arquitectura para sucursales en AWS](deliverables/AWS_arq_sucursales_propuesta_v1.md)

### **2. Manejo de Casos Extremos**

* [Job de Glue/PySpark para manejar duplicados y retrasos](deliverables/casos_edge.py)

### **3. Experiencias y Aprendizajes**

* [Banco de conocimiento sobre experiencias en ETL](documentacion/experienciasETL.md)

---

## 🚀 Ejercicio 3: Arquitectura de Eventos para el Campo

**Objetivo:** Capturar datos de eventos (geolocalización, fotos, pagos) desde una aplicación móvil en zonas rurales con conectividad limitada.

### **1. Estrategia "Offline-First"**

* [Estrategia para una arquitectura offline-first](deliverables/offline-first.md)

### **2. Pipeline de Procesamiento "Serverless"**

* [Diseño del pipeline serverless en AWS](deliverables/pipeline_serverless.md)

### **3. Observabilidad y Monitoreo**

* [Estrategia de métricas y monitoreo para el flujo de campo](deliverables/monitoreo_flujo_campo.md)

---

## 🚀 Ejercicio 4: Integración para Cumplimiento Regulatorio

**Objetivo:** Entregar un reporte consolidado diario a las 6:00 a.m. para el regulador, con datos de 15 sistemas diferentes y alta disponibilidad.

### **1. Arquitectura Resiliente**

* [Propuesta de arquitectura resiliente en AWS](deliverables/propuesta_solucion_cumpRegulatorio.md)

### **2. Orquestación con Step Functions**

* [Propuesta de orquestación con AWS Step Functions](deliverables/step_functions_reporte_regulatorio.md)

### **3. Decisiones Críticas**

* [Plan de contingencia y decisiones críticas](deliverables/decisiones_criticas_cumpReg.md)

---

## 🚀 Ejercicio 5: Gobierno de Datos y AWS DataZone

* [Banco de conocimiento sobre gobierno de datos](documentacion/data_gobernance.md)
