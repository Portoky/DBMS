USE Faculty_lab3
Go

DROP TABLE IF EXISTS LogTable 
CREATE TABLE LogTable(
	Lid INT IDENTITY PRIMARY KEY,
	TypeOperation VARCHAR(50),
	TableOperation VARCHAR(50),
	ExecutionDate DATETIME
);

Go

Create Or Alter Proc uspAddStudent( @id integer, @name varchar(50), @cnp varchar(15), @age int )
AS
BEGIN
	SET NOCOUNT ON
	If LEN(@name) < 2 OR LEN(@name) > 30
	Begin
		RAISERROR(N'Invalid name', 14, 1);
	End
	If LEN(@cnp) < 12 OR LEN(@cnp) > 16 
	Begin
		RAISERROR('Invalid cnp', 14, 1);
	End
	If Exists(Select * From Student Where StudentId = @id)
	Begin
		RAISERROR('Id already in Table', 14, 1);
	End
	Insert Into Student (StudentId, [Name], CNP, AGE) Values(@id, @name, @cnp, @age);
	INSERT INTO LogTable VALUES ('add', 'student', GETDATE())
END

Go

Create Or Alter Proc uspAddCourse( @id integer, @name varchar(50), @description varchar(15) )
AS
BEGIN
	SET NOCOUNT ON
	If LEN(@name) < 2 OR LEN(@name) > 30
	Begin
		RAISERROR(N'Invalid name', 14, 1);
	End
	If LEN(@description) < 12
	Begin
		RAISERROR('Invalid description', 14, 1);
	End
	If Exists(Select * From Course Where CourseId = @id)
	Begin
		RAISERROR('Id already in Table', 14, 1);
	End
	Insert Into Course(CourseId, [Name], [Description]) Values(@id, @name, @description);
	INSERT INTO LogTable VALUES ('add', 'course', GETDATE())
END

Go 

Create Or Alter Proc uspAddSubscription( @studentId integer, @courseId int, @price int )
AS
BEGIN
	SET NOCOUNT ON
	If @price < 0 OR @price > 10000
	Begin
		RAISERROR('Invalid price', 14, 1);
	End
	If Exists(Select * From Subscription Where StudentId = @studentId AND CourseId = @courseId)
	Begin
		RAISERROR('Id already in Table', 14, 1);
	End
	Insert Into Subscription (CourseId, StudentId, Price) Values(@courseId, @studentId, @price);
	INSERT INTO LogTable VALUES ('add', 'subscription', GETDATE())
END

GO

Create Or Alter Proc uspCommit
AS
Begin	
	Begin Tran
	Begin Try
		Exec uspAddStudent 2, 'teststudent', '5012657228412', 20
		Exec uspAddCourse 2, 'DBMS', 'really good subject fr fr'
		Exec uspAddSubscription 2, 2, 50
		Commit Tran
	End Try
	Begin Catch
		Rollback Tran
		Return
	End Catch
End

Go

Create Or Alter Proc uspRollback
AS
Begin	
	Begin Tran
	Begin Try
		Exec uspAddStudent 3, 'teststudent', '5012657228412', 20
		Exec uspAddCourse 3, 'DBMS', 'hahainvalid' --rollback hopefully
		Exec uspAddSubscription 3, 3, 50
		Commit Tran
	End Try
	Begin Catch
		Rollback Tran
		Return
	End Catch
End	

exec uspCommit
select * from Student;
select * from Course;
select * from Subscription;

exec uspRollback