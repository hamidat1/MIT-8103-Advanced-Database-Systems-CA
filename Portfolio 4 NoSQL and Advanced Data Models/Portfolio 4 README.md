# PORTFOLIO 4: NoSQL AND ADVANCED DATA MODELS

## MIT 8103 – Advanced Database Systems

### Case Study: Federal Mortgage Bank of Nigeria (FMBN) Mortgage Loan Management System

## 1. Introduction

For my MIT 8103 Advanced Database Systems Continuous Assessment, I selected the Federal Mortgage Bank of Nigeria (FMBN) Mortgage Loan Management System as my case study.

My decision to use FMBN was influenced by my professional experience as an employee of the bank. Working within this environment has given me a better appreciation of the importance of proper data management in banking operations, particularly in areas involving customer information, mortgage loan applications, loan processing, and record management.

I considered this case study suitable for my assessment because it allows me to relate the database concepts I am learning to an environment I am already familiar with. Rather than approaching the assignment purely from a theoretical perspective, I wanted to explore how different database technologies could be applied to a practical banking scenario.

For Portfolio 4, I focused on implementing a NoSQL database using MongoDB. My objective was to demonstrate how mortgage application records, customer information, and loan details could be organised and managed using a document-oriented database model.

To carry out the implementation, I created fictional customer profiles and mortgage application records based on the type of information a mortgage loan management system would typically handle. I then used these records to demonstrate document insertion, retrieval, filtering, updating, counting, and aggregation.

Through this exercise, I aim to demonstrate my understanding of NoSQL database concepts while exploring their relevance to mortgage banking operations.

## 2. Selection of the NoSQL Database Model

For this portfolio, I selected MongoDB, which uses a document-oriented NoSQL database model.

I chose this model because it allows me to organise related information within a single document instead of separating every category of information into different relational tables.

In my implementation, each mortgage application document contains information about the application, the customer and the requested loan.

I used embedded documents to represent customer information and loan details.

This approach helped me demonstrate how MongoDB can manage related information using a flexible document structure.

## 3. Database Design and Structure

I created my MongoDB database using MongoDB Atlas and accessed it through MongoDB Shell (mongosh) on Ubuntu.

The database and collection names I used are:

Database:
fmbn_mortgage_nosql

Collection:
mortgage_applications

I organised each mortgage application document using the following fields:

- application_id: Identifies the mortgage application.
- customer: Stores the customer's details as an embedded document.
- customer_id: Identifies the customer.
- full_name: Stores the customer's name.
- employment_status: Records the customer's employment category.
- requested_amount: Stores the mortgage amount requested.
- application_status: Records the current application status.
- loan_details: Stores information about the requested mortgage.
- loan_type: Identifies the mortgage product.
- repayment_period_years: Records the proposed repayment period.
- interest_rate: Records the interest rate used in the sample.

I also prepared a NoSQL data model diagram to illustrate how I organised the database, collection and embedded documents.

## 4. MongoDB Implementation

I implemented the document model using four fictional mortgage application records.

The records represent the following applicants:

1. Ahmed Ibrahim
2. Fatima Bello
3. Chinedu Okafor
4. Aisha Musa

I used these records to demonstrate the following MongoDB operations.

### 4.1 Document Insertion

I used insertOne() to insert my first mortgage application document.

I then used insertMany() to insert three additional mortgage application documents.

After inserting the records, I retrieved them to confirm that MongoDB had stored the documents successfully.

### 4.2 Document Retrieval

I used findOne() to retrieve an individual mortgage application.

I also used find() to retrieve the mortgage application records from the collection.

These operations allowed me to inspect the stored documents and confirm their structure.

### 4.3 Conditional Queries

I performed a query to retrieve mortgage applications with an application_status of "Approved".

This allowed me to demonstrate how MongoDB filters documents using a specified condition.

I also queried applications where the requested_amount was greater than 20,000,000.

This demonstrated the use of MongoDB comparison operators when filtering numerical values.

### 4.4 Querying Embedded Documents

I queried the customer.employment_status field to retrieve applications belonging to self-employed customers.

I used dot notation to access the employment_status field within the embedded customer document.

This demonstrated how I could retrieve information stored inside nested MongoDB documents.

### 4.5 Document Update

I used updateOne() to change Fatima Bello's application status from "Pending" to "Under Review".

I then retrieved the document again to confirm that the update had been applied.

This demonstrated how I could modify a specific field without replacing the entire document.

### 4.6 Document Counting

I used countDocuments() to determine the number of mortgage application records in my collection.

The operation returned four documents, confirming the number of sample applications I had inserted.

### 4.7 Aggregation

I used MongoDB's aggregation framework to group mortgage applications by their application status.

I calculated both the number of applications and the total requested mortgage amount for each status.

My aggregation returned the following results:

Approved:
- Number of applications: 2
- Total requested amount: NGN 37,000,000

Under Review:
- Number of applications: 2
- Total requested amount: NGN 48,000,000

From these results, I observed that the four applications had a combined requested amount of NGN 85,000,000.

This exercise demonstrated how I could use MongoDB aggregation to summarise mortgage application data.

## 5. Suitability of MongoDB for the Case Study

I consider MongoDB suitable for this mortgage loan management case study for several reasons.

First, its document-oriented structure allowed me to keep related application, customer and loan information together.

Second, its support for embedded documents made it possible for me to organise customer details and loan information without creating separate collections for every field.

Third, MongoDB's query capabilities allowed me to retrieve applications based on their status, requested amount and customer employment category.

Fourth, I was able to update an application status and use aggregation to summarise the mortgage application records.

I also recognise that a real banking implementation would require additional considerations, including access controls, data validation, audit trails, consistency requirements and protection of customer information.

For this assessment, my implementation demonstrates how the MongoDB document model could support the storage and analysis of mortgage application information.

## 6. Implementation Evidence

I captured screenshots during my MongoDB practical exercises to demonstrate the operations I performed.

My evidence includes:

- Portfolio 4 MongoDB Document Insertion and Retrieval.png
- Portfolio 4 MongoDB Multiple Document Retrieval.png
- Portfolio 4 MongoDB Conditional Query Approved Applications.png
- Portfolio 4 MongoDB Numerical Query Above 20 Million.png
- Portfolio 4 MongoDB Nested Document Query.png
- Portfolio 4 MongoDB Document Update.png
- Portfolio 4 MongoDB Document Count.png
- Portfolio 4 MongoDB Aggregation by Application Status.png
- Portfolio 4 MongoDB NoSQL Data Model.png

I also prepared the following JavaScript implementation file:

Portfolio 4 MongoDB Implementation.js

The JavaScript file brings together the database structure, sample records, retrieval queries, counting and aggregation operations used in my implementation.

## 7. Conclusion

Through Portfolio 4, I gained practical experience in designing and working with a document-oriented NoSQL database.

I successfully created a MongoDB database, stored mortgage application documents, queried both ordinary and embedded fields, updated an application status, counted records and performed aggregation.

The exercise helped me understand how MongoDB differs from a traditional relational database in the way it organises related information.

Most importantly, I was able to connect the NoSQL concepts covered in MIT 8103 Advanced Database Systems to a mortgage banking scenario that is familiar to me through my professional experience.
