Use Faculty_lab3
Go
SET TRAN ISOLATION LEVEL SNAPSHOT
BEGIN TRAN
UPDATE Course SET Description = 'Problem occured' WHERE CourseId = 6
WAITFOR DELAY '00:00:05'
COMMIT TRAN