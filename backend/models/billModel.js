const db= require("../db");


const createBill = async (billData) => {

    const {
        company_id,
        customer_account_no,
        consumer_no,
        billing_month,
        due_date,
        amount,
        remarks
    } = billData;


    const query = `
        INSERT INTO bill
        (
            company_id,
            customer_account_no,
            consumer_no,
            billing_month,
            due_date,
            amount,
            remarks
        )
        VALUES
        ($1,$2,$3,$4,$5,$6,$7)

        RETURNING *;
    `;


    const values = [
        company_id,
        customer_account_no,
        consumer_no,
        billing_month,
        due_date,
        amount,
        remarks
    ];


    const result = await db.query(query, values);

    return result.rows[0];
};



const getAllBills = async () => {

    const query = `
        SELECT 
        b.*,
        c.company_name

        FROM bill b

        JOIN company c
        ON b.company_id = c.company_id

        ORDER BY b.created_at DESC;
    `;


    const result = await db.query(query);

    return result.rows;
};



const getBillsByAccount = async(account_no)=>{

    const query = `
        SELECT 
        b.*,
        c.company_name

        FROM bill b

        JOIN company c
        ON b.company_id = c.company_id

        WHERE b.customer_account_no = $1

        ORDER BY b.created_at DESC;
    `;


    const result = await db.query(query,[account_no]);

    return result.rows;
};

const getBillById = async (bill_id) => {

    const query = `
        SELECT *
        FROM bill
        WHERE bill_id = $1;
    `;

    const result = await db.query(query, [bill_id]);

    return result.rows[0];
};

const getCompanyAccount = async (company_id) => {

    const query = `
        SELECT company_account_no
        FROM company
        WHERE company_id = $1
        AND company_status = 'Active';
    `;

    const result = await db.query(query, [company_id]);

    return result.rows[0];
};

const updateBillStatus = async (bill_id) => {

    const query = `
        UPDATE bill
        SET bill_status = 'Paid'
        WHERE bill_id = $1
        RETURNING *;
    `;

    const result = await db.query(query, [bill_id]);

    return result.rows[0];
};

const checkCustomerAccount = async(account_no)=>{

const query=`
SELECT account_no
FROM account
WHERE account_no=$1;
`;

const result=await db.query(query,[account_no]);

return result.rows[0];

}

const getCompanyBillSummary = async (company_id) => {

    const query = `
        SELECT
            COUNT(*) AS total,

            COUNT(*) FILTER
            (WHERE bill_status='Paid') AS paid,

            COUNT(*) FILTER
            (WHERE bill_status='Pending') AS pending,

            COUNT(*) FILTER
            (WHERE bill_status='Overdue') AS overdue,

            COUNT(*) FILTER
            (WHERE bill_status='Cancelled') AS cancelled

        FROM bill

        WHERE company_id = $1;
    `;

    const result = await db.query(query,[company_id]);

    return result.rows[0];
};

const getBillsByCompany = async(company_id,status)=>{

    let query=`
    SELECT *
    FROM bill
    WHERE company_id=$1
    `;

    const values=[company_id];

    if(status){

        query += " AND bill_status=$2";

        values.push(status);

    }

    query += " ORDER BY created_at DESC";

    const result=await db.query(query,values);

    return result.rows;

}

const getBillWithCompany = async (bill_id) => {

    const query = `
        SELECT
            b.*,
            c.company_name
        FROM bill b
        JOIN company c
        ON b.company_id = c.company_id
        WHERE b.bill_id = $1;
    `;

    const result = await db.query(query,[bill_id]);

    return result.rows[0];
};

const getBillStatistics = async (company_id) => {

    const query = `
    SELECT
        COUNT(*) AS total,

        COUNT(*) FILTER(
            WHERE bill_status = 'Paid'
        ) AS paid,

        COUNT(*) FILTER(
            WHERE bill_status = 'Pending'
        ) AS pending,

        COUNT(*) FILTER(
            WHERE bill_status = 'Overdue'
        ) AS overdue

    FROM bill

    WHERE company_id = $1;
    `;


    const result = await db.query(
        query,
        [company_id]
    );


    const data = result.rows[0];


    const total = Number(data.total);


    return {

        total,

        paid: Number(data.paid),

        pending: Number(data.pending),

        overdue: Number(data.overdue),


        paid_percentage:
            total === 0 ? 0 :
            ((Number(data.paid) / total) * 100)
            .toFixed(1),


        pending_percentage:
            total === 0 ? 0 :
            ((Number(data.pending) / total) * 100)
            .toFixed(1),


        overdue_percentage:
            total === 0 ? 0 :
            ((Number(data.overdue) / total) * 100)
            .toFixed(1),

    };

};

const getCustomerBills = async (accountNo, status) => {

    let query = `
        SELECT
            b.bill_id,
            b.company_id,
            c.company_name,
            b.customer_account_no,
            b.consumer_no,
            b.billing_month,
            b.bill_issue_date,
            b.due_date,
            b.amount,
            b.remarks,
            b.fine,

            CASE
                WHEN b.bill_status = 'Paid'
                    THEN 'Paid'

                WHEN b.bill_status = 'Pending'
                     AND b.due_date < CURRENT_DATE
                    THEN 'Overdue'

                ELSE b.bill_status
            END AS bill_status

        FROM bill b
        JOIN company c
            ON b.company_id = c.company_id

        WHERE b.customer_account_no = $1
    `;

    const values = [accountNo];
if (status && status != "All") {

    if (status == "Overdue") {

        query += `
            AND b.bill_status = 'Overdue'
        `;

    } else {

        query += ` AND b.bill_status = $2`;
        values.push(status);

    }

}

    query += `
    ORDER BY
        due_date ASC
    `;

    const result = await db.query(query, values);

    return result.rows;
};

const getCompanyById = async (companyId) => {

    const query = `
        SELECT *
        FROM company
        WHERE company_id = $1;
    `;

    const result =
        await db.query(query, [companyId]);

    return result.rows[0];

};

const getCustomerByAccount = async (accountNo) => {

    const query = `

        SELECT
            c.*,
            a.account_no

        FROM customer c

        JOIN account a
        ON c.customer_id = a.customer_id

        WHERE a.account_no = $1;

    `;

    const result =
        await db.query(query, [accountNo]);

    return result.rows[0];

};

const getBillTransaction = async (billId) => {

    const query = `
        SELECT *
        FROM transactions
        WHERE narration_line2 = $1
        ORDER BY created_at DESC
        LIMIT 1;
    `;

    const result =
        await db.query(query, [billId]);

    return result.rows[0];

};
const updateOverdueBills = async () => {

    const query = `
        UPDATE bill
        SET
            bill_status = 'Overdue',
            fine = amount * 0.05
        WHERE
            due_date < CURRENT_DATE
            AND bill_status = 'Pending'
        RETURNING *;
    `;

    const result = await db.query(query);

    console.log("Updated Bills:", result.rows);

    return result.rows;
};
module.exports = {
    createBill,
    getAllBills,
    getBillsByAccount,
    getBillById,
    getCompanyAccount,
    updateBillStatus,
    checkCustomerAccount,
    getCompanyBillSummary,
    getBillsByCompany,
    getBillWithCompany,
    getBillStatistics,
    getCustomerBills,
    getCompanyById,
    getCustomerByAccount,
    getBillTransaction,
    updateOverdueBills
};