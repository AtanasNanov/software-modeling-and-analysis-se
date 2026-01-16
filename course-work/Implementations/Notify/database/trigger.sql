
USE NotifyDb;
GO

IF OBJECT_ID('dbo.tr_Notes_TouchPageUpdatedAt', 'TR') IS NOT NULL
    DROP TRIGGER dbo.tr_Notes_TouchPageUpdatedAt;
GO

CREATE TRIGGER dbo.tr_Notes_TouchPageUpdatedAt
ON dbo.Notes
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH ChangedPages AS (
        SELECT PageId FROM inserted
        UNION
        SELECT PageId FROM deleted
    )
    UPDATE p
        SET UpdatedAt = SYSDATETIME()
    FROM dbo.Pages p
    INNER JOIN ChangedPages c ON c.PageId = p.PageId;
END
GO
