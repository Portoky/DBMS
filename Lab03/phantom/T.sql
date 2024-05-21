Use Faculty_lab3
Go

--Solution
SET TRAN ISOLATION LEVEL SERIALIZABLE

Begin Tran 
Select * From Course
WaitFor Delay '00:00:06'
Select * From Course
Commit tran
