const historyModel = require("../models/historyModel");

const getTransactionHistory = async (req, res) => {

    try {

        const { account_no } = req.params;

        const transactions = await historyModel.getTransactionHistory(account_no);

        res.json({
            success: true,
            transactions
        });

    }

    catch (error) {

    console.log(error);

    res.status(500).json({
        success: false,
        message: error.message
    });

}

};

module.exports = {
    getTransactionHistory
};