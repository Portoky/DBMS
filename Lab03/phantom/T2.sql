Use Faculty_lab3
Go



--SET TRAN ISOLATION LEVEL REPEATABLE READ
Begin Tran 
Waitfor Delay '00:00:03'
--Update Course 
--Set [Name] ='updatedcourse'
--Where CourseId=1
Insert Into Course(CourseId, [Name], [Description]) Values(5, 'testcourse55!!', 'testdescriptioncourse');
Commit Tran

--Delete From COurse Where CourseId = 5;