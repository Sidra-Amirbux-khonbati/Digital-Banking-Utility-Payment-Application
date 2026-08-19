const db = require("../db");

const createCompanyRequest = async (companyData) => {

    const {
        company_name,
        company_type,
        contact_email,
        contact_phone,
        company_address,
        tax_number
    } = companyData;

    const query = `
        INSERT INTO company_queue
        (
            company_name,
            company_type,
            contact_email,
            contact_phone,
            company_address,
            tax_number
        )
        VALUES
        (
            $1,$2,$3,$4,$5,$6
        )
        RETURNING *;
    `;

    const values = [
        company_name,
        company_type,
        contact_email,
        contact_phone,
        company_address,
        tax_number
    ];

    const result = await db.query(query, values);

    return result.rows[0];
};


const getPendingCompanies = async () => {

    const query = `
        SELECT *
        FROM company_queue
        WHERE status='Pending'
        ORDER BY created_at;
    `;

    const result = await db.query(query);

    return result.rows;
};

const getQueueCompanyById = async (queue_id) => {

    const query = `
        SELECT *
        FROM company_queue
        WHERE queue_id = $1;
    `;

    const result = await db.query(query, [queue_id]);

    return result.rows[0];
};


const createApprovedCompany = async (company) => {

    const query = `
        INSERT INTO company
        (
            company_name,
            company_type,
            contact_email,
            contact_phone
        )
        VALUES
        (
            $1,$2,$3,$4
        )
        RETURNING *;
    `;

    const values = [
        company.company_name,
        company.company_type,
        company.contact_email,
        company.contact_phone
    ];

    const result = await db.query(query, values);

    return result.rows[0];
};



const updateQueueStatus = async (
    queue_id,
    status
) => {

    const query = `
        UPDATE company_queue
        SET status = $1
        WHERE queue_id = $2
        RETURNING *;
    `;

    const result = await db.query(
        query,
        [status, queue_id]
    );

    return result.rows[0];
};


const rejectCompany = async (queue_id) => {

    const query = `
        UPDATE company_queue
        SET status = 'Rejected'
        WHERE queue_id = $1
        RETURNING *;
    `;

    const result = await db.query(query, [queue_id]);

    return result.rows[0];
};



const getCompanyStatus = async (email) => {

    const approvedQuery = `
        SELECT
            company_name,
            company_status,
            company_id,
            company_account_no
        FROM company
        WHERE contact_email = $1;
    `;

    const approved = await db.query(approvedQuery, [email]);

    if (approved.rows.length > 0) {

        return {
            status: "Approved",
            company: approved.rows[0]
        };

    }

    const pendingQuery = `
        SELECT
            status
        FROM company_queue
        WHERE contact_email = $1;
    `;

    const pending = await db.query(pendingQuery, [email]);

    if (pending.rows.length > 0) {

        return {
            status: pending.rows[0].status
        };

    }

    return null;
};


const companyLogin = async (
    contact_email,
    company_account_no
) => {

    const query = `
        SELECT *
        FROM company
        WHERE contact_email = $1
        AND company_account_no = $2
        AND company_status = 'Active';
    `;

    const result = await db.query(
        query,
        [contact_email, company_account_no]
    );

    return result.rows[0];
};


const getCompanyById = async (company_id) => {

    const query = `
        SELECT *
        FROM company
        WHERE company_id = $1;
    `;

    const result = await db.query(
        query,
        [company_id]
    );

    return result.rows[0];
};

module.exports = {
    createCompanyRequest,
    getPendingCompanies,
    getQueueCompanyById,
    createApprovedCompany,
    updateQueueStatus,
    rejectCompany,
    getCompanyStatus,
    companyLogin,
    getCompanyById
};