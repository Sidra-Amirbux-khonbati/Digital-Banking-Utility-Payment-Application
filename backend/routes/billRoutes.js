const express = require("express");
const router = express.Router();
const billController = require("../controllers/billController");

router.post("/generate", billController.generateBill);
router.post("/pay", billController.payBill);
router.get("/company/:company_id/statistics",billController.getBillStatistics);
router.post("/customer/pay",billController.customerPayBill);
router.get("/all", billController.getBills);
router.get("/company/:company_id/summary",billController.getCompanyBillSummary);
router.get("/company/:company_id",billController.getCompanyBills);
router.get("/customer/:accountNo",billController.getCustomerBills);
router.get("/pdf/:bill_id", billController.downloadBillPdf);
router.get("/receipt/:bill_id",billController.downloadReceipt);


module.exports = router;