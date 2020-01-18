1. It is possible that in doing this there may be a conflict with some of the baseball data and/or there is missing data, which means that the primary and/or foreign keys may prevent you from inserting some of the data.  There are three ways you can resolve this problem. What are they (one sentence each, maximum)?  What is the necessary SQL to implement the solution in each case.
   1. Disable foreign key checks, insert the data, then enable foreign key checks.
   ```
    drop database baseball2016;
    SET FOREIGN_KEY_CHECKS=0;
    source /home/z5mohamm/ece356-a1/lahman2016-tables.sql;
    source /home/z5mohamm/ece356-a1/lahman2016-data.sql;
    SET FOREIGN_KEY_CHECKS=0;

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

    SET FOREIGN_KEY_CHECKS=0;

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

    SET FOREIGN_KEY_CHECKS=0;

    SELECT DISTINCT schoolid FROM CollegePlaying WHERE schoolid NOT IN (SELECT schoolid FROM Schools);
    SELECT DISTINCT playerid FROM HallOfFame WHERE playerid NOT IN (SELECT playerid from Master);
    SELECT DISTINCT playerid FROM Salaries WHERE playerid NOT IN (SELECT playerid from Master);
    ```
2. 