/* ==========================================================================
   Dubai Buy-to-Let Investor Yield Analysis
   Source: Bayut "For Sale" listings (Dubai Real Estate Sales Insights, Kaggle)
   Cleaning applied before load: filtered to Dubai + purpose = For Sale,
   removed price = 0 rows, kept only listings with real average_rent data
   (excluded rows where rent was recorded as 0 = not disclosed), and
   capped rental yield to a realistic 1%-20% range to remove data-entry
   outliers (e.g. rent/price typos producing 400%+ "yield").
   Result: 15,605 clean listings, all completion_status = Ready.
   ========================================================================== */

-- Table schema (as loaded into `listings`)
-- CREATE TABLE listings (
--     price INTEGER,
--     price_category TEXT,       -- Average / Medium / High
--     type TEXT,                 -- Apartment / Villa / Townhouse / Penthouse / Hotel Apartment
--     beds INTEGER,
--     baths INTEGER,
--     address TEXT,
--     furnishing TEXT,
--     completion_status TEXT,
--     post_date TEXT,
--     average_rent INTEGER,      -- annual rent estimate (AED)
--     building_name TEXT,
--     year_of_completion INTEGER,
--     total_parking_spaces INTEGER,
--     total_floors INTEGER,
--     total_building_area_sqft INTEGER,
--     elevators INTEGER,
--     area_name TEXT,
--     city TEXT,
--     country TEXT,
--     Latitude REAL,
--     Longitude REAL,
--     purpose TEXT,
--     yield_pct REAL             -- derived: (average_rent / price) * 100
-- );


-- ==========================================================================
-- Q1. Portfolio-level baseline
-- Why: establishes the overall benchmark every other cut gets compared to.
-- ==========================================================================
SELECT
    COUNT(*)                       AS total_listings,
    ROUND(AVG(yield_pct), 2)       AS avg_yield_pct,
    ROUND(MIN(yield_pct), 2)       AS min_yield_pct,
    ROUND(MAX(yield_pct), 2)       AS max_yield_pct,
    ROUND(AVG(price), 0)           AS avg_price_aed,
    ROUND(AVG(average_rent), 0)    AS avg_annual_rent_aed
FROM listings;


-- ==========================================================================
-- Q2. Top 15 areas by average yield (min. 20 listings, to avoid tiny samples)
-- Why: the core "where to market" ranking.
-- ==========================================================================
SELECT
    area_name,
    COUNT(*)                   AS listing_count,
    ROUND(AVG(yield_pct), 2)   AS avg_yield_pct,
    ROUND(AVG(price), 0)       AS avg_price_aed
FROM listings
GROUP BY area_name
HAVING COUNT(*) >= 20
ORDER BY avg_yield_pct DESC
LIMIT 15;


-- ==========================================================================
-- Q3. Bottom 15 areas by average yield (min. 20 listings)
-- Why: the "deprioritize" list — where NOT to spend investor-marketing budget.
-- ==========================================================================
SELECT
    area_name,
    COUNT(*)                   AS listing_count,
    ROUND(AVG(yield_pct), 2)   AS avg_yield_pct,
    ROUND(AVG(price), 0)       AS avg_price_aed
FROM listings
GROUP BY area_name
HAVING COUNT(*) >= 20
ORDER BY avg_yield_pct ASC
LIMIT 15;


-- ==========================================================================
-- Q4. Yield by property type
-- Why: tests whether the recommendation should be type-specific
-- (e.g. "market apartments, not villas").
-- ==========================================================================
SELECT
    type,
    COUNT(*)                   AS listing_count,
    ROUND(AVG(yield_pct), 2)   AS avg_yield_pct,
    ROUND(AVG(price), 0)       AS avg_price_aed
FROM listings
GROUP BY type
ORDER BY avg_yield_pct DESC;


-- ==========================================================================
-- Q5. Yield by price band (Average / Medium / High, as pre-labeled in source)
-- Why: confirms the affordability-yield relationship at a portfolio level.
-- ==========================================================================
SELECT
    price_category,
    COUNT(*)                   AS listing_count,
    ROUND(AVG(yield_pct), 2)   AS avg_yield_pct,
    ROUND(MIN(price), 0)       AS min_price_aed,
    ROUND(MAX(price), 0)       AS max_price_aed
FROM listings
GROUP BY price_category
ORDER BY avg_yield_pct DESC;


-- ==========================================================================
-- Q6. Yield by furnishing status
-- Why: checks if furnished units justify a yield premium (they mostly don't
-- here — useful to rule out as a marketing lever).
-- ==========================================================================
SELECT
    furnishing,
    COUNT(*)                   AS listing_count,
    ROUND(AVG(yield_pct), 2)   AS avg_yield_pct
FROM listings
GROUP BY furnishing
ORDER BY avg_yield_pct DESC;


-- ==========================================================================
-- Q7. "Sweet spot" areas: high yield AND high listing volume (>=100 listings)
-- Why: high yield in a tiny micro-market is a weak signal. This finds areas
-- with both strong yield and enough market depth to sustain a real campaign.
-- ==========================================================================
SELECT
    area_name,
    COUNT(*)                   AS listing_count,
    ROUND(AVG(yield_pct), 2)   AS avg_yield_pct,
    ROUND(AVG(price), 0)       AS avg_price_aed
FROM listings
GROUP BY area_name
HAVING COUNT(*) >= 100
ORDER BY avg_yield_pct DESC
LIMIT 10;


-- ==========================================================================
-- Q8. Top area + property-type combinations (min. 30 listings per combo)
-- Why: the most actionable cut for campaign targeting — not just "which
-- area" but "which area AND which unit type" to promote.
-- ==========================================================================
SELECT
    area_name,
    type,
    COUNT(*)                   AS listing_count,
    ROUND(AVG(yield_pct), 2)   AS avg_yield_pct,
    ROUND(AVG(price), 0)       AS avg_price_aed
FROM listings
GROUP BY area_name, type
HAVING COUNT(*) >= 30
ORDER BY avg_yield_pct DESC
LIMIT 15;


-- ==========================================================================
-- Q9. Yield by bedroom count (studio through 5-bed)
-- Why: tests unit-size targeting — studios/1-beds vs. large family units.
-- ==========================================================================
SELECT
    beds,
    COUNT(*)                   AS listing_count,
    ROUND(AVG(yield_pct), 2)   AS avg_yield_pct,
    ROUND(AVG(price), 0)       AS avg_price_aed
FROM listings
WHERE beds BETWEEN 0 AND 5
GROUP BY beds
ORDER BY beds;
