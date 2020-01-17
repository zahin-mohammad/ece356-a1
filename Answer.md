1. It is possible that in doing this there may be a conflict with some of the baseball data and/or there is missing data, which means that the primary and/or foreign keys may prevent you from inserting some of the data.  There are three ways you can resolve this problem. What are they (one sentence each, maximum)?  What is the necessary SQL to implement the solution in each case.
   1. Disable primary keys, insert data, then test potential primary key using the SQL command below, where `a1,a2...an` are the potential primary key attributes, and r1 is the relation being test.
    ```
    SELECT b.* 
    FROM (
        SELECT <a1,a2,...an>, count(*) as cnt 
        FROM <r1> 
        GROUP BY <a1,a2,...an> 
        HAVING cnt >1) as one 
    LEFT JOIN <r1> as b 
    ON b.playerid = one.playerid 
    AND b.yearid = one.yearid 
    AND b.teamid = one.teamid 
    AND b.gameid = one.gameid 
    ORDER BY <b.a1, b.a2,...b.an>\G;
    ```
   2. Method two.
   3. Method three.