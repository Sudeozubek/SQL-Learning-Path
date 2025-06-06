USE kitaplik;
DROP TABLE IF EXISTS StudentGrade;
DROP TABLE IF EXISTS Course;
DROP TABLE IF EXISTS Person;
DROP TABLE IF EXISTS Department;


-- 1. Department tablosu
CREATE TABLE Department (
                            DepartmentId INT PRIMARY KEY,
                            Name NVARCHAR(50)
);

-- 2. Person tablosu
CREATE TABLE Person (
                        PersonId INT PRIMARY KEY AUTO_INCREMENT,
                        FirstName NVARCHAR(50),
                        LastName NVARCHAR(50),
                        Discriminator NVARCHAR(20)
);

-- 3. Course tablosu
CREATE TABLE Course (
                        CourseId INT PRIMARY KEY,
                        Title NVARCHAR(100),
                        DepartmentId INT,
                        FOREIGN KEY (DepartmentId) REFERENCES Department(DepartmentId)
);

-- 4. StudentGrade tablosu
CREATE TABLE StudentGrade (
                              EnrollmentId INT PRIMARY KEY AUTO_INCREMENT,
                              CourseId INT,
                              StudentId INT,
                              Grade DECIMAL(3,2),
                              FOREIGN KEY (CourseId) REFERENCES Course(CourseId),
                              FOREIGN KEY (StudentId) REFERENCES Person(PersonId)
);

-- Department verisi
INSERT INTO Department (DepartmentId, Name)
VALUES
    (1, 'Computer Science'),
    (2, 'Mathematics'),
    (3, 'Literature');

-- Person verisi
INSERT INTO Person (FirstName, LastName, Discriminator)
VALUES
    ('Sude', 'Özübek', 'Student'),
    ('Halil İbrahim', 'Kurnaz', 'Student'),
    ('Ayşe', 'Demir', 'Instructor'),
    ('Melike', 'Can', 'Instructor');

-- Course verisi
INSERT INTO Course (CourseId, Title, DepartmentId)
VALUES
    (101, 'SQL Basics', 1),
    (102, 'Java', 2),
    (103, 'Artificial Intelligence', 1);

-- StudentGrade verisi
INSERT INTO StudentGrade (CourseId, StudentId, Grade)
VALUES
    (101, 1, 3.5),   -- Sude, SQL
    (101, 2, 2.0),   -- Halil, SQL
    (102, 1, 4.0),   -- Sude, Java
    (103, 2, 1.5);   -- Halil, AI



SELECT * FROM Department;
SELECT * FROM Person;

SELECT * FROM Person WHERE Discriminator = 'Student';
SELECT * FROM Person WHERE Discriminator ='Instructor';

-- List the titles of all courses along with the name of the department they belong to.
SELECT c.Title AS CourseName, d.Name AS DepartmentName
FROM Course c
JOIN Department d ON c.DepartmentId = d.DepartmentId;

-- Show the first name, last name, course title, and grade of each student.
SELECT p.FirstName, p.LastName, c.Title, sg.Grade
FROM StudentGrade sg
JOIN Person p ON sg.StudentId = p.PersonId
JOIN Course c ON sg.CourseId = c.CourseId
WHERE p.Discriminator = 'Student';

-- Find the average grade of each student and list their first name, last name, and average grade.
SELECT p.FirstName, p.LastName, ROUND(AVG(sg.Grade), 2) AS AvarageGrade
FROM StudentGrade sg
JOIN Person p ON sg.StudentId = p.PersonId
WHERE p.Discriminator = 'Student'
GROUP BY p.FirstName, p.LastName;

-- List all departments that have at least one course.
SELECT d.Name AS DepartmentName
FROM Department d
JOIN Course c ON d.DepartmentId = c.DepartmentId
GROUP BY d.Name;

-- Show the number of students each instructor is teaching. List instructor's first name, last name, and the number of students.
ALTER TABLE Course
ADD InstructorId INT;

UPDATE Course SET InstructorId = 3 WHERE CourseId = 101; -- SQL Basics
UPDATE Course SET InstructorId = 3 WHERE CourseId = 102; -- Java
UPDATE Course SET InstructorId = 4 WHERE CourseId = 103; -- Artificial Intelligence

SELECT p.FirstName, p.LastName, COUNT(sg.StudentId) AS NumberOfStudents
FROM Course c
JOIN Person p ON c.InstructorId= p.PersonId
JOIN StudentGrade sg on c.CourseId = sg.CourseId
WHERE p.Discriminator = 'Instructor'
GROUP BY p.FirstName, p.LastName;


