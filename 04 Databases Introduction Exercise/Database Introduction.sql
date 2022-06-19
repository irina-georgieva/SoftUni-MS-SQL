-- 01 Create Database
CREATE DATABASE[Minions]

-- 02 Create Tables
USE [Minions]

CREATE TABLE [Minions](
	[Id] INT PRIMARY KEY,
	[Name] NVARCHAR(50) NOT NULL,
	[Age] TINYINT NOT NULL
)

CREATE TABLE [Towns](
	[Id] INT PRIMARY KEY,
	[Name] NVARCHAR(70) NOT NULL,
)

-- 03 Alter Minions Table
ALTER TABLE [Minions]
ADD [TownId] INT FOREIGN KEY REFERENCES [Towns]([Id]) NOT NULL

-- 04 Insert Records in Both Tables
GO

INSERT INTO [Towns]([Id], [Name])
	VALUES
	(1, 'Sofia'),
	(2, 'Plovdiv'),
	(3, 'Varna')

INSERT INTO [Minions]([Id], [Name], [Age], [TownId])
	VALUES
	(1, 'Kevin', 22, 1),
	(2, 'Bob', 15, 3),
	(3, 'Steward', NULL, 2)

GO

SELECT *
	FROM [Towns]
SELECT * 
	FROM [Minions]

SELECT	[Name], [Age]
	FROM [Minions]

GO

-- 05 Truncate Table Minions

TRUNCATE TABLE [Minions]

GO

CREATE TABLE [People] (
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(200) NOT NULL,
	[Picture] VARBINARY(MAX),
	CHECK (DATALENGTH([Picture]) <= 2000000),
	[Height] DECIMAL(3,2),
	[Weight] DECIMAL(5,2),
	[Gender] CHAR(1) NOT NULL,
	CHECK ([Gender] = 'm' OR [Gender] = 'f'),
	[Birthdate] DATE NOT NULL,
	[Biography] NVARCHAR(MAX)
)

INSERT INTO [People] ([Name], [Height], [Weight], [Gender], [Birthdate])
	VALUES
	('Pesho', 1.77, 75.2, 'm', '1998-05-25'),
	('Gosho', NULL, NULL, 'm', '1977-11-05'),
	('Maria', 1.65, 42.2, 'f', '1998-06-27'),
	('Viki', NULL, NULL, 'f', '1986-02-02'),
	('Vancho', 1.69, 77.8, 'm', '1999-03-03')

SELECT * FROM [People]

-- DEFAULT
ALTER TABLE [People]
ADD CONSTRAINT DF_DefaultBiography DEFAULT ('No biography provided') FOR [Biography]

-- 08 Create Table Users
USE [Minions]

CREATE TABLE [Users](
	[Id] INT PRIMARY KEY IDENTITY,
	[Username] VARCHAR(30) NOT NULL,
	[Password] VARCHAR(26) NOT NULL,
	[ProfilePicture] VARBINARY(MAX),
	CHECK (DATALENGTH([ProfilePicture]) <= 900),
	[LastLoginTime] TIMESTAMP,
	[IsDeleted] CHAR(5),
	CHECK ([IsDeleted] = 'true' OR [IsDeleted] = 'false'),
)

INSERT INTO [Users] ([Username], [Password], [IsDeleted])
	VALUES
	('batMisho', 'walkingDead', 'false'),
	('batRusio', 'batman', 'true'),
	('batRadi', 'cukamQko', 'false'),
	('batIvo', 'obichamBira', 'true'),
	('batLucho', 'kOlElO', 'false')

SELECT * FROM [Users]

-- 09 Change Primary Key

ALTER TABLE [Users]
-- get the index name of the primary key to get it work
	DROP CONSTRAINT PK__Users__3214EC0722BDFFBB;
ALTER TABLE [Users]
	ADD CONSTRAINT PK_users
	PRIMARY KEY (id, username)

-- 10 Add Check Constraint

ALTER TABLE [Users]
ADD CONSTRAINT CK_Password_Length CHECK(LEN([Password]) >=5)

-- 11 Set Default Value of a Field
ALTER TABLE [Users]
ADD CONSTRAINT DF_DefaultTime DEFAULT CURRENT_TIMESTAMP FOR [LastLoginTime]

-- 12 Set Unique Field
ALTER TABLE [Users]
DROP CONSTRAINT PK_users
ALTER TABLE [Users]
ADD PRIMARY KEY (id)
ALTER TABLE [Users]
ADD CHECK(LEN([Username]) >=3)

-- 13 Movies Database
CREATE DATABASE [Movies]

CREATE TABLE [Directors](
	[Id] INT PRIMARY KEY IDENTITY,
	[DirectorName] NVARCHAR(200) NOT NULL,
	[Notes] NVARCHAR(1500)
)

CREATE TABLE [Genres](
	[Id] INT PRIMARY KEY IDENTITY,
	[GenreName] NVARCHAR(200) NOT NULL,
	[Notes] NVARCHAR(1500)
)

CREATE TABLE [Categories](
	[Id] INT PRIMARY KEY IDENTITY,
	[CategoryName] NVARCHAR(200) NOT NULL,
	[Notes] NVARCHAR(1500)
)

CREATE TABLE [Movies](
	[Id] INT PRIMARY KEY IDENTITY,
	[Title] NVARCHAR (500) NOT NULL,
	[DirectorId] INT FOREIGN KEY REFERENCES [Directors]([Id]),
	[CopyrightYear] SMALLINT,
	[Length] TIME,
	[GenreId] INT FOREIGN KEY REFERENCES [Genres]([Id]),
	[CategoryId] INT FOREIGN KEY REFERENCES [Categories]([Id]),
	[Rating] DECIMAL (2,1),
	[Notes] NVARCHAR(1500)
)

INSERT INTO [Directors]
	VALUES
	('Frank Darabont', 'Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.'),
	('Francis Ford Coppola', 'The aging patriarch of an organized crime dynasty in postwar New York City transfers control of his clandestine empire to his reluctant youngest son.'),
	('Christopher Nolan', 'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one'),
	('Francis Ford Coppola', 'The early life and career of Vito Corleone in 1920s New York City is portrayed, while his son, Michael, expands and tightens his grip on the family crime syndicate.'),
	('Sidney Lumet', 'The jury in a New York City murder trial is frustrated by a single member whose skeptical caution forces them to more carefully consider the evidence before jumping to a hasty verdict.')

INSERT INTO [Genres]
	VALUES
	('Drama', 'based on the short novel "Rita Hayworth'),
	('Crime', 'and Drama'),
	('Action', 'Crime and Drama'),
	('Crime', 'and Drama'),
	('Crime', 'Drama')

INSERT INTO [Categories]
	VALUES
	('Drama', 'Hayworth and the Shawshank Redemption"'),
	('Drama', 'Writers Mario Puzo'),
	('Crime', 'Writers Jonathan Nolan'),
	('Drama', 'Writers Francis Ford Coppola'),
	('Drama', 'Writer Reginald Rose')

INSERT INTO [Movies]
	VALUES
	('The Shawshank Redemption', 1, 1994, NULL, 1, 1, 9.3, '2h 22m'),
	('The Godfather', 2, 1972, NULL, 2, 2, 9.2, '2h 55m'),
	('The Dark Knight', 3, 2008, NULL, 3, 3, 9.0, '2h 32m'),
	('The Godfather: Part II', 4, 1974, NULL, 4, 4, 9.0, '3h 22m'),
	('12 Angry Men', 5, 1957, NULL, 5, 5, 9.0, '1h 36m')

-- 14 Car Rental Database
CREATE DATABASE CarRental

CREATE TABLE [Categories]
(
	[Id] INT PRIMARY KEY IDENTITY,
	[CategoryName] NVARCHAR(100) NOT NULL,
	[DailyRate] DECIMAL(3,2),
	[WeeklyRate] DECIMAL(3,2),
	[MonthlyRate] DECIMAL(3,2),
	[WeekendRate] DECIMAL(3,2)
)
CREATE TABLE [Cars]
(
	[Id] INT PRIMARY KEY IDENTITY,
	[PlateNumber] NVARCHAR(20) NOT NULL,
	[Manufacturer] NVARCHAR(100) NOT NULL,
	[Model] NVARCHAR(100) NOT NULL,
	[CarYear] INT NOT NULL,
	[CategoryId] INT FOREIGN KEY REFERENCES [Categories]([Id]),
	[Doors] INT,
	[Picture] VARBINARY(MAX),
	[Condition] NVARCHAR(100),
	[Available] NVARCHAR(100)
)
CREATE TABLE [Employees]
(
	[Id] INT PRIMARY KEY,
	[FirstName] NVARCHAR(50) NOT NULL,
	[LastName] NVARCHAR(50) NOT NULL,
	[Title] NVARCHAR(100),
	[Notes] NVARCHAR(1500)
)
CREATE TABLE [Customers]
(
	[Id] INT PRIMARY KEY,
	[DriverLicenseNumber] INT NOT NULL,
	[FullName] NVARCHAR(50) NOT NULL,
	[Address] NVARCHAR(1500),
	[City] NVARCHAR(50),
	[ZIPCode] NVARCHAR(20),
	[Notes] NVARCHAR(1500)
)
CREATE TABLE [RentalOrders]
(
	[Id] INT PRIMARY KEY,
	[EmployeeId] INT FOREIGN KEY REFERENCES Employees([Id]),
	[CustomerId] INT FOREIGN KEY REFERENCES Customers([Id]),
	[CarId] INT FOREIGN KEY REFERENCES Cars([Id]),
	[TankLevel] INT,
	[KilometrageStart] INT,
	[KilometrageEnd] INT,
	[TotalKilometrage] INT,
	[StartDate] DATE,
	[EndDate] DATE,
	[TotalDays] INT,
	[RateApplied] DECIMAL(3,2),
	[TaxRate] DECIMAL(3,2),
	[OrderStatus] NVARCHAR(100) NOT NULL,
	[Notes] NVARCHAR(1500)
)
INSERT INTO [Categories]
	VALUES
	('Citroen', NULL, NULL, NULL, NULL),
	('Audi', NULL, NULL, NULL, NULL),
	('Ford', NULL, NULL, NULL, NULL)
INSERT INTO [Cars]
	VALUES
	('BIM6254', 'Audi', 'A1', 2020, 2, NULL, NULL, NULL, NULL),
	('RPN654', 'Mercedes', 'CLA', 2018, 1, NULL, NULL, NULL, NULL),
	('KIK472', 'Ford', 'Kuga', 2015, 3, NULL, NULL, NULL, NULL)
INSERT INTO [Employees] 
	VALUES
	('Peter', 'Ivanov', NULL, NULL),
	('Ivo', 'Marinov', NULL, NULL),
	('Rosen', 'Velikov', NULL, NULL)
INSERT INTO [Customers]
	VALUES
	(674513, 'Jjvko Andreev', NULL, NULL, NULL, NULL),
	(765238, 'Max Mustermann', NULL, NULL, NULL, NULL),
	(321867, 'Karl Heinz', NULL, NULL, NULL, NULL)
INSERT INTO [RentalOrders] 
	VALUES
	(2, 3, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Sent', NULL),
	(3, 1, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Received', NULL),
	(1, 2, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Sent', NULL)

-- Hotel Database
CREATE DATABASE [Hotel]

USE [Hotel]

CREATE TABLE[Employees](
	[Id] INT PRIMARY KEY IDENTITY,
	[FirstName] NVARCHAR(50) NOT NULL,
	[LastName] NVARCHAR(50) NOT NULL,
	[Title] NVARCHAR(10),
	[Notes] NVARCHAR(1500)
)

CREATE TABLE [Customers](
	[AccountNumber] INT PRIMARY KEY IDENTITY,
	[FirstName] NVARCHAR(50) NOT NULL,
	[LastName] NVARCHAR(50) NOT NULL,
	[PhoneNumber] INT,
	[EmergencyName] NVARCHAR(50),
	[EmergencyNumber] INT,
	[Notes] NVARCHAR(1500)
)

CREATE TABLE [RoomStatus](
	[RoomStatus] NVARCHAR(50) PRIMARY KEY,
	[Notes] NVARCHAR(1500)
)

CREATE TABLE [RoomTypes](
	[RoomType] NVARCHAR(50) PRIMARY KEY,
	[Notes] NVARCHAR(1500)
)

CREATE TABLE [BedTypes](
	[BedType] NVARCHAR(50) PRIMARY KEY,
	[Notes] NVARCHAR(1500)
)

CREATE TABLE [Rooms](
	[RoomNumber] INT PRIMARY KEY IDENTITY,
	[RoomType] NVARCHAR(50) FOREIGN KEY REFERENCES [RoomTypes]([RoomType]),
	[BedType] NVARCHAR(50) FOREIGN KEY REFERENCES [BedTypes]([BedType]),
	[Rate] INT,
	[RoomStatus] NVARCHAR(50),
	[Notes] NVARCHAR(1500)
)

CREATE TABLE [Payments](
	[Id] INT PRIMARY KEY IDENTITY,
	[EmployeeId] INT FOREIGN KEY REFERENCES [Employees]([Id]),
	[PaymentDate] DATE,
	[AccountNumber] INT,
	[FirstDateOccupied] DATE,
	[LastDateOccupied] DATE,
	[TotalDays] SMALLINT,
	[AmountCharged] INT,
	[TaxRate] DECIMAL(5,2),
	[TaxAmount] DECIMAL(5,2),
	[PaymentTotal] DECIMAL(5,2),
	[Notes] NVARCHAR(1500)
)

CREATE TABLE [Occupancies](
	[Id] INT PRIMARY KEY IDENTITY,
	[EmployeeId] INT FOREIGN KEY REFERENCES [Employees]([Id]),
	[DateOccupied] DATE,
	[AccountNumber] INT FOREIGN KEY REFERENCES [Customers]([AccountNumber]),
	[RoomNumber] INT FOREIGN KEY REFERENCES [Rooms]([RoomNumber]),
	[RateApplied] DECIMAL(5,2),
	[PhoneCharge] INT,
	[Notes] NVARCHAR(1500)
)

INSERT INTO [Employees] ([FirstName], [LastName]) 
	VALUES
	('Ivo', 'Ivanov'),
	('Ruslan', 'Petrov'),
	('Gloria', 'Mihailova')
INSERT INTO [Customers] ([FirstName], [LastName], [PhoneNumber]) 
	VALUES
	('Dora', 'Nikolaeva', 0896541),
	('Sven', 'Djorchevic', 0865464),
	('Ilina', 'Georgieva', 03042356)
INSERT INTO [RoomStatus]([RoomStatus]) 
	VALUES
	('Reserved'),
	('Checked-In'),
	('To be cleaned')
INSERT INTO [RoomTypes]([RoomType]) 
	VALUES
	('Single'),
	('Double'),
	('Apartment')
INSERT INTO [BedTypes]([BedType]) 
	VALUES
	('Two bed'),
	('One bed'),
	('Kind Size bed')
INSERT INTO [Rooms]([RoomType], [BedType], [RoomStatus]) 
	VALUES
	('Single', 'One bed', 'Checked-In'),
	('Double', 'Two bed', 'Reserved'),
	('Apartment', 'Kind Size bed', 'To be cleaned')
INSERT INTO [Payments] ([EmployeeId], [AccountNumber], [PaymentTotal]) 
	VALUES
	(1, 1, 489.25),
	(2, 2, 561.21),
	(3, 3, 421.89)
INSERT INTO [Occupancies] ([EmployeeId], [AccountNumber], [RoomNumber]) 
	VALUES
	(1, 1, 1),
	(2, 2, 2),
	(3, 3, 3)

-- 15 Create SoftUni Database

CREATE DATABASE [SoftUni]

CREATE TABLE [Towns](
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(100)
)
CREATE TABLE [Addresses](
	[Id] INT PRIMARY KEY IDENTITY,
	[AddressText] NVARCHAR(250) NOT NULL,
	[TownId] INT FOREIGN KEY REFERENCES [Towns]([Id])
)
CREATE TABLE [Departments](
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(100)
)
CREATE TABLE [Employees](
	[Id] INT PRIMARY KEY IDENTITY,
	[FirstName] NVARCHAR(30) NOT NULL,
	[LastName] NVARCHAR(30) NOT NULL,
	[JobTitle] NVARCHAR(30) NOT NULL,
	[DepartmentId] INT FOREIGN KEY REFERENCES [Departments]([Id]),
	[HireDate] DATE,
	[Salary] DECIMAL(8,2) NOT NULL,
	[AddressId] INT FOREIGN KEY REFERENCES [Addresses]([Id])
)

-- 17 Backup Database

BACKUP DATABASE [SoftUni]
TO DISK = 'E:\DB_SoftUni.bak'

DROP DATABASE [SoftUni]
RESTORE DATABASE [SoftUni]
FROM DISK = 'E:\DB_SoftUni.bak'

-- 18 Basic Insert

INSERT INTO [Towns] ([Name]) 
	VALUES
	('Sofia'),
	('Plovdiv'),
	('Varna'),
	('Burgas')
INSERT INTO [Departments] ([Name]) 
	VALUES
	('Engineering'),
	('Sales'),
	('Marketing'),
	('Software Development'),
	('Quality Assurance')
INSERT INTO [Employees] ([FirstName], [LastName], [JobTitle], [DepartmentId], [HireDate], [Salary]) 
	VALUES
	('Ivan', 'Ivanov', '.NET Developer', 4, '2013-02-01', 3500.00),
	('Petar', 'Petrov', 'Senior Engineer', 1, '2004-03-02', 4000.00),
	('Maria', 'Ivanova', 'Intern', 5, '2016-08-28', 525.25),
	('Georgi', 'Ivanov', 'CEO', 2, '2007-12-09', 3000.00),
	('Peter', 'Pan', 'Intern', 3, '2016-08-28', 599.88)

-- 19 Basic Select All Fields

SELECT * FROM [Towns]
SELECT * FROM [Departments]
SELECT * FROM [Employees]

-- 20 Basic Select All Fields and Order Them

SELECT * FROM [Towns]
ORDER BY [Towns].[Name]
SELECT * FROM [Departments]
ORDER BY [Departments].[Name]
SELECT * FROM [Employees]
ORDER BY [Employees].[Salary] DESC

-- 21 Basic Select Some Fields

SELECT [Name] FROM [Towns]
ORDER BY [Name]
SELECT [Name] FROM [Departments]
ORDER BY [Name]
SELECT [FirstName], [LastName], [JobTitle], [Salary] FROM [Employees]
ORDER BY [Salary] DESC

-- 22 Increase Employees Salary

UPDATE [Employees]
SET [Salary] = [Salary] * 1.1
SELECT [Employees].[Salary] FROM [Employees]

-- 23 Decrease Tax Rate

USE [Hotel]

UPDATE [Payments]
SET [TaxRate] = [TaxRate] * 0.97
SELECT [Payments].[TaxRate] FROM [Payments]

-- 24 Delete All Records

USE [Hotel]

TRUNCATE TABLE [Occupancies]