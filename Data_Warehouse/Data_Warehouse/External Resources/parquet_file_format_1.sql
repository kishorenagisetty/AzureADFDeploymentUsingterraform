CREATE EXTERNAL FILE FORMAT [parquet_file_format]
    WITH (
    FORMAT_TYPE = PARQUET,
    DATA_COMPRESSION = N'org.apache.hadoop.io.compress.GzipCodec'
    );

