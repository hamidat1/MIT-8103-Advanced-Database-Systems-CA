# Portfolio 1: Database Design and Modelling

**Course:** MIT 8103 Advanced Database Systems  
**Case study:** Federal Mortgage Bank of Nigeria (FMBN) Mortgage Loan Management System  
**Database:** `fmbn_mortgage_db`  
**Platform:** PostgreSQL, managed through pgAdmin 4

## 1. Case study and design scope

For this assessment, I designed a relational database to model a fictional mortgage processing environment for the Federal Mortgage Bank of Nigeria. Its scope covers branch administration, customer registration, employee records, property information, mortgage applications, approval decisions, loan accounts and repayments. The purpose of this design is to connect the stages of mortgage processing while preserving the identity and relationships of the records involved.

I implemented eight relational tables in the `public` schema of `fmbn_mortgage_db`. I generated the accompanying SQL export from the existing PostgreSQL database using pgAdmin. I also produced the Entity Relationship diagram in pgAdmin and saved it with the Portfolio 1 screenshots. The schema and diagram are the basis for the analysis below.

## 2. Relational schema and table responsibilities

| Table | Primary key | Main attributes and purpose |
| --- | --- | --- |
| `branches` | `branch_id` | Stores branch name, location and telephone number. |
| `customers` | `customer_id` | Stores customer identity, contact details, registration date and associated branch. |
| `employees` | `employee_id` | Stores employee identity, job title, email and associated branch. |
| `properties` | `property_id` | Stores property address, type and recorded value. |
| `mortgage_applications` | `application_id` | Links a customer to a property and records the requested amount, date and application status. |
| `loan_approvals` | `approval_id` | Records an application decision, responsible employee, date and remarks. |
| `loans` | `loan_id` | Records the loan linked to an application, including amount, interest rate, duration, disbursement date and status. |
| `repayments` | `repayment_id` | Records individual payments against a loan, including date, amount, method and reference. |

Each table has a distinct primary key. PostgreSQL sequences supply default values for these identifiers. The exported script includes the table definitions, sequences, constraints and index; it does not include the table records because it was generated as a schema only export.

## 3. Relationships and Entity Relationship diagram

The diagram shows how records are connected through the eight foreign key constraints implemented in PostgreSQL:

| Referencing table and column | Referenced table and column | Design implication |
| --- | --- | --- |
| `customers.branch_id` | `branches.branch_id` | Each customer is associated with one recorded branch; a branch can be referenced by multiple customers. |
| `employees.branch_id` | `branches.branch_id` | Each employee is associated with one recorded branch; a branch can be referenced by multiple employees. |
| `mortgage_applications.customer_id` | `customers.customer_id` | Each application belongs to one customer; a customer can submit multiple applications. |
| `mortgage_applications.property_id` | `properties.property_id` | Each application refers to one property; the schema permits a property to be referenced by multiple applications. |
| `loan_approvals.application_id` | `mortgage_applications.application_id` | Each approval record concerns one application; multiple approval records are not prohibited by this foreign key. |
| `loan_approvals.employee_id` | `employees.employee_id` | Each approval record identifies an employee; an employee can appear in multiple approval records. |
| `loans.application_id` | `mortgage_applications.application_id` | Each loan refers to one application; the unique constraint on this column limits an application to at most one loan record. |
| `repayments.loan_id` | `loans.loan_id` | Each repayment belongs to one loan; a loan can have multiple repayments. |

PostgreSQL foreign key constraints enforce references to existing parent rows (PostgreSQL Global Development Group, n.d.a). In this implementation, the foreign keys prevent a child record from referring to a nonexistent parent record. In particular, a repayment cannot reference a loan identifier absent from `loans`, and a mortgage application cannot reference an unregistered customer or property. The schema does not specify cascading deletes, so no cascading deletion behaviour is claimed.

**Diagram evidence:** `Screenshots/04 - fmbn entity relationship diagram(2).png`.

## 4. Implemented constraints and validation

The exported schema establishes the following controls:

**Required values.** Primary key columns and important relationship fields are `NOT NULL`. Mortgage application requested amounts, property values, loan amounts, interest rates, loan durations, repayment amounts and specified status fields also have required value constraints where defined.

**Unique values.** `customers.email` and `employees.email` have unique constraints. `repayments.payment_reference` is unique, and `loans.application_id` is unique. The email and payment reference columns are nullable, so these constraints should not be interpreted as requiring a value for every record.

**Amount and duration checks.** The schema requires positive property values, requested amounts, loan amounts, repayment amounts and loan durations. Interest rates must be zero or greater. These checks prevent certain invalid numeric entries but do not establish wider mortgage eligibility rules.

**Status checks.** `mortgage_applications.application_status` accepts `Pending`, `Approved` or `Rejected`, with `Pending` as its default. `loan_approvals.approval_status` accepts `Approved` or `Rejected`. `loans.loan_status` accepts `Active`, `Completed` or `Defaulted`, with `Active` as its default.

**Date defaults.** Customer registration dates, mortgage application dates, approval dates and repayment dates default to `CURRENT_DATE` where the corresponding columns are omitted during insertion.

These controls follow PostgreSQL’s documented constraint mechanisms (PostgreSQL Global Development Group, n.d.a) and support basic data integrity at database level. They do not, on their own, enforce every possible business rule. For example, the exported schema does not establish that a loan can be inserted only after an approved decision has been recorded.

## 5. Normalisation analysis

I organised the table structure to separate branch, customer, employee, property, application, approval, loan and repayment information instead of repeating all details in a single mortgage transaction table.

**First Normal Form (1NF).** The implemented tables use individual columns for the recorded attributes and primary keys to distinguish rows. Repeated repayments are stored as separate rows in `repayments`, rather than as multiple payment fields within a loan record. This structure is consistent with the main requirements of 1NF.

**Second Normal Form (2NF).** Every table uses a single column primary key. Consequently, there is no composite primary key from which a nonkey attribute could depend on only one part. This removes the usual partial dependency concern associated with composite keys, assuming the attributes represent the entities described in the schema.

**Third Normal Form (3NF).** Branch details are held in `branches`, while customers and employees store `branch_id` references rather than duplicating branch names and locations. Property attributes are maintained in `properties` rather than repeated in each application. Loan terms are held in `loans`, and individual payment details are held in `repayments`. These separations reduce common transitive dependency and update anomaly risks.

The separation of attributes follows established relational normalisation principles (Elmasri & Navathe, 2016). The design is **consistent with a 3NF approach for the stated business assumptions**, but the SQL export alone does not formally prove all functional dependencies. A definitive normalisation assessment would require the full set of business rules, including whether any attributes uniquely determine others beyond the declared keys. This limitation is relevant when interpreting the schema as a production design.

## 6. Index and implementation evidence

I created a B tree index named `idx_mortgage_requested_amount` on `mortgage_applications.requested_amount`. This is visible in the exported SQL schema and may support queries that filter or order by requested loan amount. Whether PostgreSQL uses the index for a particular query depends on its execution plan and the data distribution; index performance is examined separately in Portfolio 2. PostgreSQL documents how indexes can accelerate suitable queries while introducing maintenance overhead (PostgreSQL Global Development Group, n.d.b).

The supporting Portfolio 1 materials comprise:

1. `Portfolio 1 Database Schema.sql`, exported from PostgreSQL as schema only SQL.
2. The Entity Relationship diagram in the `Screenshots` folder.
3. The remaining Portfolio 1 pgAdmin screenshots showing the practical database design work.

The schema only export follows the functionality described in PostgreSQL’s `pg_dump` documentation (PostgreSQL Global Development Group, n.d.c). The SQL script provides inspectable evidence of the implemented table definitions and constraints, while the diagram makes the relationships easier to follow. The screenshot evidence and schema should be read together.

## 7. Technical reflection

The main design decision was to separate mortgage processing into related records. A customer can be linked to multiple applications without repeating their identity information, and a loan can be linked to multiple repayments without storing payment history inside a single row. Primary and foreign keys provide a clear basis for tracing an application from its customer and property through approval, loan creation and repayment.

Reviewing my exported schema highlighted limitations that would matter in a live banking environment. The application status options are restricted to three values, and the current constraints do not fully enforce the relationship between an approval decision and the creation of a loan. Additional business rules, permissions and transaction controls would be needed before the model could support production mortgage processing. I therefore regard this database as a practical academic implementation rather than a complete operational banking system.

## 8. References, implementation evidence and AI use declaration

**References**

Elmasri, R., & Navathe, S. B. (2016). *Fundamentals of database systems* (7th ed.). Pearson.

PostgreSQL Global Development Group. (n.d.a). *Constraints*. PostgreSQL documentation. https://www.postgresql.org/docs/current/ddl-constraints.html

PostgreSQL Global Development Group. (n.d.b). *Indexes*. PostgreSQL documentation. https://www.postgresql.org/docs/current/indexes.html

PostgreSQL Global Development Group. (n.d.c). *pg_dump*. PostgreSQL documentation. https://www.postgresql.org/docs/current/app-pgdump.html

**Course assessment document:** MIT 8103 Advanced Database Systems. (2026). *Continuous Assessment brief, 2026/2027 academic session*. Course material.

**Implementation evidence:** `Portfolio 1 Database Schema.sql`, exported from `fmbn_mortgage_db`, and the Portfolio 1 pgAdmin screenshots, including the Entity Relationship diagram.

**AI use declaration:** I used ChatGPT as a supporting tool during the preparation of this portfolio, particularly in organising the documentation, refining the presentation of technical information and improving the clarity and coherence of my explanations. Its assistance helped me present my database design, implementation process and technical observations in a structured and systematic manner. The database design, practical implementation, technical decisions and supporting evidence presented in this portfolio are based on the work I personally carried out.
