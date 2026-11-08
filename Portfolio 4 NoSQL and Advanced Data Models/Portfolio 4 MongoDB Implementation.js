// MIT 8103 Advanced Database Systems
// Portfolio 4: NoSQL and Advanced Data Models
// Case Study: Simulated FMBN Mortgage Loan Management System
// Database: fmbn_mortgage_nosql
// Collection: mortgage_applications

// STEP 1: Select the MongoDB database
const mortgageDB = db.getSiblingDB("fmbn_mortgage_nosql");
const applications = mortgageDB.getCollection("mortgage_applications");

print("=== FMBN Mortgage Loan Management System ===");

// STEP 2: Insert or update sample mortgage applications
// Using upsert avoids creating duplicate application IDs.

const mortgageRecords = [
  {
    application_id: 1,
    customer: {
      customer_id: 1,
      full_name: "Ahmed Ibrahim",
      employment_status: "Employed"
    },
    requested_amount: 25000000,
    application_status: "Approved",
    loan_details: {
      loan_type: "National Housing Fund Mortgage",
      repayment_period_years: 20,
      interest_rate: 6.0
    }
  },
  {
    application_id: 2,
    customer: {
      customer_id: 2,
      full_name: "Fatima Bello",
      employment_status: "Self-Employed"
    },
    requested_amount: 18000000,
    application_status: "Under Review",
    loan_details: {
      loan_type: "National Housing Fund Mortgage",
      repayment_period_years: 15,
      interest_rate: 6.0
    }
  },
  {
    application_id: 3,
    customer: {
      customer_id: 3,
      full_name: "Chinedu Okafor",
      employment_status: "Employed"
    },
    requested_amount: 12000000,
    application_status: "Approved",
    loan_details: {
      loan_type: "National Housing Fund Mortgage",
      repayment_period_years: 10,
      interest_rate: 6.0
    }
  },
  {
    application_id: 4,
    customer: {
      customer_id: 4,
      full_name: "Aisha Musa",
      employment_status: "Employed"
    },
    requested_amount: 30000000,
    application_status: "Under Review",
    loan_details: {
      loan_type: "National Housing Fund Mortgage",
      repayment_period_years: 25,
      interest_rate: 6.0
    }
  }
];

mortgageRecords.forEach((record) => {
  applications.updateOne(
    { application_id: record.application_id },
    { $set: record },
    { upsert: true }
  );
});

print("Sample mortgage applications saved successfully.");

// STEP 3: Retrieve all mortgage applications
print("\n=== ALL MORTGAGE APPLICATIONS ===");

printjson(
  applications.find(
    {},
    {
      projection: {
        _id: 0,
        application_id: 1,
        "customer.full_name": 1,
        requested_amount: 1,
        application_status: 1
      }
    }
  ).sort({ application_id: 1 }).toArray()
);

// STEP 4: Retrieve approved applications
print("\n=== APPROVED APPLICATIONS ===");

printjson(
  applications.find(
    { application_status: "Approved" }
  ).toArray()
);

// STEP 5: Retrieve applications above 20 million
print("\n=== APPLICATIONS ABOVE 20 MILLION ===");

printjson(
  applications.find(
    { requested_amount: { $gt: 20000000 } }
  ).toArray()
);

// STEP 6: Query nested customer information
print("\n=== SELF-EMPLOYED CUSTOMERS ===");

printjson(
  applications.find(
    { "customer.employment_status": "Self-Employed" }
  ).toArray()
);

// STEP 7: Count mortgage applications
print("\n=== TOTAL APPLICATION COUNT ===");

print(applications.countDocuments({}));

// STEP 8: Aggregate applications by status
print("\n=== APPLICATION STATUS AGGREGATION ===");

printjson(
  applications.aggregate([
    {
      $group: {
        _id: "$application_status",
        total_applications: { $sum: 1 },
        total_requested_amount: { $sum: "$requested_amount" }
      }
    },
    {
      $sort: { _id: 1 }
    }
  ]).toArray()
);

print("\n=== PORTFOLIO 4 SCRIPT COMPLETED ===");
