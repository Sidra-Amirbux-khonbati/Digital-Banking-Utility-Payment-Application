const express = require("express");
const router = express.Router();
const accountController = require("../controllers/accountController");

router.post("/add", accountController.addAccount);

module.exports = router;