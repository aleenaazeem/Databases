CREATE DATABASE Group14ADTLab5;
GO
USE Group14ADTLab5;
CREATE TABLE Group14Students (
    StudentID INT PRIMARY KEY,
    FullName VARCHAR(100),
    Email VARCHAR(100),
    TotalCredits INT
);

CREATE TABLE Group14Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100),
    Instructor VARCHAR(100),
    CourseCredits INT,
    AvailableSeats INT
);

CREATE TABLE Group14StudentRegistration (
    RegistrationID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT FOREIGN KEY REFERENCES Group14Students(StudentID),
    CourseID INT FOREIGN KEY REFERENCES Group14Courses(CourseID)
);

-- Insert sample data
-- Insert sample data
INSERT INTO Group14Students VALUES
(1, 'Peter Johnson', 'peter.johnson@example.com', 0),
(2, 'Tony Park', 'tony.park@example.com', 0),
(3, 'Sarah Adams', 'sarah.adams@example.com', 0);

INSERT INTO Group14Courses VALUES
(1, 'Physics', 'Professor Smith', 1, 5),
(2, 'Chemistry', 'Professor Clark', 3, 30),
(3, 'Computer Science', 'Professor Williams', 2, 15);
Go

CREATE OR ALTER PROCEDURE Group14_spInsertStudentRegistration 
    @StudentID INT, 
    @CourseID INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        DECLARE @Seats INT, @Credits INT;
        SELECT @Seats = AvailableSeats, @Credits = CourseCredits 
        FROM Group14Courses WHERE CourseID = @CourseID;
        IF @Seats <= 0
        BEGIN
            RAISERROR('Course is full. Registration failed', 16, 1);
            ROLLBACK;
            RETURN;
        END
        -- Register student
        INSERT INTO Group14StudentRegistration (StudentID, CourseID)
        VALUES (@StudentID, @CourseID);
        -- Update seats
        UPDATE Group14Courses 
        SET AvailableSeats = AvailableSeats - 1
        WHERE CourseID = @CourseID;
        -- Update student credits
        UPDATE Group14Students
        SET TotalCredits = TotalCredits + @Credits
        WHERE StudentID = @StudentID;
        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        PRINT ERROR_MESSAGE();
    END CATCH
END

EXEC Group14_spInsertStudentRegistration 1, 2; -- Peter - Chemistry
SELECT * FROM Group14Students;
SELECT * FROM Group14Courses;
SELECT * FROM Group14StudentRegistration;

EXEC Group14_spInsertStudentRegistration 3, 3; -- Sarah - CS
SELECT * FROM Group14Students;
SELECT * FROM Group14Courses;
SELECT * FROM Group14StudentRegistration;

EXEC Group14_spInsertStudentRegistration 3, 1; -- Sarah - Physics
SELECT * FROM Group14Students;
SELECT * FROM Group14Courses;
SELECT * FROM Group14StudentRegistration;

EXEC Group14_spInsertStudentRegistration 1, 3; -- Peter - CS
SELECT * FROM Group14Students;
SELECT * FROM Group14Courses;
SELECT * FROM Group14StudentRegistration;

