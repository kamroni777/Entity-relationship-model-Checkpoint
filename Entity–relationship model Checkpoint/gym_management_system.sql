
DROP DATABASE IF EXISTS GymManagementSystem;


CREATE DATABASE GymManagementSystem;
USE GymManagementSystem;


CREATE TABLE GYMNASIUM (
    GymID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Address VARCHAR(200) NOT NULL,
    PhoneNumber VARCHAR(20) NOT NULL,
    CONSTRAINT unique_gym_name UNIQUE (Name)
);


CREATE TABLE COACH (
    CoachID INT AUTO_INCREMENT PRIMARY KEY,
    LastName VARCHAR(50) NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    Age INT CHECK (Age >= 18 AND Age <= 70),
    Specialty VARCHAR(100) NOT NULL,
    CONSTRAINT unique_coach_name UNIQUE (LastName, FirstName)
);


CREATE TABLE SESSION (
    SessionID INT AUTO_INCREMENT PRIMARY KEY,
    SportType VARCHAR(50) NOT NULL,
    Schedule DATETIME NOT NULL,
    MaxCapacity INT DEFAULT 20 CHECK (MaxCapacity <= 20),
    GymID INT NOT NULL,
    FOREIGN KEY (GymID) REFERENCES GYMNASIUM(GymID) ON DELETE CASCADE,
    CONSTRAINT unique_session_time UNIQUE (GymID, Schedule)
);


CREATE TABLE SESSION_COACH (
    SessionID INT,
    CoachID INT,
    PRIMARY KEY (SessionID, CoachID),
    FOREIGN KEY (SessionID) REFERENCES SESSION(SessionID) ON DELETE CASCADE,
    FOREIGN KEY (CoachID) REFERENCES COACH(CoachID) ON DELETE CASCADE,
    CONSTRAINT max_two_coaches_per_session CHECK (
        (SELECT COUNT(*) FROM SESSION_COACH WHERE SessionID = SessionID) <= 2
    )
);


CREATE TABLE MEMBER (
    MemberID INT AUTO_INCREMENT PRIMARY KEY,
    LastName VARCHAR(50) NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    Address VARCHAR(200) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender CHAR(1) CHECK (Gender IN ('M', 'F', 'O')),
    GymID INT NOT NULL,
    FOREIGN KEY (GymID) REFERENCES GYMNASIUM(GymID) ON DELETE CASCADE,
    CONSTRAINT unique_member_identity UNIQUE (LastName, FirstName, DateOfBirth)
);


CREATE TABLE MEMBER_SESSION (
    MemberID INT,
    SessionID INT,
    RegistrationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (MemberID, SessionID),
    FOREIGN KEY (MemberID) REFERENCES MEMBER(MemberID) ON DELETE CASCADE,
    FOREIGN KEY (SessionID) REFERENCES SESSION(SessionID) ON DELETE CASCADE
);


CREATE INDEX idx_session_schedule ON SESSION(Schedule);
CREATE INDEX idx_member_name ON MEMBER(LastName, FirstName);
CREATE INDEX idx_coach_specialty ON COACH(Specialty);




INSERT INTO GYMNASIUM (Name, Address, PhoneNumber) VALUES
('Fitness World Downtown', '123 Main St, Cityville', '555-0101'),
('Fitness World Uptown', '456 Oak Ave, Cityville', '555-0102'),
('Fitness World Suburbia', '789 Pine Rd, Townsville', '555-0103');


INSERT INTO COACH (LastName, FirstName, Age, Specialty) VALUES
('Smith', 'John', 35, 'Weight Training'),
('Johnson', 'Sarah', 28, 'Yoga'),
('Williams', 'Mike', 42, 'CrossFit'),
('Brown', 'Emily', 31, 'Pilates'),
('Taylor', 'Robert', 38, 'Cardio');


INSERT INTO SESSION (SportType, Schedule, GymID) VALUES
('Yoga', '2023-11-01 08:00:00', 1),
('Weight Training', '2023-11-01 18:00:00', 1),
('Pilates', '2023-11-02 09:00:00', 2),
('CrossFit', '2023-11-02 17:00:00', 3),
('Cardio', '2023-11-03 07:00:00', 1),
('Yoga', '2023-11-03 08:00:00', 2);


INSERT INTO SESSION_COACH (SessionID, CoachID) VALUES
(1, 2), 
(2, 1), 
(2, 5), 
(3, 4), 
(4, 3), 
(5, 5), 
(6, 2); 


INSERT INTO MEMBER (LastName, FirstName, Address, DateOfBirth, Gender, GymID) VALUES
('Davis', 'Chris', '101 Elm St, Cityville', '1990-05-15', 'M', 1),
('Miller', 'Jessica', '202 Maple Dr, Cityville', '1985-11-22', 'F', 1),
('Wilson', 'David', '303 Cedar Ln, Townsville', '1995-02-10', 'M', 2),
('Moore', 'Lisa', '404 Birch Blvd, Townsville', '1988-07-30', 'F', 3),
('Taylor', 'Alex', '505 Spruce Ave, Cityville', '1992-03-18', 'O', 1),
('Anderson', 'Sam', '606 Redwood Way, Townsville', '1987-09-14', 'M', 2);


INSERT INTO MEMBER_SESSION (MemberID, SessionID) VALUES
(1, 1), 
(1, 2), 
(2, 1), 
(3, 3), 
(4, 4), 
(5, 5), 
(5, 6), 
(6, 3), 
(6, 6); 

CREATE VIEW SessionDetails AS
SELECT 
    s.SessionID,
    s.SportType,
    s.Schedule,
    s.MaxCapacity,
    g.Name AS GymName,
    g.Address