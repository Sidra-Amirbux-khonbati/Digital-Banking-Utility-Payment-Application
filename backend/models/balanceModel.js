const db = require("../db");

const createBalance = async (account_no) => {
    const query = `
        INSERT INTO balance (account_no, running_balance)
        VALUES ($1, 0.00)
        RETURNING *;
    `;

    const result = await db.query(query, [account_no]);
    return result.rows[0];
};

const getBalance = async (account_no) => {

    const result = await db.query(

        `SELECT
            a.account_no,
            c.first_name || ' ' || c.last_name AS customer_name,
            a.account_status,
            b.running_balance
        FROM account a
        JOIN customer c
            ON a.customer_id = c.customer_id
        JOIN balance b
            ON a.account_no = b.account_no
        WHERE a.account_no = $1`,

        [account_no]

    );

    return result.rows[0];

};

module.exports = {
    createBalance,
    getBalance
};



