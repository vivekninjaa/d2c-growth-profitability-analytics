-- D2C Growth & Profitability Analytics
-- SQL analysis queries
-- Adapt table/file names and date syntax to your SQL database.

-- 1. Seller performance benchmark
SELECT
    seller_name,
    category,
    nmv,
    profit,
    profit_margin_pct,
    orders,
    CASE WHEN orders = 0 THEN NULL ELSE nmv / orders END AS aov,
    roas,
    rto_pct_weighted
FROM seller_master
ORDER BY profit DESC;

-- 2. Portfolio KPI summary
SELECT
    SUM(nmv) AS total_nmv,
    SUM(profit) AS total_profit,
    CASE WHEN SUM(nmv) = 0 THEN NULL ELSE 100.0 * SUM(profit) / SUM(nmv) END AS profit_margin_pct,
    SUM(orders) AS total_orders,
    CASE WHEN SUM(orders) = 0 THEN NULL ELSE SUM(nmv) / SUM(orders) END AS portfolio_aov
FROM seller_master;

-- 3. Rank sellers by NMV and profit
SELECT
    seller_name,
    nmv,
    profit,
    RANK() OVER (ORDER BY nmv DESC) AS nmv_rank,
    RANK() OVER (ORDER BY profit DESC) AS profit_rank
FROM seller_master;

-- 4. Identify sellers with negative unit economics
SELECT
    seller_name,
    nmv,
    profit,
    profit_margin_pct,
    orders
FROM seller_master
WHERE profit < 0 OR profit_margin_pct < 0
ORDER BY profit ASC;

-- 5. Growth analysis
SELECT
    seller_name,
    nmv_growth_pct,
    profit_change
FROM growth_trend
ORDER BY nmv_growth_pct DESC;

-- 6. Sellers with high RTO opportunity
SELECT
    seller_name,
    high_rto_orders
FROM rto_opportunity
ORDER BY high_rto_orders DESC;

-- 7. Highest RTO seller-state combinations
SELECT
    seller_name,
    state,
    awb_nc,
    rto_pct,
    avoidable_rto_orders_to_25pct
FROM state_rto_detail
WHERE rto_pct > 25
ORDER BY rto_pct DESC, awb_nc DESC;

-- 8. Product concentration
SELECT
    seller_name,
    category,
    product_count,
    top10_nmv_share_pct,
    top20_nmv_share_pct
FROM product_concentration
ORDER BY top10_nmv_share_pct DESC;

-- 9. COD RTO penalty by seller
SELECT
    seller_name,
    cod_rto_pct,
    non_cod_avg_rto_pct,
    cod_rto_penalty_pp
FROM payment_penalty
ORDER BY cod_rto_penalty_pp DESC;

-- 10. Payment mode detail
SELECT
    seller_name,
    payment_mode,
    awb_nc,
    rto_%
FROM payment_detail
ORDER BY seller_name, rto_% DESC;

-- 11. Priority flags for management
SELECT
    seller_name,
    priority,
    scale_status,
    profit_status,
    rto_status,
    marketing_status
FROM seller_priority_flags
ORDER BY
    CASE priority
        WHEN 'High' THEN 1
        WHEN 'Medium' THEN 2
        ELSE 3
    END;
