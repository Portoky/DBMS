Use Faculty_lab3
Go

--Solution 
--SET TRAN ISOLATION LEVEL REPEATABLE READ

Insert Into Course(CourseId, [Name], [Description]) Values(1, 'testcourse!!', 'testdescriptioncourse');
Begin Tran 
Waitfor Delay '00:00:03'
Update Course 
Set [Name] ='updatedcourse'
Where CourseId=1
Commit Tran


--run until this
delete from Course where CourseId = 1;