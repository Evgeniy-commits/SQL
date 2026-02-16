--SQLQuery - CREATE AllInOne
--SQLQuery0-CREATE DATABASE.sql

CREATE DATABASE PV_521_DDL
ON
(
	NAME		=	PV_521_DDL,
	FILENAME	=	'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\PV_521_DDL.mdf',
	SIZE		=	8 MB,
	MAXSIZE		=	500 MB,
	FILEGROWTH	=	8 MB
)
LOG ON
(
	NAME		=	PV_521_DDL_log,
	FILENAME	=	'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\PV_521_DDL.ldf',
	SIZE		=	8 MB,
	MAXSIZE		=	500 MB,
	FILEGROWTH	=	8 MB
)

USE PV_521_DDL;
GO
CREATE TABLE Directions
(
	direction_id	TINYINT			PRIMARY KEY,
	direction_name	NVARCHAR(150)	NOT NULL
);

CREATE TABLE Groups
(
	group_id	INT			PRIMARY KEY,
	group_name	NVARCHAR(24)	NOT NULL,
	direction	TINYINT			NOT NULL
	CONSTRAINT FK_Groups_Direction FOREIGN KEY REFERENCES Directions(direction_id) 
);

CREATE TABLE Students
(
	student_id		INT			PRIMARY KEY IDENTITY(1,1),
	last_name		NVARCHAR(50)	NOT NULL,
	first_name		NVARCHAR(50)	NOT NULL,
	middle_name		NVARCHAR(50),
	birth_date		DATE			NOT NULL,
	[group]			INT				NOT NULL
	CONSTRAINT FK_Students_Group FOREIGN KEY REFERENCES Groups(group_id) 
);

--DROP TABLE Students, Groups, Directions;

GO
CREATE TABLE Teachers
(
	teacher_id		INT		PRIMARY KEY,
	last_name		NVARCHAR(50)	NOT NULL,
	first_name		NVARCHAR(50)	NOT NULL,
	middle_name		NVARCHAR(50),
	birth_date		DATE			NOT NULL
);

CREATE TABLE Disciplines
(
	discipline_id			SMALLINT			PRIMARY KEY,
	discipline_name			NVARCHAR(256)		NOT NULL,
	number_of_lessons		TINYINT				NOT NULL
);

CREATE TABLE DisciplinesDirectionsRelation
(
	discipline			SMALLINT,
	direction			TINYINT,
	PRIMARY KEY(discipline, direction),
	CONSTRAINT	FK_DDR_Disciplines	FOREIGN KEY (discipline)	REFERENCES Disciplines(discipline_id),
	CONSTRAINT	FK_DDR_Direction	FOREIGN KEY (direction)		REFERENCES Directions(direction_id)
);

CREATE TABLE TeacersDisciplinesRelation
(
	teacher		INT,
	discipline	SMALLINT,
	PRIMARY KEY(teacher, discipline),
	CONSTRAINT	FK_TDR_Teacher		FOREIGN KEY (teacher) 		REFERENCES Teachers(teacher_id),
	CONSTRAINT	FK_TDR_Discipline	FOREIGN KEY (discipline) 	REFERENCES Disciplines(discipline_id)
);

CREATE TABLE RequireDisciplines
(
	discipline		SMALLINT,
	required_discipline	SMALLINT,
	PRIMARY KEY(discipline,required_discipline),
	CONSTRAINT FK_RD_Discipline		FOREIGN KEY (discipline) 	REFERENCES Disciplines(discipline_id),
	CONSTRAINT FK_RD_Required		FOREIGN KEY (required_discipline)	REFERENCES Disciplines(discipline_id)
);

CREATE TABLE DependentDisciplines
(
	discipline		SMALLINT,
	dependent_discipline	SMALLINT,
	PRIMARY KEY(discipline,dependent_discipline),
	CONSTRAINT FK_DD_Discipline		FOREIGN KEY (discipline) 		REFERENCES Disciplines(discipline_id),
	CONSTRAINT FK_DD_Dependent		FOREIGN KEY (dependent_discipline)		REFERENCES Disciplines(discipline_id)
);

--DROP TABLE Teachers, DisciplinesDirectionRelation, Disciplines, TeacersDisciplinesRelation, RequireDisciplines, DependentDisciplines;

GO
CREATE TABLE Schedule
(
	lesson_id		BIGINT		PRIMARY KEY,
	[date]			DATE		NOT NULL,
	[time]			TIME(0)		NOT NULL,
	[group]			INT			NOT NULL
	CONSTRAINT	FK_Schedule_Groups	FOREIGN KEY REFERENCES Groups(group_id),
	discipline		SMALLINT	NOT NULL
	CONSTRAINT	FK_Schedule_Disciplines	FOREIGN KEY REFERENCES Disciplines(discipline_id),
	teacher			INT			NOT NULL
	CONSTRAINT	FK_Schedule_Teacher	FOREIGN KEY REFERENCES Teachers(teacher_id),
	[subject]		NVARCHAR(256),
	spend			BIT			NOT NULL
);

CREATE TABLE Grades
(
	student		INT			CONSTRAINT	FK_Grades_Students	FOREIGN KEY REFERENCES Students(student_id),
	lesson		BIGINT		CONSTRAINT	FK_Grades_Schedule	FOREIGN KEY REFERENCES Schedule(lesson_id),
	PRIMARY	KEY(student,lesson),
	grade_1		TINYINT		CONSTRAINT	CK_Grade_1		CHECK	(grade_1>0 AND grade_1<=12),
	grade_2		TINYINT		CONSTRAINT	CK_Grade_2		CHECK	(grade_2>0 AND grade_2<=12)
);

CREATE TABLE Exams
(
	student		INT			CONSTRAINT	FK_Exams_Students	FOREIGN KEY REFERENCES Students(student_id),
	discipline	SMALLINT	CONSTRAINT	FK_Exams_Disciplines	FOREIGN KEY REFERENCES Disciplines(discipline_id),
	grade		TINYINT		CONSTRAINT	CK_Exam_Grade		CHECK	(grade>0 AND grade<=12)
);

CREATE TABLE HomeWorks
(
	[group]		INT			CONSTRAINT	FK_HW_Groups	FOREIGN KEY REFERENCES Groups(group_id),
	lesson		BIGINT		CONSTRAINT	FK_HW_Schedule	FOREIGN KEY REFERENCES Schedule(lesson_id),
	[data]		VARBINARY(MAX),
	comment		NVARCHAR(1024),
	CONSTRAINT  CK_DATA_OR_COMMENT	CHECK ([data] IS NOT NULL OR comment IS NOT NULL),
	PRIMARY KEY([group], lesson)
);

CREATE TABLE ResultsHW
(
	student		INT			CONSTRAINT	FK_Results_Students	FOREIGN KEY REFERENCES Students(student_id),
	[group]		INT,		--CONSTRAINT	FK_Results_Groups	FOREIGN KEY REFERENCES Groups(group_id),
	lesson		BIGINT,		--CONSTRAINT	FK_Results_Schedule	FOREIGN KEY REFERENCES Schedule(lesson_id),
	result		VARBINARY(MAX),
	comment		NVARCHAR(1024),
	grade		TINYINT		CONSTRAINT CK_HW_Grade		CHECK	(grade>0 AND grade<=12),
	CONSTRAINT	FK_Results_HW	FOREIGN KEY ([group],lesson) REFERENCES HomeWorks([group],lesson),
	CONSTRAINT  CK_ResultHW_OR_COMMENT	CHECK (result IS NOT NULL OR comment IS NOT NULL),
	PRIMARY KEY(student,[group],lesson)
);