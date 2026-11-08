-- MIT 8103 Advanced Database Systems
-- Portfolio 2: Query Processing and Optimisation
-- FMBN Mortgage Loan Management System
-- Database: fmbn_mortgage_db
-- These statements reproduce the queries visible in the Portfolio 2 screenshots.
-- Run against the existing database. No customer or mortgage records are modified.

-- 1. Customer mortgage applications (Screenshot 07)
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    p.property_address,
    ma.requested_amount,
    ma.application_status
FROM customers c
INNER JOIN mortgage_applications ma
    ON c.customer_id = ma.customer_id
INNER JOIN properties p
    ON ma.property_id = p.property_id
ORDER BY c.customer_id;

-- 2. Mortgage application status report (Screenshot 08)
SELECT
    application_status,
    COUNT(*) AS total_applications,
    SUM(requested_amount) AS total_requested_amount,
    ROUND(AVG(requested_amount), 2) AS average_requested_amount
FROM mortgage_applications
GROUP BY application_status
ORDER BY application_status;

-- 3. Execution plan for the amount filter and customer join (Screenshot 09)
-- Screenshot 09 records an initial plan. Because the index now exists,
-- rerunning this statement does not recreate the original test conditions.
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    ma.requested_amount,
    ma.application_status
FROM customers c
INNER JOIN mortgage_applications ma
    ON c.customer_id = ma.customer_id
WHERE ma.requested_amount >= 15000000
ORDER BY ma.requested_amount DESC;

-- 4. Index used in the exercise (Screenshot 10)
-- The index already exists in the exported Portfolio 1 schema.
-- IF NOT EXISTS avoids creating it again if this script is rerun.
CREATE INDEX IF NOT EXISTS idx_mortgage_requested_amount
    ON public.mortgage_applications USING btree (requested_amount);

-- 5. Verify the indexes on mortgage_applications (Screenshot 10)
SELECT
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname = 'public'
    AND tablename = 'mortgage_applications'
ORDER BY indexname;

-- 6. Execution plan with the index present (Screenshot 11)
-- This is the same EXPLAIN query as section 3. The recorded screenshot
-- shows PostgreSQL still using a sequential scan on mortgage_applications.
-- Do not interpret the existence of an index as proof of improved performance.
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    ma.requested_amount,
    ma.application_status
FROM customers c
INNER JOIN mortgage_applications ma
    ON c.customer_id = ma.customer_id
WHERE ma.requested_amount >= 15000000
ORDER BY ma.requested_amount DESC;
