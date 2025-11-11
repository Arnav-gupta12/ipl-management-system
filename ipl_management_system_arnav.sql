create database ipl;
SHOW databases;
USE ipl;

CREATE TABLE Admin (
    Username VARCHAR(20) PRIMARY KEY,
    Password VARCHAR(10) NOT NULL
);

-- Player Table
CREATE TABLE Player (
    Player_id INT PRIMARY KEY,
    Player_name VARCHAR(30) NOT NULL
);

-- Player Details Table
CREATE TABLE Player_details (
    Player_name VARCHAR(30) PRIMARY KEY,
    Current_price INT,
    Matches INT,
    Runs INT,
    Batting_SR DECIMAL(5,2),
    Batting_AVG DECIMAL(5,2),
    Best INT,
    Wickets INT,
    Bowling_SR DECIMAL(5,2),
    Bowling_AVG DECIMAL(5,2),
    Team_name VARCHAR(50),
    Status VARCHAR(6) DEFAULT 'Unsold'
);

-- Team Table
CREATE TABLE Team (
    Team_name VARCHAR(50) PRIMARY KEY,
    Balance INT,
    Player_count INT,
    Captain VARCHAR(30)
);

-- Owners Table
CREATE TABLE Owners (
    Team_name VARCHAR(50) REFERENCES Team(Team_name),
    Owner_name VARCHAR(50),
    PRIMARY KEY (Team_name, Owner_name)
);



INSERT INTO Admin VALUES ('Chirag Jawa', '102203988');
INSERT INTO Admin VALUES ('Apoorav', '102203503');
INSERT INTO Admin VALUES ('Arnav', '102203749');
INSERT INTO Admin VALUES ('Ekasjot', '102203583');

-- Team Data
INSERT INTO Team VALUES ('RCB', 9500, 1, 'Virat Kohli');
INSERT INTO Team VALUES ('KKR', 9500, 1, 'Shreyas Iyer');

-- Player Details
INSERT INTO Player_details VALUES ('Virat Kohli', 1500, 210, 7300, 130.72, 48.67, 183, 5, 62.75, 29.1, 'RCB', 'Sold');
-- Add more players similarly...

-- Player Table
INSERT INTO Player VALUES (101, 'Virat Kohli');
-- Add more players similarly...

-- Owners
INSERT INTO Owners VALUES ('KKR', 'Shah Rukh Khan');
INSERT INTO Owners VALUES ('KKR', 'Juhi Chawla');
INSERT INTO Owners VALUES ('KKR', 'Jay Mehta');
INSERT INTO Owners VALUES ('RCB', 'Prathmesh Mishra');





DELIMITER $$

-- 1. PROCEDURE: Print Team Details
CREATE PROCEDURE print_team(IN tname VARCHAR(50))
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE team_balance INT;
    DECLARE player_count INT;
    DECLARE captain_name VARCHAR(50);

    DECLARE cur CURSOR FOR
        SELECT Balance, Player_count, Captain FROM Team WHERE Team_name = tname;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO team_balance, player_count, captain_name;
        IF done THEN
            LEAVE read_loop;
        END IF;

        SELECT CONCAT('Team: ', tname) AS Team,
               CONCAT('Balance: ', team_balance) AS Balance,
               CONCAT('Player Count: ', player_count) AS PlayerCount,
               CONCAT('Captain: ', captain_name) AS Captain;
    END LOOP;

    CLOSE cur;
END$$

-- 2. PROCEDURE: Print Player Details
DELIMITER $$

CREATE PROCEDURE print_player(IN p_name VARCHAR(30))
BEGIN
    SELECT * FROM Player_details WHERE Player_name = p_name;
END$$

DELIMITER ;

-- 3. PROCEDURE: Sell Player
DELIMITER $$

CREATE PROCEDURE sell_player(IN p_name VARCHAR(30))
BEGIN
    UPDATE Player_details 
    SET Status = 'Sold' 
    WHERE Player_name = p_name;

    IF ROW_COUNT() = 0 THEN
        SELECT 'Player not present in auction' AS message;
    ELSE
        SELECT CONCAT('Player successfully sold to ', Team_name) AS message
        FROM Player_details 
        WHERE Player_name = p_name;
    END IF;
END$$

DELIMITER ;

-- 4. PROCEDURE: Add Player
DELIMITER $$
CREATE PROCEDURE add_player(
    IN p_name VARCHAR(30),
    IN curr_price INT,
    IN matches INT,
    IN runs INT,
    IN bat_sr DECIMAL(5,2),
    IN bat_avg DECIMAL(5,2),
    IN best INT,
    IN wickets INT,
    IN bowl_sr DECIMAL(5,2),
    IN bowl_avg DECIMAL(5,2),
    IN team_name VARCHAR(50),
    IN p_type VARCHAR(20)
)
BEGIN
    INSERT INTO Player_details (
        Player_name, Current_price, Matches, Runs, Batting_SR, Batting_AVG,
        Best, Wickets, Bowling_SR, Bowling_AVG, Team_name, Status
    ) VALUES (
        p_name, curr_price, matches, runs, bat_sr, bat_avg,
        best, wickets, bowl_sr, bowl_avg, team_name, 'Unsold'
    );
END$$

-- 5. PROCEDURE: Register Bid
DELIMITER $$
CREATE PROCEDURE register_bid(IN p_name VARCHAR(30), IN new_price INT)
BEGIN
    DECLARE curr_price INT;

    SELECT Current_price INTO curr_price FROM Player_details WHERE Player_name = p_name;

    IF new_price <= curr_price THEN
        SELECT 'Bid not accepted' AS message;
    ELSE
        UPDATE Player_details SET Current_price = new_price WHERE Player_name = p_name;
        SELECT 'Bid registered successfully' AS message;
    END IF;
END$$

-- 6. TRIGGER: Auto insert into Player when new Player_details is added
DELIMITER $$
CREATE TRIGGER trg_auto_add_player
AFTER INSERT ON Player_details
FOR EACH ROW
BEGIN
    DECLARE new_id INT;

    SELECT IFNULL(MAX(Player_id), 100) + 1 INTO new_id FROM Player;
    INSERT INTO Player(Player_id, Player_name) VALUES (new_id, NEW.Player_name);
END$$

-- 7. TRIGGER: Update Team when Player is marked as Sold
DELIMITER $$
CREATE TRIGGER trg_team_update_on_sell
AFTER UPDATE ON Player_details
FOR EACH ROW
BEGIN
    IF NEW.Status = 'Sold' AND OLD.Status <> 'Sold' THEN
        UPDATE Team
        SET Balance = Balance - NEW.Current_price,
            Player_count = Player_count + 1
        WHERE Team_name = NEW.Team_name;
    END IF;
END$$

-- Reset back to default delimiter
DELIMITER ;






-- View all teams
SELECT * FROM Team;

-- View all players
SELECT * FROM Player_details;

-- View player IDs
SELECT * FROM Player;

-- View team owners


CALL add_player(
    'Rohit Sharma', 
    1800, 
    220, 
    7800, 
    132.55, 
    48.3, 
    109, 
    1, 
    72.1, 
    28.9, 
    'MI', 
    'Batsman'
);


SELECT * FROM Player_details WHERE Player_name = 'Rohit Sharma';
SELECT * FROM Player WHERE Player_name = 'Rohit Sharma';


CALL register_bid('Rohit Sharma', 2000);

CALL register_bid('Rohit Sharma', 1500);


CALL sell_player('Rohit Sharma');


SELECT * FROM Player_details WHERE Player_name = 'Rohit Sharma';
SELECT * FROM Team WHERE Team_name = 'MI';


CALL print_team('RCB');
CALL print_player('Virat Kohli');


CALL add_player(
    'Glenn Maxwell', 
    1600, 
    150, 
    4800, 
    145.25, 
    36.4, 
    95, 
    45, 
    48.3, 
    27.1, 
    'RCB', 
    'All-Rounder'
);



SELECT * FROM Player_details WHERE Player_name = 'Glenn Maxwell';
SELECT * FROM Player WHERE Player_name = 'Glenn Maxwell';



CALL register_bid('Glenn Maxwell', 1800);



CALL register_bid('Glenn Maxwell', 1500);  -- Should be rejected



CALL sell_player('Glenn Maxwell');


-- Player status update
SELECT * FROM Player_details WHERE Player_name = 'Glenn Maxwell';

-- RCB balance and player count update
SELECT * FROM Team WHERE Team_name = 'RCB';



-- Print Team Info
CALL print_team('RCB');

-- Print Player Info
CALL print_player('Glenn Maxwell');


