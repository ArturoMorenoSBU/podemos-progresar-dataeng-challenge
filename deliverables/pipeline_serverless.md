### Diseña el flujo usando servicios AWS (EventBridge, Kinesis, SQS, Lambda)
- EventBridge, al ser un servicio que facilita la construcción de aplicaciones enfocadas a eventos, captura un evento cuando un archivo de eventos cae en S3.
- Configuramos una regla en EventBridge para enviar un mensaje a SQS al detectar un evento. SQS actúa como búfer para manejar la avalancha de mensajes.
- Se usará Lambda para leer el queue de SQS. Se logra un procesamiento asíncrono y batch.
- Lambda consolida y procesa los eventos. Luego envía los datos como los queremos a un S3 o incluso a Redshift. 
### Incluye un ejemplo de función Lambda para procesar pagos.
```python
import json
import boto3
from urllib.parse import unquote_plus

s3 = boto3.client('s3')

def process_payment_event(event, context):
    for record in event['Records']:
        # Se asume que el mensaje de SQS contiene la información del archivo de S3.
        payload = json.loads(record['body'])
        bucket = payload['bucket']['name']
        key = unquote_plus(payload['object']['key'])

        try:
            # 1. Leer el archivo de S3
            response = s3.get_object(Bucket=bucket, Key=key)
            file_content = response['Body'].read().decode('utf-8')
            events = [json.loads(line) for line in file_content.strip().split('\n')]

            # 2. Procesar cada evento
            for event in events:
                event_id = event.get('event_id')
                
                # Check de idempotencia:
                if is_processed(event_id):
                    print(f"Evento {event_id} ya procesado. Omitiendo.")
                    continue
                
                # Procesamiento real del pago
                # Aquí iría la lógica de transformación, validación, etc.
                process_payment(event)

                # Registrar el evento como procesado
                mark_as_processed(event_id)

            print(f"Archivo {key} procesado exitosamente.")

        except Exception as e:
            print(f"Error procesando el archivo {key}: {e}")
            raise # SQS manejará el reintento si la función falla
            
def is_processed(event_id):
    # Lógica de verificación en una base de datos (DynamoDB es ideal).
    # Se haría una consulta rápida por event_id.
    # return True si el id existe, False si no.
    return False 

def mark_as_processed(event_id):
    # Lógica para registrar el event_id en DynamoDB.
    # Esto asegura que no se procese de nuevo.
    pass

def process_payment(event_data):
    # Lógica para limpiar y cargar el pago a la base de datos de destino.
    # (ej. enviar a Redshift, a otra capa en S3)
    pass
```
### ¿Cómo garantizas idempotencia en el procesamiento?
- En la parte de check de idempotencia se basa en un identificador único.
- Antes de procesar un evento, la función Lambda consulta una base de datos (DynamoDB sugerida para estos casos) para ver si el event_id ya existe. Si existe, se omite. Si no, se procesa y se registra en la base de datos. Esto asegura que aunque el mismo mensaje de SQS sea entregado o procesado varias veces, el resultado en la base de datos final será el mismo.
###  ¿Qué estrategia usarías para manejar eventos que exceden límites de Lambda?
- Mi estrategia se basa en SQS. Actúa como bufer, así lambda no supera los 15 minutos que tiene para ejecución al procesar un lote de mensajes a la vez, y no la carga completa.
- Un lambda que lea el archivo de S3 y divida su contenido en mensajes de menor tamaño que se envían a SQS, después múltiples lambdas procesan el archivo en paralelo.
