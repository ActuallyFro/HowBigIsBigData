Messing Around with MySQL
=========================
I will make a script
for data must be super fun
unless it is big

FAQ
===

Problems
--------
1. Cannot use LOAD DATA (or LOAD DATA LOCAL):   
See where your local files are restricted to with: in mysql: `SHOW VARIABLES LIKE "secure_file_priv";` OR `cat /etc/mysql/my.cnf`

Then either (1) use that folder, or (2) disable the line and reboot:

  1. Run: `sudo nano /etc/mysql/my.cnf`:  
```
[mysqld]
secure-file-priv = ""
```
  2. Run: `sudo systemctl restart mysql.service`

2. The BIGGER issue is cannot read/write to "/var/lib/mysql-files" (just give everyone access... OR make a folder that is then configured for access)
 1. `sudo chown ``whoami`` /var/lib/mysql-files`
 2. `sudo chmod -R a+rwx /var/lib/mysql-files`

3. Folder Configure access (see #1) just indicate your new folder  
```
[mysqld]
secure-file-priv = "<NEW FOLDER EVERYONE CAN ACCESS PATH HERE>"
```
FAQ 1-3 can be [read more here](https://computingforgeeks.com/how-to-solve-mysql-server-is-running-with-the-secure-file-priv-error/)