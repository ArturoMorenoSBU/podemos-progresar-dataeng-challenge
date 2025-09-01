### ¿Cómo diseñarías la captura y el almacenamiento local de eventos?
- Si el enfoque es offline-first, los dispositivos móviles de los oficiales servirían como base de datos ya que SQLite está integrada de forma nativa.
- Diseño de tabla de eventos para garantizar trazabilidad y orden; event_id, event_type (pago, confirmación, fotos de pagos, etc), event_data (json con datos del evento), timesta,p, sync_status (rastrear status de la sinconización)
### ¿Qué estrategia usarías para sincronización cuando hay conectividad?
- Sincronización de datos por lotes pequeños, no todos los encolados con estado de pending.
- Monitorear estado de red para iniciar la sincronización cuando haya red (configurar trabajos para conexiones fuertes y débiles)
- Mantenemos principios ACID con sync_status.
- El destino estaría enfocado en un enfoque serverless con ayuda de API Gateway de AWS, enviando los batches desde el cliente móvil de los oficiales.
### ¿Cómo manejarías picos de reconexión (ej. 500 dispositivos a la vez)?
- Del lado del cliente (smartphones de los oficiales): Cada dispositivo esperaría un tiempo aleatorio para intentar la sincronización, aumentando este tiempo con cada retry.
- Del lado del backend: API Gateway al ser serverless puede escalar automáticamente para el volumen de peticiones. Lambda para instancias paralelas para procesar las solicitudes.
- 
