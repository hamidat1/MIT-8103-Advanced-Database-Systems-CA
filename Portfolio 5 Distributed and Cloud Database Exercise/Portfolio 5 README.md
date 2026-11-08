# Portfolio 5: Distributed and Cloud Database Exercise

**Course:** MIT 8103 Advanced Database Systems  
**Case study:** Federal Mortgage Bank of Nigeria (FMBN) Mortgage Loan Management System  
**Platform:** MongoDB Atlas

## 1. Scope and approach

I carried out this exercise using the MongoDB Atlas environment I had established for Portfolio 4. I retained the FMBN Mortgage Loan Management System as my case study so that the cloud deployment could be assessed in relation to the same fictional mortgage application records used in my earlier practical work. Rather than create a separate database merely for this portfolio, I examined the deployment configuration, the replication arrangement and the operational information available through Atlas.

My practical investigation concentrated on the existing cloud deployment and its replica set. I also considered the implications of the observed architecture for mortgage application availability and record consistency, together with the circumstances in which sharding might become appropriate. I have distinguished the configuration I inspected from measures I did not implement or test.

## 2. Cloud deployment and database configuration

I accessed the Atlas Clusters page and inspected **FMBN-Mortgage-Cluster**, which hosts the `fmbn_mortgage_nosql` database and the `mortgage_applications` collection. The collection contains four fictional mortgage applications created during Portfolio 4, with customer details, requested loan amounts, application statuses and mortgage information. These records provided continuity between the document database exercise and my examination of its cloud infrastructure.

The Atlas interface identified **Amazon Web Services (AWS)** as the hosting provider, **Paris** as the deployment region, the **Free** cluster tier and **MongoDB version 8.0.37**. The deployment was identified as a **replica set comprising three members**. I recorded these settings in *Portfolio 5 MongoDB Atlas Cloud Deployment and Replication.png*.

This was an inspection of an existing Atlas deployment, not a new cloud infrastructure installation undertaken specifically for Portfolio 5. The distinction matters because my evidence establishes the configuration visible in Atlas, rather than a claim that I manually provisioned each database server.

## 3. Replication configuration and operational observations

I opened the cluster monitoring dashboard and subsequently examined the cluster overview to identify the replica set members. At the time of observation, **Node 01** was labelled **Primary**, while **Node 00** and **Node 02** were labelled **Secondary**. All three displayed green status indicators. The monitoring dashboard also presented operational charts for the cluster, including database activity metrics.

These observations are documented in *Portfolio 5 MongoDB Atlas Replica Set Monitoring.png* and *Portfolio 5 MongoDB Atlas Primary and Secondary Nodes.png*. The screenshots provide evidence of the member roles and the reported operational state at the time I inspected the deployment. They do not independently establish how quickly replication occurs or whether the cluster would recover within a particular period after a failure.

For the FMBN case study, maintaining copies of mortgage application data across replica set members is relevant to continuity of operations. Application processing involves changes to records that staff may need to retrieve later, including status changes and loan details. The observed configuration reduces dependence on a single database member, although actual service continuity remains subject to the cluster's election conditions, network connectivity and application behaviour.

## 4. Availability considerations for mortgage processing

I assessed availability in relation to the three member replica set I observed. The presence of a primary and two secondaries provides an architecture in which an eligible secondary may be elected primary if the existing primary becomes unavailable and the required majority can participate. This is significant for a mortgage processing environment because an interruption during application review could delay record retrieval or prevent staff from saving updates.

My screenshots show that the three members were reporting healthy status when I inspected them. I did **not** stop a member, simulate a network interruption or initiate an election. Consequently, I have not presented the configuration as proof of successful failover, uninterrupted service or a measured recovery time. Those claims would require a controlled test and supporting results beyond the evidence collected for this exercise.

## 5. Consistency considerations for mortgage application records

I considered consistency using the application status information stored in `mortgage_applications`. In Portfolio 4, I updated a fictional application status from **Pending** to **Under Review**. In a mortgage processing system, a status change of this kind must be handled carefully because staff decisions and subsequent processing may depend on which version of a record is retrieved.

The replica set architecture makes the choice of read and write settings relevant. For a production implementation, I would evaluate majority acknowledgement for important updates and select read settings according to the level of freshness and consistency required by each operation. I would also consider how the application handles retries and confirms that a status update has been committed before displaying a final outcome to a user. These choices require attention to both correctness and the latency they may introduce.

I did **not** configure or test alternative read concern or write concern settings in this portfolio. I therefore make no claim that a particular consistency guarantee was experimentally demonstrated. My analysis identifies decisions that would need to be validated before applying this architecture to live mortgage records.

## 6. Sharding assessment and scalability

I considered whether the same database would benefit from sharding as its workload grows. The present exercise uses four fictional application documents, and the Atlas deployment I inspected is a replica set rather than a sharded cluster. At this scale, introducing sharding would not be justified by the evidence available.

For a substantially larger mortgage system, I would first examine application volume, frequently executed queries, write activity and the distribution of requests across customer and application records. If the workload exceeded the capacity of an appropriately sized replica set, sharding could be evaluated as a way to distribute data and processing across multiple shards. The selection of a shard key would require particular care: an unsuitable key could concentrate requests on a small part of the deployment or make common application searches less efficient.

I did **not** configure sharding, select a production shard key or benchmark a sharded deployment. This section records a reasoned scalability assessment based on the case study, not an implementation result.

## 7. Practical evidence and verification

I retained three screenshots in the `Screenshots` folder:

1. **Portfolio 5 MongoDB Atlas Cloud Deployment and Replication.png.** Records the cluster name, AWS hosting, Paris region, cluster tier, MongoDB version and three member replica set configuration.
2. **Portfolio 5 MongoDB Atlas Replica Set Monitoring.png.** Records the monitoring dashboard and the operational metrics displayed for the cluster.
3. **Portfolio 5 MongoDB Atlas Primary and Secondary Nodes.png.** Records the primary and secondary member roles and their status indicators at the time of inspection.

I verified the information reported in this document against the Atlas screens I accessed. The practical evidence supports the deployment and replication observations. The discussion of failover conditions, consistency settings and sharding is analytical and should not be interpreted as evidence that I configured or tested those features.

## 8. Technical reflection

Working with the same MongoDB database across Portfolios 4 and 5 allowed me to examine the relationship between application data and the infrastructure that hosts it. The most useful observation was the distinction between seeing a three member replica set in the Atlas interface and establishing its behaviour under failure conditions. I could identify the primary and secondary members and review monitoring information, but those observations alone could not tell me how quickly an election would complete or what a user would experience during an interruption.

The exercise also made me consider the consequences of infrastructure decisions for mortgage processing. Replication is relevant to continuity, while the handling of reads and acknowledged writes affects how confidently an application can present updated records. I would prioritise controlled failure testing, verification of write acknowledgement and review of application query patterns before recommending a production configuration for a banking environment. I would not introduce sharding without evidence of a genuine capacity or workload requirement.

## 9. References and AI use declaration

**Assessment brief:** MIT 8103 Advanced Database Systems, First Semester Continuous Assessment, 2026/2027 academic session.

**Technical reference:** MongoDB official documentation covering replica sets, elections, read concern, write concern and sharding. The documentation was used as conceptual guidance; the cluster details and observations reported above were taken from my Atlas exercise.

**AI use declaration:** I used ChatGPT to assist with organising and drafting this account of the exercise and with clarifying relevant database concepts. I reviewed the wording against my MongoDB Atlas screenshots and the work I carried out. I remain responsible for checking the technical accuracy of the final submission and for explaining the decisions and limitations described here.
