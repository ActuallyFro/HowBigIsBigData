-- AS ROOT:
-- --------
-- CREATE DATABASE db_test;

-- USE db_test;
-- GRANT ALL PRIVILEGES ON db_test.* TO 'bigdata'@'localhost';

USE db_test;

CREATE TABLE IF NOT EXISTS tbl_test (
      id BINARY(16) PRIMARY KEY,
      value FLOAT(30,6)
);

