-- Index on timestamp for time-series filtering
CREATE INDEX idx_trades_timestamp ON trades(timestamp);

-- Index on instrument (symbol-level analytics via join)
CREATE INDEX idx_trades_instrument ON trades(instrument_id);

-- Index on exchange for cross-exchange comparison
CREATE INDEX idx_trades_exchange ON trades(exchange_id);


 DROP TABLE IF EXISTS trades;

CREATE TABLE trades (
  trade_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  instrument_id INT NOT NULL,
  expiry_id INT NOT NULL,
  exchange_id INT NOT NULL,
  trade_date DATE,
  expiry_dt DATE,
  open_pr DECIMAL(10,2),
  high_pr DECIMAL(10,2),
  low_pr DECIMAL(10,2),
  close_pr DECIMAL(10,2),
  settle_pr DECIMAL(10,2),
  volume BIGINT,
  open_int BIGINT,
  timestamp DATETIME,

  KEY idx_timestamp (timestamp),
  KEY idx_instrument (instrument_id),
  KEY idx_exchange (exchange_id)
)
PARTITION BY RANGE (YEAR(expiry_dt)) (
  PARTITION p2023 VALUES LESS THAN (2024),
  PARTITION p2024 VALUES LESS THAN (2025),
  PARTITION p2025 VALUES LESS THAN (2026)
);
-- Query for  Performance test
SELECT
  i.symbol,
  MAX(t.volume) AS max_volume
FROM trades t
JOIN instruments i ON t.instrument_id = i.instrument_id
WHERE t.timestamp >= NOW() - INTERVAL 30 DAY
GROUP BY i.symbol;


EXPLAIN ANALYZE
SELECT
  i.symbol,
  MAX(t.volume) AS max_volume
FROM trades t
JOIN instruments i ON t.instrument_id = i.instrument_id
WHERE t.timestamp >= NOW() - INTERVAL 30 DAY
GROUP BY i.symbol;