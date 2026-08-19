const express = require("express");

const router = express.Router();

const companyController =
require("../controllers/companyController");


router.post("/signup",companyController.signupCompany);
router.post("/login",companyController.companyLogin);
router.get("/pending",companyController.getPendingCompanies);
router.get("/status/:email",companyController.checkCompanyStatus);
router.patch("/approve/:queue_id",companyController.approveCompany);
router.patch("/reject/:queue_id", companyController.rejectCompany);

module.exports = router;