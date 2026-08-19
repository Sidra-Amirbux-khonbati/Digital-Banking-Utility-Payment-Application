const customerModel = require("../models/customerModel");

const addCustomer = async (req, res) => {
    try {
        const customer = await customerModel.createCustomer(req.body);
        res.json({
            message: "Customer saved successfully",
            customer_id: customer.customer_id
        });
    } catch (error) {
        console.log("Database Error:", error);
        res.status(500).json({
            error: error.message
        });
    }
};

const loginCustomer = async (req, res) => {

    try {

        const { email, account_no } = req.body;

        const customer = await customerModel.loginCustomer(
            email,
            account_no
        );

        if (!customer) {
            return res.status(401).json({
                success: false,
                message: "Invalid Email or Account Number"
            });
        }

        res.json({
            success: true,
            message: "Login Successful",
            customer
        });

    } catch (error) {

        console.log(error);

        res.status(500).json({
            success: false,
            error: error.message
        });

    }

};

module.exports = {
    addCustomer,
    loginCustomer
};