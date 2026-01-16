
USE NotifyDb;
GO

IF OBJECT_ID('dbo.fn_UserReminderCount', 'FN') IS NOT NULL
    DROP FUNCTION dbo.fn_UserReminderCount;
GO

CREATE FUNCTION dbo.fn_UserReminderCount (@UserId INT)
RETURNS INT
AS
BEGIN
    DECLARE @cnt INT;
    SELECT @cnt = COUNT(*) FROM dbo.Reminders WHERE UserId = @UserId;
    RETURN ISNULL(@cnt, 0);
END
GO
