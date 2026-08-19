const db = require("../db");

const createCompanyAccount = async (
    company_id,
    company_account_no
) => {

    const query = `
        INSERT INTO account
        (
            account_no,
            company_id,
            account_type
        )
        VALUES
        (
            $1,
            $2,
            'Company'
        )
        RETURNING account_no;
    `;

    const values = [
        company_account_no,
        company_id
    ];

    const result = await db.query(query, values);

    return result.rows[0];
};

module.exports = {
    createCompanyAccount
};