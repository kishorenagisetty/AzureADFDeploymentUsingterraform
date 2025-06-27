CREATE PROC [ELT].[InsertJsonAAS] @JSONDATA [nvarchar](max) AS 


delete from  [ELT].[ImportJsonAAS];

with		GetAllRefreshTimes as
(
select		json_value(x.value,'$.refreshId')	as [refreshId]
			,json_value(x.value,'$.startTime')	as [startTime]
			,json_value(x.value,'$.endTime')	as [endTime]
			,json_value(x.value,'$.status')		as [status]
from		(select @JSONDATA as JSONDATA) i
cross apply	openjson(replace(replace(replace(replace(replace(replace(replace(replace(JSONDATA,right(JSONDATA,charindex('{',REVERSE(JSONDATA))-1),'"refreshId": "000"}]'),'\\t','\t'),'\\r','\r'),'\\n','\n'),'\\f','\f'),'\\b','\b'),'"','"'),'\\','\')) as X
)

insert into	ELT.ImportJsonAAS
			(refreshId
			,startTime
			,endTime
			,[status]
			,[CreatedDate])
select		top 1
			refreshId	
			,startTime	
			,endTime	
			,status
			,getdate()
from		GetAllRefreshTimes
where		startTime = (select		max(startTime)
						 from		GetAllRefreshTimes)
						 
						 
/****** Object:  StoredProcedure [ELT].[SelectAASLatestTime]    Script Date: 18/04/2023 19:30:25 ******/
SET ANSI_NULLS ON