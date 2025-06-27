create master key;
go;

CREATE DATABASE SCOPED CREDENTIAL [AzureDataLakeGen2Credential]
WITH IDENTITY = N'ADLG2';
go;

CREATE DATABASE SCOPED CREDENTIAL [polybase]
WITH IDENTITY = N'UK-BI-DW-Developer',
SECRET = 'tXJkef82vAwQ02r0apjg8U5Bz241D+F2yCvlVyjBz/RZQIrxLUm5Rn39WEHyWrATjsgwcKHvlbqdejkqaCtlsw=='
go;


create DATABASE SCOPED CREDENTIAL AzureDataLakeGen2TESTCredential
WITH IDENTITY = 'ADLG2_TEST',
SECRET = 'tkGzex1mP1QwxmDhCF5rSNI24ZbJbnsQ4cS5jIoz09woTimh/4khKhfBHMe9jXEXbKqBooMA/I1j6Nw6HOax+A==' 
go;

CREATE EXTERNAL DATA SOURCE [ADLG2_TEST_PSA] WITH (TYPE = HADOOP, LOCATION = N'wasbs://psa@ukmaxbitestdtlk01.blob.core.windows.net',
CREDENTIAL = [AzureDataLakeGen2TESTCredential])
GO;

--create DATABASE SCOPED CREDENTIAL AzureDataLakeGen2ProdCredential
--WITH IDENTITY = 'ADLG2_PROD',
--SECRET = 'Pssi2DD8s084Qq/6qLxjLM7swIlSiYkMoYNMOEW+FprDoCKJhqX8HlTuz3dvsr8AjiFsC/xJi+lQKMzn7S7gLw==' 
--go;

--CREATE EXTERNAL DATA SOURCE [ADLG2_PROD_PSA] WITH (TYPE = HADOOP, LOCATION = N'wasbs://psa@ukmaxbiproddtlk01.blob.core.windows.net',
--CREDENTIAL = [AzureDataLakeGen2PRODCredential])
--GO;