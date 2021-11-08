---
title: Analyzing MySQL LONGTEXT (Select Video Selections)
author: Brandon Froberg
date: 7 Nov 21
geometry: margin=1in
...

LONGTEXT!
==========
```
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| db_test            |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
5 rows in set (0.00 sec)
```
```
mysql> use db_test;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+-------------------+
| Tables_in_db_test |
+-------------------+
| tbl_test          |
| tbl_test_longtext |
+-------------------+
2 rows in set (0.00 sec)

mysql> SELECT * FROM tbl_test_longtext;
Empty set (0.00 sec)
```


```
root@focal:/home/focal/My_Programming/HowBigIsBigData# ls /var/lib/mysql/db_test/ -lahtr
total 77M
drwx------ 7 mysql mysql 4.0K Nov  7 19:15 ..
-rw-r----- 1 mysql mysql  76M Nov  8 03:06 tbl_test.ibd
drwxr-x--- 2 mysql mysql 4.0K Nov  8 03:13 .
-rw-r----- 1 mysql mysql 112K Nov  8 03:13 tbl_test_longtext.ibd
```


```
focal@focal:~/My_Programming/HowBigIsBigData$ time ./01_RunSQLCommands.sh insert
[RunCommands] Updating .csv (/var/lib/mysql-files/generateRandFloat.csv )
[RunCommands] Sending Cmd: <USE db_test; LOAD DATA INFILE '/var/lib/mysql-files/generateRandFloat.csv'
 INTO TABLE tbl_test_longtext FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 2 LINES 
 (@uuid,value) SET id= UUID_TO_BIN(@uuid);>
ERROR 1054 (42S22) at line 1: Unknown column 'value' in 'field list'
[RunCommands] Done inserting!

real    0m0.070s [editorial note: RED FLAG -- so did digging...]
user    0m0.018s
sys     0m0.048s
```

ERROR in the table -- it was uuid (binary), and name(longtext) 
SHOULD BE/now is: uuid (binary), and value(longtext) 

```
focal@focal:~/My_Programming/HowBigIsBigData$ time ./01_RunSQLCommands.sh insert
[RunCommands] Updating .csv (/var/lib/mysql-files/generateRandFloat.csv )
[RunCommands] Sending Cmd: <USE db_test; LOAD DATA INFILE '/var/lib/mysql-files/generateRandFloat.csv'
 INTO TABLE tbl_test_longtext FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 2 LINES 
 (@uuid,value) SET id= UUID_TO_BIN(@uuid);>
[RunCommands] Done inserting!

real    0m20.218s
user    0m0.022s
sys     0m0.045s
```

```
mysql> SELECT COUNT(*) FROM tbl_test_longtext;
+----------+
| COUNT(*) |
+----------+
|  1000000 |
+----------+
1 row in set (0.11 sec)

mysql> SELECT * FROM tbl_test_longtext LIMIT 15;

+------------------------------------+-------------------------+
| id                                 | value                   |
+------------------------------------+-------------------------+
| 0x027730116D3AE157451427E0E26B1F9A | 11261447241728.000000   |
| 0x0558DAB76F7A956C092A4F4D26C5999B | 69431074816.000000      |
| 0x0587B833A45753042A9B256128AC096F | 377148604416.000000     |
| 0x05BC459AF08764C8AF06B3C4A8259B2B | -36285706240.000000     |
| 0x0654E62B2C21CAB27678B26EFD4F376E | 4648223637504.000000    |
| 0x07966A22466DEBA6107EEE560EDCF370 | 1447788281856.000000    |
| 0x1000040A1FFCF6C3C50DEB62D55BF2D3 | 664200347648.000000     |
| 0x100009B87D6B82F46998F7B63D0EFDAD | -285973552300032.000000 |
| 0x10000C37F45C0857E245E38494018134 | -1538523791360.000000   |
| 0x100020FF3ED8C7D4BAC1287E94FC3D03 | -4386588983296.000000   |
| 0x1000228F6B0A3EE962CFBA95A23496A3 | -46123213389824.000000  |
| 0x10002B7B23A079F32FF7945B64348AAC | -122009010176.000000    |
| 0x10002C8F5D737C072A9A517C32F2A66C | 745080619008.000000     |
| 0x10002F0530FBCBB35BD8E16A6137601F | 281773768704.000000     |
| 0x10003C386A34D24742A53242E1953146 | -39988418838528.000000  |
+------------------------------------+-------------------------+
15 rows in set (0.00 sec)
```

```
root@focal:/home/focal/My_Programming/HowBigIsBigData# ls /var/lib/mysql/db_test/ -lahtr
total 181M
-rw-r----- 1 mysql mysql  76M Nov  8 03:06 tbl_test.ibd
drwxr-x--- 2 mysql mysql 4.0K Nov  8 03:21 .
drwx------ 7 mysql mysql 4.0K Nov  8 03:22 ..
-rw-r----- 1 mysql mysql 104M Nov  8 03:23 tbl_test_longtext.ibd
```

```
root@focal:/home/focal/My_Programming/HowBigIsBigData# ls /var/lib/mysql/db_test/ -latr
total 184336
-rw-r----- 1 mysql mysql  79691776 Nov  8 03:06 tbl_test.ibd
drwxr-x--- 2 mysql mysql      4096 Nov  8 03:21 .
drwx------ 7 mysql mysql      4096 Nov  8 03:22 ..
-rw-r----- 1 mysql mysql 109051904 Nov  8 03:23 tbl_test_longtext.ibd
root@focal:/home/focal/My_Programming/HowBigIsBigData# echo 109051904*100/79691776 | bc
136
root@focal:/home/focal/My_Programming/HowBigIsBigData# echo "it's 136% LARGER to store longtext
 over floats..."
```

Summary-ish
===========
It's 136% LARGER to store longtext over floats...

1. 6/4 = 1.5 == 150%
2. 5/4 = 1.25 == 125%

WAG: the LONGTEXT uses "as-needed bytes" to fill the string content. BUT it's (from this subset) in the worst case adding two bytes to the base of 4 bytes of a float.
