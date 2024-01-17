-- What are the full details of all employees in the alphabetical order of last then first names within every department?
SELECT *
FROM [TerpsEnterprise.Employee] e
ORDER BY e.departmentId, e.employeeLastName, e.employeeFirstName;


-- How many unique department locations?
SELECT COUNT(DISTINCT l.departmentLocation) AS 'Count of Location'
FROM [TerpsEnterprise.DepartmentLocation] l;


-- What are the managers' names and the corresponding department names, in the alphabetical order of last then first names?
SELECT e.employeeLastName, e.employeeFirstName, d.departmentName
FROM [TerpsEnterprise.Employee] e
JOIN [TerpsEnterprise.Department] d ON e.employeeSSN = d.managerEmployeeSSN
ORDER BY e.employeeLastName, e.employeeFirstName;


-- For each department name, how many employees in the department, in the order of department names?
SELECT d.departmentName, COUNT(*) AS 'Count of Employees'
FROM [TerpsEnterprise.Department] d
JOIN [TerpsEnterprise.Employee] e ON d.departmentId = e.departmentId
GROUP BY d.departmentName
ORDER BY d.departmentName


-- For each department name, how many locations in the department, in the order of department names?
SELECT d.departmentName, COUNT(l.departmentLocation) AS 'No of Locations'
FROM [TerpsEnterprise.Department] d
JOIN [TerpsEnterprise.DepartmentLocation] l ON d.departmentId = l.departmentId
GROUP BY d.departmentName
ORDER BY d.departmentName;


--What are employee names, in the alphabetical order of their last then first names, who work on projects organized by the research department?
SELECT DISTINCT e.employeeLastName, e.employeeFirstName, d.departmentName
FROM [TerpsEnterprise.Employee] e
JOIN [TerpsEnterprise.Work] w ON e.employeeSSN = w.employeeSSN
JOIN [TerpsEnterprise.Project] p ON w.projectId = p.projectId
JOIN [TerpsEnterprise.Department] d ON p.departmentId = d.departmentId
WHERE D.departmentName = 'Research'
ORDER BY e.employeeLastName, e.employeeFirstName;


-- What are employee names, in the alphabetical order of their last then first names, and numbers
-- of worked projects, where the employee worked on at least two projects?
SELECT e.employeeLastName, e.employeeFirstName, COUNT(w.projectId) AS 'No of
projects'
FROM [TerpsEnterprise.Employee] e
JOIN [TerpsEnterprise.Work] w ON e.employeeSSN = w.employeeSSN
GROUP BY e.employeeLastName, e.employeeFirstName
HAVING COUNT(w.projectId) >= 2
ORDER BY e.employeeLastName, e.employeeFirstName;


-- What are all details of a department, which organizes more than one project?
SELECT d.*
FROM [TerpsEnterprise.Department] d
WHERE d.departmentId IN (
SELECT p.departmentId
FROM [TerpsEnterprise.Project] p
GROUP BY p.departmentId
HAVING COUNT(P.projectId) > 1
);


-- What are all details of managers in the departments, for which more than three employees work in?
SELECT *
FROM [TerpsEnterprise.Employee] e
WHERE e.employeeSSN IN (
SELECT d.managerEmployeeSSN
FROM [TerpsEnterprise.Department] d
JOIN [TerpsEnterprise.Employee] em ON d.managerEmployeeSSN = em.employeeSSN
JOIN [TerpsEnterprise.Employee] e ON d.departmentId = e.departmentId
GROUP BY d.managerEmployeeSSN
HAVING COUNT(e.employeeSSN) > 3
);


-- What are all details about the oldest employee?
SELECT TOP 1 *
FROM [TerpsEnterprise.Employee] e
ORDER BY e.employeeDOB


-- What are all details about employees, who have letter 'e' in the name?
SELECT *
FROM [TerpsEnterprise.Employee] e
WHERE e.employeeFirstName LIKE '%e%' OR e.employeeLastName LIKE '%e%' OR
e.employeeMiddleInitial LIKE '%e%'


-- What are all details of a dependent, who has the same gender as the corresponding employee, using correlated subquery?
SELECT *
FROM [TerpsEnterprise.Dependent] dep
WHERE dep.dependentGender = (
SELECT e.employeeGender
FROM [TerpsEnterprise.Employee] e
WHERE e.employeeSSN = dep.employeeSSN
);


-- What are the cities, where there is a department, a project, or both?
SELECT DISTINCT l.departmentLocation
FROM [TerpsEnterprise.DepartmentLocation] l
WHERE l.departmentLocation IN (
SELECT p.projectLocation
FROM [TerpsEnterprise.Project] p
UNION
SELECT d.departmentId
FROM [TerpsEnterprise.Department] d
);


-- What are the cities, where there is both department and project?
SELECT DISTINCT l.departmentLocation
FROM [TerpsEnterprise.DepartmentLocation] l
WHERE l.departmentLocation IN (
SELECT p.projectLocation
FROM [TerpsEnterprise.Project] p
);


-- 15. What are the numbers of work hours for all possible combinations of employees and then projects?
SELECT w.employeeSSN, w.projectId, SUM(w.hours) AS 'Hours worked'
FROM [TerpsEnterprise.Work] w
GROUP BY CUBE (w.employeeSSN, w.projectId)
HAVING SUM(w.hours) IS NOT NULL
ORDER BY w.employeeSSN, w.projectId
