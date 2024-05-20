Use Faculty_lab3
Go
Begin Tran
UPDATE Student
SET Name = 'TestDirtyRead'
WHERE StudentId = 3
WAITFOR DELAY '00:00:06'
ROLLBACK TRAN
