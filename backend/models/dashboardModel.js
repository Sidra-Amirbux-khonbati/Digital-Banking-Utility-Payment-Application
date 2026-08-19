const db = require("../db");

const getDashboard = async (account_no) => {

    // Current Balance
    const balanceQuery = `
        SELECT running_balance
        FROM balance
        WHERE account_no = $1;
    `;

    // Total Transactions
    const transactionQuery = `
        SELECT COUNT(*) AS total_transactions
        FROM transactions
        WHERE from_account = $1
           OR to_account = $1;
    `;

    // Pending Bills
    const pendingBillsQuery = `
        SELECT COUNT(*) AS pending_bills
        FROM bill
        WHERE customer_account_no = $1
        AND bill_status = 'Pending';
    `;

    // Paid Bills
    const paidBillsQuery = `
        SELECT COUNT(*) AS paid_bills
        FROM bill
        WHERE customer_account_no = $1
        AND bill_status = 'Paid';
    `;

    const balance = await db.query(balanceQuery, [account_no]);
    const transactions = await db.query(transactionQuery, [account_no]);
    const pendingBills = await db.query(pendingBillsQuery, [account_no]);
    const paidBills = await db.query(paidBillsQuery, [account_no]);

    return {
        account_no,
        current_balance: balance.rows[0]?.running_balance || 0,
        total_transactions: Number(transactions.rows[0].total_transactions),
        pending_bills: Number(pendingBills.rows[0].pending_bills),
        paid_bills: Number(paidBills.rows[0].paid_bills)
    };
};

module.exports = {
    getDashboard
};