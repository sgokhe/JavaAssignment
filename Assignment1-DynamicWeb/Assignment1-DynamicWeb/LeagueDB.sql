--DROP TABLE GPAULLEY.ROSTER;
--DROP TABLE GPAULLEY.GAME;
--DROP TABLE GPAULLEY.PLAYERSTATS;
--DROP TABLE GPAULLEY.PLAYER;
--DROP TABLE GPAULLEY.TEAM;
--DROP TABLE GPAULLEY.STAFF;
--DROP TABLE GPAULLEY.ARENA;
--DROP TABLE GPAULLEY.SCHEDULE;
--DROP TABLE GPAULLEY.LEAGUE;

-- 1 A
select t.teamName, s.firstname || ', ' || s.lastname as HeadCoach,
	   s1.firstname || ' ' || s1.lastname as AsstCoach,
	   s2.firstname || ' ' || s2.lastname as Trainer,
	   s3.firstname || ' ' || s3.lastname as Manager
from gpaulley.team t join gpaulley.staff s
		on s.staffID = t.headCoach
	join gpaulley.staff s1
		on s1.staffID = t.asstCoach
	join  gpaulley.staff s2
		on s2.staffID = t.trainer
	join gpaulley.staff s3
		on s3.staffID = t.manager
order by teamname;

-- 1 B
SELECT FIRSTNAME, LASTNAME, TEAMNAME, POSITION, JERSEY
FROM GPAULLEY.TEAM t INNER JOIN GPAULLEY.ROSTER r
		ON t.TEAMID = r.TEAM
	JOIN gpaulley.player p
		ON p.playerID = r.player
ORDER BY jersey;

-- 1 C
Select OT, SO, ARENANAME, HOMESCORE, VISITORSCORE
FROM gpaulley.arena INNER JOIN GPAULLEY.GAME
	ON GPAULLEY.ARENA.arenaid = GPAULLEY.game.arena
WHERE OT='Y'AND SO='Y'
ORDER BY ARENANAME;

-- 1 D
Select VISITOR, HOME, ARENANAME, HOMESCORE, VISITORSCORE, TEAMNAME
FROM gpaulley.arena INNER JOIN GPAULLEY.GAME
		ON GPAULLEY.ARENA.arenaid = GPAULLEY.game.arena
	INNER JOIN GPAULLEY.TEAM
		ON GPAULLEY.game.home = GPAULLEY.team.teamid
WHERE HOMESCORE IS NULL
ORDER BY TEAMNAME;


CREATE TABLE GPAULLEY.LEAGUE
(
	leagueID CHAR(8) NOT NULL PRIMARY KEY,
	leagueName VARCHAR(40) NOT NULL,
	leagueSponsor VARCHAR(60)
);

CREATE TABLE GPAULLEY.PLAYER(
	playerID INT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	lastName VARCHAR(40) NOT NULL,
	firstName VARCHAR(40) NOT NULL,
	height DECIMAL(5,2),  /* Height in cm */
	weight DECIMAL(4,1),  /* Weight in kg */
	DOB DATE,
	school VARCHAR(75),
	streetAddress VARCHAR(50),
	city VARCHAR(40),
	state_province VARCHAR(30),
	postalCode VARCHAR(7),
	country VARCHAR(30),
	phone VARCHAR(13),
	mobile VARCHAR(13),
	email VARCHAR(100)
);

CREATE TABLE GPAULLEY.STAFF(
	staffID INT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	lastName VARCHAR(40) NOT NULL,
	firstName VARCHAR(40) NOT NULL,
	streetAddress VARCHAR(50),
	city VARCHAR(40),
	state_province VARCHAR(30),
	postalCode VARCHAR(7),
	country VARCHAR(30),
	phone VARCHAR(13),
	mobile VARCHAR(13),
	email VARCHAR(100),
	certification VARCHAR(100)	
);

CREATE TABLE GPAULLEY.ARENA
(
	arenaID INT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	arenaName VARCHAR(40) NOT NULL,
	streetAddress VARCHAR(50),
	city VARCHAR(30),
	state_province VARCHAR(30),
	postalCode CHAR(7),
	country VARCHAR(30),
	phone CHAR(10),
	capacity INT
);	

CREATE TABLE GPAULLEY.SCHEDULE 
(
	scheduleID INT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	league CHAR(8) NOT NULL,
	season VARCHAR(20),
	scheduleName VARCHAR(40),
	sponsor VARCHAR(40),
	CONSTRAINT schedule_league_fk
	    FOREIGN KEY (league)
	    REFERENCES GPAULLEY.LEAGUE(leagueID)
);

CREATE TABLE GPAULLEY.TEAM(
	teamID CHAR(6) NOT NULL PRIMARY KEY,
	league CHAR(8) NOT NULL,
	sponsor VARCHAR(30),
	teamName VARCHAR(50) NOT NULL,
	headCoach INT,
	asstCoach INT,
	trainer INT,
	manager INT,
	website VARCHAR(100),
	CONSTRAINT team_league_fk
	    FOREIGN KEY (league)
	    REFERENCES GPAULLEY.LEAGUE(leagueID),
	CONSTRAINT team_coach_fk
	    FOREIGN KEY (headCoach)
	    REFERENCES GPAULLEY.STAFF(staffID),
	CONSTRAINT team_asstcoach_fk
	    FOREIGN KEY (asstCoach)
	    REFERENCES GPAULLEY.STAFF(staffID),
	CONSTRAINT team_trainer_fk
	    FOREIGN KEY (trainer)
	    REFERENCES GPAULLEY.STAFF(staffID),
	CONSTRAINT team_manager_fk
	    FOREIGN KEY (manager)
	    REFERENCES GPAULLEY.STAFF(staffID)
);
	
CREATE TABLE GPAULLEY.GAME
(
 	gameID INT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	schedule INT NOT NULL,
	gameDate DATE NOT NULL,
	gameTime TIME NOT NULL,
	arena INT,
	home CHAR(6),
	visitor CHAR(6),
	homeScore INT,
	visitorScore INT,
	OT CHAR(1),
	SO CHAR(1),
	CONSTRAINT game_schedule_fk
	    FOREIGN KEY (schedule)
	    REFERENCES GPAULLEY.SCHEDULE(scheduleID),
	CONSTRAINT game_arena_fk
	    FOREIGN KEY (arena)
	    REFERENCES GPAULLEY.ARENA(arenaID),
	CONSTRAINT game_hometeam_fk
	    FOREIGN KEY (home)
	    REFERENCES GPAULLEY.TEAM(teamID),
	CONSTRAINT game_visitorteam_fk
	    FOREIGN KEY (visitor)
	    REFERENCES GPAULLEY.TEAM(teamID)
);


CREATE TABLE GPAULLEY.ROSTER(
	rosterID INT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	player INT NOT NULL,
	team CHAR(6) NOT NULL,
	position VARCHAR(15),
	jersey INT,	
	CONSTRAINT roster_player_fk
	    FOREIGN KEY (player)
	    REFERENCES GPAULLEY.PLAYER(playerID),
	CONSTRAINT roster_team_fk
	    FOREIGN KEY (team)
	    REFERENCES GPAULLEY.TEAM(teamID)
);

CREATE TABLE GPAULLEY.PLAYERSTATS(
	statsID INT NOT NULL GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	player INT NOT NULL,
	roster INT NOT NULL,
	schedule INT NOT NULL,
	GP INT,
	goals INT,
	assists INT,
	plusminus INT,
	PIM INT,
	PP INT,
	SH INT,
	GWG INT,
	shots INT,
	shotpct DECIMAL(5,2),
	suspensions INT,
	GAA DECIMAL(5,2),
	SO INT,
	CONSTRAINT stats_player_fk /* Redundant relationship */
	    FOREIGN KEY (player)
	    REFERENCES GPAULLEY.PLAYER(playerID),
	CONSTRAINT stats_schedule_fk
	    FOREIGN KEY (schedule)
	    REFERENCES GPAULLEY.SCHEDULE(scheduleID),
	CONSTRAINT stats_roster_fk
	    FOREIGN KEY (roster)
	    REFERENCES GPAULLEY.ROSTER(rosterID)
);

/* Insert team, player, roster, and staff information for various NHL teams */

INSERT INTO GPAULLEY.LEAGUE VALUES('NHL     ','National Hockey League', NULL );

INSERT INTO GPAULLEY.SCHEDULE( league, season, scheduleName )
    VALUES( 'NHL     ', '2014-2015', 'Regular season' );

/* Montreal Canadiens - 4 staff, 23 players */

ALTER TABLE GPAULLEY.STAFF ALTER COLUMN staffid RESTART WITH 20001;

INSERT INTO GPAULLEY.STAFF (lastName, firstName, city, state_province, country )
   VALUES( 'Therrien', 'Michel', 'Montreal', 'Quebec', 'Canada' );

INSERT INTO GPAULLEY.STAFF (lastName, firstName, city, state_province, country )
   VALUES( 'Daigneault', 'Jean-Jacques', 'Montreal', 'Quebec', 'Canada' );

INSERT INTO GPAULLEY.STAFF (lastName, firstName, city, state_province, country )
   VALUES( 'Bergevin', 'Marc', 'Montreal', 'Quebec', 'Canada' );

INSERT INTO GPAULLEY.STAFF (lastName, firstName, city, state_province, country )
   VALUES( 'Rynbend', 'Graham', 'Pointe Claire', 'Quebec', 'Canada' );

INSERT INTO GPAULLEY.TEAM VALUES( 'CAN002', 'NHL', NULL, 'Montreal Canadiens',
   20001, 20002, 20004, 20003, 'canadiens.nhl.com' );

ALTER TABLE GPAULLEY.PLAYER ALTER COLUMN playerid RESTART WITH 100001;
ALTER TABLE GPAULLEY.ROSTER ALTER COLUMN rosterid RESTART WITH 200001;

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Andrighetto', 'Sven', 175.26, 83.18, '1993-03-21', NULL,
    NULL, 'Zurich', NULL, NULL, 'Switzerland' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100001, 'CAN002', 'Right Wing', 58 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Bournival', 'Michael', 180.34, 88.64, '1992-05-31', NULL,
    NULL, 'Shawinigan', 'Quebec', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100002, 'CAN002', 'Left Wing', 49 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Desharnais', 'David', 170.18, 80, '1986-09-14', NULL,
    NULL, 'Laurier-Station', 'Quebec', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100003, 'CAN002', 'Centre', 51 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Eller', 'Lars', 188, 95, '1989-05-08', NULL,
    NULL, 'Rodovre', NULL, NULL, 'Denmark' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100004, 'CAN002', 'Centre', 81 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Galchenyuk', 'Alex', 185.4, 90.45, '1994-02-12', NULL,
    NULL, 'Milwaukee', 'Wisconsin', NULL, 'USA' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100005, 'CAN002', 'Centre', 27 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Gallagher', 'Brendan', 175, 82.73, '1992-02-12', NULL,
    NULL, 'Edmonton', 'Alberta', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100006, 'CAN002', 'Right Wing', 11 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Malhotra', 'Manny', 188, 94, '1980-05-18', NULL,
    NULL, 'Mississauga', 'Ontario', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100007, 'CAN002', 'Centre', 20 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Pacioretty', 'Max', 188, 97.3, '1988-11-20', 'University of Michigan',
    NULL, 'New Canaan', 'Connecticut', NULL, 'USA' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100008, 'CAN002', 'Left Wing', 67 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Parenteau', 'Pierre-Alexandre', 182.88, 89.55, '1983-03-24', NULL,
    NULL, 'Hull', 'Quebec', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100009, 'CAN002', 'Right Wing', 15 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Plekanec', 'Tomas', 180.3, 90, '1982-10-31', NULL,
    NULL, 'Kladno', NULL, NULL, 'Czech Republic' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100010, 'CAN002', 'Centre', 14 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Prust', 'Brandon', 182.88, 88.64, '1984-03-16', NULL,
    NULL, 'London', 'Ontario', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100011, 'CAN002', 'Left Wing', 8 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Sekac', 'Jiri', 188, 88.64, '1992-06-10', NULL,
    NULL, 'Kladno', NULL, NULL, 'Czech Republic' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100012, 'CAN002', 'Left Wing', 26 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Thomas', 'Christian', 175.3, 80, '1992-06-10', NULL,
    NULL, 'Toronto', 'Ontario', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100013, 'CAN002', 'Left Wing', 60 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Wiese', 'Dale', 188, 93.2, '1988-08-05', NULL,
    NULL, 'Winnipeg', 'Manitoba', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100014, 'CAN002', 'Right Wing', 22 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Beaulieu', 'Nathan', 188, 88.2, '1992-12-05', NULL,
    NULL, 'Strathroy', 'Ontario', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100015, 'CAN002', 'Defence', 28 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Emelin', 'Alexei', 188, 98.64, '1986-05-25', NULL,
    NULL, 'Togliatti', NULL, NULL, 'Russia' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100016, 'CAN002', 'Defence', 74 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Gilbert', 'Tom', 188, 92.7, '1983-01-10', 'University of Wisconsin',
    NULL, 'Bloomington', 'Minnesota', NULL, 'USA' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100017, 'CAN002', 'Defence', 77 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Gonchar', 'Sergei', 188, 95.5, '1974-05-13', NULL,
    NULL, 'Chelyabinsk', NULL, NULL, 'Russia' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100018, 'CAN002', 'Defence', 55 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Markov', 'Andrei', 182.9, 89.5, '1978-12-20', NULL,
    NULL, 'Voskresensk', NULL, NULL, 'Russia' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100019, 'CAN002', 'Defence', 79 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Subban', 'P. K.', 182.9, 97.3, '1989-05-13', NULL,
    NULL, 'Toronto', 'Ontario', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100020, 'CAN002', 'Defence', 76 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Weaver', 'Mike', 177.8, 84.55, '1978-05-02', NULL,
    NULL, 'Brampton', 'Ontario', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100021, 'CAN002', 'Defence', 43 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Price', 'Carey', 190.5, 98.18, '1987-08-16', NULL,
    NULL, 'Anahim Lake', 'British Columbia', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100022, 'CAN002', 'Goalie', 31 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Tokarski', 'Dustin', 180.34, 88.6, '1989-09-16', NULL,
    NULL, 'Watson', 'Saskatchewan', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100023, 'CAN002', 'Goalie', 35 );

/* Boston Bruins - 4 staff, 23 players */

ALTER TABLE GPAULLEY.STAFF ALTER COLUMN staffid RESTART WITH 20011;

INSERT INTO GPAULLEY.STAFF (lastName, firstName, city, state_province, country )
   VALUES( 'Julien', 'Claude', 'Blind River', 'Ontario', 'Canada' );

INSERT INTO GPAULLEY.STAFF (lastName, firstName, city, state_province, country )
   VALUES( 'Houda', 'Doug ', 'Blairmore', 'Alberta', 'Canada' );

INSERT INTO GPAULLEY.STAFF (lastName, firstName, city, state_province, country )
   VALUES( 'DelNegro', 'Don', 'Lynnfield', 'Massachusetts', 'USA' );

INSERT INTO GPAULLEY.STAFF (lastName, firstName, city, state_province, country )
   VALUES( 'Chiarelli', 'Peter', 'Nepean', 'Ontario', 'Canada' );

INSERT INTO GPAULLEY.TEAM VALUES( 'BRU001', 'NHL', NULL, 'Boston Bruins',
   20011, 20012, 20013, 20014, 'bruins.nhl.com' );

ALTER TABLE GPAULLEY.PLAYER ALTER COLUMN playerid RESTART WITH 100101;
ALTER TABLE GPAULLEY.ROSTER ALTER COLUMN rosterid RESTART WITH 200101;

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Bergeron', 'Patrice', 188, 88, '1988-06-04', NULL,
    NULL, 'Quebec City', 'Quebec', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100101, 'BRU001', 'Centre', 37 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Campbell', 'Gregory', 183, 89, '1983-12-17', NULL,
    NULL, 'Tillsonburg', 'Ontario', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100102, 'BRU001', 'Centre', 11);

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Caron', 'Jordan', 188, 92, '1990-11-02', NULL,
    NULL, 'Sayabec', 'Quebec', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100103, 'BRU001', 'Right Wing', 38 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Cunningham', 'Craig', 178, 83, '1990-09-13', NULL,
    NULL, 'Trail', 'British Columbia', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100104, 'BRU001', 'Right Wing', 61 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Eriksson', 'Loui', 188, 89, '1985-07-17', NULL,
    NULL, 'Goteborg', NULL, NULL, 'Sweden' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100105, 'BRU001', 'Right Wing', 21 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Kelly', 'Chris', 183, 90, '1980-11-11', NULL,
    NULL, 'Toronto', 'Ontario', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100106, 'BRU001', 'Centre', 23 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Krejci', 'David', 183, 80, '1986-04-28', NULL,
    NULL, 'Sternberk', NULL, NULL, 'Czech Republic' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100107, 'BRU001', 'Centre', 46 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Lucic', 'Milan', 188, 97.3, '1988-06-07', NULL,
    NULL, 'Vancouver', 'British Columbia', NULL, 'Ontario' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100108, 'BRU001', 'Left Wing', 17 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Marchand', 'Brad', 175, 83, '1988-05-11', NULL,
    NULL, 'Hammonds Plains', 'Nova Scotia', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100109, 'BRU001', 'Left Wing', 63 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Paille', 'Daniel', 183, 91, '1984-04-15', NULL,
    NULL, 'Welland', 'Ontario', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100110, 'BRU001', 'Left Wing', 20 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Pastrnak', 'David', 183, 76, '1996-05-25', NULL,
    NULL, 'Havirov', NULL, NULL, 'Czech Republic' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100111, 'BRU001', 'Right Wing', 88 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Savard', 'Marc', 178, 87, '1977-07-17', NULL,
    NULL, 'Peterborough', 'Ontario', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100112, 'BRU001', 'Centre', 91 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Smith', 'Reilly', 183, 84, '1991-04-01', NULL,
    NULL, 'Toronto', 'Ontario', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100113, 'BRU001', 'Right Wing', 18 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Soderberg', 'Carl', 191, 90, '1985-10-12', NULL,
    NULL, 'Malmo', NULL, NULL, 'Sweden' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100114, 'BRU001', 'Centre', 34 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Bartkowski', 'Matt', 185, 89, '1988-06-04', NULL,
    NULL, 'Pittsburg', 'Pennsylvania', NULL, 'USA' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100115, 'BRU001', 'Defence', 43 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Chara', 'Zdeno', 206, 116, '1977-03-18', NULL,
    NULL, 'Trencin', NULL, NULL, 'Slovakia' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100116, 'BRU001', 'Defence', 33 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Hamilton', 'Dougie', 196, 96, '1993-06-17', NULL,
    NULL, 'Toronto', 'Ontario', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100117, 'BRU001', 'Defence', 27 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Krug', 'Torey', 175, 82, '1991-04-12', NULL,
    NULL, 'Livonia', 'Michigan', NULL, 'USA' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100118, 'BRU001', 'Defence', 47 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'McQuaid', 'Adam', 196, 95, '1986-10-12', NULL,
    NULL, 'Cornwall', 'Prince Edward Island', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100119, 'BRU001', 'Defence', 54 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Miller', 'Kevan', 188, 95, '1987-11-15', NULL,
    NULL, 'Los Angeles', 'California', NULL, 'USA' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100120, 'BRU001', 'Defence', 86 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Seidenberg', 'Dennis', 185, 95, '1981-07-18', NULL,
    NULL, 'Villingen', NULL, NULL, 'Germany' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100121, 'BRU001', 'Defence', 44 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Rask', 'Tuukka', 191, 84, '1987-03-10', NULL,
    NULL, 'Tampere', NULL, NULL, 'Finland' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100122, 'BRU001', 'Goalie', 40 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Svedberg', 'Niklas', 185, 80, '1989-09-04', NULL,
    NULL, 'Sollentuna', NULL, NULL, 'Sweden' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100123, 'BRU001', 'Goalie', 72 );

/* Pittsburgh Penguins - 4 staff, 27 players */

ALTER TABLE GPAULLEY.STAFF ALTER COLUMN staffid RESTART WITH 20021;

INSERT INTO GPAULLEY.STAFF (lastName, firstName, city, state_province, country )
	VALUES('Johnston','Mike', 'Pittsburgh', 'Pennsylvania', 'United States');
	
INSERT INTO GPAULLEY.STAFF (lastName, firstName, city, state_province, country )
	VALUES('Tocchet','Rick', 'Pittsburgh', 'Pennsylvania', 'United States');
	
INSERT INTO GPAULLEY.STAFF (lastName, firstName, city, state_province, country )
	VALUES('Kadar','Mike', 'Pittsburgh', 'Pennsylvania', 'United States');
	
INSERT INTO GPAULLEY.STAFF (lastName, firstName, city, state_province, country )
	VALUES('Rutherford','Jim', 'Pittsburgh', 'Pennsylvania', 'United States');
	
INSERT INTO GPAULLEY.TEAM VALUES('PEN001', 'NHL', 'Lemieux Group L.P.', 'Pittsburgh Penguins',
		20021, 20022, 20023, 20024, 'penguins.nhl.com');
		
ALTER TABLE GPAULLEY.PLAYER ALTER COLUMN playerid RESTART WITH 100201;
ALTER TABLE GPAULLEY.ROSTER ALTER COLUMN rosterid RESTART WITH 200201;

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Adams', 'Craig', 182.8, 90.9, '1977-04-26', NULL,
    NULL, 'Seria', NULL, NULL, 'Brunei Darssalam' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100201, 'PEN001', 'Right Wing', 27 );
   
 INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Bennett', 'Beau', 188, 88.6, '1991-11-27', NULL,
    NULL, 'Gardena', 'California', NULL, 'USA' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100202, 'PEN001', 'Right Wing', 19 );  
 
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Comeau', 'Blake', 185.4, 91, '1986-02-18', NULL,
    NULL, 'Meadow Lake', 'Saskatchewan', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100203, 'PEN001', 'Right Wing', 17 );  
   
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Crosby', 'Sidney', 180.3, 91, '1987-08-07', NULL,
    NULL, 'Cole Harbour', 'Nova Scotia', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100204, 'PEN001', 'Center', 87 );   
   
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Downie', 'Steve', 180.3, 87, '1987-04-03', NULL,
    NULL, 'Newmarket', 'Ontario', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100205, 'PEN001', 'Right Wing', 23 );  
   
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Dupuis', 'Pascal', 185.4, 93.2, '1979-04-07', NULL,
    NULL, 'Laval', 'Quebec', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100206, 'PEN001', 'Right Wing', 9 );  
   
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Ebbett', 'Andrew', 175.2, 79.2, '1983-01-02', NULL,
    NULL, 'Vernon', 'British Columbia', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100207, 'PEN001', 'Right Wing', 25 );  
   
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Goc', 'Marcel', 185.4, 89, '1983-08-24', NULL,
    NULL, 'Claw', NULL, NULL, 'Germany' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100208, 'PEN001', 'Right Center', 57 );  
   
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Hornqvist', 'Patric', 180.34, 86, '1987-01-01', NULL,
    NULL, 'Sollentuna', NULL, NULL, 'Sweden' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100209, 'PEN001', 'Center', 72 ); 

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Kunitz', 'Chris', 182.88, 88.6, '1979-09-26', NULL,
    NULL, 'Regina', 'Saskatchewan', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100210, 'PEN001', 'Left Wing', 14 ); 

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Malkin', 'Evgeni', 190.5, 88.6, '1986-07-31', NULL,
    NULL, 'Magintogorsk', NULL, NULL, 'Russia' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100211, 'PEN001', 'Center', 71);   
   
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Parron', 'David', 182.9, 90.9, '1988-05-28', NULL,
    NULL, 'Regina', 'Saskatchewan', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100212, 'PEN001', 'Left Wing', 39 );   

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Rust', 'Bryan', 180.3, 87, '1992-05-11', NULL,
    NULL, 'Pontiac', 'Michigan', NULL, 'USA' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100213, 'PEN001', 'Right Wing', 36 );   

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Sill', 'Zach', 182.8, 91.6, '1988-05-24', NULL,
    NULL, 'Truro', 'Nova Scotia', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100214, 'PEN001', 'Center', 38 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Spaling', 'Nick', 185.4, 91, '1988-09-19', NULL,
    NULL, 'Palmerston', 'Ontario', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100215, 'PEN001', 'Center', 13 );   
   
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Sutter', 'Brandon', 190.5, 86.4, '1989-02-14', NULL,
    NULL, 'Huntington', 'New York', NULL, 'USA' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100216, 'PEN001', 'Center', 16 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Wilson', 'Scott', 180.34, 82.8, '1992-04-24', NULL,
    NULL, 'Oakville', 'Ontario', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100217, 'PEN001', 'Center', 43 );  
   
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Bortuzzo', 'Robert', 193.04, 97.7, '1989-03-18', NULL,
    NULL, 'Thunder Bay', 'Ontario', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100218, 'PEN001', 'Defence', 41 );     
   
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Chorney', 'Taylor', 185.4, 86, '1987-04-27', NULL,
    NULL, 'Thunder Bay', 'Ontario', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100219, 'PEN001', 'Defence', 44 );   
   
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Despres', 'Simon', 193.04, 97.5, '1991-07-27', NULL,
    NULL, 'Laval', 'Quebec', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100220, 'PEN001', 'Defence', 47 );   
   
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Ehrhoff', 'Christian', 187.9, 93.18, '1982-07-06', NULL,
    NULL, 'Moers', NULL, NULL, 'Germany' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100221, 'PEN001', 'Defence', 10 );   
   
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Letang', 'Kris', 182.88, 91, '1987-04-24', NULL,
    NULL, 'Montreal', 'Quebec', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100222, 'PEN001', 'Defence', 58 );   
   
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Maatta', 'Olli', 187.9, 93.4, '1994-08-22', NULL,
    NULL, 'Jyvaskyla', NULL, NULL, 'Finland' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100223, 'PEN001', 'Defence', 3 );
   
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Martin', 'Paul', 185.4, 90.9, '1981-03-05', NULL,
    NULL, 'Minneapolis', 'Minnesota', NULL, 'USA' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100224, 'PEN001', 'Defence', 7 );   
   
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Scuderi', 'Rob', 185.4, 96, '1978-12-30', NULL,
    NULL, 'Syosset', 'New York', NULL, 'USA' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100225, 'PEN001', 'Defence', 4 );     
   
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Fleury', 'Marc-Andre', 187.9, 81.8, '1984-11-28', NULL,
    NULL, 'Sorel', 'Quebec', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100226, 'PEN001', 'Goalie', 29 );     
   
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Greiss', 'Thomas', 185.4, 100, '1986-01-29', NULL,
    NULL, 'Fussen', NULL, NULL, 'Germany' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100227, 'PEN001', 'Goalie', 1);    

/* Vancouver Canucks - 4 staff, 23 players */

ALTER TABLE GPAULLEY.STAFF ALTER COLUMN staffid RESTART WITH 20031;

INSERT INTO GPAULLEY.STAFF (lastName, firstName, city, state_province, country )
   VALUES( 'Desjardins', 'Willie', 'Climax', 'Saskatchewan', 'Canada' );
INSERT INTO GPAULLEY.STAFF (lastName, firstName, city, state_province, country )
   VALUES( 'Lidster', 'Doug', 'Kamloops', 'British Columbia', 'Canada' );
INSERT INTO GPAULLEY.STAFF (lastName, firstName, city, state_province, country )
   VALUES( 'Burnstein', 'Mike', NULL, NULL, NULL );
INSERT INTO GPAULLEY.STAFF (lastName, firstName, city, state_province, country )
	VALUES( 'Benning', 'Jim', 'Edmonton', 'Alberta', 'Canada' );
	
INSERT INTO GPAULLEY.TEAM VALUES( 'CAN001', 'NHL', NULL, 'Vancouver Canucks',
   20031, 20032, 20033, 20034, 'canucks.nhl.com' );
   
ALTER TABLE GPAULLEY.PLAYER ALTER COLUMN playerid RESTART WITH 100301;
ALTER TABLE GPAULLEY.ROSTER ALTER COLUMN rosterid RESTART WITH 200301;

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Bieksa', 'Kevin', 185, 93, '1981-06-16', NULL,
    NULL, 'Grimsby', 'Ontario', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) 
	VALUES ( 100301, 'CAN001', 'Defence', 3 );
	
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Bonino', 'Nick', 185, 86, '1988-04-20', NULL,
    NULL, 'Hartford', 'Connecticut', NULL, 'USA' );
	
INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) 
	VALUES ( 100302, 'CAN001', 'Center', 13 );
	
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Burrows', 'Alex', 185, 85, '1981-04-11', NULL,
    NULL, 'Pincourt', 'Quebec', NULL, 'Canada' );
	
INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) 
	VALUES ( 100303, 'CAN001', 'Right Wing', 14 );
	
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Corrado', 'Frank', 183, 86, '1993-06-26', NULL,
    NULL, 'Toronto', 'Ontario', NULL, 'Canada' );
	
INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) 
	VALUES ( 100304, 'CAN001', 'Defence', 26 );
	
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Dorsett', 'Derek', 183, 87, '1986-12-20', NULL,
    NULL, 'Kindersley', 'Saskatchewan', NULL, 'Canada' );
	
INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) 
	VALUES ( 100305, 'CAN001', 'Right Wing', 51 );
	
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Edler', 'Alexander', 191, 98, '1986-04-21', NULL,
    NULL, 'Ostersund', NULL , NULL, 'Sweden' );
	
INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) 
	VALUES ( 100306, 'CAN001', 'Defence', 23 );
	
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Hamhuis', 'Dan', 185 , 95 , '1982-12-13', NULL,
    NULL, 'Smithers', 'British Columbia' , NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) 
	VALUES ( 100307, 'CAN001', 'Defence', 2 );
	
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Hansen', 'Jannik', 185 , 88 , '1986-03-15', NULL,
    NULL, 'Herlev', NULL , NULL, 'Denmark' );
	
INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) 
	VALUES ( 100308, 'CAN001', 'Defence', 36 );
	
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Higgins', 'Chris', 183 , 92 , '1983-06-02', NULL,
    NULL, 'Smithtown', 'New York' , NULL, 'USA' );
	
INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) 
	VALUES ( 100309, 'CAN001', 'Left Wing', 20 );
	
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Horvat', 'Bo', 183 , 92 , '1995-04-05', NULL,
    NULL, 'London', 'Ontario' , NULL, 'Canada' );
	
INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) 
	VALUES ( 100310, 'CAN001', 'Center', 53 );
	
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Kassian', 'Zack', 191 , 97 , '1991-01-24', NULL,
    NULL, 'Windsor', 'Ontario' , NULL, 'Canada' );
	
INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) 
	VALUES ( 100311, 'CAN001', 'Right Wing', 9 );
	
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Lack', 'Eddie', 193 , 83 , '1988-01-05', NULL,
    NULL, 'Norrtalje', NULL , NULL, 'Sweden' );
	
INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) 
	VALUES ( 100312, 'CAN001', 'Goalie', 31 );
	
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Matthias', 'Shawn', 191 , 96 , '1988-02-19', NULL,
    NULL, 'Mississauga', 'Ontario' , NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) 
	VALUES ( 100313, 'CAN001', 'Center', 27 );
	
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Miller', 'Ryan', 188 , 76 , '1980-07-17', NULL,
    NULL, 'East Lansing', 'Michigan' , NULL, 'USA' );
	
INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) 
	VALUES ( 100314, 'CAN001', 'Goalie', 30 );
	
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Richardson', 'Brad', 180 , 81 , '1985-02-04', NULL,
    NULL, 'Belleville', 'Ontario' , NULL, 'Canada' );
	
INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) 
	VALUES ( 100315, 'CAN001', 'Right Wing', 15 );
	
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Sbisa', 'Luca', 188 , 93 , '1990-01-30', NULL,
    NULL, 'Ozieri', NULL , NULL, 'Italy' );
	
INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) 
	VALUES ( 100316, 'CAN001', 'Defence', 5 );
	
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Sedin', 'Daniel', 185 , 85 , '1980-09-26', NULL,
    NULL, 'Ornskoldsvik', NULL , NULL, 'Sweden' );
	
INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) 
	VALUES ( 100317, 'CAN001', 'Left Wing', 22 );
	
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Sedin', 'Henrik', 188 , 85 , '1980-09-26', NULL,
    NULL, 'Ornskoldsvik', NULL , NULL, 'Sweden' );
	
INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) 
	VALUES ( 100318, 'CAN001', 'Center', 33 );
	
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Stanton', 'Ryan', 185 , 86 , '1989-07-20', NULL,
    NULL, 'St. Albert', 'Alberta' , NULL, 'Canada' );
	
INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) 
	VALUES ( 100319, 'CAN001', 'Defence', 18 );
	
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Tanev', 'Chris', 188 , 87 , '1989-12-20', NULL,
    NULL, 'East York', 'Ontario' , NULL, 'Canada' );
	
INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) 
	VALUES ( 100320, 'CAN001', 'Defence', 8 );
	
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Vey', 'Linden', 180 , 80 , '1991-07-17', NULL,
    NULL, 'Wakaw', 'Saskatchewan' , NULL, 'Canada' );
	
INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) 
	VALUES ( 100321, 'CAN001', 'Right Wing', 7 );
	
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Vrbata', 'Radim', 185 , 86 , '1981-06-13', NULL,
    NULL, 'Mlada Boleslav', NULL , NULL, 'Czechoslovakia' );
	
INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) 
	VALUES ( 100322, 'CAN001', 'Right Wing', 17 );
	
INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Weber', 'Yannick', 180 , 90 , '1988-09-23', NULL,
    NULL, 'Morges', NULL , NULL, 'Switzerland' );
	
INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) 
	VALUES ( 100323, 'CAN001', 'Defence', 6 );

/* Toronto Maple Leafs - 4 staff, 23 players */

ALTER TABLE GPAULLEY.STAFF ALTER COLUMN staffid RESTART WITH 20041;

INSERT INTO GPAULLEY.STAFF (lastName, firstName, city, state_province, country )
   VALUES( 'Horachek', 'Peter', 'Toronto', 'Toronto', 'Canada' );

INSERT INTO GPAULLEY.STAFF (lastName, firstName, city, state_province, country )
   VALUES( 'Spott', 'Steve', 'Toronto', 'Toronto', 'Canada' );

INSERT INTO GPAULLEY.STAFF (lastName, firstName, city, state_province, country )
   VALUES( 'Ayotte', 'Paul', 'Toronto', 'Toronto', 'Canada' );

INSERT INTO GPAULLEY.STAFF (lastName, firstName, city, state_province, country )
   VALUES( 'Nonis', 'Dave', 'Toronto', 'Toronto', 'Canada' );

INSERT INTO GPAULLEY.TEAM VALUES( 'LFS001', 'NHL', NULL, 'Toronto Maple Leafs',
   20041, 20042, 20043, 20044, 'mapleleafs.nhl.com' );

ALTER TABLE GPAULLEY.PLAYER ALTER COLUMN playerid RESTART WITH 100401;
ALTER TABLE GPAULLEY.ROSTER ALTER COLUMN rosterid RESTART WITH 200401;

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Ashton', 'Carter', 192.02, 97.52, '1993-04-1', NULL,
    NULL, 'Winnipeg', 'Manitoba', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100401, 'LFS001', 'Right Wing', 37 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Booth', 'David', 182.88, 96.16, '1984-11-24', NULL,
    NULL, 'Detroit', 'Michigan', NULL, 'USA' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100402, 'LFS001', 'Left Wing', 20 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Bozak', 'Tyler', 185.18, 90.23, '1986-03-19', NULL,
    NULL, 'Regina', 'Saskatchewan', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100403, 'LFS001', 'Centre', 42 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Clarkson', 'David', 185.18, 92.32, '1984-05-08', NULL,
    NULL, 'Toronto', 'Ontario', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100404, 'LFS001', 'Right Wing', 71 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Holland', 'Peter', 185.34, 91.45, '1991-02-12', NULL,
    NULL, 'Toronto', 'Ontario', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100405, 'LFS001', 'Centre', 24 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Kadri', 'Nazem', 182.01, 85.73, '1990-01-12', NULL,
    NULL, 'London', 'Ontario', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100406, 'LFS001', 'Right Wing', 43 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Komarov', 'Leo', 178.25, 94.25, '1987-05-18', NULL,
    NULL, 'Madison', 'Wisconsin', NULL, 'USA' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100407, 'LFS001', 'Centre', 47 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Lupul', 'Joffrey', 182.24, 89.3, '1983-09-20', NULL,
    NULL, 'Fort Saskatchewan', 'Alberta', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100408, 'LFS001', 'Left Wing', 19 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'McKegg', 'Greg', 182.88, 88.55, '1992-06-24', NULL,
    NULL, 'St. Thomas', 'Ontario', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100409, 'LFS001', 'Centre', 36 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Panik', 'Richard', 182.32, 90.23, '1991-02-07', NULL,
    NULL, 'Martin', NULL, NULL, 'Slovakia' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100410, 'LFS001', 'Right Wing', 18 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Santorelli', 'Mike', 183.88, 90.64, '1985-03-16', NULL,
    NULL, 'Vancouver', 'British Columbia', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100411, 'LFS001', 'Centre', 25 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Winnik', 'Daniel', 188.36, 88.64, '1985-07-10', NULL,
    NULL, 'Toronto', 'Ontario', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100412, 'LFS001', 'Centre', 26 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Van Riemsdyk', 'James', 175.3, 80, '1989-01-10', NULL,
    NULL, 'Middletown', 'New Jersey', NULL, 'USA' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100413, 'LFS001', 'Left Wing', 21 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Franson', 'Cody', 188.21, 93.2, '1988-08-05', NULL,
    NULL, 'Sicamous', 'British Columbia', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100414, 'LFS001', 'Defence', 4 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Gardiner', 'Jake', 188.21, 82.2, '1990-12-03', NULL,
    NULL, 'Minnetonka', 'Minnesota', NULL, 'USA' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100415, 'LFS001', 'Defence', 51 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Holzer', 'Korbinian', 192.25, 98.64, '1988-03-25', NULL,
    NULL, 'Munich', NULL, NULL, 'Germany' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100416, 'LFS001', 'Defence', 55 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Phaneuf', 'Dion', 192.21, 92.7, '1985-01-10', NULL,
    NULL, 'Edmonton', 'Alberta', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100417, 'LFS001', 'Defence', 3 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Polak', 'Roman', 187.21, 95.5, '1986-05-13', NULL,
    NULL, 'Ostrava', NULL, NULL, 'Czech Republic' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100418, 'LFS001', 'Defence', 46 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Rielly', 'Morgan', 183.9, 89.5, '1994-12-20', NULL,
    NULL, 'Vancouver', 'British Columbia', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100419, 'LFS001', 'Defence', 44 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Robidas', 'Stephane', 182.9, 97.3, '1977-02-13', NULL,
    NULL, 'Sherbrooke', 'Quebec', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100420, 'LFS001', 'Defence', 12 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Bernier', 'Jonathan', 180.8, 84.55, '1988-05-02', NULL,
    NULL, 'Laval', 'Quebec', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100421, 'LFS001', 'Goalie', 45 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Reimer', 'James', 190.5, 98.18, '1988-08-16', NULL,
    NULL, 'Morweena', 'Manitoba ', NULL, 'Canada' );

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100422, 'LFS001', 'Goalie', 34 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Kessel', 'Phil', 182.25, 90.25, '1987-05-18', NULL,
    NULL, 'Madison', 'Wisconsin', NULL, 'USA' );
	   
INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100423, 'LFS001', 'Right Wing', 81 );

INSERT INTO GPAULLEY.PLAYER ( lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Granberg', 'Petter', 192, 96.25, '1992-08-22', NULL,
    NULL, 'Gallivare', NULL, NULL, 'Sweden' );
	   
INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   ( 100424, 'LFS001', 'Right Wing', 8 );

/* Detroit Red Wings */

-- staff table - 1 row for the coach, assistant coach, trainer, and general manager

ALTER TABLE GPAULLEY.STAFF ALTER COLUMN staffid RESTART WITH 20051;

INSERT INTO GPAULLEY.STAFF (lastName, firstName, city, state_province, country )
   VALUES( 'Babcock', 'Mike', 'Manitouwadge', 'Ontario', 'USA' );

INSERT INTO GPAULLEY.STAFF (lastName, firstName, city, state_province, country )
   VALUES( 'Granato', 'Tony', 'Downers Grove', 'Illinois', 'USA' );
 
INSERT INTO GPAULLEY.STAFF (lastName, firstName, city, state_province, country )
   VALUES( 'VanZant', 'Piet', 'Detroit', 'Michigan', 'USA' );

INSERT INTO GPAULLEY.STAFF (lastName, firstName, city, state_province, country )
   VALUES( 'Holland', 'Ken', 'Vernon', 'British Columbia', 'Canada' );

INSERT INTO GPAULLEY.TEAM VALUES( 'RDW001', 'NHL', 'Flagstar Bank', 'Detroit Red Wings',
   20051, 20052, 20053, 20054, 'redwings.nhl.com' );

ALTER TABLE GPAULLEY.PLAYER ALTER COLUMN playerid RESTART WITH 100501;
ALTER TABLE GPAULLEY.ROSTER ALTER COLUMN rosterid RESTART WITH 200501;

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES('Abdelkader', 'Justin', 187.96, 98, '1987-02-25', NULL,
    NULL, 'Muskegon', 'Michigan', NULL, 'USA');
    
INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   (100501, 'RDW001', 'Left Wing', 8);
    
    
INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES('Andersson', 'Joakim', 187.96, 95, '1989-02-05', NULL,
    NULL, 'Munkedal', NULL, NULL, 'Sweden');
    
INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   (100502, 'RDW001', 'Centre', 18);
   
  
INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES('Cleary', 'Daniel', 185.42, 92, '1978-12-18', NULL,
    NULL, 'Carbonear', 'Newfoundland and Labrador', NULL, 'Canada');   

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   (100503, 'RDW001', 'Right Wing', 11);
   

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES('Datsyuk', 'Pavel', 180.34, 87, '1978-07-20', NULL,
    NULL, 'Sverdlovsk', NULL, NULL, 'Russia');   
  
 INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   (100504, 'RDW001', 'Centre', 13);
  
    
INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES('Franzen', 'Johan', 193.04, 105, '1979-02-05', NULL,
    NULL, 'Vetlanda', NULL, NULL, 'Sweden');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   (100505, 'RDW001', 'Right Wing', 93);
   

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES('Glendening', 'Luke', 180.34, 87, '1989-04-28', NULL,
    NULL, 'Grand Rapids', 'Michigan', NULL, 'USA');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   (100506, 'RDW001', 'Centre', 41);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES('Helm', 'Darren', 182.88, 89, '1987-01-21', NULL,
    NULL, 'St. Andrews', 'Manitoba', NULL, 'Canada');
    
INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   (100507, 'RDW001', 'Centre', 43);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES('Jurco', 'Tomas', 185.42, 92, '1992-12-28', NULL,
    NULL, 'Kosice', NULL, NULL, 'Slovakia');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   (100508, 'RDW001', 'Right Wing', 26);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES('Miller', 'Drew', 187.96, 81, '1984-02-17', NULL,
    NULL, 'Dover', 'New Jersey', NULL, 'USA');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   (100509, 'RDW001', 'Left Wing', 20);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES('Nyquist', 'Gustav', 180.34, 83, '1989-09-01', NULL,
    NULL, 'Halmstad', NULL, NULL, 'Sweden');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   (100510, 'RDW001', 'Right Wing', 14);
   
INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES('Pulkkinen', 'Teemu', 180.34, 83, '1992-01-02', NULL,
    NULL, 'Vantaa', NULL, NULL, 'Fin');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   (100511, 'RDW001', 'Left Wing', 56);
   
INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES('Sheahan', 'Riley', 190.5, 100, '1991-12-07', NULL,
    NULL, 'St. Catharines', 'Ontario', NULL, 'Canada');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   (100512, 'RDW001', 'Centre', 15);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES('Tatar', 'Tomas', 177.8, 83, '1990-12-01', NULL,
    NULL, 'Ilava', NULL, NULL, 'Slovakia');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   (100513, 'RDW001', 'Left Wing', 21);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES('Weiss', 'Stephen', 182.88, 88, '1983-04-03', NULL,
    NULL, 'Toronto', 'Ontario', NULL, 'Canada');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   (100514, 'RDW001', 'Centre', 90);
   
INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES('Zetterberg', 'Henrik', 182.88, 88, '1980-10-09', NULL,
    NULL, 'Njurunda', NULL, NULL, 'Sweden');
    
INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   (100515, 'RDW001', 'Left Wing', 40);

--Defencemen

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES('DeKeyser', 'Danny', 190.5, 86, '1990-03-07', NULL,
    NULL, 'Detroit', 'Michigan', NULL, 'USA');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   (100516, 'RDW001', 'Defence', 65);
   
INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES('Ericsson', 'Jonathan', 193.04, 99, '1984-03-02', NULL,
    NULL, 'Karlskrona', NULL, NULL, 'Sweden');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   (100517, 'RDW001', 'Defence', 52);
   
INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES( 'Kindl', 'Jakub', 190.5, 90, '1987-02-10', NULL,
    NULL, 'Sumperk', NULL, NULL, 'Czech Republic');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   (100518, 'RDW001', 'Defence', 4);
   
INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES('Kronwall', 'Niklas', 182.88, 87, '1981-01-12', NULL,
    NULL, 'Stockholm', NULL, NULL, 'Sweden');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   (100519, 'RDW001', 'Defence', 55);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES('Lashoff', 'Brian', 190.5, 100, '1990-05-16', NULL,
    NULL, 'Albany', 'New York', NULL, 'USA');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   (100520, 'RDW001', 'Defence', 23);
   
INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES('Ouellet', 'Xavier', 185.42, 90, '1993-05-29', NULL,
    NULL, 'Bayonne', NULL, NULL, 'France');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   (100521, 'RDW001', 'Defence', 61);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES('Quincey', 'Kyle', 187.96, 97, '1985-08-12', NULL,
    NULL, 'Kitchener', 'Ontario', NULL, 'Canada');
    
INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   (100522, 'RDW001', 'Defence', 27);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES('Smith', 'Brendan', 187.96, 95, '1989-02-08', NULL,
    NULL, 'Mimico', 'Ontario', NULL, 'Canada');
    
INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   (100523, 'RDW001', 'Defence', 2);

--Goaltenders

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES('Gustavsson', 'Jonas', 193.04, 96, '1984-10-24', NULL,
    NULL, 'Danderyd', NULL, NULL, 'Sweden');
    
INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   (100524, 'RDW001', 'Goalie', 50);
   
INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES('Howard', 'Jimmy', 185.42, 98, '1984-03-26', NULL,
    NULL, 'Syracuse', 'New York', NULL, 'USA');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   (100525, 'RDW001', 'Goalie', 35);    

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES('McCollum', 'Tom', 187.96, 102, '1989-12-07', NULL,
    NULL, 'Amherst', 'New York', NULL, 'USA');
    
INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   (100526, 'RDW001', 'Goalie', 38);  
    
INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
  VALUES('Mrazek', 'Petr', 187.96, 102, '1992-02-14', NULL,
    NULL, 'Ostrava', NULL, NULL, 'Czech Republic');
    
INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES
   (100527, 'RDW001', 'Goalie', 34);  

/* Chicago Blackhawks */

ALTER TABLE GPAULLEY.STAFF ALTER COLUMN staffid RESTART WITH 20061;

INSERT INTO GPAULLEY.STAFF (lastName, firstName, city, state_province, country )
  VALUES( 'Bowman', 'Stan', 'Montreal', 'Quebec', 'Canada'
);

INSERT INTO GPAULLEY.STAFF (lastName, firstName, city, state_province, country )
  VALUES ( 'Quenneville', 'Joel', 'Windsor', 'Ontario', 'Canada'
);

INSERT INTO GPAULLEY.STAFF (lastName, firstName, city, state_province, country )
  VALUES( 'Dineen', 'Kevin', 'Montreal', 'Quebec', 'Canada'
);

INSERT INTO GPAULLEY.STAFF (lastName, firstName, city, state_province, country )
  VALUES ( 'Goodman', 'Paul', 'Madison', 'Wisconsin', 'USA'
);

INSERT INTO GPAULLEY.TEAM VALUES (
  'BLK001', 'NHL', 'Quill.com', 'Chicago Blackhawks', 20062, 20063, 20064, 20061, 'blackhawks.nhl.com'
);

ALTER TABLE GPAULLEY.PLAYER ALTER COLUMN playerid RESTART WITH 100601;
ALTER TABLE GPAULLEY.ROSTER ALTER COLUMN rosterid RESTART WITH 200601;

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
VALUES (
  'Bickell', 'Bryan', 195.07, 101.36, '1986-03-09',
  null, null, 'Bowmanville', 'Ontario', null, 'Canada' );

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
VALUES (
  'Carcillo', 'Daniel', 182.22, 90.09, '1985-01-28',
  null, null, 'King City', 'Ontario', null, 'Canada'
);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
VALUES (
  'Hossa', 'Marian', 185.93, 94.09, '1979-01-12',
  null, null, 'Stara Lubovna', null, null, 'Slovakia'
);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
VALUES (
 'Kane', 'Patrick', 155.75, 80.45, '1988-11-19',
  null, null, 'Buffalo', 'New York', null, 'USA');

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
VALUES (
  'Kruger', 'Marcus', 182.22, 84.54, '1990-05-27',
  null, null, 'Stockholm', null, null, 'Sweden'
);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
VALUES (
  'Nordstrom', 'Joakim', 185.93, 85.91, '1992-02-25',
  null, null, 'Stockholm', null, null, 'Sweden'
);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
VALUES (
  'Richards', 'Brad', 182.22, 90.91, '1980-05-02',
  null, null, 'Murray Harbour', 'Prince Edward Island', null, 'Canada'
);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
VALUES (
  'Saad', 'Brandon', 185.93, 92.73, '1992-10-27',
  null, null, 'Pittsburgh', 'Pennsylvannia', null, 'USA'
);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
VALUES (
  'Sharp', 'Patrick', 185.93, 90, '1981-12-27',
  null, null, 'Winnipeg', 'Manitoba', null, 'Canada'
);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
VALUES (
  'Shaw', 'Andrew', 155.75, 81.36, '1991-07-20',
  null, null, 'Belleville', 'Ontario', null, 'Canada'
);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
VALUES (
  'Smith', 'Ben', 155.75, 90.45, '1988-07-11',
  'Boston College', null, 'Winston-Salem', 'North Carolina', null, 'USA'
);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
VALUES (
  'Teravainen', 'Teuvo', 155.75, 80.91, '1994-09-11',
  null, null, 'Helsinki', null, null, 'Finland'
);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
VALUES (
  'Toews', 'Jonathan', 188.97, 91.36, '1988-04-29',
  'University of North Dakota', null, 'Winnipeg', 'Manitoba', null, 'Canada'
);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
VALUES (
  'Versteeg', 'Kris', 155.75, 80, '1986-05-13',
  null, null, 'Lethbridge', 'Alberta', null, 'Canada'
);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
VALUES (
  'Erixon', 'Tim', 188.97, 90.91, '1991-02-24',
  null, null, 'Port Chester', 'New York', null, 'USA'
);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
VALUES (
  'Hjalmarsson', 'Niklas', 192.02, 89.54, '1987-06-06',
  null, null, 'Eksjo', null, null, 'Sweden'
);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
VALUES (
  'Keith', 'Duncan', 185.92, 87.27, '1983-07-16',
  null, null, 'Winnipeg', 'Manitoba', null, 'Canada'
);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
VALUES (
  'Oduya', 'Johnny', 182.88, 85.45, '1981-10-01',
  null, null, 'Stockholm', null, null, 'Sweden'
);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
VALUES (
  'Rozsival', 'Michal', 185.92, 95.45, '1978-09-03',
  null, null, 'Vlasim', null, null, 'Czech Republic'
);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
VALUES (
  'Rundblad', 'David', 188.97, 85, '1990-10-08',
  null, null, 'Lycksele', null, null, 'Sweden'
);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
VALUES (
  'Seabrook', 'Brent', 192.02, 100.0, '1985-04-20',
  null, null, 'Richmond', 'British Columbia', null, 'Canada'
);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
VALUES (
  'Van Riemsdyk', 'Trevor', 188.97, 85.45, '1991-07-24',
  null, null, 'Middletown', 'New Jersey', null, 'USA'
);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
VALUES (
  'Crawford', 'Corey', 188.97, 98.18, '1984-12-31',
  null, null, 'Montreal', 'Quebec', null, 'Canada'
);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, school,
    streetAddress, city, state_province, postalCode, country )
VALUES (
  'Raanta', 'Antti', 182.22, 87.73, '1989-05-12',
  null, null, 'Rauma', null, null, 'Finland'
);

-- Insert roster
INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES (
  100601, 'BLK001', 'Left Wing', 29
);

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES (
  100602, 'BLK001', 'Left Wing', 13
);

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES (
  100603, 'BLK001', 'Right Wing', 81
);

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES (
  100604, 'BLK001', 'Right Wing', 88
);

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES (
  100605, 'BLK001', 'Centre', 16
);

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES (
  100606, 'BLK001', 'Centre', 42
);

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES (
  100607, 'BLK001', 'Centre', 91
);

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES (
  100608, 'BLK001', 'Left Wing', 20
);

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES (
  100609, 'BLK001', 'Left Wing', 10
);

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES (
  100610, 'BLK001', 'Centre', 65
);

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES (
  100611, 'BLK001', 'Right Wing', 28
);

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES (
  100612, 'BLK001', 'Centre', 86
);

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES (
  100613, 'BLK001', 'Centre', 19
);

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES (
  100614, 'BLK001', 'Left Wing', 23
);

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES (
  100615, 'BLK001', 'Defence', 34
);

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES (
  100616, 'BLK001', 'Defence', 4
);

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES (
  100617, 'BLK001', 'Defence', 2
);

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES (
  100618, 'BLK001', 'Defence', 27
);

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES (
  100619, 'BLK001', 'Defence', 32
);

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES (
  100620, 'BLK001', 'Defence', 5
);

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES (
  100621, 'BLK001', 'Defence', 7
);

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES (
  100622, 'BLK001', 'Defence', 57
);

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES (
  100623, 'BLK001', 'Goalie', 50
);

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey ) VALUES (
  100624, 'BLK001', 'Goalie', 31
);

/* New Jersey Devils */

-- Coaching staff 

ALTER TABLE GPAULLEY.STAFF ALTER COLUMN staffid RESTART WITH 20071;

INSERT INTO GPAULLEY.STAFF (lastName, firstName, city, state_province, country )
VALUES ('Stevens', 'Scott', 'Kitchener', 'Ontario', 'Canada');

INSERT INTO GPAULLEY.STAFF (lastName, firstName, city, state_province, country )
VALUES ('Oates', 'Adam', 'Weston', 'Ontario', 'Canada');

INSERT INTO GPAULLEY.STAFF (lastName, firstName, city, state_province, country )
VALUES ('Stinziano', 'Richard', 'Verona', 'New Jersey', 'USA');

INSERT INTO GPAULLEY.STAFF (lastName, firstName, city, state_province, country )
VALUES ('Lamoriello', 'Lou', 'Providence', 'Rhode Island', 'USA');
		   
INSERT INTO GPAULLEY.TEAM
VALUES ('DEV001', 'NHL', NULL, 'New Jersey Devils', 
  20071, 20072, 20073, 20074, 'http://devils.nhl.com/');

ALTER TABLE GPAULLEY.PLAYER ALTER COLUMN playerid RESTART WITH 100701;
ALTER TABLE GPAULLEY.ROSTER ALTER COLUMN rosterid RESTART WITH 200701;

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, 
   school, streetAddress, city, state_province, postalCode, country)
VALUES ('Bernier', 'Steve', 190.5, 97.7, '1985-03-31', 
   NULL, NULL, 'Quebec City', 'Quebec', NULL, 'Canada');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey )
VALUES (100701, 'DEV001', 'Right Wing', 18);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, 
  school, streetAddress, city, state_province, postalCode, country)
VALUES ('Cammalleri', 'Mike', 175.2, 86.4, '1982-06-08', 
  NULL, NULL, 'Richmond Hill', 'Ontario', NULL, 'Canada');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey )
VALUES (100702, 'DEV001', 'Left Wing', 23);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, 
  school, streetAddress, city, state_province, postalCode, country)
VALUES ('Clowe', 'Ryane', 190.5, 102.3, '1982-09-30', 
  NULL, NULL, 'St. John''s', 'Newfoundland and Labrador', NULL, 'Canada');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey )
VALUES (100703, 'DEV001', 'Left Wing', 29);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB,
   school, streetAddress, city, state_province, postalCode, country)
VALUES ('Elias', 'Patrik', 185.4, 88.63, '1976-04-13',
   NULL, NULL, 'Trebic', NULL, NULL, 'Czech Republic');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey )
VALUES (100704, 'DEV001', 'Center', 26);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, 
  school, streetAddress, city, state_province, postalCode, country)
VALUES ('Gionta', 'Stephen', 170.1, 84, '1983-10-09', 
  NULL, NULL, 'Rochester', 'New York', NULL, 'USA');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey )
VALUES (100705, 'DEV001', 'Center', 11);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB,
  school, streetAddress, city, state_province, postalCode, country)
VALUES ('Gomez', 'Scott', 180.34, 90.91, '1979-12-23',
  NULL, NULL, 'Anchorage', 'Alaska', NULL, 'USA');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey )
VALUES (100706, 'DEV001', 'Center', 21);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, 
  school, streetAddress, city, state_province, postalCode, country)
VALUES ('Havlat', 'Martin', 188, 95.45, '1981-04-19', 
  NULL, NULL, 'Mlada Boleslav', NULL, NULL, 'Czech Republic');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey )
VALUES (100707, 'DEV001', 'Left Wing', 9);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, 
  school, streetAddress, city, state_province, postalCode, country)
VALUES ('Henrique', 'Adam', 182.9, 88.63, '1990-02-06',
  NULL, NULL, 'Brantford', 'Ontario', NULL, 'Canada');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey )
VALUES (100708, 'DEV001', 'Center', 14);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB,
  school, streetAddress, city, state_province, postalCode, country)
VALUES ('Jagr', 'Jaromir', 190.5, 104.5, '1972-02-15', 
  NULL, NULL, 'Kladno', NULL, NULL, 'Czech, Republic');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey )
VALUES (100709, 'DEV001', 'Right Wing', 68);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, 
  school, streetAddress, city, state_province, postalCode, country)
VALUES ('Josefson', 'Jacob', 185.42, 86.36, '1991-03-02', 
  NULL, NULL, 'Stockholm', NULL, NULL, 'Sweden');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey )
VALUES (100710, 'DEV001', 'Center', 16);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, 
  school, streetAddress, city, state_province, postalCode, country)
VALUES ('Ruutu', 'Tumomo', 182.9, 93.18, '1983-02-16',
  NULL, NULL, 'Vantaa', NULL, NULL, 'Finnland');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey )
VALUES (100711, 'DEV001', 'Left Wing', 15);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB,
  school, streetAddress, city, state_province, postalCode, country)
VALUES ('Ryder', 'Michael', 185.4, 90.91, '1980-05-31',
  NULL, NULL, 'Bonavista', 'Newfoundland and Labrador', NULL, 'Canada');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey )
VALUES (100712, 'DEV001', 'Right Wing', 17);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, 
  school, streetAddress, city, state_province, postalCode, country)
VALUES ('Sestito', 'Tim', 180.34, 88.63, '1984-08-28',
  NULL, NULL, 'Rome', 'New York', NULL, 'Canada');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey )
VALUES (100713, 'DEV001', 'Left Wing', 12);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, 
 school, streetAddress, city, state_province, postalCode, country)
VALUES ('Tootoo', 'Jordin', 175.26, 88.63, '1983-02-02',
 NULL, NULL, 'Churchill', 'Manitoba', NULL, 'Canada');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey )
VALUES (100714, 'DEV001', 'Right Wing', 20);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, 
 school, streetAddress, city, state_province, postalCode, country)
VALUES ('Zajac', 'Travis', 190.5, 93.18, '1985-05-13',
 NULL, NULL, 'Winnipeg', 'Manitoba', NULL, 'Canada');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey )
VALUES (100715, 'DEV001', 'Centre', 19);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, 
 school, streetAddress, city, state_province, postalCode, country)
VALUES ('Zubrus', 'Dainius', 190.6, 102.27, '1978-06-16',
 NULL, NULL, 'Elektrenai', NULL, NULL, 'Lithuania');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey )
VALUES (100716, 'DEV001', 'Centre', 8);

-- Defence
INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, 
 school, streetAddress, city, state_province, postalCode, country)
VALUES ('Fraser', 'Mark', 193.04, 100, '1986-09-29', 
 NULL, NULL, 'Ottawa', 'Ontario', NULL, 'Canada');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey )
VALUES (100717, 'DEV001', 'Defence', 32);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, 
 school, streetAddress, city, state_province, postalCode, country)
VALUES ('Gelinas', 'Eric', 193.04, 97.72, '1991-05-08', 
 NULL, NULL, 'Vanier', 'Ontario', NULL, 'Canada');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey )
VALUES (100718, 'DEV001', 'Defence', 22);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB,
  school, streetAddress, city, state_province, postalCode, country)
VALUES ('Greene', 'Andy', 180.34, 86.36, '1982-10-30', 
  NULL, NULL, 'Trenton', 'Michigan', NULL, 'USA');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey )
VALUES (100719, 'DEV001', 'Defence', 6);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, 
 school, streetAddress, city, state_province, postalCode, country)
VALUES ('Harrold', 'Peter', 180.34, 81.81, '1983-06-08', 
 NULL, NULL, 'Kirtland Hills', 'Ohio', NULL, 'USA');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey )
VALUES (100720, 'DEV001', 'Defence', 10);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, 
 school, streetAddress, city, state_province, postalCode, country)
VALUES ('Larsson', 'Adam', 190.5, 93.18, '1992-11-12', 
 NULL, NULL, 'Skelleftea', NULL, NULL, 'Sweden');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey )
VALUES (100721, 'DEV001', 'Defence', 5);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, 
 school, streetAddress, city, state_province, postalCode, country)
VALUES ('Merrill', 'Jon', 190.5, 93.18, '1992-02-03', 
 NULL, NULL, 'Oklahoma City', 'Oklahoma', NULL, 'USA');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey )
VALUEs (100722, 'DEV001', 'Defence', 7);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB,
  school, streetAddress, city, state_province, postalCode, country)
VALUES ('Salvador', 'Bryce', 190.5, 97.72, '1976-02-11',
  NULL, NULL, 'Brandon', 'Manitoba', NULL, 'Canada');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey )
VALUES (100723, 'DEV001', 'Defence', 24);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, 
 school, streetAddress, city, state_province, postalCode, country)
VALUES ('Severson', 'Damon', 187.96, 93.18, '1994-08-07', 
 NULL, NULL, 'Brandon', 'Manitoba', NULL, 'Canada');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey )
VALUES (100724, 'DEV001', 'Defence', 28);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, 
 school, streetAddress, city, state_province, postalCode, country)
VALUES ('Zidlicky', 'Marek', 180.34, 86.36, '1997-02-03', 
 NULL, NULL, 'Most', NULL, NULL, 'Czech Republic');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey )
VALUES (100725, 'DEV001', 'Defence', 2);

-- Goalies
INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB, 
 school, streetAddress, city, state_province, postalCode, country)
VALUES ('Kinkaid', 'Keith', 187.96, 88.64, '1989-07-04', 
 NULL, NULL, 'Farmingville', 'New York', NULL, 'USA');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey )
VALUES (100726, 'DEV001', 'Goalie', 1);

INSERT INTO GPAULLEY.PLAYER (lastName, firstName, height, weight, DOB,
  school, streetAddress, city, state_province, postalCode, country)
VALUES ('Schneider', 'Cory', 187.96, 93.18, '1986-03-18', 
  NULL, NULL, 'Marblehead', 'Massachusetts', NULL, 'USA');

INSERT INTO GPAULLEY.ROSTER ( player, team, position, jersey )
VALUES (100727, 'DEV001', 'Goalie', 35);

/* NHL Arenas */

ALTER TABLE GPAULLEY.ARENA ALTER COLUMN arenaID RESTART WITH 10001;

/* Montreal 10001 */
INSERT INTO GPAULLEY.ARENA (arenaName, streetAddress, city, state_province, postalCode, country, phone, capacity)
VALUES( 'Bell Centre', '1909 Avenue des Canadiens-de-Montreal', 'Montreal', 'Quebec', 'H4B 5G0', 'Canada', null, 21287 );

/* Pittsburgh  10002 */
INSERT INTO GPAULLEY.ARENA (arenaName, streetAddress, city, state_province, postalCode, country, phone, capacity)
VALUES( 'Consol Energy Center', '1001 Fifth Avenue', 'Pittsburgh', 'Pennsylvannia', '15219', 'USA', null, 18387 );

/* Chicago 10003 */
INSERT INTO GPAULLEY.ARENA (arenaName, streetAddress, city, state_province, postalCode, country, phone, capacity)
VALUES( 'United Center', '1901 West Madison Street', 'Chicago', 'Illinois', '60612', 'USA', null, 19717 );

/* New Jersey 10004 */
INSERT INTO GPAULLEY.ARENA (arenaName, streetAddress, city, state_province, postalCode, country, phone, capacity)
VALUES( 'Prudential Center', '165 Mulberry Street', 'Newark', 'New Jersey', '07102', 'USA', null, 17625 );

/* Toronto 10005 */
INSERT INTO GPAULLEY.ARENA (arenaName, streetAddress, city, state_province, postalCode, country, phone, capacity)
VALUES( 'Air Canada Centre', '40 Bay Street', 'Toronto', 'Ontario', 'M5J 2X2', 'Canada', '4168155500', 18819 );

/* Boston 10006 */
INSERT INTO GPAULLEY.ARENA (arenaName, streetAddress, city, state_province, postalCode, country, phone, capacity)
VALUES( 'TD Garden', '100 Legends Way', 'Boston', 'Massachusetts', '02114', 'USA', null, 17565 );

/* Vancouver 10007 */
INSERT INTO GPAULLEY.ARENA (arenaName, streetAddress, city, state_province, postalCode, country, phone, capacity)
VALUES( 'Rogers Arena', '800 Griffiths Way', 'Vancouver', 'British Columbia', 'V6B 6G1', 'Canada', null, 18910 );

/* Detroit  10008 */
INSERT INTO GPAULLEY.ARENA (arenaName, streetAddress, city, state_province, postalCode, country, phone, capacity)
VALUES( 'Joe Louis Arena', '19 Steve Yzerman Drive', 'Detroit', 'Michigan', null, 'USA', null, 20027 );


/* NHL Games */ 

ALTER TABLE GPAULLEY.GAME ALTER COLUMN gameID RESTART WITH 400001;

/* Montreal Canadiens home games */

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-10-21', '19:30', 10001, 'CAN002', 'RDW001', 2, 1, 'Y', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-11-04', '19:30', 10001, 'CAN002', 'BLK001', 0, 5, 'N', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-11-13', '19:30', 10001, 'CAN002', 'BRU001', 5, 1, 'N', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-11-18', '19:30', 10001, 'CAN002', 'PEN001', 0, 4, 'N', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-12-12', '19:30', 10001, 'CAN002', 'CAN001', 3, 1, 'N', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2015-01-10', '19:30', 10001, 'CAN002', 'PEN001', 1, 2, 'Y', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2015-02-07', '19:30', 10001, 'CAN002', 'DEV001', null, null, null, null );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2015-02-07', '19:00', 10001, 'CAN002', 'DEV001', null, null, null, null );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2015-02-14', '19:00', 10001, 'CAN002', 'LFS001', null, null, null, null );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2015-04-09', '19:30', 10001, 'CAN002', 'RDW001', null, null, null, null );

/* Toronto Maple Leafs home games */

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-10-08', '19:00', 10005, 'LFS001', 'CAN002', 3, 4, 'N', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-10-11', '19:00', 10005, 'LFS001', 'PEN001', 2, 5, 'N', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-10-17', '19:30', 10005, 'LFS001', 'RDW001', 1, 4, 'N', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-10-25', '19:00', 10005, 'LFS001', 'BRU001', 1, 4, 'N', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-11-01', '19:00', 10005, 'LFS001', 'BLK001', 2, 1, 'N', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-11-12', '20:00', 10005, 'LFS001', 'BRU001', 6, 1, 'N', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-11-14', '19:30', 10005, 'LFS001', 'PEN001', 1, 2, 'N', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-11-22', '19:00', 10005, 'LFS001', 'RDW001', 4, 1, 'N', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-12-04', '19:30', 10005, 'LFS001', 'DEV001', 3, 5, 'N', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-12-06', '19:00', 10005, 'LFS001', 'CAN001', 5, 2, 'N', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-12-13', '19:00', 10005, 'LFS001', 'RDW001', 4, 1, 'N', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2015-04-11', '19:00', 10005, 'LFS001', 'RDW001', null, null, null, null );

/* Detroit Red Wings home games */

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-10-09', '19:30', 10008, 'RDW001', 'BRU001', 2, 1, 'N', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-10-15', '19:30', 10008, 'RDW001', 'BRU001', 2, 3, 'Y', 'Y' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-10-18', '19:00', 10008, 'RDW001', 'LFS001', 1, 0, 'Y', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-10-23', '19:30', 10008, 'RDW001', 'PEN001', 4, 3, 'Y', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-11-07', '19:30', 10008, 'RDW001', 'DEV001', 4, 2, 'N', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-11-14', '19:30', 10008, 'RDW001', 'BLK001', 4, 1, 'N', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-11-16', '19:00', 10008, 'RDW001', 'CAN002', 1, 4, 'N', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-11-30', '14:00', 10008, 'RDW001', 'CAN001', 5, 3, 'N', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-12-10', '20:00', 10008, 'RDW001', 'LFS001', 1, 2, 'Y', 'Y' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-12-31', '19:30', 10008, 'RDW001', 'DEV001', 3, 1, 'N', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2015-02-16', '19:30', 10008, 'RDW001', 'CAN002', null, null, null, null );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2015-04-02', '19:30', 10008, 'RDW001', 'BRU001', null, null, null, null );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2015-04-02', '19:30', 10008, 'RDW001', 'BRU001', null, null, null, null );

/* Boston Bruins home games */

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-11-10', '19:00', 10006, 'BRU001', 'DEV001', 4, 2, 'N', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-11-22', '19:00', 10006, 'BRU001', 'CAN002', 0, 2, 'N', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-11-24', '19:00', 10006, 'BRU001', 'PEN001', 2, 3, 'Y', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-12-11', '19:00', 10006, 'BRU001', 'BLK001', 2, 3, 'N', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-12-29', '19:00', 10006, 'BRU001', 'RDW001', 5, 2, 'N', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-12-31', '19:00', 10006, 'BRU001', 'LFS001', 3, 4, 'Y', 'Y' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2015-01-08', '19:00', 10006, 'BRU001', 'DEV001', 0, 3, 'N', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2015-02-08', '19:00', 10006, 'BRU001', 'CAN002', null, null, null, null );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2015-02-24', '19:00', 10006, 'BRU001', 'CAN001', null, null, null, null );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2015-03-08', '19:30', 10006, 'BRU001', 'RDW001', null, null, null, null );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2015-04-04', '19:00', 10006, 'BRU001', 'LFS001', null, null, null, null );

/* Vancouver Canucks home games */

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-10-30', '19:00', 10007, 'CAN001', 'CAN002', 3, 2, 'Y', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-11-23', '18:30', 10007, 'CAN001', 'BLK001', 4, 1, 'N', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-11-25', '19:00', 10007, 'CAN001', 'DEV001', 2, 0, 'N', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2015-01-03', '19:00', 10007, 'CAN001', 'RDW001', 4, 1, 'N', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2015-02-07', '19:00', 10007, 'CAN001', 'PEN001', null, null, null, null );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2015-02-13', '19:00', 10007, 'CAN001', 'BRU001', null, null, null, null );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2015-03-14', '16:00', 10007, 'CAN001', 'LFS001', null, null, null, null );

/* Chicago Blackhawks home games */

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-12-05', '19:30', 10003, 'BLK001', 'CAN002', 4, 3, 'N', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-12-21', '18:00', 10003, 'BLK001', 'CAN002', 4, 0, 'N', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2015-02-11', '19:00', 10003, 'BLK001', 'CAN001', null, null, null, null );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2015-02-13', '19:30', 10003, 'BLK001', 'DEV001', null, null, null, null );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2015-02-15', '11:30', 10003, 'BLK001', 'PEN001', null, null, null, null );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2015-02-18', '18:30', 10003, 'BLK001', 'RDW001', null, null, null, null );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2015-02-22', '14:00', 10003, 'BLK001', 'BRU001', null, null, null, null );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2015-04-02', '19:30', 10003, 'BLK001', 'CAN001', null, null, null, null );

/* New Jersey Devils home games */

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-11-28', '19:00', 10004, 'DEV001', 'RDW001', 4, 5, 'Y', 'Y' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-12-09', '19:00', 10004, 'DEV001', 'BLK001', 2, 3, 'Y', 'Y' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-12-29', '19:00', 10004, 'DEV001', 'PEN001', 3, 1, 'N', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2015-01-02', '19:00', 10004, 'DEV001', 'PEN001', 2, 4, 'N', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2015-01-28', '19:30', 10004, 'DEV001', 'LFS001', 2, 1, 'Y', 'Y' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2015-02-06', '19:00', 10004, 'DEV001', 'LFS001', null, null, null, null );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2015-02-20', '19:00', 10004, 'DEV001', 'CAN001', null, null, null, null );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2015-02-27', '19:00', 10004, 'DEV001', 'BRU001', null, null, null, null );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2015-03-17', '19:00', 10004, 'DEV001', 'PEN001', null, null, null, null );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2015-04-03', '19:00', 10004, 'DEV001', 'CAN002', null, null, null, null );

/* Pittsburgh Penguins home games */

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-10-28', '19:00', 10002, 'PEN001', 'DEV001', 8, 3, 'N', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-11-26', '19:30', 10002, 'PEN001', 'LFS001', 4, 3, 'Y', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-12-02', '19:00', 10002, 'PEN001', 'DEV001', 1, 0, 'N', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-12-04', '19:00', 10002, 'PEN001', 'CAN001', 0, 3, 'N', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2014-12-04', '19:00', 10002, 'PEN001', 'CAN001', 0, 3, 'N', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2015-01-03', '19:00', 10002, 'PEN001', 'CAN002', 1, 4, 'N', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2015-01-07', '20:00', 10002, 'PEN001', 'BRU001', 2, 3, 'Y', 'N' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2015-01-21', '20:00', 10002, 'PEN001', 'BLK001', 2, 3, 'Y', 'Y' );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2015-02-11', '20:00', 10002, 'PEN001', 'RDW001', null, null, null, null );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2015-02-11', '20:00', 10002, 'PEN001', 'RDW001', null, null, null, null );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2015-03-14', '13:00', 10002, 'PEN001', 'BRU001', null, null, null, null );

INSERT INTO GPAULLEY.GAME (schedule, gameDate, gameTime, arena, home, visitor, homeScore, visitorScore, OT, SO )
VALUES( 1, '2015-03-15', '19:30', 10002, 'PEN001', 'RDW001', null, null, null, null );
