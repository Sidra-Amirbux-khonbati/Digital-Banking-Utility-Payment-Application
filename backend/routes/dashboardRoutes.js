const express = require("express");

const router = express.Router();

const dashboardController =
require("../controllers/dashboardController");

router.get("/:account_no",dashboardController.getDashboard);

module.exports = router;