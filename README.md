# Finova — Digital Banking & Utility Bill Payment Platform

## 📌 Overview

**Finova** is a full-stack digital banking and utility bill payment platform that allows customers to manage their bank accounts, transfer money, pay utility bills, and view transactions.

The system also provides a separate portal for **utility companies** to generate and manage customer bills, while an **Admin** reviews and approves or rejects company registration requests.

A key feature of the system is automated customer registration: the customer uploads a PDF account-opening form, the system extracts the required information and automatically fills the registration form. After successful account creation, a confirmation email is sent to the customer.

---

## 🚀 Key Features

### 👤 Customer Module

* Customer registration
* PDF form upload
* Automatic form auto-fill from uploaded PDF
* PDF text extraction using `pdf-parse`
* Data extraction using Regular Expressions (Regex)
* Automatic customer account creation
* Account number generation
* Customer confirmation email using Nodemailer
* Customer login
* Customer profile
* Account balance
* Cash deposit
* Money transfer
* QR code generation
* QR code scanning
* Recent transactions
* Complete transaction history
* Utility bill viewing
* Bill details
* Bill payment
* Overdue bill detection
* Automatic 5% late-payment fine
* Total payable amount calculation
* PDF payment receipt
* Receipt viewing/download

---

### 🏢 Company Module

Companies can register their company by submitting a registration request.

#### Company Registration Flow

```text
Company Registration Request
          ↓
       Admin
          ↓
    Approve / Reject
          ↓
     Company Login
```

Features include:

* Company registration request
* Request status checking using email
* Admin approval/rejection
* Company login
* Company dashboard
* Bill generation
* Bill management
* Customer bill records
* Paid/Pending/Overdue bill tracking
* Bill statistics
* Payment history

---

### 👨‍💼 Admin Module

The Admin module manages company registration requests.

Admin can:

* View pending company requests
* Approve company requests
* Reject company requests
* Control which companies can access the company portal

---

## 💰 Banking Features

### Account Management

Each customer receives a unique account number after successful registration.

The system maintains:

* Customer information
* Account information
* Account type
* Account status
* Account balance

### Money Transfer

Customers can transfer money using:

* Account number
* QR code

The system validates transactions and prevents invalid transfers such as transferring money to the same account.

### Balance Management

The system maintains running balances for customer and company accounts.

Transactions update the relevant balances accordingly.

---

## 🧾 Utility Bill Management

Companies can generate bills containing information such as:

* Bill ID
* Customer account number
* Consumer number
* Billing month
* Bill issue date
* Due date
* Amount
* Remarks

Customers can view and pay their bills through the Flutter application.

---

## 🔴 Overdue & Fine System

The system automatically checks whether a pending bill has passed its due date.

```text
Pending Bill
     ↓
Due Date Passed
     ↓
Overdue
     ↓
5% Late Fee
```

For example:

```text
Bill Amount = PKR 2,500
Fine        = PKR 125
Total       = PKR 2,625
```

The customer can see:

* Original bill amount
* Late fee
* Total payable amount
* Overdue status

---

## 📄 PDF Processing

During customer registration, the user uploads a PDF account-opening form.

The backend:

1. Receives the uploaded PDF.
2. Extracts text using **pdf-parse**.
3. Uses **Regular Expressions (Regex)** to identify required fields.
4. Sends the extracted information to the frontend.
5. Automatically fills the customer registration form.
6. Creates the customer account after submission.

> **Note:** The project uses PDF text extraction with `pdf-parse` and Regex for this workflow.

---

## 📧 Email Notification

After successful customer account creation, the system automatically sends a confirmation email using **Nodemailer**.

The email can contain:

* Account creation confirmation
* Customer information
* Account number
* Relevant account details

---

## 📱 QR Code System

FinBridge supports QR-based money transfers.

### QR Generation

The customer can generate a QR code containing transfer information.

### QR Scanning

Another customer can scan the QR code using the mobile scanner and proceed to the transfer screen.

Technologies used:

* `qr_flutter`
* `mobile_scanner`

---

## 📑 PDF Receipt

After a successful bill payment, the customer can view the payment receipt as a PDF.

The backend generates the receipt using **PDFKit**.

---

# 🛠️ Technology Stack

## Frontend

* Flutter
* Dart
* Material Design
* HTTP
* `mobile_scanner`
* `qr_flutter`
* `url_launcher`

## Backend

* Node.js
* Express.js
* JavaScript
* REST APIs
* MVC Architecture
* Multer
* pdf-parse
* Regex
* Nodemailer
* PDFKit

## Database

* PostgreSQL
* NeonDB
* SQL
* Relational Database Design
* Foreign Keys
* Constraints
* Joins
* Database Transactions

## Development Tools

* Visual Studio Code
* Postman
* Git
* GitHub
* Flutter SDK
* Node.js
* PostgreSQL / NeonDB

---

# 🏗️ System Architecture

```text
                ┌─────────────────────┐
                │      Flutter App    │
                │   Customer / Company│
                └──────────┬──────────┘
                           │
                       REST APIs
                           │
                           ▼
                ┌─────────────────────┐
                │   Node.js + Express │
                │      Backend        │
                │    MVC Architecture │
                └──────────┬──────────┘
                           │
                           ▼
                ┌─────────────────────┐
                │ PostgreSQL / NeonDB │
                └─────────────────────┘
```

Additional integrations:

```text
PDF Upload → pdf-parse → Regex → Auto-filled Form

Customer Registration → Nodemailer → Confirmation Email

Bill Payment → PDFKit → Payment Receipt

QR Generator → QR Code → QR Scanner → Transfer
```

---

# 🗄️ Database

The project uses PostgreSQL hosted on NeonDB.

Main tables include:

* `customer`
* `account`
* `balance`
* `company`
* `bill`
* `transactions`
* `company_queue`


The database uses relationships, foreign keys, constraints and SQL queries to maintain data consistency.

---

# 🔌 Major REST APIs

### Customer

```text
POST /customer/login
POST /customer/add
```

### Company

```text
POST /company/login
POST /company/request
GET  /company/status/:email
```

### Bills

```text
POST /bill/generate
POST /bill/pay
POST /bill/customer/pay

GET /bill/all
GET /bill/customer/:accountNo
GET /bill/company/:company_id
GET /bill/company/:company_id/summary
GET /bill/company/:company_id/statistics
GET /bill/pdf/:bill_id
GET /bill/receipt/:bill_id
```

### Transactions

```text
POST /transaction/deposit
POST /transaction/transfer
GET  /transaction/history/:accountNo
GET  /transaction/recent/:accountNo
GET  /transaction/company/:companyAccountNo
```

### Balance

```text
GET /balance/:accountNo
```

---

# 🔐 Business Logic

The system implements several real-world banking rules:

* Unique customer accounts
* Account balance management
* Same-account transfer prevention
* Balance validation
* Transaction recording
* Bill payment validation
* Automatic overdue detection
* 5% overdue fine calculation
* Customer/company balance updates
* Payment receipt generation
* Company approval workflow
* Customer email notification

---

# 📂 Project Structure

```text
FinBridge/
│
├── backend/
│   ├── controllers/
│   ├── models/
│   ├── routes/
│   ├── services/
│   ├── utils/
│   └── server.js
│
├── flutter/
│   ├── lib/
│   │   ├── core/
│   │   ├── screens/
│   │   ├── services/
│   │   └── widgets/
│   └── pubspec.yaml
│
└── README.md
```

---

# ▶️ How to Run

## Backend

Navigate to the backend folder:

```bash
cd backend
```

Install dependencies:

```bash
npm install
```

Start the server:

```bash
node server.js
```

---

## Flutter

Navigate to the Flutter project:

```bash
cd flutter
```

Get dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

---

# 🔒 Environment Configuration

Sensitive information such as:

* Database credentials
* Email credentials
* API keys
* Environment variables

should be stored in a `.env` file and should **not be committed to GitHub**.

Example:

```env
DB_HOST=your_database_host
DB_USER=your_database_user
DB_PASSWORD=your_database_password
DB_NAME=your_database_name

EMAIL_USER=your_email
EMAIL_PASSWORD=your_email_app_password
```

Add `.env` to `.gitignore`:

```text
.env
```

---

# 🎯 Skills Demonstrated

This project demonstrates practical experience in:

* Full Stack Development
* Flutter Mobile Development
* Backend Development
* REST API Development
* PostgreSQL Database Management
* MVC Architecture
* SQL & Database Design
* PDF Processing
* Regex Data Extraction
* Email Integration
* QR Code Integration
* Financial Transaction Logic
* Bill Payment Systems
* Authentication
* API Integration
* Error Handling
* Git & GitHub
* Debugging and Problem Solving

---

# 👩‍💻 Project Purpose

The main purpose of FinBridge is to demonstrate how a real-world banking and utility payment workflow can be implemented by integrating a mobile frontend, backend REST APIs, relational database, document processing, email services, QR payments and financial business logic into a single system.

---

## 👤 Author

**Sidra Amirbux Khonbati**

BS Software Engineering

