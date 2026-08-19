const db = require("../db");

const createTransaction = async (
    from_account,
    to_account,
    amount,
    transaction_type,
    narration_line1,
    narration_line2,
    narration_line3
) => {

    const query = `
        INSERT INTO transactions
        (
            from_account,
            to_account,
            amount,
            transaction_type,
            narration_line1,
            narration_line2,
            narration_line3
        )
        VALUES
        (
            $1, $2, $3, $4, $5, $6, $7
        )
        RETURNING *;
    `;

    const values = [
        from_account,
        to_account,
        amount,
        transaction_type,
        narration_line1,
        narration_line2,
        narration_line3
    ];

    const result = await db.query(query, values);

    return result.rows[0];
};


const getBalance = async (account_no) => {

    const query = `
        SELECT running_balance
        FROM balance
        WHERE account_no = $1;
    `;

    const result = await db.query(query, [account_no]);

    return result.rows[0];
};

const updateBalance = async (account_no, newBalance) => {

    const query = `
        UPDATE balance
        SET running_balance = $1,
            updated_at = CURRENT_TIMESTAMP
        WHERE account_no = $2
        RETURNING *;
    `;

    const result = await db.query(query, [newBalance, account_no]);
    return result.rows[0];
};

const accountExists = async (account_no) => {

    const query = `
        SELECT account_no
        FROM account
        WHERE account_no = $1;
    `;

    const result = await db.query(query, [account_no]);

    return result.rows[0];
};


const getTransactionHistory = async (account_no) => {

    const query = `
        SELECT
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
        ORDER BY created_at DESC;
    `;

    const result = await db.query(query, [account_no]);

    return result.rows;
};

const getTransactionById = async (transaction_id) => {

    const query = `
        SELECT *
        FROM transactions
        WHERE transaction_id = $1;
    `;

    const result = await db.query(query, [transaction_id]);

    return result.rows[0];
};

const getCompanyPayments = async (companyAccountNo) => {

    const query = `
        SELECT
            transaction_id,
            from_account,
            to_account,
            amount,
            transaction_type,
            narration_line1,
            created_at
        FROM transactions
        WHERE to_account = $1
        ORDER BY created_at DESC;
    `;

    const result = await db.query(query, [companyAccountNo]);

    return result.rows;
};

const getRecentTransactions = async (account_no) => {

    const query = `
        SELECT *
        FROM transactions
        WHERE from_account = $1
           OR to_account = $1
        ORDER BY created_at DESC
        LIMIT 3;
    `;

    const result = await db.query(query, [account_no]);

    return result.rows;
};

module.exports = {
    createTransaction,
    getBalance,
    updateBalance,
    accountExists,
    getTransactionHistory,
    getTransactionById,
    getCompanyPayments,
    getRecentTransactions
};