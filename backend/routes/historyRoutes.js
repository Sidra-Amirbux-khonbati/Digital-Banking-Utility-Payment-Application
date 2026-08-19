const express = require("express");
const router = express.Router();
const historyController = require("../controllers/historyController");

router.get("/:account_no", historyController.getTransactionHistory);

module.exports = router;