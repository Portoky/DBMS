Use ModelPractic
Go

Drop Table Comments;
Drop Table Posts;
Drop Table Likes;
Drop Table Users;
Drop Table Pages;
Drop Table Categories;

GO

Create Table Categories(
	CategoryId Int primary key identity(1,1),
	[Name] Varchar(200),
	[Description] Varchar(500)
)

Create Table Pages(
	PageId Int primary key identity(1,1),
	[Name] Varchar(200),
	CategoryId INT references Categories(CategoryId)
)

Create Table Users(
	UserId Int primary key identity(1,1),
	[Name] Varchar(200),
	City Varchar(50),
	DateOfBirth Date
)

Create Table Likes(
	UserId INT references Users(UserId),
	PageId INT references Pages(PageId),
	[Date] Date,
	Constraint PK_LikesConstraint Primary Key (UserId, PageId)
)

Create Table Posts(
	PostId Int primary key identity(1,1),
	PostDate date,
	PostText varchar(500),
	NrOfShares int,
	UserId INT references Users(UserId)
)

Create Table Comments(
	CommentId Int primary key identity(1,1),
	CommentText varchar(300),
	CommentDate date,
	TopComment bit,
	PostId INT references Posts(PostId)
)
go


Insert Into Users ([Name], City, DateOfBirth) Values('u1', 'b', '2022-02-02');
Insert Into Users  ([Name], City, DateOfBirth)  Values('u2', 'd', '2022-02-04');

Insert Into Posts (PostText,[PostDate], NrOfShares, UserId) Values ('p1', '2022-02-02', 1, 1);
Insert Into Posts (PostText,[PostDate], NrOfShares, UserId) Values ('p2', '2022-02-02',2 , 1);
Insert Into Posts (PostText,[PostDate], NrOfShares, UserId) Values ('p3', '2022-02-02', 2, 2);

select * from Users
select * from Posts