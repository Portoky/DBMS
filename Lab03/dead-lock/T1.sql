Use Faculty_lab3
Go

SET TRAN ISOLATION LEVEL READ COMMITTED
Begin Tran
Update Course  --x lock taken from Course table
Set [Name] = 'updatedName2'
Where CourseId = 3;

Waitfor Delay '00:00:06'

Update Student --waiting for x lock for student table
Set [Name] = 'updatedName2'
Where StudentId = 3;
Commit Tran
Select * from Course;
Select * from Student;
