# Portfolio 3: Transactions and Concurrency

**Course:** MIT 8103 Advanced Database Systems  
**Case study:** Federal Mortgage Bank of Nigeria (FMBN) Mortgage Loan Management System  
**Platform:** PostgreSQL, using pgAdmin 4  
**Database:** `fmbn_mortgage_db`

## 1. Objective

In this portfolio, I explored how PostgreSQL manages mortgage application changes using transactions, isolation levels and concurrency controls. I used fictional mortgage records to examine how `COMMIT`, `ROLLBACK`, consistent reads and row-level locks protect data when more than one database session is active.

## 2. Transaction management

I demonstrated transaction rollback and commit using mortgage application data. `ROLLBACK` cancels changes made within a transaction, while `COMMIT` makes successful changes permanent. Screenshots **12** and **13** record these exercises. These mechanisms are important for preventing partially completed mortgage processing operations from being treated as final.

## 3. Isolation levels

I worked with two pgAdmin Query Tool sessions, labelled **Session A** and **Session B**, to observe how one session reads data while another changes it.

| Isolation level | Experiment and interpretation | Screenshot group |
|---|---|---|
| READ COMMITTED | I compared reads before and after another session committed its update. Uncommitted changes were not visible; a subsequent statement could see the committed value. | 15A–15G |
| REPEATABLE READ | I examined repeated reads within a transaction while another session updated and committed the record. The reading transaction retained its earlier snapshot. | 16A–16G |
| SERIALIZABLE | I examined reads in Session A while Session B updated and committed the same application. Session A continued to show ₦21,000,000 during its transaction; the later final check showed ₦23,000,000. | 17A–17G |

The SERIALIZABLE evidence demonstrates a consistent view during this particular test. **I did not observe or document a serialization-failure error**, so I do not claim that this experiment demonstrated conflict detection or transaction retries.

## 4. Row-level locking and concurrency control

I checked the default PostgreSQL isolation setting with `SHOW default_transaction_isolation;`; it returned **`read committed`** (18A). I then tested concurrent updates to `mortgage_applications` for `application_id = 1`.

1. I verified the application's existing data (18B).
2. In Session A, I began a transaction and selected the application with `FOR UPDATE`, holding a row-level lock (18C).
3. In Session B, I attempted to update the same record to **₦25,000,000**, using `SET LOCAL lock_timeout = '5s'`. PostgreSQL returned **`ERROR: canceling statement due to lock timeout`**, SQLSTATE **55P03** (18D).
4. I committed Session A to release its lock (18E), then rolled back the failed transaction in Session B (18F).
5. I retried the update in Session B. This time, the statement succeeded and returned the new amount (18G); I committed it (18H).
6. Finally, I queried the record again and confirmed **₦25,000,000**, with application status **Approved** (18I).

This demonstrated that PostgreSQL prevents two transactions from freely changing a locked row at the same time. The timeout was an expected outcome of the test, not a database malfunction. Once the first transaction released its lock and the failed transaction was reset, the update could proceed.

## 5. SQL implementation and evidence

- **`Portfolio 3 Transactions and Concurrency.sql`** — an annotated **reproduction guide** for the experiments, including SQL statements for transaction management, isolation tests and row-level locking. The multi-session instructions are intentionally commented out to prevent accidental execution as a single script. It is not presented as an exact historical transcript of every statement executed.
- **`Screenshots/`** — original pgAdmin screenshots, numbered **12–18**, showing queries, outputs and session interactions. Screenshot names may include descriptive suffixes such as `15A`, `17C` or `18I`.

**How to reproduce:** Open two independent pgAdmin Query Tool connections to the test database. Follow the numbered sections in the SQL file **one step at a time**, using the indicated session. Do not execute the full file as one batch. The examples update fictional data for `application_id = 1`, so they must not be run against a production system.

## 6. Reflection

These exercises helped me understand that transaction control is more than issuing `COMMIT` and `ROLLBACK`. Isolation determines which changes a session can observe, while row-level locking controls competing modifications. In a mortgage loan management system, these safeguards matter because concurrent processing must not accidentally overwrite application details or expose unfinished updates. I also learned to distinguish a demonstrated lock timeout from other concurrency errors, such as a serialization failure, which my evidence did not show.

## 7. References and AI-use declaration

- MIT 8103 Advanced Database Systems, Continuous Assessment instructions, 2026/2027 academic session.
- PostgreSQL documentation: transaction isolation, explicit locking, and transaction control.

**AI-use declaration:** I used ChatGPT to help organise the technical explanation and prepare an annotated SQL reproduction guide. The pgAdmin screenshots document my practical work. I reviewed the descriptions against the captured evidence and remain responsible for the accuracy of my submission.
