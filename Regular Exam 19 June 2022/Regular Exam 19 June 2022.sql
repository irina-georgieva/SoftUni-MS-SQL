CREATE DATABASE [Zoo]

GO

USE [Zoo]

GO

-- 01 DDL

CREATE TABLE [Owners](
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	[PhoneNumber] VARCHAR(15) NOT NULL,
	[Address] VARCHAR (50)
)

CREATE TABLE [AnimalTypes] (
	[Id] INT PRIMARY KEY IDENTITY,
	[AnimalType] VARCHAR (30) NOT NULL
)

CREATE TABLE [Cages](
	[Id] INT PRIMARY KEY IDENTITY,
	[AnimalTypeId] INT NOT NULL FOREIGN KEY REFERENCES [AnimalTypes]([Id])
)

CREATE TABLE [Animals](
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR (30) NOT NULL,
	[BirthDate] DATE NOT NULL,
	[OwnerId] INT FOREIGN KEY REFERENCES [Owners]([Id]),
	[AnimalTypeId] INT NOT NULL FOREIGN KEY REFERENCES [AnimalTypes]([Id])
)

CREATE TABLE [AnimalsCages](
	[CageId] INT NOT NULL FOREIGN KEY REFERENCES [Cages]([Id]),
	[AnimalId] INT NOT NULL FOREIGN KEY REFERENCES [Animals]([Id]),
	PRIMARY KEY ([CageId], [AnimalId])
)

CREATE TABLE [VolunteersDepartments](
	[Id] INT PRIMARY KEY IDENTITY,
	[DepartmentName] VARCHAR(30) NOT NULL
)

CREATE TABLE [Volunteers](
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	[PhoneNumber] VARCHAR(15) NOT NULL,
	[Address] VARCHAR(50),
	[AnimalId] INT FOREIGN KEY REFERENCES [Animals]([Id]),
	[DepartmentId] INT NOT NULL FOREIGN KEY REFERENCES [VolunteersDepartments]([Id])
)

-- 02 Insert

INSERT INTO [Volunteers]([Name], [PhoneNumber], [Address], [AnimalId], [DepartmentId])
	VALUES
	('Anita Kostova', '0896365412', 'Sofia, 5 Rosa str.', 15, 1),
	('Dimitur Stoev', '0877564223', NULL, 42, 4),
	('Kalina Evtimova', '0896321112', 'Silistra, 21 Breza str.', 9, 7),
	('Stoyan Tomov', '0898564100', 'Montana, 1 Bor str.', 18, 8),
	('Boryana Mileva', '0888112233', NULL, 31, 5)

INSERT INTO [Animals]([Name], [BirthDate], [OwnerId], [AnimalTypeId])
	VALUES
	('Giraffe', '2018-09-21', 21, 1),
	('Harpy Eagle', '2015-04-17', 15, 3),
	('Hamadryas Baboon', '2017-11-02', NULL, 1),
	('Tuatara', '2021-06-30', 2, 4)

-- 03 Update
SELECT [Id]
	FROM [Owners]
	WHERE [Name] = 'Kaloqn Stoqnov'
	-- Id = 4

UPDATE [Animals]
	SET [OwnerId] = 4
	WHERE [OwnerId] IS NULL

-- 04 DELETE
DELETE FROM [Volunteers]
	WHERE [DepartmentId] IN ( SELECT [Id]
								FROM [VolunteersDepartments]
								WHERE [DepartmentName] = 'Education program assistant'
							)
DELETE FROM [VolunteersDepartments]
	WHERE [DepartmentName] = 'Education program assistant'

-- 05 Volunteers
SELECT [Name], [PhoneNumber], [Address], [AnimalId], [DepartmentId]
	FROM [Volunteers]
	ORDER BY [Name], [AnimalId], [DepartmentId] DESC

-- 06 Animals data
SELECT [a].[Name], [t].[AnimalType], 
		FORMAT([a].[BirthDate], 'dd.MM.yyyy')
	FROM [Animals] AS [a]
	LEFT JOIN [AnimalTypes] [t]
	ON [a].[AnimalTypeId] = [t].[Id]
	ORDER BY [a].[Name]

-- 07 Owners and Their Animals
SELECT TOP (5) [o].[Name], COUNT([a].[Name]) AS [CountOfAnimals]
	FROM [Animals] AS [a]
	LEFT JOIN [Owners] AS [o]
	ON [a].[OwnerId] = [o].[Id]
	WHERE [o].[Name] IS NOT NULL
	GROUP BY [o].[Name]
	ORDER BY [CountOfAnimals] DESC, [o].[Name]

-- 08 Owners, Animals and Cages

SELECT CONCAT([o].[Name], '-', [a].[Name]) AS [OwnersAnimals],
		[o].[PhoneNumber],
		[ac].[CageId]
	FROM [Owners] AS [o]
	JOIN [Animals] AS [a]
	ON [o].[Id] = [a].[OwnerId]
	JOIN [AnimalTypes] AS [at]
	ON [at].[Id] = [a].[AnimalTypeId]
	JOIN [AnimalsCages] AS [ac]
	ON [a].[Id] = [ac].[AnimalId]
	WHERE [at].[AnimalType] = 'Mammals'
	ORDER BY [o].[Name], [a].[Name] DESC

-- 09 Volunteers in Sofia
SELECT [v].[Name], [v].[PhoneNumber],
	TRIM(SUBSTRING(TRIM([v].[Address]), 8 ,LEN([v].[Address]))) AS [Address]
	FROM [Volunteers] AS [v]
	JOIN [VolunteersDepartments] AS [vd]
	ON [v].[DepartmentId] = [vd].[Id]
	WHERE [vd].[DepartmentName] = 'Education program assistant'
	AND [v].[Address] LIKE '%Sofia%'
	ORDER BY [v].[Name]

-- 10 Animals for Adoption
SELECT [a].[Name],
	DATEPART(YEAR, [BirthDate]) AS [BirthYear],
	[at].[AnimalType]
	FROM [Animals] AS [a]
	JOIN [AnimalTypes] AS [at]
	ON [a].[AnimalTypeId] = [at].[Id]
	WHERE [OwnerId] IS NULL
	AND DATEPART(YEAR, [BirthDate]) >= 2018
	AND NOT [at].[AnimalType] = 'Birds'
	ORDER BY [a].[Name]
	
-- 11 All Volunteers in a Department
GO

CREATE FUNCTION [udf_GetVolunteersCountFromADepartment] (@VolunteersDepartment VARCHAR(30))
RETURNS INT
AS
BEGIN
	RETURN (SELECT COUNT([v].[Name])
					FROM [Volunteers] AS [v]
					LEFT JOIN [VolunteersDepartments] AS [vd]
					ON [v].[DepartmentId] = [vd].[Id]
					WHERE [vd].[DepartmentName] = @VolunteersDepartment
					)
END

-- 12 Animals with Owner or Not
GO

CREATE PROC [usp_AnimalsWithOwnersOrNot](@AnimalName VARCHAR (30))
AS
BEGIN
	SELECT [a].[Name],
			CASE
				WHEN [o].[Name] IS NULL THEN 'For adoption'
			ELSE
				[o].[Name]
			END AS [OwnersName]
		FROM [Animals] AS [a]
		LEFT JOIN [Owners] AS [o]
		ON [a].[OwnerId] = [o].[Id]
		WHERE [a].[Name] = @AnimalName
END

EXEC usp_AnimalsWithOwnersOrNot 'Hippo'