const db = require("../db");

const createCustomer = async (customerData) => {
    const query = `
        INSERT INTO customer (
            office_name,
            joining_date,
            title,
            first_name,
            last_name,
            card_no,
            nationality,
            dob,
            age,
            marital_status,
            guardian_name,
            spouse_name,
            relationship,
            working_position,
            office_location,
            address,
            province,
            postal_code,
            home_phone,
            office_phone,
            mobile,
            email,
            fax_no
        )
        VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9, $10, $11, $12, $13, $14, $15, 
        $16, $17, $18, $19, $20, $21, $22, $23)
        RETURNING customer_id;
    `;

    const values = [
        customerData.office_name,
        customerData.joining_date,
        customerData.title,
        customerData.first_name,
        customerData.last_name,
        customerData.card_no,
        customerData.nationality,
        customerData.dob,
        customerData.age,
        customerData.marital_status,
        customerData.guardian_name,
        customerData.spouse_name,
        customerData.relationship,
        customerData.working_position,
        customerData.office_location,
        customerData.address,
        customerData.province,
        customerData.postal_code,
        customerData.home_phone,
        customerData.office_phone,
        customerData.mobile,
        customerData.email,
        customerData.fax_no
    ];

    const result = await db.query(query, values);
    return result.rows ? result.rows[0] : result[0];
};

  const getCustomerById = async (customer_id) => {
    const query = `
        SELECT first_name, email, mobile
        FROM customer
        WHERE customer_id = $1;
    `;
    const result = await db.query(query, [customer_id]);
    return result.rows[0];
};

const loginCustomer = async (email, account_no) => {

    const query = `
        SELECT
            c.customer_id,
            c.first_name,
            c.last_name,
            c.email,
            c.card_no,
            c.mobile,
            c.office_name,
            c.nationality,
            c.address,
            a.account_no,
            a.account_type,
            a.account_status
        FROM customer c
        INNER JOIN account a
            ON c.customer_id = a.customer_id
        WHERE c.email = $1
        AND a.account_no = $2;
    `;

    const result = await db.query(query, [email, account_no]);

    return result.rows[0];
};
module.exports = {
    createCustomer,
    getCustomerById,
    loginCustomer
};

