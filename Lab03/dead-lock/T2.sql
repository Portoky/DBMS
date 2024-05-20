Use Faculty_lab3
Go
--Solution
--SET DEADLOCK_PRIORITY HIGH
SET TRAN ISOLATION LEVEL READ COMMITTED
Begin Tran
Update Student --waiting for x lock for student table
Set [Name] = 'updatedName2'
Where StudentId = 3;

Waitfor Delay '00:00:06'

Update Course  --x lock taken from Course table
Set [Name] = 'updatedName2'
Where CourseId = 3;
Commit Tran
