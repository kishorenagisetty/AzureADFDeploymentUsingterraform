CREATE PROC [ELT].[adf_iconi_document_processing] @adf_process_id [varchar](500),@is_rerun [int],@re_run_id [varchar](100) AS

--If this is not a re-run then find last date and insert details
if @is_rerun = 0
begin

	declare @last_complete_date datetime, @current_run_end_date datetime

	set @current_run_end_date = getdate()

	select
		@last_complete_date = coalesce(max(document_end_date), '01-Jan-2020 00:00:00')
	from
		[elt].[iconi_document_manager];


	insert into
		[elt].[iconi_document_manager]
	values
		(@adf_process_id, @last_complete_date, @current_run_end_date, -1);

	select
		*
	from
		[elt].[iconi_document_manager]
	where
		adf_process_key = @adf_process_id;
end
--however, if it is a re-run just return details of existing event
else
begin
	select
		*
	from
		[elt].[iconi_document_manager]
	where
		adf_process_key = @re_run_id;
end