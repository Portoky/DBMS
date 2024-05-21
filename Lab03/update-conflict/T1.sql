Use Faculty_lab3
Go
--INSERT INTO Course (CourseId, Name, Description) VALUES (6, 'Mathematics', 'Basic Math Course');
--Delete From Course Where CourseId=6
-- update conflict
ALTER DATABASE Faculty_lab3 SET ALLOW_SNAPSHOT_ISOLATION ON --OFF
SET TRAN ISOLATION LEVEL SNAPSHOT
BEGIN TRAN

WAITFOR DELAY '00:00:02'

-- T1 has now updated and obtained a lock on this table
-- trying to update the same row will result in a error (process is blocked)
UPDATE Course SET Description='update conflict hoperfully ' where CourseId= 6
COMMIT TRAN

Select * From Course