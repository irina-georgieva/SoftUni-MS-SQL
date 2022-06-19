-- 01 One-To-One Relationship

CREATE DATABASE [EntityRelationsDemo2022]

USE [EntityRelationsDemo2022]

CREATE TABLE [Passports](
	[PassportID] INT PRIMARY KEY IDENTITY (101, 1),
	[PassportNumber] VARCHAR(10) NOT NULL
)

CREATE TABLE [Persons](
	[PersonID] INT PRIMARY KEY IDENTITY,
	[FirstName] NVARCHAR(30) NOT NULL,
	[Salary] DECIMAL (8,2) NOT NULL,
	[PassportID] INT FOREIGN KEY REFERENCES [Passports]([PassportID]) UNIQUE NOT NULL
)

INSERT INTO [Passports]([PassportNumber])
	VALUES ('N34FG21B'), ('K65LO4R7'), ('ZE657QP2')

INSERT INTO [Persons] ([FirstName], [Salary], [PassportID])
	VALUES
		('Roberto', 43300.00, 102),
		('Tom', 56100.00, 103),
		('Yana', 60200.00, 101)

-- 02 One-To-Many Relationship

CREATE TABLE [Manufacturers](
	[ManufacturerID] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(30) NOT NULL,
	[EstablishedOn] DATE NOT NULL
)

CREATE TABLE [Models](
	[ModelID] INT PRIMARY KEY IDENTITY (101,1),
	[Name] VARCHAR(35) NOT NULL,
	[ManufacturerID] INT FOREIGN KEY REFERENCES [Manufacturers] ([ManufacturerID]) NOT NULL
)

INSERT INTO [Manufacturers]([Name], [EstablishedOn])
	VALUES
		('BMW', '07/03/1916'),
		('Tesla', '01/01/2003'),
		('Lada', '01/05/1966')

INSERT INTO [Models]([Name], [ManufacturerID])
	VALUES
		('X1', 1),
		('i6', 1),
		('Model S', 2),
		('Model X', 2),
		('Model 3', 2),
		('Nova', 3)

SELECT *
	FROM [Models]

SELECT *
	FROM [Manufacturers]

-- 03 Many-To-Many Relationship

CREATE TABLE [Students](
	[StudentID] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE [Exams](
	[ExamID] INT PRIMARY KEY IDENTITY (101,1),
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE [StudentsExams](
	[StudentID] INT FOREIGN KEY REFERENCES [Students] ([StudentID]),
	[ExamID] INT FOREIGN KEY REFERENCES [Exams] (ExamId),
	PRIMARY KEY ([StudentID], [ExamID])
)

INSERT INTO [Students] ([Name])
	VALUES
	('Mila'),
	('Toni'),
	('Ron')

INSERT INTO [Exams]([Name])
	VALUES
	('SpringMVC'),
	('Neo4j'),
	('Oracle 11g')

-- 04 Self-Referencing

CREATE TABLE [Teachers](
	[TeacherID] INT PRIMARY KEY IDENTITY (101,1),
	[Name] NVARCHAR(50) NOT NULL,
	[ManagerID] INT FOREIGN KEY REFERENCES [Teachers]([TeacherID])
)

INSERT INTO [Teachers]([Name], [ManagerID])
	VALUES
	('John', NULL),
	('Maya', 106),
	('Silvia', 106),
	('Ted', 105),
	('Mark', 101),
	('Greta', 101)

-- 05 Online Store Database

CREATE DATABASE [Online Store]

CREATE TABLE [Cities](
	[CityID] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR (50) NOT NULL
)

CREATE TABLE [Customers](
	[CustomerID] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR (50) NOT NULL,
	[Birthdate] DATE,
	[CityID] INT FOREIGN KEY REFERENCES [Cities] ([CityID])
)

CREATE TABLE [Orders](
	[OrderID] INT PRIMARY KEY IDENTITY,
	[CustomerID] INT FOREIGN KEY REFERENCES [Customers] ([CustomerID])
)

CREATE TABLE [ItemTypes](
	[ItemTypeID] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR (50) NOT NULL
)

CREATE TABLE [Items](
	[ItemID] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR (50) NOT NULL,
	[ItemTypeID] INT FOREIGN KEY REFERENCES [ItemTypes] ([ItemTypeID])
)

CREATE TABLE [OrderItems](
	[OrderID] INT FOREIGN KEY REFERENCES [Orders] ([OrderID]),
	[ItemID] INT FOREIGN KEY REFERENCES [Items] ([ItemID]),
	PRIMARY KEY ([OrderID], [ItemID])
)

-- 06 University Database

CREATE DATABASE [University]

CREATE TABLE [Majors](
	[MajorID] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(70) NOT NULL
)

CREATE TABLE [Students](
	[StudentID] INT PRIMARY KEY IDENTITY,
	[StudentNumber] VARCHAR(15) NOT NULL,
	[StudentName] NVARCHAR(70) NOT NULL,
	[MajorID] INT FOREIGN KEY REFERENCES [Majors] ([MajorID])
)

CREATE TABLE [Payments](
	[PaymentID] INT PRIMARY KEY IDENTITY,
	[PaymentDate] DATETIME2,
	[PaymentAmount] DECIMAL (8,2) NOT NULL,
	[StudentID] INT FOREIGN KEY REFERENCES [Students] ([StudentID]) NOT NULL
)

CREATE TABLE [Subjects](
	[SubjectID] INT PRIMARY KEY IDENTITY,
	[SubjectName] NVARCHAR (70) NOT NULL
)

CREATE TABLE [Agenda](
	[StudentID] INT FOREIGN KEY REFERENCES [Students] ([StudentID]),
	[SubjectID] INT FOREIGN KEY REFERENCES [Subjects] ([SubjectID]),
	PRIMARY KEY ([StudentID], [SubjectID])
)

-- 09 *Peaks in Rila

USE [Geography]

SELECT [m].[MountainRange], [p].[PeakName], [p].[Elevation]
	FROM [Mountains] AS [m]
	LEFT JOIN [Peaks] AS [p]
	ON [p].[MountainId] = [m].[Id]
	WHERE [MountainRange] =	'Rila'
	ORDER BY [p].[Elevation] DESC
