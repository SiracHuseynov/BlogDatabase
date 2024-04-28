Create Database BlogDB

use BlogDB

Create Table Categories(
Id int primary key identity,
Name nvarchar(50) not null unique
)

Create Table Tags(
Id int primary key identity,
Name nvarchar(50) not null unique
)

Create Table Users(
Id int primary key identity,
UserName nvarchar(50) not null unique,
FullName nvarchar(50) not null,
Age int
Check(Age > 0 and Age < 150)
)

Create Table Blogs(
Id int primary key identity,
Title nvarchar(50) not null,
Description nvarchar(250) not null,
UsersID int foreign key references Users(Id),
CategoriesID int foreign key references Categories(Id)
)

Create Table Comments(
Id int primary key identity,
Content nvarchar(250) not null,
UsersID int foreign key references Users(Id),
BlogsID int foreign key references Blogs(Id)
)

Create Table Blogs_Tags(
Id int primary key identity,
BlogsID int foreign key references Blogs(Id),
TagsID int foreign key references Tags(Id)
)

Insert into Categories (Name) Values 
('Fashion'),
('Food'),
('Music'),
('Science'),
('Sports'),
('Technology'),
('Travel')

Select * from Categories

Insert into Tags (Name) Values 
('Biology'),
('Cooking'),
('Fashion'),
('Football'),
('Photography'),
('Programming'),
('Rock')

Select * from Tags

Insert into Users (UserName, FullName, Age) Values 
('user1', 'John Doe', 30),
('user2', 'Jane Smith', 25),
('user3', 'Michael Johnson', 40),
('user4', 'Emily Brown', 28),
('user5', 'David Wilson', 35)

Select * from Users

Insert into Blogs (Title, Description, UsersID, CategoriesID) Values 
('Introduction to Python Programming', 'Learn the basics of Python programming language.', 1, 1),
('Travel Guide: Exploring Europe', 'Discover the best destinations in Europe for your next trip.', 2, 2),
('Delicious Pasta Recipes', 'Explore a variety of pasta recipes for your next meal.', 4, 3),
('Fashion Trends 2024', 'Stay updated with the latest fashion trends for this year.', 3, 4),
('Best Rock Albums of All Time', 'Discover the greatest rock albums that every music enthusiast must listen to.', 5, 5);

Select * from Blogs

Insert into Comments (Content, UsersID, BlogsID) Values 
('Great tutorial!', 2, 1),
('I love traveling in Europe!', 4, 2),
('These recipes look delicious.', 1, 3),
('Interesting article about fashion.', 3, 4),
('Rock music is timeless!', 5, 5)

Select * from Comments

Insert into Blogs_Tags (BlogsID, TagsID) Values 
(1, 1),
(1, 2),
(3, 3),
(4, 4),
(5, 5)

Select * from Blogs_Tags

Create View VW_GetTitleandUserNameandFullName
as
Select Blogs.Title as 'Blog title', Users.UserName as 'Username', Users.FullName as 'FullName' from Blogs
Join Users
ON Users.Id = Blogs.UsersID

Select * from VW_GetTitleandUserNameandFullName

Create View VW_GetTitleAndName
as
Select Blogs.Title as 'Blog title', Categories.Name as 'Category Name' from Blogs
Join Categories
on Categories.Id = Blogs.CategoriesID

Select * from VW_GetTitleandName


Create Procedure SP_GetComments @userId int
as
Select * from Comments
where Comments.UsersID = @userId

Exec SP_GetComments 2

Create Procedure SP_GetBlogs @userId int
as
Select * from Blogs
where Blogs.UsersID = @userId 

Exec SP_GetBlogs 1



Create Function UFN_GetBlogsCount(@categoryId int)
Returns int
Begin
	Declare @TotalCount Int;

	Select @TotalCount = Count(Blogs.Id) from Blogs
	where Blogs.CategoriesID = @categoryId
	
	return @TotalCount
End

Select dbo.UFN_GetBlogsCount(1)

Create Function UFN_GetUserBlogs(@userId int) 
Returns Table as
	return (Select * from Blogs
	where Blogs.UsersID = @userId)

Select * from UFN_GetUserBlogs(3)

Alter Table Blogs
Add IsDeleted Bit not null default 0

Create Trigger TRGR_AfterDelete 
on Blogs
Instead Of Delete
as
Begin
	Declare @id int;
	Select @id = Id from deleted;
	Update Blogs Set isDeleted=1
	where Id = @Id
End

Delete From Blogs
where Blogs.Id=1

Select * from Blogs


