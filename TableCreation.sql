ALTER TABLE [Terps.Employee]
DROP CONSTRAINT IF EXISTS fk_Employee_dptId;
DROP TABLE IF EXISTS [Terps.Dependent];
DROP TABLE IF EXISTS [Terps.Work];
DROP TABLE IF EXISTS [Terps.Project];
DROP TABLE IF EXISTS [Terps.DepartmentLocation];
DROP TABLE IF EXISTS [Terps.Department];
DROP TABLE IF EXISTS [Terps.Employee];


-- SQL create tables:
CREATE TABLE [Terps.Employee] (
empSSN CHAR(11) NOT NULL,
empFName VARCHAR(30) NOT NULL,
empMInit CHAR(1),
empLName VARCHAR(30) NOT NULL,
empDOB DATE,
empGender CHAR(10),
empStreet VARCHAR(40),
empCity VARCHAR(40),
empState CHAR(20),
empZip CHAR(10),
empSalary DECIMAL(10, 2),
sprEmpSSN CHAR(11),
dptId VARCHAR(10),
CONSTRAINT pk_Employee_empSSN PRIMARY KEY (empSSN),
CONSTRAINT fk_Employee_sprEmpSSN FOREIGN KEY (sprEmpSSN)
REFERENCES [Terps.Employee] (empSSN)
ON DELETE NO ACTION ON UPDATE NO ACTION
);


CREATE TABLE [Terps.Department] (
dptId VARCHAR(10) NOT NULL,
dptName VARCHAR(30) NOT NULL,
mgrEmpSSN CHAR(11),
mgrStartDate DATE,
CONSTRAINT pk_Department_dptId PRIMARY KEY (dptId),
CONSTRAINT fk_Department_mgrEmpSSN FOREIGN KEY (mgrEmpSSN)
REFERENCES [Terps.Employee] (empSSN)
ON DELETE NO ACTION ON UPDATE NO ACTION
);


ALTER TABLE [Terps.Employee]
ADD CONSTRAINT fk_Employee_dptId
FOREIGN KEY (dptId) REFERENCES [Terps.Department] (dptId)
ON DELETE NO ACTION ON UPDATE NO ACTION
CREATE TABLE [Terps.DepartmentLocation] (
dptId VARCHAR(10) NOT NULL,
dptLoc VARCHAR(50) NOT NULL,
CONSTRAINT pk_DepartmentLocation_dptLoc PRIMARY KEY (dptId, dptLoc),
CONSTRAINT fk_DepartmentLocation_dptId FOREIGN KEY (dptId)
REFERENCES [Terps.Department] (dptId)
ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE [Terps.Project] (
prjId VARCHAR(10) NOT NULL,
prjName VARCHAR(50),
prjLoc VARCHAR(50),
dptId VARCHAR(10),
CONSTRAINT pk_Project_prjId PRIMARY KEY (prjId),
CONSTRAINT fk_Project_dptId FOREIGN KEY (dptId)
REFERENCES [Terps.Department] (dptId)
ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE [Terps.Work] (
empSSN CHAR(11) NOT NULL,
prjId VARCHAR(10) NOT NULL,
hours DECIMAL(5, 2),
CONSTRAINT pk_EmployeeWork_empSSN_prjId PRIMARY KEY (empSSN, prjId),
CONSTRAINT fk_EmployeeWork_empSSN FOREIGN KEY (empSSN)
REFERENCES [Terps.Employee] (empSSN)
ON DELETE NO ACTION ON UPDATE NO ACTION,
CONSTRAINT fk_EmployeeWork_prjId FOREIGN KEY (prjId)
REFERENCES [Terps.Project] (prjId)
ON DELETE NO ACTION ON UPDATE NO ACTION
);


CREATE TABLE [Terps.Dependent] (
empSSN CHAR(11) NOT NULL,
dpdName VARCHAR(50) NOT NULL,
dpdDOB DATE,
dpdGender CHAR(10),
relationship VARCHAR(20),
CONSTRAINT pk_Dependent_empSSN_dpdName PRIMARY KEY (empSSN, dpdName),
CONSTRAINT fk_Dependent_empSSN FOREIGN KEY (empSSN)
REFERENCES [Terps.Employee] (empSSN)
ON DELETE CASCADE ON UPDATE CASCADE
);


-- Adding record of Supervisor into Employee table
INSERT INTO [Terps.Employee] VALUES
('000-00-0000', 'Ron', 'A', 'Kayne', '1996-05-09', 'Male', 'XYZ Street',
'Riverdale', 'Maryland', '20781', 200000, NULL, NULL);


-- Adding record of Manager into Employee table
INSERT INTO [Terps.Employee] VALUES
('000-00-0001', 'Sofie', 'P', 'Jam', '1995-05-09', 'Female', 'ABC Street',
'Hyattsville', 'Maryland', '20783', 220000, NULL, NULL);


-- Inserting record into Department table
INSERT INTO [Terps.Department] VALUES
('DEV', 'DEVELOPMENT', '000-00-0001', '2021-10-10');


-- Adding record of Employee into Employee table
INSERT INTO [Terps.Employee] VALUES
('000-00-0002', 'Zack', 'B', 'Wayne', '1998-05-09', 'Male', 'DEF Street',
'Hyattsville', 'Maryland', '20783', 100000, '000-00-0000', 'DEV');


-- Adding location into DepartmentLocation table
INSERT INTO [Terps.DepartmentLocation] VALUES
('DEV', 'Ohio');


-- Adding Project to Project table
INSERT INTO [Terps.Project] VALUES
('PRJ1', 'Project Alpha', 'Ohio', 'DEV');


-- Adding work details into Work table
INSERT INTO [Terps.Work] VALUES
('000-00-0002', 'PRJ1', '23.50');


-- Adding Dependent details into Dependent table
INSERT INTO [Terps.Dependent] VALUES
('000-00-0002', 'Peter', '2000-06-09', 'Male', 'Brother');
