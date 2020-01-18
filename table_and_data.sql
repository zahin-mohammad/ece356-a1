drop database baseball2016;
SET FOREIGN_KEY_CHECKS=0;

source /home/z5mohamm/ece356-a1/lahman2016-tables.sql;
source /home/z5mohamm/ece356-a1/lahman2016-data.sql;

-- Option 1, insert data to have valid foreign keys
INSERT INTO Schools (schoolid) (SELECT DISTINCT schoolid FROM CollegePlaying WHERE schoolid NOT IN (SELECT schoolid FROM Schools));
INSERT INTO Master (playerid) (SELECT DISTINCT playerid FROM HallOfFame WHERE playerid NOT IN (SELECT playerid from Master));
INSERT INTO Master (playerid) (SELECT DISTINCT playerid FROM Salaries WHERE playerid NOT IN (SELECT playerid from Master));

-- Option 2, delete data to have valid foreign keys
-- DELETE FROM CollegePlaying WHERE schoolid NOT IN (SELECT schoolid FROM Schools);
-- DELETE FROM HallOfFame WHERE playerid NOT IN (SELECT playerid FROM Master);
-- DELETE FROM Salaries WHERE playerid NOT in (select playerid FROM Master);

SET FOREIGN_KEY_CHECKS=1;

SELECT DISTINCT schoolid FROM CollegePlaying WHERE schoolid NOT IN (SELECT schoolid FROM Schools);
SELECT DISTINCT playerid FROM HallOfFame WHERE playerid NOT IN (SELECT playerid from Master);
SELECT DISTINCT playerid FROM Salaries WHERE playerid NOT IN (SELECT playerid from Master);


