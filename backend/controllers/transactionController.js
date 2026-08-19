const transactionModel = require("../models/transactionModel");

const deposit = async (req, res) => {
    try {

        const {
            from_account,
            to_account,
            amount,
            narration_line1,
            narration_line2,
            narration_line3
        } = req.body;

    const balance = await transactionModel.getBalance(to_account);
        if (!balance) {
            return res.status(404).json({
                message: "Account not found"
            });
        }

        const newBalance =
            Number(balance.running_balance) + Number(amount);

        const transaction = await transactionModel.createTransaction(
            from_account,
            to_account,
            amount,
            "Deposit",
            narration_line1,
            narration_line2,
            narration_line3
        );

        await transactionModel.updateBalance(to_account, newBalance);

        res.status(200).json({
            message: "Amount credited successfully",
            transaction,
            running_balance: newBalance
        });

    } catch (error) {

        console.log(error);

        res.status(500).json({
            error: error.message
        });
    }
};


const transfer = async (req, res) => {
    try {

        const {
            from_account,
            to_account,
            amount,
            narration_line1,
            narration_line2,
            narration_line3
        } = req.body;

        // Validate amount
        if (!amount || Number(amount) <= 0) {
            return res.status(400).json({
                message: "Amount must be greater than 0"
            });
        }

        // Check sender account
        const sender = await transactionModel.accountExists(from_account);

        if (!sender) {
            return res.status(404).json({
                message: "Sender account not found"
            });
        }

        // Check receiver account
        const receiver = await transactionModel.accountExists(to_account);

        if (!receiver) {
            return res.status(404).json({
                message: "Receiver account not found"
            });
        }

        // Get sender balance
        const senderBalance = await transactionModel.getBalance(from_account);

        // Get receiver balance
        const receiverBalance = await transactionModel.getBalance(to_account);

        // Check sufficient balance
        if (Number(senderBalance.running_balance) < Number(amount)) {

            return res.status(400).json({
                message: "Insufficient Balance"
            });

        }

        // Calculate new balances
        const newSenderBalance =
            Number(senderBalance.running_balance) - Number(amount);

        const newReceiverBalance =
            Number(receiverBalance.running_balance) + Number(amount);

        // Update sender balance
        await transactionModel.updateBalance(
            from_account,
            newSenderBalance
        );

        // Update receiver balance
        await transactionModel.updateBalance(
            to_account,
            newReceiverBalance
        );

        // Save transaction
        const transaction = await transactionModel.createTransaction(
            from_account,
            to_account,
            amount,
            "Transfer",
            narration_line1,
            narration_line2,
            narration_line3
        );

        res.status(200).json({

            message: "Amount transferred successfully",

            transaction,

            sender_balance: newSenderBalance,

            receiver_balance: newReceiverBalance

        });

    } catch (error) {

        console.log(error);

        res.status(500).json({
            error: error.message
        });

    }
};



const debit = async (req, res) => {

    try {

        const {
            from_account,
            to_account,
            amount,
            narration_line1,
            narration_line2,
            narration_line3
        } = req.body;

        const balance = await transactionModel.getBalance(from_account);

        if (!balance) {
            return res.status(404).json({
                message: "Account not found"
            });
        }

        if (Number(amount) > Number(balance.running_balance)) {

            return res.status(400).json({
                message: "Insufficient Balance"
            });

        }

        const newBalance =
            Number(balance.running_balance) - Number(amount);

        const transaction = await transactionModel.createTransaction(
            from_account,
            to_account,
            amount,
            "Debit",
            narration_line1,
            narration_line2,
            narration_line3
        );

        await transactionModel.updateBalance(from_account, newBalance);

        res.status(200).json({
            message: "Amount debited successfully",
            transaction,
            running_balance: newBalance
        });

    } catch (error) {

        console.log(error);

        res.status(500).json({
            error: error.message
        });

    }

};

const getTransactionHistory = async (req, res) => {

    try {

        const account_no = req.params.account_no;

        const transactions =
            await transactionModel.getTransactionHistory(account_no);

        res.status(200).json({
            account_no,
            total_transactions: transactions.length,
            transactions
        });

    } catch (error) {

        console.log(error);

        res.status(500).json({
            message: error.message
        });

    }

};

const getTransactionById = async (req, res) => {

    try {

        const transaction_id = req.params.transaction_id;

        const transaction =
            await transactionModel.getTransactionById(transaction_id);

        if (!transaction) {
            return res.status(404).json({
                message: "Transaction not found"
            });
        }

        res.status(200).json(transaction);

    } catch (error) {

        console.log(error);

        res.status(500).json({
            message: error.message
        });

    }

};

const getCompanyPayments = async (req, res) => {

    try {

        const { companyAccountNo } = req.params;

        const payments =
            await transactionModel.getCompanyPayments(companyAccountNo);

        res.status(200).json(payments);

    } catch (error) {

        console.log(error);

        res.status(500).json({
            message: error.message,
        });

    }

};

const getRecentTransactions = async (req, res) => {

    try {

        const { account_no } = req.params;

        const transactions =
            await transactionModel.getRecentTransactions(account_no);

        res.json(transactions);

    } catch (error) {

        res.status(500).json({
            message: error.message,
        });

    }

};

module.exports = {
    deposit,
    transfer,
    debit,
    getTransactionHistory,
    getTransactionById,
    getCompanyPayments,
    getRecentTransactions
};