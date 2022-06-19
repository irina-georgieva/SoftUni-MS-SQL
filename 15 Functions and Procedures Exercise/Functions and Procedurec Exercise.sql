USE [SoftUni]

GO

--01 Employees with Salary Above 35000

CREATE PROC [usp_GetEmployeesSalaryAbove35000]
AS
BEGIN
	SELECT [FirstName], [LastName]
		FROM [Employees]
		WHERE [Salary] > 35000
END

EXEC [dbo].[usp_GetEmployeeSalaryAbove35000]

-- 02 Employees with Salary Above Number
GO

CREATE PROC [usp_GetEmployeesSalaryAboveNumber] @minSalary DECIMAL(18,4)
AS
BEGIN
	SELECT [FirstName], [LastName]
		FROM [Employees]
		WHERE [Salary] >= @minSalary
END

-- 03 Town Names Starting With

GO

CREATE PROC [usp_GetTownsStartingWith] @startLetter VARCHAR(50)
AS
BEGIN
	SELECT [Name]
		FROM [Towns]
		WHERE LEFT([Name], 1) = 'b'
END

-- 04 Employees from Town

GO

CREATE PROC [usp_GetEmployeesFromTown] @townName VARCHAR(50)
AS
BEGIN
	SELECT [FirstName], [LastName]
		FROM [Employees] AS [e]
	LEFT JOIN [Addresses] AS [a]
		ON [e].[AddressID] = [a].[AddressID]
	LEFT JOIN [Towns] AS [t]
		ON [a].[TownID] = [t].[TownID]
	WHERE [t].[Name] = @townName
END

-- 05 Salary Level Function
GO

CREATE FUNCTION [ufn_GetSalaryLevel](@salary DECIMAL(18,4))
RETURNS VARCHAR(8)
AS
BEGIN
	DECLARE @salaryLevel VARCHAR(8)
	
	IF @salary < 30000
	BEGIN
		SET @salaryLevel = 'Low'
	END
	IF @salary BETWEEN 30000 AND 50000
	BEGIN
		SET @salaryLevel = 'Average'
	END
	IF @salary > 50000
	BEGIN
		SET @salaryLevel = 'High'
	END

	RETURN @salaryLevel
END

-- 06 Employees by Salary Level
GO

CREATE PROC [usp_EmployeesBySalaryLevel] @salaryLevel VARCHAR(8)
AS
BEGIN
	SELECT [FirstName], [LastName]
		FROM [Employees]
		WHERE [dbo].[ufn_GetSalaryLevel]([Salary]) = @salaryLevel
END

-- 07 Define Function
GO

CREATE FUNCTION [ufn_IsWordComprised](@setOfLetters VARCHAR, @word VARCHAR (50))
RETURNS INT
AS
BEGIN
	DECLARE @currentIndex INT = 1
		WHILE(@currentIndex <= LEN(@word))
		BEGIN
			IF(CHARINDEX(SUBSTRING(@word, @currentIndex, 1), @setOfLetters) = 0)
				RETURN 0
			ELSE 
				SET @currentIndex += 1
		END
	RETURN 1
END

-- 08 Delete Employees and Departments
GO

CREATE PROC [usp_DeleteEmployeesFromDepartment](@departmentId INT)
AS
BEGIN
	DELETE FROM [EmployeesProjects]
		WHERE [EmployeeID] IN (
								SELECT [EmployeeID]
								  FROM [Employees]
								 WHERE [DepartmentID] = @departmentId
							   )
		UPDATE [Employees]
			SET [ManagerID] = NULL
			WHERE [ManagerID] IN (
								SELECT [EmployeeID]
								  FROM [Employees]
								 WHERE [DepartmentID] = @departmentId
								 )
		ALTER TABLE [Departments]
		ALTER COLUMN [ManagerID] INT

		UPDATE [Departments]
			SET [ManagerID] = NULL
			WHERE [ManagerID] IN (
								SELECT [EmployeeID]
								  FROM [Employees]
								 WHERE [DepartmentID] = @departmentId
								 )
		DELETE FROM [Employees]
			WHERE [DepartmentID] = @departmentId

		DELETE FROM [Departments]
			WHERE [DepartmentID] = @departmentId

		SELECT COUNT([EmployeeID])
			FROM [Employees]
			WHERE [DepartmentID] = @departmentId
END

GO

EXEC [dbo].[usp_DeleteEmployeesFromDepartment] 2

-- 09 Find Full Name

USE [Bank]

GO

CREATE PROC [usp_GetHoldersFullName]
AS
BEGIN
	SELECT CONCAT([FirstName], ' ', [LastName]) AS [FullName]
		FROM [AccountHolders]
END

-- 10 People with Balance Higher Than
GO

CREATE PROC [usp_GetHoldersWithBalanceHigherThan] (@money MONEY)
AS
BEGIN
	SELECT [ah].[FirstName], [ah].[LastName]
		FROM [AccountHolders] AS [ah]
		LEFT JOIN [Accounts] AS [a]
		ON [a].[AccountHolderId] = [ah].[Id]
		GROUP BY [ah].[Id], [ah].[FirstName], [ah].[LastName]
		HAVING SUM([a].[Balance]) > @money
		ORDER BY [FirstName], [LastName]
END

GO

-- 11 Future Value Function
CREATE FUNCTION [ufn_CalculateFutureValue] (@sum DECIMAL(36,4), @yearlyInterestRate FLOAT, @NumberOfYears INT)
RETURNS DECIMAL (36, 4)
AS
BEGIN
	RETURN
	@sum * (POWER((1 + @yearlyInterestRate), @NumberOfYears))
END

-- SELECT [dbo].[ufn_CalculateFutureValue] (1000, 0.10, 5)

GO

-- 12 Calculating Interest

CREATE PROC [usp_CalculateFutureValueForAccount] (@accountID INT, @interestRate FLOAT)
AS
BEGIN
	SELECT [ah].[Id] AS [Account Id],
			[ah].[FirstName], [ah].[LastName],
			[a].[Balance] AS [Current Balance],
			[dbo].[ufn_CalculateFutureValue]([a].[Balance], @interestRate, 5) AS [Balance in 5 years]
		FROM [AccountHolders] AS [ah]
		JOIN [Accounts] AS [a]
		ON [a].[AccountHolderId] = [ah].[Id]
		WHERE [a].[Id] = @accountID
END

-- 13 *Scalar Function: Cash in User Games Odd Rows

GO

USE [Diablo]

GO

CREATE FUNCTION [ufn_CashInUsersGames](@gameName NVARCHAR(50))
RETURNS TABLE
AS RETURN (
	SELECT SUM ([Cash]) AS [SumCash]
		FROM (
				SELECT [ug].[Cash],
					ROW_NUMBER() OVER(ORDER BY [ug].[Cash] DESC)
					AS [RowNumber]
					FROM [UsersGames] AS [ug]
					LEFT JOIN [Games] AS [g]
					ON [ug].[GameId] = [g].[Id]
					WHERE [g].[Name] = @gameName
				) AS [RowNumberSubquery]
			WHERE [RowNumber] % 2 <> 0
		)
GO
SELECT * FROM [ufn_CashInUsersGames] ('Love in a mist')
GO