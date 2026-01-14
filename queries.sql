/*Top 10 symbols by open interest (OI) change across exchanges.*/

SELECT
    i.symbol,
    ex.exchange_name,
    SUM(t.open_int) AS total_open_interest
FROM trades t
JOIN instruments i ON t.instrument_id = i.instrument_id
JOIN exchanges ex ON t.exchange_id = ex.exchange_id
GROUP BY i.symbol, ex.exchange_name
ORDER BY total_open_interest DESC
LIMIT 10;

/* Volatility analysis: 7-day rolling std dev of close prices for NIFTY options.*/

SELECT
    t.trade_date,
    exp.expiry_dt,
    exp.strike_pr,
    exp.option_typ,
    STDDEV_POP(t.close_pr) OVER (
        PARTITION BY t.expiry_id
        ORDER BY t.trade_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS rolling_7d_volatility
FROM trades t
JOIN expiries exp ON t.expiry_id = exp.expiry_id
JOIN instruments i ON t.instrument_id = i.instrument_id
WHERE i.symbol = 'NIFTY'
  AND exp.option_typ IN ('CE', 'PE');
  
  
/*Cross-exchange comparison: Avg settle_pr for gold futures (MCX) vs. equity index futures (NSE)*/
SELECT
    ex.exchange_name,
    CASE
        WHEN i.symbol = 'GOLD' THEN 'GOLD FUTURES'
        ELSE 'EQUITY INDEX FUTURES'
    END AS contract_type,
    AVG(t.settle_pr) AS avg_settle_price
FROM trades t
JOIN instruments i
    ON t.instrument_id = i.instrument_id
JOIN exchanges ex
    ON t.exchange_id = ex.exchange_id
WHERE
    i.instrument_type = 'FUTURE'
    AND (
        (i.symbol = 'GOLD' AND ex.exchange_name = 'MCX')
        OR
        (i.symbol IN ('NIFTY', 'BANKNIFTY') AND ex.exchange_name = 'NSE')
    )
GROUP BY
    ex.exchange_name,
    contract_type;
    
    /*Option chain summary: Grouped by expiry_dt and strike_pr, calculating implied volume.
*/

SELECT
    exp.expiry_dt,
    exp.strike_pr,
    exp.option_typ,
    SUM(t.volume) AS total_volume
FROM trades t
JOIN expiries exp ON t.expiry_id = exp.expiry_id
GROUP BY
    exp.expiry_dt,
    exp.strike_pr,
    exp.option_typ
ORDER BY exp.expiry_dt, exp.strike_pr;

/*Performance-optimized query for max volume in last 30 days using indexes/window functions.*/

SELECT
    trade_date,
    instrument_id,
    volume
FROM (
    SELECT
        trade_date,
        instrument_id,
        volume,
        ROW_NUMBER() OVER (
            PARTITION BY trade_date
            ORDER BY volume DESC
        ) AS rn
    FROM trades
    WHERE trade_date >= CURDATE() - INTERVAL 30 DAY
) ranked
WHERE rn = 1;
