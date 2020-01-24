-- 1 ) Method 1
DROP DATABASE baseball2016;
SET FOREIGN_KEY_CHECKS=0;
source /home/z5mohamm/ece356-a1/lahman2016-tables.sql;
source /home/z5mohamm/ece356-a1/lahman2016-data.sql;
SET FOREIGN_KEY_CHECKS=1;

-- 1) Method 2
DROP DATABASE baseball2016;
SET FOREIGN_KEY_CHECKS=0;

source /home/z5mohamm/ece356-a1/lahman2016-tables.sql;
source /home/z5mohamm/ece356-a1/lahman2016-data.sql;

INSERT INTO Schools (schoolid) (SELECT DISTINCT schoolid FROM CollegePlaying WHERE schoolid NOT IN (SELECT schoolid FROM Schools));
INSERT INTO Master (playerid) (SELECT DISTINCT playerid FROM HallOfFame WHERE playerid NOT IN (SELECT playerid from Master));
INSERT INTO Master (playerid) (SELECT DISTINCT playerid FROM Salaries WHERE playerid NOT IN (SELECT playerid from Master));

SET FOREIGN_KEY_CHECKS=1;

-- Should be empty set
SELECT DISTINCT schoolid FROM CollegePlaying WHERE schoolid NOT IN (SELECT schoolid FROM Schools);
-- Should be empty set
SELECT DISTINCT playerid FROM HallOfFame WHERE playerid NOT IN (SELECT playerid from Master);
-- Should be empty set
SELECT DISTINCT playerid FROM Salaries WHERE playerid NOT IN (SELECT playerid from Master);

-- 1) Method 3
drop database baseball2016;
SET FOREIGN_KEY_CHECKS=0;

source /home/z5mohamm/ece356-a1/lahman2016-tables.sql;
source /home/z5mohamm/ece356-a1/lahman2016-data.sql;


DELETE FROM CollegePlaying WHERE schoolid NOT IN (SELECT schoolid FROM Schools);
DELETE FROM HallOfFame WHERE playerid NOT IN (SELECT playerid FROM Master);
DELETE FROM Salaries WHERE playerid NOT in (select playerid FROM Master);

SET FOREIGN_KEY_CHECKS=1;
-- Should be empty set
SELECT DISTINCT schoolid FROM CollegePlaying WHERE schoolid NOT IN (SELECT schoolid FROM Schools);
-- Should be empty set
SELECT DISTINCT playerid FROM HallOfFame WHERE playerid NOT IN (SELECT playerid from Master);
-- Should be empty set
SELECT DISTINCT playerid FROM Salaries WHERE playerid NOT IN (SELECT playerid from Master);

-- 2) 
-- Load the Tables and the Data
SELECT 'Loading Tables and Data' AS '';
source /home/z5mohamm/ece356-a1/table_and_data.sql;
SET FOREIGN_KEY_CHECKS=0;

SELECT 'Starting INSERT test' AS '';
TRUNCATE Batting;

SELECT CURRENT_TIMESTAMP;
source /home/z5mohamm/ece356-a1/lahman2016-batting.sql;
SELECT CURRENT_TIMESTAMP;

SELECT 'Starting LOAD test' AS '';
TRUNCATE Batting;

SELECT CURRENT_TIMESTAMP;
LOAD DATA INFILE '/var/lib/mysql-files/Batting.csv' 
INTO TABLE Batting 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT CURRENT_TIMESTAMP;

SET FOREIGN_KEY_CHECKS=1;
SELECT 'Using sql as final data' AS '';
TRUNCATE Batting;
source /home/z5mohamm/ece356-a1/lahman2016-batting.sql;

-- 3.a)
select count(*) as "Players With Unknown Birthdays" from Master where birthyear in('',0) or birthmonth in ('',0) or birthday in('',0) or birthyear is null or birthmonth is null or birthday is null;

-- 3.b)
--   How many people are in the Hall of Fame?
select count(distinct playerid) as "People in the Hall Of Fame" from HallOfFame where inducted='Y';
-- What fraction of each category of person are in the Hall Of Fame?
SELECT a.category, 
    a.counthalloffame, 
    a.counttotal, 
    a.counthalloffame / a.counttotal AS fraction 
FROM   (SELECT category, 
            Count(DISTINCT playerid) AS CountHallOfFame, 
            (SELECT Count(DISTINCT playerid) 
                FROM   HallOfFame 
                WHERE  inducted = 'Y')  AS CountTotal 
        FROM   HallOfFame 
        GROUP  BY category) AS a; 
-- Are More People Alive or Dead?
SELECT 
    count(distinct q1.playerid) as alive,
    count(distinct q2.playerid) as dead
FROM
(SELECT Master.playerid FROM Master JOIN HallOfFame ON Master.playerid = HallOfFame.playerid WHERE inducted = 'Y' AND deathyear  = '') as q1,
(SELECT Master.playerid FROM Master JOIN HallOfFame ON Master.playerid = HallOfFame.playerid WHERE inducted = 'Y' AND deathyear != '') as q2; 
-- Does this vary by category? 
SELECT category, 
    SUM(IF(deathyear = '' 
            OR deathyear IS NULL, 1, 0))     AS alive, 
    SUM(IF(deathyear != '' 
            AND deathyear IS NOT NULL, 1, 0)) AS dead 
FROM   (SELECT tt1.category, 
            Master.deathyear, 
            Master.playerid 
        FROM   Master 
            join (SELECT DISTINCT playerid, 
                                    category 
                    FROM   HallOfFame 
                    WHERE inducted='Y') AS tt1 
                ON Master.playerid = tt1.playerid) AS t1 
GROUP  BY category; 

-- 3.c)
-- What are the names and total pay (individually) of the three people with the three largest totalsalaries?
SELECT Master.namefirst, 
        Master.namelast, 
        totalsalary 
    FROM   (SELECT playerid, 
                Sum(salary) AS TotalSalary 
            FROM   Salaries 
            GROUP  BY playerid 
            ORDER  BY totalsalary DESC 
            LIMIT  3) AS q1 
        JOIN Master 
            ON q1.playerid = Master.playerid; 
-- What category are these people?
SELECT 
        q2.playerid,
        q2.manager,
        IF(q2.manager='Y' OR q2.batter='Y' OR q2.pitcher='Y' OR q2.fielder='Y', 'Y','N') as player,
        IF(q2.manager='N' and q2.batter='N' and q2.pitcher='N' and q2.fielder='N', 'Y','N') as other
    FROM(
        SELECT 
            Master.playerid,
            IF((SELECT distinct playerid FROM Managers where Managers.playerid = Master.playerid) is null, 'N', 'Y') AS manager,
            IF((SELECT distinct playerid FROM Batting where Batting.playerid = Master.playerid) is null, 'N', 'Y') AS batter, 
            IF((SELECT distinct playerid FROM Pitching where Pitching.playerid = Master.playerid) is null, 'N', 'Y') AS pitcher,
            IF((SELECT distinct playerid FROM Fielding where Fielding.playerid = Master.playerid) is null, 'N', 'Y') AS fielder
        FROM   (SELECT playerid, 
                    Sum(salary) AS TotalSalary 
                FROM   Salaries 
                GROUP  BY playerid 
                ORDER  BY totalsalary DESC 
                LIMIT  3) AS q1 
            JOIN Master 
                ON q1.playerid = Master.playerid  
    ) as q2;
--  What are the top three in the other categories?
-- Managers
SELECT 
        playerid,
        manager_salary
    FROM(
        SELECT 
            playerid,   
            SUM(IF((SELECT distinct playerid FROM Managers where Managers.playerid = Salaries.playerid AND Managers.yearid = Salaries.yearid) is null,0,salary)) as manager_salary,
            SUM(IF((
                SELECT distinct Fielding.playerid FROM Fielding where Fielding.playerid = Salaries.playerid AND Fielding.yearid = Salaries.yearid
                UNION
                SELECT distinct Pitching.playerid FROM Pitching where Pitching.playerid = Salaries.playerid AND Pitching.yearid = Salaries.yearid
                UNION
                SELECT distinct Batting.playerid FROM Batting where Batting.playerid = Salaries.playerid AND Batting.yearid = Salaries.yearid
                ) is null,salary,0)) as other_salary
        FROM Salaries
        GROUP BY playerid
        ) as q1
    WHERE manager_salary != 0
    ORDER BY manager_salary DESC
    LIMIT 3;
-- Other
SELECT 
        playerid,
        other_salary
    FROM(
        SELECT 
            playerid,   
            SUM(IF((SELECT distinct playerid FROM Managers where Managers.playerid = Salaries.playerid AND Managers.yearid = Salaries.yearid) is null,0,salary)) as manager_salary,
            SUM(IF((
                SELECT distinct Fielding.playerid FROM Fielding where Fielding.playerid = Salaries.playerid AND Fielding.yearid = Salaries.yearid
                UNION
                SELECT distinct Pitching.playerid FROM Pitching where Pitching.playerid = Salaries.playerid AND Pitching.yearid = Salaries.yearid
                UNION
                SELECT distinct Batting.playerid FROM Batting where Batting.playerid = Salaries.playerid AND Batting.yearid = Salaries.yearid
                UNION
                SELECT distinct Managers.playerid FROM Managers where Managers.playerid = Salaries.playerid AND Managers.yearid = Salaries.yearid
                ) is null,salary,0)) as other_salary
        FROM Salaries
        GROUP BY playerid
        ) as q1
        WHERE other_salary !=0
        ORDER BY other_salary DESC
        LIMIT 3;

-- 3.d)
select sum(hr)/count(distinct playerid) as "Average # of Homeruns" from Batting;

-- 3.e)
SELECT SUM(q1.total_homerun)/count(q1.total_homerun) as "Average Home Runs Excluding 0's" FROM (SELECT sum(hr) as total_homerun FROM Batting group by playerid having total_homerun>0) as q1;

-- 3.f)
SELECT COUNT(*) as "Players that are good Batters and Pitchers"
    FROM(
        SELECT
            Pitching.playerid,
            SUM(Pitching.sho) as player_shut_out_total
        FROM Pitching
        GROUP BY Pitching.playerid
        HAVING 
            player_shut_out_total > (SELECT SUM(Pitching.sho)/COUNT(distinct Pitching.playerid) FROM Pitching)
    ) AS q1
    INNER JOIN (
        SELECT
            Batting.playerid,
            SUM(Batting.hr) as player_home_run_total
        FROM Batting
        GROUP BY Batting.playerid
        HAVING 
            player_home_run_total > (SELECT SUM(Batting.hr)/COUNT(distinct Batting.playerid) FROM Batting)
    ) AS q2
    ON q1.playerid = q2.playerid;  