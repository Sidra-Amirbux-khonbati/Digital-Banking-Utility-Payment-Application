const db = require("../db");

const createAccount = async (customer_id) => {
    const query = `
        INSERT INTO account (customer_id)
        VALUES ($1)
        RETURNING account_no;
    `;
    const result = await db.query(query, [customer_id]);
    return result.rows[0];
};

const createCompanyAccount = async (company_id) => {

    const query = `
        INSERT INTO account
        (
            company_id,
            account_type
        )
        VALUES
        (
            $1,
            'Company'
        )
        RETURNING account_no;
    `;

    const result = await db.query(query, [company_id]);

    return result.rows[0];
};

module.exports = {
    createAccount,
    createCompanyAccount
};