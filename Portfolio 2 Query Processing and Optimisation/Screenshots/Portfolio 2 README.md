# Portfolio 2: Query Processing and Optimisation

**Course:** MIT 8103 Advanced Database Systems  
**Case study:** Federal Mortgage Bank of Nigeria (FMBN) Mortgage Loan Management System  
**Database:** `fmbn_mortgage_db`  
**Platform:** PostgreSQL and pgAdmin 4

## 1. Scope of the exercise

For this portfolio, I used the PostgreSQL database developed in Portfolio 1 to retrieve mortgage application information, produce a summary report and examine how PostgreSQL executed a filtered query. The investigation focused on the `customers`, `properties` and `mortgage_applications` tables. The five screenshots in the `Screenshots` folder document the SQL statements, returned records, index verification and execution plan output.

The accompanying `Portfolio 2 SQL Queries.sql` file consolidates the SQL used in the exercise. It includes a guarded index creation statement so that an existing index is not recreated when the script is run again.

## 2. Retrieving customer mortgage applications

The first query joined `customers` to `mortgage_applications` through `customer_id` and then joined `properties` through `property_id`. It returned each customer's identifier, first and last names, property address, requested amount and application status, ordered by customer identifier.

The query returned **five application records**. The visible results included three approved applications, one pending application and one rejected application. Joining these tables allowed the report to display customer, property and application information together without storing those details in a single table.

**Evidence:** `07 - fmbn customer mortgage applications(1).png`.

## 3. Mortgage application status report

A second query grouped applications by `application_status` and calculated the number of applications, total requested amount and average requested amount for each status.

| Application status | Number of applications | Total requested amount (₦) | Average requested amount (₦) |
| --- | ---: | ---: | ---: |
| Approved | 3 | 55,000,000.00 | 18,333,333.33 |
| Pending | 1 | 15,000,000.00 | 15,000,000.00 |
| Rejected | 1 | 20,000,000.00 | 20,000,000.00 |
| **Total** | **5** | **90,000,000.00** | |

The status report shows how aggregate queries can summarise the mortgage application workload without changing the underlying records. These figures represent the fictional data used for the assessment and should not be interpreted as FMBN operational statistics.

**Evidence:** `08 - fmbn mortgage application status report(1).png`.

## 4. Initial query execution plan

To examine query processing, I used `EXPLAIN (ANALYZE, BUFFERS)` on a query joining customers and mortgage applications, filtering applications with `requested_amount >= 15000000`, and ordering the results by requested amount in descending order.

The initial plan displayed a **sequential scan on `mortgage_applications`**, followed by a **hash join** with `customers` and a **sort** on the requested amount. The visible plan reported four rows at the final sort stage and used quicksort with approximately **25 kB** of memory. These observations describe the plan displayed during the exercise, not a general performance guarantee.

The plan is useful because it identifies the operations PostgreSQL selected for this particular query and dataset. Its estimated costs and measured timings must be interpreted in the context of the small number of records and the conditions under which the query was executed.

**Evidence:** `09 - fmbn initial query execution plan(1).png`.

## 5. Index verification and query processing after indexing

The database includes a B tree index named `idx_mortgage_requested_amount` on `mortgage_applications.requested_amount`. I verified its presence by querying the PostgreSQL `pg_indexes` catalogue. The result listed the requested amount index and the primary key index on `mortgage_applications`.

The SQL file also contains `CREATE INDEX IF NOT EXISTS` to document the indexing operation without recreating the index if it is already present. The index definition is independently recorded in the Portfolio 1 schema export.

**Evidence:** `10 - fmbn mortgage application index created(1).png`.

The same filtered join query was then examined with `EXPLAIN (ANALYZE, BUFFERS)`. The visible portion of the later plan still reported a **sequential scan on `mortgage_applications`**, with four rows passing the amount filter and one row removed by the filter. The screenshot also displayed **Execution Time: 0.126 ms**.

This result does **not** demonstrate that the index accelerated the query. PostgreSQL may prefer a sequential scan when a table is small or when a large proportion of its rows satisfy the condition. The evidence confirms that the index existed, but the plan shown did not use it for the filtered table access.

**Evidence:** `11 - fmbn query performance after indexing(1).png`.

## 6. Performance interpretation and limitations

The exercise demonstrates three distinct aspects of query processing: retrieving related records through joins, summarising applications through aggregation, and inspecting execution plans rather than assuming how a query will run.

The before and after screenshots are useful for observing the selected access method, but they do not provide a controlled benchmark establishing a measurable performance improvement. The later screenshot shows the lower portion of the plan, while the initial screenshot shows its upper portion. Differences in displayed query completion times should not be treated as reliable proof of an indexing benefit. A more rigorous comparison would require complete execution plans, repeated runs under comparable conditions and a dataset large enough to make alternative access methods meaningful.

For a larger mortgage application database, an index on the requested amount might help selective amount range searches. Its usefulness would depend on the volume and distribution of records, the frequency of those searches and the cost of maintaining the index during inserts and updates.

## 7. Technical reflection

Working with the existing FMBN database showed how SQL queries can serve both operational reporting and performance investigation. The join query brought together customer, property and application details, while the grouped report provided a concise view of application outcomes and requested funding.

The most important finding was that creating an index does not mean PostgreSQL will necessarily use it. In this exercise, the index was present but the displayed execution plan continued to use a sequential scan. That observation reinforced the need to examine actual execution plans and measured results before recommending an optimisation. For a production mortgage system, query tuning would need to be based on realistic data volumes and recurring application workloads rather than on a small demonstration dataset.

## 8. References and AI use declaration

**References**

PostgreSQL Global Development Group. (n.d.). *Using EXPLAIN*. PostgreSQL documentation. https://www.postgresql.org/docs/current/using-explain.html

PostgreSQL Global Development Group. (n.d.). *Indexes*. PostgreSQL documentation. https://www.postgresql.org/docs/current/indexes.html

PostgreSQL Global Development Group. (n.d.). *Aggregate functions*. PostgreSQL documentation. https://www.postgresql.org/docs/current/functions-aggregate.html

**Course material:** MIT 8103 Advanced Database Systems. (2026). *Continuous Assessment brief, 2026/2027 academic session*.

**AI use declaration:** I used ChatGPT as a supporting tool during the preparation of this portfolio, particularly in organising the documentation, refining the presentation of technical information and improving the clarity and coherence of my explanations. Its assistance helped me present my SQL queries, execution plan observations and performance analysis in a structured and systematic manner. The practical database activities, technical decisions and supporting evidence presented in this portfolio are based on the work I personally carried out.
