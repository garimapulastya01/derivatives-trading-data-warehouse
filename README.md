# derivatives-trading-data-warehouse
End-to-end data warehouse design and analytics on derivatives trading data using MySQL and Python.

F&O Market Data Database 

Project Overview

This project is about designing a relational database to store and analyze high-volume Futures & Options (F&O) market data from Indian exchanges like NSE, BSE, and MCX.

The goal was to create a schema that is easy to query for analytics, efficient for large datasets, and scalable for millions of rows, while keeping the structure clean and maintainable.

Dataset

Source: NSE F&O Dataset (3 months, Kaggle)

Rows: ~2.5M

Key columns: Instrument, Symbol, Expiry Date, Strike Price, Option Type, OHLC prices, Volume, Open Interest, Timestamp

The design also supports ingestion from other exchanges (BSE, MCX) without changes.

Design Rationale
Normalization Choices

I used 3NF normalization.

exchanges table stores all exchange info to avoid repeating it.

instruments table holds symbols and underlying assets.

expiries table stores each unique derivative contract (expiry + strike + option type).

trades table only stores the fact data like OHLC, volume, and open interest.

This avoids redundancy and makes analytics queries faster and more reliable.

Why Not Star Schema

Derivatives contracts change frequently and strike prices vary constantly.

Star schema would duplicate too much data and be harder to maintain.

A normalized schema works better for write-heavy, evolving financial datasets.

Performance & Scalability

Indexed columns: expiry_dt, instrument_id, exchange_id.

Partitioned the trades table by expiry year (PARTITION BY RANGE(YEAR(expiry_dt))) to reduce scan time and enable partition pruning.

Designed to scale for 10M+ rows, suitable for high-frequency ingestion scenarios.

Optimization Example

Querying for Open Interest changes per symbol across exchanges uses expiry-based filtering and indexes.
EXPLAIN ANALYZE shows that only relevant partitions are scanned and indexes are used, improving performance significantly.

Use Cases Supported

Open Interest analysis (build-up/unwinding)

Option chain summaries by expiry and strike

Volatility tracking

Cross-exchange comparisons

Liquidity and trading activity monitoring



Tools & Tech Stack

Database: MySQL 8.0

Tools: MySQL Workbench, dbdiagram.io, Python for CSV ingestion

Dataset: Kaggle NSE F&O 3M


