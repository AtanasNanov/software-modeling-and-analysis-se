
USE NotifyDb;
GO

INSERT INTO dbo.Users (Email, Username, PasswordHash, FirstName, LastName, Role)
VALUES
(N'atanas@example.com', N'atanas', N'hash1', N'Atanas', N'Nanov', N'Admin'),
(N'maria@example.com',  N'maria',  N'hash2', N'Maria',  N'Ivanova', N'User'),
(N'georgi@example.com', N'georgi', N'hash3', N'Georgi', N'Petrov', N'User');
GO

INSERT INTO dbo.Pages (OwnerUserId, Title, Description, Visibility)
VALUES
(1, N'Uni Projects', N'Notes for university tasks', 'Private'),
(2, N'Work',        N'Work notes and tasks',       'Private');
GO

INSERT INTO dbo.Notes (PageId, Title, Content, IsPinned, SortOrder)
VALUES
(1, N'First note', N'TODO: finish database diagrams', 0, 0),
(1, N'DW ideas',   N'Fact: Notes, Fact: Reminders, Fact: Sharing...', 1, 1),
(2, N'Client',     N'Call client on Thursday.', 0, 0);
GO

INSERT INTO dbo.Tags (OwnerUserId, Name, Color)
VALUES
(1, N'uni',    N'blue'),
(1, N'urgent', N'red'),
(2, N'work',   N'green');
GO

INSERT INTO dbo.NoteTags (NoteId, TagId)
VALUES
(1, 1), -- First note tagged uni
(1, 2), -- and urgent
(2, 1); -- DW ideas tagged uni
GO

INSERT INTO dbo.Reminders (UserId, NoteId, Title, RemindAt, RepeatPattern)
VALUES
(1, 1, N'Submit coursework',     DATEADD(day, 3, SYSDATETIME()), 'None'),
(2, 3, N'Client call reminder',  DATEADD(day, 2, SYSDATETIME()), 'None');
GO

INSERT INTO dbo.SharedPages (PageId, UserId, Permission)
VALUES
(1, 2, 'Read'),
(1, 3, 'Write');
GO
