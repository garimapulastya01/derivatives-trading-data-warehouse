CREATE DATABASE fno_trading;
USE fno_tradintrades_ibfk_1g;

CREATE TABLE exchanges (
  exchange_id INT AUTO_INCREMENT PRIMARY KEY,
  exchange_code VARCHAR(10) UNIQUE NOT NULL,
  exchange_name VARCHAR(50),
  timezone VARCHAR(20)
);


CREATE TABLE instruments (
  instrument_id INT AUTO_INCREMENT PRIMARY KEY,
  symbol VARCHAR(20) NOT NULL,
  instrument_type ENUM('FUTURE','OPTION'),
  underlying VARCHAR(20),
  exchange_id INT,
  FOREIGN KEY (exchange_id) REFERENCES exchanges(exchange_id)
);

CREATE TABLE expiries (
  expiry_id INT AUTO_INCREMENT PRIMARY KEY,
  instrument_id INT,
  expiry_dt DATE NOT NULL,
  strike_pr DECIMAL(10,2),
  option_typ ENUM('CE','PE'),
  FOREIGN KEY (instrument_id) REFERENCES instruments(instrument_id)
);


CREATE TABLE trades (
  trade_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  instrument_id INT,
  expiry_id INT,
  exchange_id INT,
  trade_date DATE,
  open_pr DECIMAL(10,2),
  high_pr DECIMAL(10,2),
  low_pr DECIMAL(10,2),
  close_pr DECIMAL(10,2),
  settle_pr DECIMAL(10,2),
  volume BIGINT,
  open_int BIGINT,
  timestamp DATETIME,
  FOREIGN KEY (instrument_id) REFERENCES instruments(instrument_id),
  FOREIGN KEY (expiry_id) REFERENCES expiries(expiry_id),
  FOREIGN KEY (exchange_id) REFERENCES exchanges(exchange_id)
);


select * from instruments;




DESCRIBE trades;

SELECT *
FROM trades ;

