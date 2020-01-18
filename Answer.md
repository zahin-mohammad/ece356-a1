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