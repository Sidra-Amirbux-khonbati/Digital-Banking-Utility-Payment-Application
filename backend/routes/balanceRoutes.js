const express = require("express");

const router = express.Router();

const balanceController = require("../controllers/balanceController");

router.get("/:account_no", balanceController.getBalance);

module.exports = router;