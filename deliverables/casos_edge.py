import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from pyspark.sql.functions import from_utc_timestamp, to_utc_timestamp, col, lit, max
from pyspark.sql.window import Window

def process_incremental_load(glueContext, source_df, target_table):
  """
  Plantilla enfocada en los puntos para el procesamiento de Glue.
  Se necesitan definir la configuración para la escritura en redshift como url, dbtable, credenciales, driver, etc
  """
    
    # 1. Manejo de Duplicados
    unique_records_df = source_df.dropDuplicates(["id_pago", "id_sucursal"])

    # 2. Normalización de Zonas Horarias
    normalized_df = unique_records_df.withColumn("fecha_pago_utc", to_utc_timestamp(col("fecha_pago"), "Mexico/General"))

    # 3. Manejo de Datos Fuera de Orden (Estrategia de UPSERT)
    window_spec = Window.partitionBy("id_pago").orderBy(col("fecha_pago_utc").desc())
    latest_records_df = normalized_df.withColumn("row_number", row_number().over(window_spec)) \
                                     .filter(col("row_number") == 1) \
                                     .drop("row_number")
    try:
        target_df = glueContext.create_dynamic_frame.from_catalog(database="your_database", table_name=target_table)
        target_df = target_df.toDF()

        # Join del batch incremental con el target para identificar actualizaciones e inserciones.
        upsert_df = latest_records_df.union(target_df).dropDuplicates(["id_pago"]).orderBy(col("fecha_pago_utc").desc())

        # Se escribe el DataFrame consolidado de vuelta a la tabla de Redshift.
        upsert_df.write.format("jdbc").options(...)
    except:
        # Si la tabla target no existe, se cargan los datos por primera vez.
        latest_records_df.write.format("jdbc").options(...)
    
    # 4. Integridad Referencial
    # Se usa una cuarentena.
    valid_clientes_df = glueContext.create_dynamic_frame.from_catalog(database="podemos_mx", table_name="sucursales").toDF()
    
    joined_df = latest_records_df.join(valid_clientes_df, on=["id_cliente"], how="left_anti")

    # Los registros que no se unieron.
    # se envían a una tabla de cuarentena para su revisión posterior.
    joined_df.write.format("parquet").mode("append").save("s3://podemos-progresar/cuarentena_pagos/")
    
    # Los registros que sí se unieron se cargarían en el destino principal.
