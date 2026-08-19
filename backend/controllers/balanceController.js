const balanceModel = require("../models/balanceModel");

const getBalance = async (req, res) => {

    try {

        const { account_no } = req.params;

        const balance = await balanceModel.getBalance(account_no);

        if (!balance) {
            return res.status(404).json({
                success: false,
                message: "Account not found"
            });
        }

        res.status(200).json({
            success: true,
            account_no: balance.account_no,
            customer_name: balance.customer_name,
            account_status: balance.account_status,
            running_balance: balance.running_balance
        });

    } catch (error) {

        console.log(error);

        res.status(500).json({
            success: false,
            message: "Server Error"
        });

    }

};

module.exports = {
    getBalance
};