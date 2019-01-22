#!/bin/bash

function getans {
    read ans
ansarr+=("$i. $ans")
i=$((i+1))
echo " "
}

echo "Let's get started"

i=1

echo "$i. What type of lock will deny users any access to a table?"
echo "a. Implicit"
echo "b. Explicit"
echo "c. Exclusive"
echo "d. Read Only"
echo "e. Shared"
getans

echo "$i. To sort results of SELECT statement use the following clause:"
echo "a. ORDERED BY"
echo "b. SORT"
echo "c. ORDER BY"
echo "d. SORT WITH"
getans

echo "$i. Which of the following is not a MySQL Storage Engine?"
echo "a. MyISAM"
echo "b. InnoDB"
echo "c. Archive"
echo "d. DXF"
getans

echo "$i. Which of the following not true about innodb storage engine?"
echo "a. Supports transactions"
echo "b. Does not supprt foreign keys"
echo "c. Supports row level locking"
echo "d. Use multi version concurrency control"
getans

echo "$i. MySQL binary log does not: "
echo "a. Capture all queries issued"
echo "b. Used for point in time recovery"
echo "c. Must be enabled for replication"
echo "d. Adds any overhead"
getans

echo "$i. Which of the following denotes difference between CHAR and VARCHAR datatypes?"
echo "a. Both of them can store any value from 0 to 255"
echo "b. When displayed, Trailing spaces are removed in CHAR, while in VARCHAR, it is displayed as stored"
echo "c. CHAR is for binary strings, VARCHAR is for non-binary strings"
getans

echo "$i. Which of the following is correct command to connect to MySQL form command line?"
echo "a. mysql -h HostName -u UserName -p"
echo "b. mysql -h HostName -u -p"
echo "c. mysql -h -u -p"
getans

echo "$i. Which of the following command is used to view the structure of a table?"
echo "a. SHOW table_name;"
echo "b. DESCRIBE table_name;"
echo "c. VIEW table_name;"
getans

echo "$i. What does the following MySQL command do?"
echo "SELECT *"
echo "FROM author"
echo "WHERE auth_name LIKE 'W%';"
echo " "
echo "a. Return those rows from the table author in which the name of the author contains the character ‘W’ somewhere in the middle of the author name"
echo "b. Return those rows from the table author in which the name of the author ends with the character ‘W’"
echo "c. Return those rows from the table author in which the name of the author starts with the character ‘W’"
getans

echo "$i. Which of the following statement is not true about MySQL DROP command?"
echo "a. It can be used to remove a table with all data"
echo "b. It can be used to remove a database"
echo "c. It can be used to delete an index"
echo "d. It can be used to delete only data but not structure of a table"
getans

echo "$i. Which of the following statement is not true about MySQL UPDATE statement?"
echo "a. MySQL UPDATE statement is used to update columns of existing rows in a table with new values"
echo "b. The LIMIT clause specifies a limit on the number of rows that can be updated"
echo "c. You can not update a column value to NULL"
getans

echo "$i. If you create a table inside a transaction, a rollback will remove this table"
echo "a. True"
echo "b. False"
getans


echo "please submit your answers: "
for answer in "${ansarr[@]}"
do
    echo "$answer"
done
