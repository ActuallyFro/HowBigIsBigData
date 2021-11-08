Database Size
==============
```
focal@focal:~/My_Programming/HowBigIsBigData$ ./01_RunSQLCommands.sh size
[RunCommands] Sending Cmd: <USE db_test; SELECT table_schema AS "Database", SUM(data_length + index_length) / 1024 / 1024 AS "Size (MB)" FROM information_schema.TABLES GROUP BY table_schema>
+--------------------+------------+
| Database           | Size (MB)  |
+--------------------+------------+
| db_test            | 0.01562500 |
| information_schema | 0.00000000 |
| mysql              | 2.60937500 |
| performance_schema | 0.00000000 |
| sys                | 0.01562500 |
+--------------------+------------+
[RunCommands] Connect is Fin!
```

Table Size
==========
```
focal@focal:~/My_Programming/HowBigIsBigData$ ./01_RunSQLCommands.sh size-tables
[RunCommands] Sending Cmd: <USE db_test; SELECT table_name AS `Table`, round(((data_length + index_length) / 1024 / 1024), 2) `Size in MB` FROM information_schema.TABLES WHERE table_schema = "db_test" AND table_name = "tbl_test";>
+----------+------------+
| Table    | Size in MB |
+----------+------------+
| tbl_test |       0.02 |
+----------+------------+
[RunCommands] Connect is Fin!
focal@focal:~/My_Programming/HowBigIsBigData$
```

Count
=====
```
focal@focal:~/My_Programming/HowBigIsBigData$ ./01_RunSQLCommands.sh count
[RunCommands] Sending Cmd: <USE db_test; SELECT COUNT(*) FROM tbl_test;>
+----------+
| COUNT(*) |
+----------+
|  1000010 |
+----------+
[RunCommands] Connect is Fin!
```
Top-Ten
=======
```
focal@focal:~/My_Programming/HowBigIsBigData$ ./01_RunSQLCommands.sh top-ten
[RunCommands] Sending Cmd: <USE db_test; SELECT * FROM tbl_test LIMIT 10;>
+------------------------------------+-------------------------+
| id                                 | value                   |
+------------------------------------+-------------------------+
| 0x027730116D3AE157451427E0E26B1F9A |   11261447241728.000000 |
| 0x0558DAB76F7A956C092A4F4D26C5999B |      69431074816.000000 |
| 0x0587B833A45753042A9B256128AC096F |     377148604416.000000 |
| 0x05BC459AF08764C8AF06B3C4A8259B2B |     -36285706240.000000 |
| 0x0654E62B2C21CAB27678B26EFD4F376E |    4648223637504.000000 |
| 0x07966A22466DEBA6107EEE560EDCF370 |    1447788281856.000000 |
| 0x1000040A1FFCF6C3C50DEB62D55BF2D3 |     664200347648.000000 |
| 0x100009B87D6B82F46998F7B63D0EFDAD | -285973552300032.000000 |
| 0x10000C37F45C0857E245E38494018134 |   -1538523791360.000000 |
| 0x100020FF3ED8C7D4BAC1287E94FC3D03 |   -4386588983296.000000 |
+------------------------------------+-------------------------+
[RunCommands] Connect is Fin!
```