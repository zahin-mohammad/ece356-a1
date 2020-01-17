1. It is possible that in doing this there may be a conflict with some of the baseball data and/or there is missing data, which means that the primary and/or foreign keys may prevent you from inserting some of the data.  There are three ways you can resolve this problem. What are they (one sentence each, maximum)?  What is the necessary SQL to implement the solution in each case.
   1. Disable primary keys, insert data, then test potential primary key using the SQL command below, where `a1,a2...an` are the potential primary key attributes, and r1 is the relation being test.
    ```
    SELECT * FROM (
        SELECT <a1,a2...an>,
        COUNT(*) as cnt
        FROM <r1>
        GROUP BY <a1,a2...an>
        HAVING cnt > 1) as quer1
        JOIN <r1> 
        WHERE <r1>.a1 = quer1.a1,
        AND <r1>.a2 = quer1.a2,
        .
        .
        .
        AND <r1>.an = quer1.an;
    )
    ```
    ```
    Reference:
    select b.* from (select playerid,yearid,teamid, count(*) as cnt from AllstarFull group by playerI
                             -> D, yearID,teamID having cnt >=2) as one right join AllstarFull as b on b.playerid = one.playerid 
                             -> and b.yearid = one.yearid and b.teamid = one.teamid\G;
    ```
   2. Method two.
   3. Method three.