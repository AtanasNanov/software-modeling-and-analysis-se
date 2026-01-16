
USE NotifyDb;
GO

IF OBJECT_ID('dbo.sp_CreatePageWithFirstNote', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_CreatePageWithFirstNote;
GO

CREATE PROCEDURE dbo.sp_CreatePageWithFirstNote
    @OwnerUserId INT,
    @PageTitle NVARCHAR(200),
    @PageDescription NVARCHAR(1000) = NULL,
    @FirstNoteContent NVARCHAR(MAX),
    @Visibility NVARCHAR(10) = 'Private'
AS
BEGIN
    SET NOCOUNT ON;

    IF @Visibility NOT IN ('Private', 'Public')
        THROW 50001, 'Invalid Visibility. Use Private/Public.', 1;

    IF LEN(LTRIM(RTRIM(@PageTitle))) = 0
        THROW 50002, 'Page title cannot be empty.', 1;

    IF LEN(LTRIM(RTRIM(@FirstNoteContent))) = 0
        THROW 50003, 'First note content cannot be empty.', 1;

    BEGIN TRAN;

    INSERT INTO dbo.Pages (OwnerUserId, Title, Description, Visibility)
    VALUES (@OwnerUserId, @PageTitle, @PageDescription, @Visibility);

    DECLARE @NewPageId INT = SCOPE_IDENTITY();

    INSERT INTO dbo.Notes (PageId, Title, Content, SortOrder)
    VALUES (@NewPageId, N'First note', @FirstNoteContent, 0);

    COMMIT;

    SELECT @NewPageId AS PageId;
END
GO
