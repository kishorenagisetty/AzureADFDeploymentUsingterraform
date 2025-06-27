BEGIN
   IF NOT EXISTS (SELECT SS.SourceSystem FROM 
                   ELT.SourceSystemRunStatus RS
				   join ELT.SourceSystemsByProgram SS on
				   SS.SourceSystem = RS.SourceSystem
				   )
   BEGIN
   insert into  ELT.SourceSystemRunStatus 
(SourceSystem,CurrentlyRunning)

select 
SourceSystem, 
0
from 
ELT.SourceSystemsByProgram


   END
END