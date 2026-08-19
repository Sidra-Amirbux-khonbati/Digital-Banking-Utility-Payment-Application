const db = require("../db");

const getTransactionHistory = async (account_no) => {

    const result = await db.query(

        `SELECT
            transaction_id,
            from_account,
            to_account,
            amount,
            transaction_type,
            narration_line1,
            narration_line2,
            narration_line3,
            created_at
        FROM transactions
        WHERE from_account = $1
           OR to_account = $1
        ORDER BY created_at DESC`,

        [account_no]

    );

    return result.rows;

};

module.exports = {
    getTransactionHistory
};