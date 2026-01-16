
IF DB_ID('NotifyDb') IS NULL
BEGIN
    CREATE DATABASE NotifyDb;
END
GO

USE NotifyDb;
GO

CREATE TABLE dbo.Users (
    UserId           INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Users PRIMARY KEY,
    Email            NVARCHAR(320) NOT NULL,
    Username         NVARCHAR(50)  NOT NULL,
    PasswordHash     NVARCHAR(255) NOT NULL,
    FirstName        NVARCHAR(50)  NULL,
    LastName         NVARCHAR(50)  NULL,
    Role             NVARCHAR(10)  NOT NULL CONSTRAINT DF_Users_Role DEFAULT ('User'),
    IsActive         BIT           NOT NULL CONSTRAINT DF_Users_IsActive DEFAULT (1),
    CreatedAt        DATETIME2(0)  NOT NULL CONSTRAINT DF_Users_CreatedAt DEFAULT (SYSDATETIME()),
    LastLoginAt      DATETIME2(0)  NULL,

    CONSTRAINT UQ_Users_Email UNIQUE (Email),
    CONSTRAINT UQ_Users_Username UNIQUE (Username),
    CONSTRAINT CK_Users_Role CHECK (Role IN ('User', 'Admin'))
);
GO

CREATE TABLE dbo.Pages (
    PageId           INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Pages PRIMARY KEY,
    OwnerUserId      INT           NOT NULL,
    Title            NVARCHAR(200) NOT NULL,
    Description      NVARCHAR(1000) NULL,
    IsArchived       BIT           NOT NULL CONSTRAINT DF_Pages_IsArchived DEFAULT (0),
    Visibility       NVARCHAR(10)  NOT NULL CONSTRAINT DF_Pages_Visibility DEFAULT ('Private'),
    CreatedAt        DATETIME2(0)  NOT NULL CONSTRAINT DF_Pages_CreatedAt DEFAULT (SYSDATETIME()),
    UpdatedAt        DATETIME2(0)  NOT NULL CONSTRAINT DF_Pages_UpdatedAt DEFAULT (SYSDATETIME()),

    CONSTRAINT FK_Pages_Users_Owner FOREIGN KEY (OwnerUserId) REFERENCES dbo.Users(UserId),
    CONSTRAINT CK_Pages_Visibility CHECK (Visibility IN ('Private', 'Public'))
);
GO

CREATE TABLE dbo.Notes (
    NoteId           INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Notes PRIMARY KEY,
    PageId           INT            NOT NULL,
    Title            NVARCHAR(200)  NULL,
    Content          NVARCHAR(MAX)  NOT NULL,
    IsPinned         BIT            NOT NULL CONSTRAINT DF_Notes_IsPinned DEFAULT (0),
    SortOrder        INT            NOT NULL CONSTRAINT DF_Notes_SortOrder DEFAULT (0),
    CreatedAt        DATETIME2(0)   NOT NULL CONSTRAINT DF_Notes_CreatedAt DEFAULT (SYSDATETIME()),
    UpdatedAt        DATETIME2(0)   NOT NULL CONSTRAINT DF_Notes_UpdatedAt DEFAULT (SYSDATETIME()),

    CONSTRAINT FK_Notes_Pages FOREIGN KEY (PageId) REFERENCES dbo.Pages(PageId),
    CONSTRAINT CK_Notes_Content_NotEmpty CHECK (LEN(LTRIM(RTRIM(Content))) > 0)
);
GO

CREATE TABLE dbo.Tags (
    TagId            INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Tags PRIMARY KEY,
    OwnerUserId      INT           NOT NULL,
    Name             NVARCHAR(50)  NOT NULL,
    Color            NVARCHAR(20)  NULL,
    CreatedAt        DATETIME2(0)  NOT NULL CONSTRAINT DF_Tags_CreatedAt DEFAULT (SYSDATETIME()),

    CONSTRAINT FK_Tags_Users_Owner FOREIGN KEY (OwnerUserId) REFERENCES dbo.Users(UserId),
    CONSTRAINT UQ_Tags_Owner_Name UNIQUE (OwnerUserId, Name)
);
GO

CREATE TABLE dbo.NoteTags (
    NoteId           INT          NOT NULL,
    TagId            INT          NOT NULL,
    AddedAt          DATETIME2(0) NOT NULL CONSTRAINT DF_NoteTags_AddedAt DEFAULT (SYSDATETIME()),

    CONSTRAINT PK_NoteTags PRIMARY KEY (NoteId, TagId),
    CONSTRAINT FK_NoteTags_Notes FOREIGN KEY (NoteId) REFERENCES dbo.Notes(NoteId) ON DELETE CASCADE,
    CONSTRAINT FK_NoteTags_Tags  FOREIGN KEY (TagId)  REFERENCES dbo.Tags(TagId)  ON DELETE CASCADE
);
GO

CREATE TABLE dbo.Reminders (
    ReminderId       INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Reminders PRIMARY KEY,
    UserId           INT           NOT NULL,
    NoteId           INT           NULL,
    Title            NVARCHAR(200) NOT NULL,
    RemindAt         DATETIME2(0)  NOT NULL,
    RepeatPattern    NVARCHAR(10)  NOT NULL CONSTRAINT DF_Reminders_Repeat DEFAULT ('None'),
    IsSent           BIT           NOT NULL CONSTRAINT DF_Reminders_IsSent DEFAULT (0),
    CreatedAt        DATETIME2(0)  NOT NULL CONSTRAINT DF_Reminders_CreatedAt DEFAULT (SYSDATETIME()),

    CONSTRAINT FK_Reminders_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId),
    CONSTRAINT FK_Reminders_Notes FOREIGN KEY (NoteId) REFERENCES dbo.Notes(NoteId),
    CONSTRAINT CK_Reminders_Repeat CHECK (RepeatPattern IN ('None', 'Daily', 'Weekly', 'Monthly'))
);
GO

CREATE TABLE dbo.SharedPages (
    PageId           INT          NOT NULL,
    UserId           INT          NOT NULL,
    Permission       NVARCHAR(5)  NOT NULL CONSTRAINT DF_SharedPages_Permission DEFAULT ('Read'),
    SharedAt         DATETIME2(0) NOT NULL CONSTRAINT DF_SharedPages_SharedAt DEFAULT (SYSDATETIME()),

    CONSTRAINT PK_SharedPages PRIMARY KEY (PageId, UserId),
    CONSTRAINT FK_SharedPages_Pages FOREIGN KEY (PageId) REFERENCES dbo.Pages(PageId) ON DELETE CASCADE,
    CONSTRAINT FK_SharedPages_Users FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId) ON DELETE CASCADE,
    CONSTRAINT CK_SharedPages_Permission CHECK (Permission IN ('Read', 'Write'))
);
GO
