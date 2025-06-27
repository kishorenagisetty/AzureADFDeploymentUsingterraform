CREATE PROC [ELT].[sp_Alert] @AlertName [VARCHAR](2000),@Mode [VARCHAR](10) AS
    BEGIN

        SET NOCOUNT ON;
 
        BEGIN TRY   

            DECLARE @PipelineName NVARCHAR(1000) = 'Alerting';
			DECLARE @Datetime datetime
			DECLARE @Msg varchar(2000)
			DECLARE @RunID INT = CAST(COALESCE((select MAX(RunID) from ELT.CTL_Load),0) + row_number() over (order by getdate()) as INT);

            DECLARE @running BIGINT;
            SELECT  @running = ( SELECT COUNT(*)
                                 FROM   [ELT].[CTL_Load]
                                 WHERE  [StartTime] = ( SELECT  MAX([StartTime]) AS [StartTime]
                                                    FROM    [ELT].[CTL_Load]
                                                    WHERE   PipelineName = @PipelineName
                                                  )
                                        AND StartTime > DATEADD(hh, -2, GETDATE())
                                        AND [Status] = 'Running'
                               );
							   -- compare logic here to sp_dq -- slightly different --which is correct?
			
            IF @running = 0
                BEGIN

                    DECLARE @LastLoadDate DATETIME = '01-JAN-1980';
                    --DECLARE @RunID INT;
                    DECLARE @CurrentLoadDate DATETIME = CAST(GETDATE() AS DATE);
					DECLARE @StartTime DATETIME = GETDATE();

--Get last successful load date
                    SELECT TOP 1
                            @LastLoadDate = LoadDate
                    FROM    [ELT].CTL_Load
                    WHERE   [Status] = 'Success'
                    ORDER BY RunID DESC;

					INSERT INTO [ELT].CTL_Load
							( [RunID] ,
							  [StartTime] ,
							  [EndTime] ,
							  [DurationSeconds] ,
							  [LoadDate] ,
							  [Status],
							  [PipelineRunID],
							  [PipelineName]
							)
					VALUES  ( @RunID			, 
							  @StartTime		, -- Start - datetime
							  NULL				, -- End - datetime
							  NULL				, -- DurationSeconds - int
							  @CurrentLoadDate	, -- LoadDate - date
							  'Running'			,  -- Status - varchar(10)
							  NULL				, -- Pipeline RunID N/A
							  @PipelineName	
							)
				
                    DECLARE @rowcount INT;
                    DECLARE @DN NVARCHAR(1000);

                    DECLARE @ID INT;

                    DECLARE @DQV VARCHAR(500);
                    DECLARE @DqExceptionID INT;
                    DECLARE @ParmDefinition NVARCHAR(500);

                    DECLARE @email_body VARCHAR(MAX);

                    DECLARE @DQAlertID INT ,
						@DQAlertStatusID INT ,
						@EmailImportance CHAR(10),
                        @EmailNotificationonFailure CHAR(1) ,
                        @EmailFailureMessage VARCHAR(2000) ,
                        @EmailNotificationonSuccess CHAR(1) ,
                        @EmailNotificationonFailureOK CHAR(1) ,
                        @EmailFailureOKMessage VARCHAR(2000) ,
                        @EmailSuccessMessage VARCHAR(2000) ,
						@EmailSubject VARCHAR(2000) ,
                        @RecipientsView VARCHAR(2000) ,
						@CcRecipientsView VARCHAR(2000) ,
						@BccRecipientsView VARCHAR(2000) ,
                        @RecipientsList VARCHAR(MAX) ,
						@CcRecipientsList VARCHAR(MAX) ,
						@BccRecipientsList VARCHAR(MAX) ,
                        @AlertView VARCHAR(2000);

                    DECLARE @DqAlert_Flag NVARCHAR(1000);

                    DECLARE @DqAlertStatus CHAR(20);

                    SELECT  @DQAlertID = DqAlertID ,
							@EmailImportance = [Importance],
                            @EmailNotificationonFailure = [EmailNotificationonFailure] ,
                            @EmailFailureMessage = [EmailFailureMessage] ,
                            @EmailNotificationonFailureOK = [EmailNotificationonFailureOK] ,
                            @EmailFailureOKMessage = [EmailFailureOKMessage] ,
                            @EmailNotificationonSuccess = [EmailNotificationonSuccess] ,
                            @EmailSuccessMessage = [EmailSuccessMessage] ,
							@EmailSubject = [EmailSubject] ,
                            @RecipientsView = [RecipientsView] ,
							@CcRecipientsView = [CcRecipientsView] ,
							@BccRecipientsView = [BccRecipientsView] ,
                            @AlertView = [AlertView]
                    FROM    [ELT].[DQ_Alert]
                    WHERE   AlertName = @AlertName; 

					IF @Mode = 'Test'
						BEGIN

							SET @RecipientsView = 'V_TEST'

						END ;

							SET @Msg = 'Running Alert Check ' + @AlertName;
							SET @Datetime = GETDATE();

						INSERT  INTO [ELT].[CTL_MsgLog]
								( [RunID] ,
								  [ActivityName] ,
								  [DateTime] ,
								  [Msg] ,
								  [Type] 
								)
						VALUES  ( @RunID ,
								  @PipelineName ,
								  @Datetime ,
								  @Msg ,
								  'I'
								);

	-- Drop temp table

		  --  SET @DqAlert_Flag = 0
                   

                    SET @DN = N' SELECT @DqAlert_Flag =  (select * from ELT. '
                        + @AlertView + '); '; 


                    SET @ParmDefinition = N'@DqAlert_Flag NVARCHAR(1000) OUTPUT';

                    EXECUTE sp_executesql @DN, @ParmDefinition,
                        @DqAlert_Flag = @DqAlert_Flag OUTPUT;
						
						
                    SET @DN = N' SELECT @RecipientsList =  (select * from ELT. '
                        + @RecipientsView + '); '; 


                    SET @ParmDefinition = N'@RecipientsList VARCHAR(MAX) OUTPUT';

					EXECUTE sp_executesql @DN, @ParmDefinition,
                        @RecipientsList = @RecipientsList OUTPUT;

                    IF @CcRecipientsView IS NOT NULL
						BEGIN
							SET @DN = N' SELECT @CcRecipientsList =  (select * from ELT. '
							+ @CcRecipientsView + '); '; 

							SET @ParmDefinition = N'@CcRecipientsList VARCHAR(MAX) OUTPUT';

							EXECUTE sp_executesql @DN, @ParmDefinition,
							@CcRecipientsList = @CcRecipientsList OUTPUT;

						END

					IF @BccRecipientsView IS NOT NULL
						BEGIN
							SET @DN = N' SELECT @BccRecipientsList =  (select * from ELT. '
								+ @BccRecipientsView + '); '; 

		                    SET @ParmDefinition = N'@BccRecipientsList VARCHAR(MAX) OUTPUT';

							EXECUTE sp_executesql @DN, @ParmDefinition,
							@BccRecipientsList = @BccRecipientsList OUTPUT;
						END

                    SELECT  @DqAlertStatus = AlertStatus
							,@DqAlertStatusID = DQAlertStatusID
                    FROM    ELT.[DQ_Alert_Status]
                    WHERE   DqAlertID = @DQAlertID
                            AND AlertDate = DATEADD(dd,
                                                    DATEDIFF(dd, 0, GETDATE()),
                                                    0);
 
                    IF @DqAlert_Flag = 1
                        AND ISNULL(@EmailNotificationonFailure, 'N/A') = 'Y'-- Check and Send Alert
                        BEGIN
							
                            IF ISNULL(@DqAlertStatus, 'N/A') <> 'Failure' -- Sent
                                BEGIN -- Send an alert and add records

									SET @DqAlertStatus = 'Failure';
							
                                    SET @email_body = '<font color=''red'' face=''arial''><i> '
                                        + @EmailFailureMessage
                                        + '<br> <br> Regards BI Team <br /> </i></font><hr />';

									-- INSERT this information into a table for logic app to pick up
									SET @Datetime = GETDATE();

									
                                    INSERT  INTO [ELT].[DQ_Alert_Status]
                                            ( [DqAlertID] ,
                                              [AlertDate] ,
                                              [AlertStatus] ,
                                              [EmailNotificationonFailureSentDateTime] 
										    )
                                    VALUES  ( @DQAlertID ,
                                              @CurrentLoadDate ,
                                              @DqAlertStatus ,
                                              NULL --GETDATE()
                                            );

									SELECT @DQAlertStatusID = DqAlertStatusID
									FROM [ELT].[DQ_Alert_Status]
									WHERE DqAlertID = @DQAlertID
									AND [AlertStatus] = @DqAlertStatus
									AND [AlertDate] = @CurrentLoadDate;

									INSERT INTO ELT.CTL_Email_Log
									(
									  [Type]
									, [DQAlertID]
									, [DQAlertStatusID]
									, [Recipients]
									, [CcRecipients]
									, [BccRecipients]
									, [Subject]
									, [Body]
									, [Importance]
									, [RequestCreatedOn]
									, [EmailSentOn]
									, [IsProcessed]
									)
									VALUES
									(
									@DqAlertStatus ,
									@DQAlertID ,
									@DQAlertStatusID,
									@RecipientsList,
									@CcRecipientsList,
									@BccRecipientsList,
								    @EmailSubject,
									@email_body,
									@EmailImportance,
									@DateTime ,	-- Request Created Datetime
									NULL,		-- Emailed Sent Datetime
									'N'			--Processed
									)

									SET @Msg = 'Alert Notification Request Created for ' + @AlertName;
									SET @DateTime = GETDATE();

                                    INSERT  INTO [ELT].[CTL_MsgLog]
                                            ( [RunID] ,
                                              [ActivityName] ,
											  [Datetime] ,
                                              [Msg] ,
                                              [Type] 
										    )
                                    VALUES  ( @RunID ,
                                              @PipelineName ,
											  @DateTime ,
                                              @Msg ,
                                              'C'
										    );

									-- Set Status to Sent

                                END;
								
								 
                        END;

                    IF ISNULL(@DqAlertStatus, 'N/A') = 'Failure'
                        AND @DqAlert_Flag = 0
																	 -- We sent a message, but the alert is now ok, so set it to 
																	 -- C - Complete and send out a message to say complete if required
                        BEGIN
							 

                            IF ISNULL(@EmailNotificationonFailureOK, 'N/A') = 'Y'
                                BEGIN

									  SET @email_body = '<font color=''green'' face=''arial''><i> '
                                        + @EmailFailureOKMessage
                                        + '<br> <br> Regards BI Team <br /> </i></font><hr />';

									  SET @DqAlertStatus = 'Complete'

									-- INSERT this information into a table for logic app to pick up
									SET @Datetime = GETDATE();

									INSERT INTO ELT.CTL_Email_Log
									(
									  [Type]
									, [DQAlertID]
									, [DQAlertStatusID]
									, [Recipients]
									, [CcRecipients]
									, [BccRecipients]
									, [Subject]
									, [Body]
									, [Importance]
									, [RequestCreatedOn]
									, [EmailSentOn]
									, [IsProcessed]
									)
									VALUES
									(
									@DqAlertStatus ,
									@DQAlertID ,
									@DQAlertStatusID,
									@RecipientsList,
									@CcRecipientsList,
									@BccRecipientsList,
								    @EmailSubject,
									@email_body,
									@EmailImportance,
									@DateTime ,	-- Request Created Datetime
									NULL,		-- Emailed Sent Datetime
									'N'			--Processed
									)

									SET @Msg = 'Failure Resolved Alert Notification Request Created for '  + @AlertName;
									SET @Datetime = GETDATE();

                                    INSERT  INTO [ELT].[CTL_MsgLog]
                                            ( [RunID] ,
                                              [ActivityName] ,
											  [DateTime] ,
                                              [Msg] ,
                                              [Type] 
												
                                            )
                                    VALUES  ( @RunID ,
                                              @PipelineName ,
											  @DateTime ,
                                              @Msg ,
                                              'C'
												
                                            );
                                END;


								UPDATE  [ELT].[DQ_Alert_Status]
								SET     [AlertStatus] = @DqAlertStatus ,
										EmailNotificationonSuccessSentDateTime = NULL --GETDATE()
								WHERE   DqAlertID = @DQAlertID
										AND AlertDate = @CurrentLoadDate; 
								
                         
                        END;
						
						-- Send out IF ok

                    IF @DqAlert_Flag = 0
                        AND ISNULL(@DqAlertStatus, 'N/A') <> 'Complete'
                        BEGIN	

                            IF ISNULL(@DqAlertStatus, 'N/A') = 'N/A'
                                BEGIN 

									SET @DqAlertStatus = 'Complete';

                                    INSERT  INTO [ELT].[DQ_Alert_Status]
                                            ( [DqAlertID] ,
                                              [AlertDate] ,
                                              [AlertStatus] ,
                                              [EmailNotificationonSuccessSentDateTime] 
												
                                            )
                                    VALUES  ( @DQAlertID ,
                                              @CurrentLoadDate ,
                                              @DqAlertStatus ,
                                              NULL
                                            );
									
									SELECT @DQAlertStatusID = DqAlertStatusID
									FROM [ELT].[DQ_Alert_Status]
									WHERE DqAlertID = @DQAlertID
									AND [AlertStatus] = @DqAlertStatus
									AND [AlertDate] = @CurrentLoadDate;

                                END; 

                            IF ISNULL(@EmailNotificationonSuccess, 'N/A') = 'Y'-- Check and Send Alert
                                BEGIN
                                    
									SET @DqAlertStatus = 'Complete';

                                    SET @email_body = '<font color=''green'' face=''arial''><i> '
                                        + @EmailSuccessMessage
                                        + '<br> <br> Regards BI Team <br /> </i></font><hr />';



                                    -- INSERT this information into a table for logic app to pick up
									SET @Datetime = GETDATE();

									INSERT INTO ELT.CTL_Email_Log
									( [Type]
									, [DQAlertID]
									, [DQAlertStatusID]
									, [Recipients]
									, [CcRecipients]
									, [BccRecipients]
									, [Subject]
									, [Body]
									, [Importance]
									, [RequestCreatedOn]
									, [EmailSentOn]
									, [IsProcessed]
									)
									VALUES
									(
									@DqAlertStatus ,
									@DQAlertID ,
									@DQAlertStatusID,
									@RecipientsList,
									@CcRecipientsList,
									@BccRecipientsList,
								    @EmailSubject,
									@email_body,
									@EmailImportance,
									@DateTime ,	-- Request Created Datetime
									NULL,		-- Emailed Sent Datetime
									'N'			--Processed
									)

									SET @Msg = 'Alert Notification Success Request Created :'+ @EmailSuccessMessage + @AlertName;
									SET @DateTime = GETDATE();

                                    INSERT  INTO [ELT].[CTL_MsgLog]
                                            ( [RunID] ,
                                              [ActivityName] ,
											  [DateTime],
                                              [Msg] ,
                                              [Type] 
												
										    )
                                    VALUES  ( @RunID ,
                                              @PipelineName ,
											  @DateTime,
                                              @Msg ,
                                              'C'
												
										    );
						
                                    UPDATE  [ELT].[DQ_Alert_Status]
                                    SET     [AlertStatus] = @DqAlertStatus -- Finished
                                    WHERE   DqAlertID = @DQAlertID
                                            AND AlertDate = @CurrentLoadDate; 

                                END;


                        END;
						
						SET @Msg = 'Completed Alert Check ' + @AlertName;
						SET @DateTime = GETDATE();
												

						UPDATE  [ELT].CTL_Load
						SET     [EndTime] = GETDATE() ,
								[Status] = 'Success' ,
								DurationSeconds = DATEDIFF(SS, StartTime, GETDATE())
						WHERE   [RunID] = @RunID;

						INSERT  INTO [ELT].[CTL_MsgLog]
								( [RunID] ,
								  [ActivityName] ,
								  [DateTime] ,
								  [Msg] ,
								  [Type] 
								 )
						VALUES  ( @RunID ,
								  @PipelineName ,
								  @DateTime ,
								  @Msg ,
								  'C'
								);

                END;

	   --close FirstCursor 
	   --DEALLOCATE FirstCursor 

        END TRY 
 
        BEGIN CATCH  

		SET @Datetime = GETDATE();
		SET @Msg = 'Error ' + ERROR_MESSAGE();

		UPDATE [ELT].CTL_Load SET [EndTime] = GETDATE() , [Status] = 'Failed', DurationSeconds=DATEDIFF(SS, StartTime, GETDATE())  WHERE [RunID] = @RunID;

            INSERT  INTO [ELT].[CTL_MsgLog]
                    ( [RunID] ,
                      [ActivityName] ,
					  [DateTime],
                      [Msg] ,
                      [Type] 
				    )
            VALUES  ( @RunID ,
                      @PipelineName ,
					  @DateTime ,
                      @Msg ,
                      'E'
                    );

            THROW;
	
    
        END CATCH;  

    END;