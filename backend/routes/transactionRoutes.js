const express = require("express");
const router = express.Router();
const transactionController = require("../controllers/transactionController");

router.post("/deposit", transactionController.deposit);
router.post("/transfer", transactionController.transfer);
router.post("/debit", transactionController.debit);
router.get("/history/:account_no",transactionController.getTransactionHistory);
router.get("/:transaction_id",transactionController.getTransactionById);

router.get("/company/:companyAccountNo",transactionController.getCompanyPayments);

router.get("/recent/:account_no",transactionController.getRecentTransactions);

module.exports = router;