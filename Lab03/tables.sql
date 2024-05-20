USE Faculty_lab3
Go

drop Table Subscription
drop Table Student
drop Table Course

Go

Create Table Course (
	CourseId int not null primary key,
	[Name] varchar(50),
	[Description] varchar(100)
)

Create Table Student (
	StudentId int not null primary key,
	[Name] varchar(50),
	CNP varchar(50),
	Age int
)

Create Table Subscription(
	CourseId int references Course(CourseId),
	StudentId int references Student(StudentId),
	Price int,
	constraint PK_Subsription Primary Key (CourseId, StudentId)	
)

