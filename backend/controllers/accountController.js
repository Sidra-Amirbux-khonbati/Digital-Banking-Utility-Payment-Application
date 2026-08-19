const accountModel = require("../models/accountModel");
const customerModel = require("../models/customerModel");
const balanceModel = require("../models/balanceModel");
const { sendAccountEmail } = require("../utils/emailService");
const { generateWelcomePDF } = require("../utils/pdfService");

const addAccount = async (req, res) => {
    try {

        const { customer_id } = req.body;

        const account = await accountModel.createAccount(customer_id);
      
        await balanceModel.createBalance(account.account_no);
        const customer = await customerModel.getCustomerById(customer_id);
        
        const pdfPath = generateWelcomePDF(
        customer.first_name,
        account.account_no
        );  

        await sendAccountEmail(
            customer.email,
            customer.first_name,
            account.account_no,
            pdfPath
        );
        

        res.json({
            message: "Account created successfully",
            account_no: account.account_no,
             mockSMS: {
        to: customer.mobile,
        message: `Dear ${customer.first_name}, your account ${account.account_no} has been created successfully.`,
        status: "Delivered"
    }
        });

    } catch (error) {
        console.error(error);

        res.status(500).json({
            error: error.message
        });
    }
};
module.exports = {
    addAccount,
};