CREATE EXTERNAL DATA SOURCE [ADLG2_PSA]
   WITH (
    TYPE = HADOOP,
    LOCATION = N'wasbs://psa@ukmaxbitests01.blob.core.windows.net',
    CREDENTIAL = [AzureDataLakeGen2Credential]
    );



