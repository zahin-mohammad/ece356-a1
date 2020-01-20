1. It is possible that in doing this there may be a conflict with some of the baseball data and/or there is missing data, which means that the primary and/or foreign keys may prevent you from inserting some of the data.  There are three ways you can resolve this problem. What are they (one sentence each, maximum)?  What is the necessary SQL to implement the solution in each case.
   1. Disable foreign key checks, insert the data, then enable foreign key checks.
   ```
    drop database baseball2016;
    SET FOREIGN_KEY_CHECKS=0;
    source /home/z5mohamm/ece356-a1/lahman2016-tables.sql;
    source /home/z5mohamm/ece356-a1/lahman2016-data.sql;
    SET FOREIGN_KEY_CHECKS=1;

   ```
   1. Disable foreign key checks, insert the data, then insert missing data in referenced tables, and lastly re-enable foreign key checks.
    ```
    drop database baseball2016;
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
    ```
   2. Disable foreign key checks, insert the data, then delete data from referencing data that uses foreign keys that are not present in the referenced table, and lastly re-enable foreign key checks.
    ```
    drop database baseball2016;
    SET FOREIGN_KEY_CHECKS=0;

    source /home/z5mohamm/ece356-a1/lahman2016-tables.sql;
    source /home/z5mohamm/ece356-a1/lahman2016-data.sql;

    Option 2, delete data to have valid foreign keys
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
    ```
2. The SQL file has a very large number of INSERT statements in order to load the data into the database.  It is typically preferred to load data directly from source files.  In the case of the Baseball data, the course files are “Comma-Separated Variable” (or CSV) files.  Create a LOAD statement that will load the data for the Batting CSV (Batting.csv) into its associated table.  You should verify that your LOAD statement operates correctly and issues no warnings. Where is the CSV data located relative to the CLI and to the DB Server? Time how long it takes to LOAD the CSV vs. Using the equivalent INSERT statement method.
   1. Can load files from the the directory specified with `secure_file_priv`
    ```
    SHOW VARIABLES LIKE "secure_file_priv";
    +------------------+-----------------------+
    | Variable_name    | Value                 |
    +------------------+-----------------------+
    | secure_file_priv | /var/lib/mysql-files/ |
    +------------------+-----------------------+
    ```

    2. 
    ```
    Starting INSERT test
    CURRENT_TIMESTAMP
    2020-01-19 20:28:19
    -- insert data
    CURRENT_TIMESTAMP
    2020-01-19 20:28:26

    Starting LOAD test
    CURRENT_TIMESTAMP
    2020-01-19 20:28:27
    -- load data
    CURRENT_TIMESTAMP
    2020-01-19 20:28:33
    ```
3. Create RA and SQL queries to answer each of the following questions
   1. How many players have an unknown birthdate?
   ```
   select count(*) from Master where birthyear in('',0) or birthmonth in ('',0) or birthday in('',0) or birthyear is null or birthmonth is null or birthday is null;
    +----------+
    | count(*) |
    +----------+
    | 458      |
    +----------+

   ```

   2. How many people are in the Hall of Fame?  What fraction of each category of person are in the Hall Of Fame?  Are more people in the Hall Of Fame alive or dead?  Does this vary by category? 
   How many people are in the Hall of Fame?
   ```
    select count(distinct playerid) from HallOfFame where inducted='Y';
    +--------------------------+
    | count(distinct playerid) |
    +--------------------------+
    | 317                      |
    +--------------------------+

   ```
   Available categories:
   ```
   select distinct category from HallOfFame;
    +-------------------+
    | category          |
    +-------------------+
    | Player            |
    | Manager           |
    | Umpire            |
    | Pioneer/Executive |
    +-------------------+
    ```
    Fraction of HallOfFame persons over Total persons by category:
    ```
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
            WHERE  inducted = 'Y' 
            GROUP  BY category) AS a; 

    +-------------------+-----------------+------------+----------+
    | category          | counthalloffame | CountTotal | fraction |
    +-------------------+-----------------+------------+----------+
    | Manager           | 23              | 317        | 0.0726   |
    | Pioneer/Executive | 34              | 317        | 0.1073   |
    | Player            | 250             | 317        | 0.7886   |
    | Umpire            | 10              | 317        | 0.0315   |
    +-------------------+-----------------+------------+----------+

    ```
    Are More People Alive or Dead?
    ```
     SELECT 
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
                    ON Master.playerid = tt1.playerid) AS t1; 
    +-------+------+
    | alive | dead |
    +-------+------+
    | 74    | 243  |
    +-------+------+
    ```
    Mortality statistics on HallOfFame persons by Category:
    ```
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
    +-------------------+-------+------+
    | category          | alive | dead |
    +-------------------+-------+------+
    | Player            | 65    | 185  |
    | Manager           | 5     | 18   |
    | Umpire            | 1     | 9    |
    | Pioneer/Executive | 3     | 31   |
    +-------------------+-------+------+
    ```
    3. What are the names and total pay (individually) of the three people with the three largest totalsalaries?  What category are these people?  What are the top three in the other categories?
    What are the names and total pay (individually) of the three people with the three largest totalsalaries?
    ```
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

    +-----------+-----------+-------------+
    | namefirst | namelast  | TotalSalary |
    +-----------+-----------+-------------+
    | Alex      | Rodriguez | 398416252   |
    | Derek     | Jeter     | 264618093   |
    | Mark      | Teixeira  | 214275000   |
    +-----------+-----------+-------------+   
    ```
    What category are these people?
    ```
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
    +-----------+---------+--------+-------+
    | playerid  | manager | player | other |
    +-----------+---------+--------+-------+
    | rodrial01 | N       | Y      | N     |
    | jeterde01 | N       | Y      | N     |
    | teixema01 | N       | Y      | N     |
    +-----------+---------+--------+-------+  
    ```
    What are the top three in the other categories?
    ```
    Other Categories are manager and other.

    SELECT 
        playerid,
        manager_salary,
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
                ) is null,salary,0)) as other_salary
        FROM Salaries
        GROUP BY playerid
        ) as q1
    WHERE manager_salary != 0
    ORDER BY manager_salary DESC
    LIMIT 3;
    +----------+----------------+--------------+
    | playerid | manager_salary | other_salary |
    +----------+----------------+--------------+
    | rosepe01 | 1358858        | 0            |
    +----------+----------------+--------------+

    SELECT 
        playerid,
        manager_salary,
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
        ;
    +-----------+----------------+--------------+
    | playerid  | manager_salary | other_salary |
    +-----------+----------------+--------------+
    | belleal01 | 0              | 37417830     |
    | vaughmo01 | 0              | 30333334     |
    | hamptmi01 | 0              | 29003543     |
    +-----------+----------------+--------------+

    ```
    1. What is the average number of Home Runs a player has?
    ```
    select sum(hr)/count(distinct playerid) as average_homeruns from Batting;
    +------------------+
    | average_homeruns |
    +------------------+
    | 15.2938          |
    +------------------+
    ```
    1. If we only count players who got at least 1 Home Run, what is the average number of Home Runs a player has?
    ```
    SELECT SUM(q1.total_homerun)/count(q1.total_homerun) as "Average Home Runs Excluding 0's" FROM (SELECT sum(hr) as total_homerun FROM Batting group by playerid having total_homerun>0) as q1;
    +---------------------------------+
    | Average Home Runs Excluding 0's |
    +---------------------------------+
    | 37.3944                         |
    +---------------------------------+

    ```
    1. If we define a player as a good batter if they have more than the average number of Home Runs, and a player is a good Pitcher if they have more than the average number of ShutOut games, then how many players are both good batters and good pitchers?
    ```
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
    +--------------------------------------------+
    | Players that are good Batters and Pitchers |
    +--------------------------------------------+
    | 39                                         |
    +--------------------------------------------+
    ```

