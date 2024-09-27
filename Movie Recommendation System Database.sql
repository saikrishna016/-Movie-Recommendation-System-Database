-- Movie Recommendation System Database

-- 1. Users Table
CREATE TABLE Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    Username VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Movies Table
CREATE TABLE Movies (
    MovieID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    ReleaseYear YEAR NOT NULL,
    DurationMinutes INT,
    Summary TEXT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Genres Table
CREATE TABLE Genres (
    GenreID INT AUTO_INCREMENT PRIMARY KEY,
    GenreName VARCHAR(100) NOT NULL UNIQUE
);

-- Insert sample data for Genres
INSERT INTO Genres (GenreName) VALUES
('Action'), 
('Sci-Fi'), 
('Drama'), 
('Adventure');

-- 4. MovieGenres Table (Many-to-Many Relationship between Movies and Genres)
CREATE TABLE MovieGenres (
    MovieID INT,
    GenreID INT,
    PRIMARY KEY (MovieID, GenreID),
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID),
    FOREIGN KEY (GenreID) REFERENCES Genres(GenreID)
);

-- Insert sample data for MovieGenres
INSERT INTO MovieGenres (MovieID, GenreID) VALUES
(1, 2),  -- Inception -> Sci-Fi
(1, 1),  -- Inception -> Action
(2, 2),  -- The Matrix -> Sci-Fi
(2, 1),  -- The Matrix -> Action
(3, 4);  -- Interstellar -> Adventure

-- 5. Ratings Table
CREATE TABLE Ratings (
    RatingID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    MovieID INT,
    Rating INT CHECK (Rating >= 1 AND Rating <= 5),
    RatingDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID)
);

-- 6. UserPreferences Table
CREATE TABLE UserPreferences (
    PreferenceID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    GenreID INT,
    PreferenceLevel INT CHECK (PreferenceLevel >= 1 AND PreferenceLevel <= 5),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (GenreID) REFERENCES Genres(GenreID)
);

-- 7. Directors Table
CREATE TABLE Directors (
    DirectorID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL
);

-- Insert sample data for Directors
INSERT INTO Directors (Name) VALUES
('Christopher Nolan'),
('Lana Wachowski'),
('Lilly Wachowski');

-- 8. MovieDirectors Table (Many-to-Many Relationship between Movies and Directors)
CREATE TABLE MovieDirectors (
    MovieID INT,
    DirectorID INT,
    PRIMARY KEY (MovieID, DirectorID),
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID),
    FOREIGN KEY (DirectorID) REFERENCES Directors(DirectorID)
);

-- Insert sample data for MovieDirectors
INSERT INTO MovieDirectors (MovieID, DirectorID) VALUES
(1, 1),  -- Inception -> Christopher Nolan
(2, 2),  -- The Matrix -> Lana Wachowski
(2, 3);  -- The Matrix -> Lilly Wachowski

-- 9. Actors Table
CREATE TABLE Actors (
    ActorID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL
);

-- Insert sample data for Actors
INSERT INTO Actors (Name) VALUES
('Leonardo DiCaprio'),
('Keanu Reeves'),
('Matthew McConaughey');

-- 10. MovieActors Table (Many-to-Many Relationship between Movies and Actors)
CREATE TABLE MovieActors (
    MovieID INT,
    ActorID INT,
    PRIMARY KEY (MovieID, ActorID),
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID),
    FOREIGN KEY (ActorID) REFERENCES Actors(ActorID)
);

-- Insert sample data for MovieActors
INSERT INTO MovieActors (MovieID, ActorID) VALUES
(1, 1),  -- Inception -> Leonardo DiCaprio
(2, 2),  -- The Matrix -> Keanu Reeves
(3, 3);  -- Interstellar -> Matthew McConaughey

-- 11. WatchHistory Table
CREATE TABLE WatchHistory (
    WatchID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    MovieID INT,
    WatchDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID)
);

-- 12. Reviews Table
CREATE TABLE Reviews (
    ReviewID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    MovieID INT,
    ReviewText TEXT,
    ReviewDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID)
);

-- Insert sample data for Reviews
INSERT INTO Reviews (UserID, MovieID, ReviewText) VALUES
(1, 1, 'Inception is a mind-bending thriller!'),
(2, 2, 'The Matrix is a revolutionary sci-fi movie.'),
(3, 3, 'Interstellar is visually stunning and thought-provoking.');




----------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Now  Testing Queries for Movie Recommendation System

-- 1. Fetch all users
SELECT * FROM Users;

-- 2. Fetch all movies
SELECT * FROM Movies;

-- 3. Fetch all genres
SELECT * FROM Genres;

-- 4. Fetch all directors
SELECT * FROM Directors;

-- 5. Fetch all actors
SELECT * FROM Actors;

-- 6. Fetch all movies and their genres
SELECT M.Title, G.GenreName
FROM Movies M
JOIN MovieGenres MG ON M.MovieID = MG.MovieID
JOIN Genres G ON MG.GenreID = G.GenreID;

-- 7. Fetch all movies and their directors
SELECT M.Title, D.Name AS DirectorName
FROM Movies M
JOIN MovieDirectors MD ON M.MovieID = MD.MovieID
JOIN Directors D ON MD.DirectorID = D.DirectorID;

-- 8. Fetch all movies and their actors
SELECT M.Title, A.Name AS ActorName
FROM Movies M
JOIN MovieActors MA ON M.MovieID = MA.MovieID
JOIN Actors A ON MA.ActorID = A.ActorID;

-- 9. Fetch all reviews with the movie titles and user details
SELECT U.Username, M.Title, R.ReviewText, R.ReviewDate
FROM Reviews R
JOIN Users U ON R.UserID = U.UserID
JOIN Movies M ON R.MovieID = M.MovieID;

-- 10. Fetch the average rating for each movie
SELECT M.Title, AVG(R.Rating) AS AverageRating
FROM Ratings R
JOIN Movies M ON R.MovieID = M.MovieID
GROUP BY M.MovieID;

-- 11. Fetch watch history for each user with movie titles and watch dates
SELECT U.Username, M.Title, WH.WatchDate
FROM WatchHistory WH
JOIN Users U ON WH.UserID = U.UserID
JOIN Movies M ON WH.MovieID = M.MovieID;

-- 12. Fetch user preferences with genre names
SELECT U.Username, G.GenreName, UP.PreferenceLevel
FROM UserPreferences UP
JOIN Users U ON UP.UserID = U.UserID
JOIN Genres G ON UP.GenreID = G.GenreID;

-- 13. Fetch top 5 movies based on highest average ratings
SELECT M.Title, AVG(R.Rating) AS AverageRating
FROM Ratings R
JOIN Movies M ON R.MovieID = M.MovieID
GROUP BY M.MovieID
ORDER BY AverageRating DESC
LIMIT 5;

-- 14. Fetch all movies released after the year 2010
SELECT Title, ReleaseYear
FROM Movies
WHERE ReleaseYear > 2010;

-- 15. Fetch all movies by a specific director (e.g., Christopher Nolan)
SELECT M.Title, D.Name AS DirectorName
FROM Movies M
JOIN MovieDirectors MD ON M.MovieID = MD.MovieID
JOIN Directors D ON MD.DirectorID = D.DirectorID
WHERE D.Name = 'Christopher Nolan';