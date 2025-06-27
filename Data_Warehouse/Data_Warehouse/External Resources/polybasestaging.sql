CREATE EXTERNAL DATA SOURCE [polybasestaging]
    WITH (
    TYPE = HADOOP,
    LOCATION = N'wasbs://polybasestaging@ukmaxbitests01.blob.core.windows.net',
    CREDENTIAL = [polybase]
    );







