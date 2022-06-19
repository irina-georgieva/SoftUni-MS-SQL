-- 01 Employee Address
USE SoftUni

SELECT TOP (5) [EmployeeID], [JobTitle], [e].[AddressId], [a].[AddressText]
	FROM [Employees] AS [e]
	LEFT JOIN [Addresses] AS [a]
	ON [e].[AddressID] = [a].[AddressID]
	ORDER BY [a].[AddressID]

-- 02 Addresses with Towns
SELECT TOP (50) [e].[FirstName], [e].[LastName], [t].[Name] AS 'Town', [a].[AddressText]
	FROM [Employees] AS [e]
	JOIN [Addresses] AS [a] 
	ON [e].[AddressID] = [a].[AddressID]
	JOIN [Towns] AS [t] 
	ON [t].[TownID] = [a].[TownID]
	ORDER BY [e].[FirstName], [e].[LastName]

-- 03 Sales Employees
SELECT [e].[EmployeeID], [e].[FirstName], [e].[LastName], [d].[Name] AS 'Department'
	FROM [Employees] AS [e]
	JOIN [Departments] AS [d] 
	ON [e].[DepartmentID] = [d].[DepartmentID]
	WHERE [d].[Name] = 'Sales'

-- 04 Employee Departments
SELECT TOP (5) [e].[EmployeeID], [e].[FirstName], [e].[Salary], [d].[Name] AS 'Department'
	FROM [Employees] AS [e]
	JOIN [Departments] AS [d] 
	ON [e].[DepartmentID] = [d].[DepartmentID]
	WHERE [e].[Salary] > 15000
	ORDER BY [d].[DepartmentID]

-- 05 Employees Without Projects
SELECT 
	TOP (3) [e].[EmployeeID], [e].[FirstName]
	FROM [Employees] AS [e]
	LEFT OUTER JOIN [EmployeesProjects] AS [ep]
	ON [e].[EmployeeID] = [ep].[EmployeeID]
	WHERE [ep].[EmployeeID] IS NULL
	ORDER BY [e].[EmployeeID]

-- 06 Employees Hired After

SELECT [e].[FirstName], [e].[LastName], [e].[HireDate], [d].[Name] AS 'DeptName'
	FROM [Employees] AS [e]
	JOIN [Departments] AS [d]
	ON [e].[DepartmentID] = [d].[DepartmentID]
	WHERE DATEPART(YEAR, [e].[HireDate]) >= 1999
	AND [d].[Name] IN ('Sales', 'Finance')
	ORDER BY [e].[HireDate]

-- 07 Employees with Project

SELECT TOP (5) [e].[EmployeeID], [e].[FirstName], [p].[Name] AS [ProjectName]
	FROM [Employees] AS [e]
	JOIN [EmployeesProjects] AS [ep]
	ON [e].[EmployeeID] = [ep].[EmployeeID]
	JOIN [Projects] AS [p]
	ON [ep].[ProjectID] = [p].[ProjectID]
	WHERE [p].[StartDate] > '08/13/2002' AND [p].[EndDate] IS NULL
	ORDER BY [e].[EmployeeID]

-- 08 Employee 24
SELECT [e].[EmployeeID], [e].[FirstName],
	(CASE
		WHEN DATEPART (YEAR, [p].[StartDate]) >= 2005 THEN NULL
		ELSE [p].[Name]
	END) AS [ProjectName]
	FROM [Employees] AS [e]
	JOIN [EmployeesProjects] AS [ep]
	ON [e].[EmployeeID] = [ep].[EmployeeID]
	RIGHT JOIN [Projects] AS [p]
	ON [ep].[ProjectID] = [p].[ProjectID]
	WHERE [e].[EmployeeID] = 24

-- 09 Employee Manager
SELECT [e].[EmployeeID], [e].[FirstName], [m].[EmployeeID] AS [ManagerID],
	[m].[FirstName] AS [ManagerName]
	FROM [Employees] AS [e]
	INNER JOIN [Employees] AS [m]
	ON [e].[ManagerID] = [m].[EmployeeID]
	WHERE [m].[EmployeeID] IN (3,7)
	ORDER BY [e].[EmployeeID]

-- 10 Employees Summary
SELECT TOP (50) [e].[EmployeeID],
	CONCAT ([e].[FirstName], ' ', [e].[LastName]) AS [EmployeeName],
	CONCAT ([m].[FirstName], ' ', [m].[LastName]) AS [ManagerName],
	[d].[Name] AS [DepartmentName]
	FROM [Employees] AS [e]
	INNER JOIN [Employees] AS [m]
	ON [e].[ManagerID] = [m].[EmployeeID]
	JOIN [Departments] AS [d]
	ON [e].[DepartmentID] = [d].[DepartmentID]

-- 11 Min Average Salary
SELECT TOP (1) AVG([Salary]) AS [MinAverageSalary]
	FROM [Employees]
	GROUP BY [DepartmentID]
	ORDER BY [MinAverageSalary]
GO
-- 12 Highest Peaks in Bulgaria
USE Geography

SELECT [mc].[CountryCode], [m].[MountainRange], [p].[PeakName], [p].[Elevation]
	FROM [Peaks] AS [p]
	INNER JOIN [Mountains] AS [m]
	ON [p].[MountainId] = [m].[Id]
	INNER JOIN [MountainsCountries] AS [mc]
	ON [m].[Id] = [mc].[MountainId]
	WHERE [mc].[CountryCode] = 'BG'
	AND [p].[Elevation] > 2835
	ORDER BY [p].[Elevation] DESC

-- 13 Count Mountain Ranges

SELECT [c].[CountryCode],
	COUNT ([mc].[MountainId]) AS [MountainRanges]
	FROM [Countries] AS [c]
	LEFT JOIN [MountainsCountries] AS [mc]
	ON [c].[CountryCode] = [mc].[CountryCode]
	WHERE [c].[CountryName] IN ('Bulgaria', 'Russia', 'United States')
	GROUP BY [c].[CountryCode]

-- 14 Countries with Rivers
SELECT TOP (5) [c].[CountryName], [r].[RiverName]
--SELECT *
	FROM [Countries] AS [c]
	LEFT JOIN [CountriesRivers] AS [cr]
	ON [c].[CountryCode] = [cr].[CountryCode]
	LEFT JOIN [Rivers] AS [r]
	ON [cr].[RiverId] = [r].[Id]
	WHERE [c].[ContinentCode] = 'AF'
	ORDER BY [c].[CountryName]

-- 15 Continents and Currencies
SELECT [ContinentCode], [CurrencyCode], [CurrencyUsage]
	FROM (
			SELECT *,
				DENSE_RANK () OVER(PARTITION BY [ContinentCode] ORDER BY [CurrencyUsage] DESC)
				AS [CurrencyRank]
				FROM (
					SELECT [co].[ContinentCode], [c].[CurrencyCode],
					COUNT([c].[CurrencyCode]) AS [CurrencyUsage]
					FROM [Continents] AS [co]
					LEFT JOIN [Countries] AS [c]
					ON [c].[ContinentCode] = [co].[ContinentCode]
					GROUP BY [co].[ContinentCode], [c].[CurrencyCode]
					) AS [CurrencyUsageQuery]
				WHERE [CurrencyUsage] > 1
				) AS [CurrencyRankQuery]
			WHERE [CurrencyRank] = 1
		ORDER BY [ContinentCode]

-- 16 Countries Without Any Mountains

SELECT COUNT([c].[CountryName]) AS [Count]
	FROM [Countries] AS [c]
	LEFT JOIN [MountainsCountries] AS [m]
	ON [c].[CountryCode] = [m].[CountryCode]
	WHERE [m].[MountainId] IS NULL

-- 17 Highest Peak and Longest River by Country
SELECT TOP (5) [c].[CountryName],
			MAX([p].[Elevation]) AS [HighestPeakElevation],
			MAX([r].[Length]) AS [LongestRiverLength]
			FROM [Countries] AS [c]
			LEFT JOIN [CountriesRivers] AS [cr]
			ON [c].[CountryCode] = [cr].[CountryCode]
			LEFT JOIN [Rivers] AS [r]
			ON [cr].[RiverId] = [r].[Id]
			LEFT JOIN [MountainsCountries] AS [mc]
			ON [mc].[CountryCode] = [c].[CountryCode]
			LEFT JOIN [Mountains] AS [m]
			ON [mc].[MountainId] = [m].[Id]
			LEFT JOIN [Peaks] AS [p]
			ON [p].[MountainId] = [m].[Id]
		GROUP BY [c].[CountryName]
		ORDER BY [HighestPeakElevation] DESC, [LongestRiverLength] DESC, [CountryName]

-- 18 Highest Peak Name and Elevation by Country
SELECT TOP (5) [Country],
	CASE
		WHEN [PeakName] IS NULL THEN '(no highest peak)'
		ELSE [PeakName]
	END AS [Highest Peak Name],
	CASE
		WHEN [Elevation] IS NULL THEN 0
		ELSE [Elevation]
	END AS [Highest Peak Elevation],
	CASE
		WHEN [MountainRange] IS NULL THEN '(no mountain)'
		ELSE [MountainRange]
	END AS [Mountain]
FROM (
	SELECT	[c].[CountryName] AS [Country],
			[m].[MountainRange],
			[p].[PeakName],
			[p].[Elevation],
			DENSE_RANK() OVER(PARTITION BY [c].[CountryName] ORDER BY [p].[Elevation])
			AS [PeakRank]
		FROM [Countries] AS [c]
		LEFT JOIN [MountainsCountries] AS [mc]
		ON [c].[CountryCode] = [mc].[CountryCode]
		LEFT JOIN [Mountains] AS [m]
		ON [mc].[MountainId] = [m].[Id]
		LEFT JOIN [Peaks] AS [p]
		ON [p].[MountainId] = [m].[Id]
	) AS [PeakRankingQuery]
WHERE [PeakRank] = 1
ORDER BY [Country], [Highest Peak Name]