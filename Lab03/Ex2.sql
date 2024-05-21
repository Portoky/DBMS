Use Faculty_lab3
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

Create Or Alter Proc uspRollback
AS
Begin	
	DECLARE @addStudentSuccess BIT = 0;
	DECLARE @addCourseSuccess BIT = 0;
	DECLARE @addSubSuccess BIT = 0;
	DECLARE @ErrorMessage NVARCHAR(4000);
	Begin Tran
	Begin Try
		Exec uspAddStudent 3, 'teststudent', '5012657228412', 20
		Set @addStudentSuccess = 1
		Save Transaction addStudent

		Exec uspAddCourse 3, 'DBMS', 'hahain' --rollback hopefully
		Set @addCourseSuccess = 1
		Save Transaction addCourse

		Exec uspAddSubscription 3, 3, 50
		Set @addSubSuccess = 1
		Save Transaction addSub
		print 'All succeeded'
		Commit tran;
	End Try
	Begin Catch
		If @@Trancount > 0
		Begin
			If @addStudentSuccess = 0
			Begin
				Rollback Tran
			End
			Else If @addCourseSuccess = 0
			Begin
				Rollback Tran addStudent
				Commit Tran
			End
			Else If @addSubSuccess = 0
			Begin
				Rollback Tran addCourse
				Rollback Tran
			End
		End
		Return
	End Catch
End	
Go

Create Or Alter Proc uspCommit
AS
Begin	
	DECLARE @addStudentSuccess BIT = 0;
	DECLARE @addCourseSuccess BIT = 0;
	DECLARE @addSubSuccess BIT = 0;
	DECLARE @ErrorMessage NVARCHAR(4000);
	Begin Tran
	Begin Try
		Exec uspAddStudent 3, 'teststudent', '5012657228412', 20
		Set @addStudentSuccess = 1
		Save Transaction addStudent

		Exec uspAddCourse 3, 'DBMS', 'hahanoproblemnowitislongenough' --rollback hopefully
		Set @addCourseSuccess = 1
		Save Transaction addCourse

		Exec uspAddSubscription 3, 3, 50
		Set @addSubSuccess = 1
		Save Transaction addSub
		print 'All succeeded'
		Commit tran;
	End Try
	Begin Catch
		If @@Trancount > 0
		Begin
			If @addStudentSuccess = 0
			Begin
				Rollback Tran
			End
			Else If @addCourseSuccess = 0
			Begin
				Rollback Tran addStudent
				Commit Tran
			End
			Else If @addSubSuccess = 0
			Begin
				Rollback Tran addCourse
				Rollback Tran
			End
		End
		Return
	End Catch
End	


Exec uspRollback
Exec uspCommit
Delete from Student;
Delete from Course;
Delete from Subscription;
Delete from LogTable;
select * from LogTable;
select * from Student;
select * from Course;
select * from Subscription;
