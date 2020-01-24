
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