TRUNCATE TABLE [ELT].[ASLogicAppNames]

INSERT INTO [ELT].[ASLogicAppNames]  ([ASLogicAPPName]
           ,[PipelineName])
     VALUES
           ('https://prod-16.uksouth.logic.azure.com:443/workflows/f7fd0523934e47d3b8914dbf241e1201/triggers/manual/paths/invoke?api-version=2016-10-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=dzjd07tVizjDXI48Iu2ewqlcOYSWdC7zWC59ZGxdIic',
           'PL_AAS_REFRESH')
GO