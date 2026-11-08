-- MIT 8103 Advanced Database Systems
-- Portfolio 3: Transactions and Concurrency
-- Case study: FMBN Mortgage Loan Management System (fictional data)
-- PostgreSQL / pgAdmin 4
--
-- REPRODUCTION GUIDE, based on the documented experiments.
-- Execute ONE numbered section at a time in the specified pgAdmin Query Tool session.
-- Do NOT run this entire file at once. Keep Session A and Session B as
-- separate database connections. Run COMMIT/ROLLBACK separately as indicated.
-- These commands MODIFY application_id = 1; use a test database only.
-- Recorded screenshots are the evidence of the original experiments.

-- =============================================================
-- 1. Basic transaction examples (reproducible illustrations)
-- =============================================================
-- ROLLBACK: execute together in one Query Tool connection.
BEGIN;
UPDATE mortgage_applications
SET requested_amount = 21000000
WHERE application_id = 1;
ROLLBACK;

-- COMMIT: example only; choose an appropriate test value.
-- BEGIN;
-- UPDATE mortgage_applications
-- SET requested_amount = 21000000
-- WHERE application_id = 1;
-- COMMIT;

-- =============================================================
-- 2. Check default isolation
-- =============================================================
SHOW default_transaction_isolation;
-- Observed in screenshot 18A: read committed.

-- =============================================================
-- 3. READ COMMITTED (screenshots 15A-15G)
-- =============================================================
-- Session A: execute BEGIN and SELECT, leaving transaction open.
-- BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- SELECT application_id, customer_id, requested_amount, application_status
-- FROM mortgage_applications WHERE application_id = 1;
--
-- Session B: start transaction, change the test amount, do not commit yet.
-- BEGIN;
-- UPDATE mortgage_applications SET requested_amount = 21000000
-- WHERE application_id = 1;
--
-- Session A: repeat SELECT before B commits; uncommitted data is not visible.
-- SELECT application_id, customer_id, requested_amount, application_status
-- FROM mortgage_applications WHERE application_id = 1;
--
-- Session B: COMMIT;
-- Session A: repeat SELECT; READ COMMITTED can now see committed change.
-- Session A: COMMIT;

-- =============================================================
-- 4. REPEATABLE READ (screenshots 16A-16G)
-- =============================================================
-- Session A:
-- BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
-- SELECT application_id, customer_id, requested_amount, application_status
-- FROM mortgage_applications WHERE application_id = 1;
--
-- Session B:
-- BEGIN;
-- UPDATE mortgage_applications SET requested_amount = 21000000
-- WHERE application_id = 1;
-- COMMIT;
--
-- Session A: repeat SELECT; the transaction's earlier snapshot is retained.
-- SELECT application_id, customer_id, requested_amount, application_status
-- FROM mortgage_applications WHERE application_id = 1;
-- COMMIT;
-- Outside the transaction, run SELECT again to see the committed value.

-- =============================================================
-- 5. SERIALIZABLE (screenshots 17A-17G)
-- =============================================================
-- Session A:
-- BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- SELECT application_id, customer_id, requested_amount, application_status
-- FROM mortgage_applications WHERE application_id = 1;
--
-- Session B: while A remains open, update then commit.
-- BEGIN;
-- UPDATE mortgage_applications SET requested_amount = 23000000
-- WHERE application_id = 1;
-- COMMIT;
--
-- Session A: repeat SELECT, then COMMIT.
-- SELECT application_id, customer_id, requested_amount, application_status
-- FROM mortgage_applications WHERE application_id = 1;
-- COMMIT;
--
-- Verify from a new transaction:
-- SELECT application_id, customer_id, requested_amount, application_status
-- FROM mortgage_applications WHERE application_id = 1;
-- Observed: Session A continued to see 21000000; final value 23000000.
-- This sequence does NOT demonstrate a serialization failure.

-- =============================================================
-- 6. Row-level locking (screenshots 18B-18I)
-- =============================================================
-- Session A: execute and KEEP the transaction open.
-- BEGIN;
-- SELECT application_id, customer_id, requested_amount, application_status
-- FROM mortgage_applications WHERE application_id = 1 FOR UPDATE;
--
-- Session B: while A holds the lock, execute these commands together.
-- BEGIN;
-- SET LOCAL lock_timeout = '5s';
-- UPDATE mortgage_applications
-- SET requested_amount = 25000000
-- WHERE application_id = 1
-- RETURNING application_id, customer_id, requested_amount, application_status;
-- Expected: SQLSTATE 55P03 (lock timeout), as shown in screenshot 18D.
--
-- Session A: COMMIT; -- releases the row lock.
-- Session B: ROLLBACK; -- clears the failed transaction.
-- Session B: retry and commit:
-- BEGIN;
-- UPDATE mortgage_applications
-- SET requested_amount = 25000000
-- WHERE application_id = 1
-- RETURNING application_id, customer_id, requested_amount, application_status;
-- COMMIT;
--
-- Session A: verify:
-- SELECT application_id, customer_id, requested_amount, application_status
-- FROM mortgage_applications WHERE application_id = 1;
-- Observed final requested_amount: 25000000; status: Approved.

-- IMPORTANT: Sections 3-6 are a guided two-session script, commented out
-- deliberately to prevent accidental execution in the wrong order.
