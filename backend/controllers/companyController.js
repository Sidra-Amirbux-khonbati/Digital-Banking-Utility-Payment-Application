
const companyModel = require("../models/companyModel");
const companyAccountModel = require("../models/companyAccountModel");
const balanceModel = require("../models/balanceModel");
exports.signupCompany = async (req, res) => {

    try {

        const company =
            await companyModel.createCompanyRequest(req.body);

        res.status(201).json({

            success: true,

            message:
                "Company registration submitted successfully. Waiting for admin approval.",

            data: company

        });

    } catch (error) {

        res.status(500).json({
            success: false,
            message: error.message
        });

    }

};


exports.getPendingCompanies = async (req, res) => {

    try {

        const companies =
            await companyModel.getPendingCompanies();

        res.status(200).json({

            success: true,

            total: companies.length,

            data: companies

        });

    } catch (error) {

        res.status(500).json({
            success: false,
            message: error.message
        });

    }

};

exports.approveCompany = async (req, res) => {

    try {

        const { queue_id } = req.params;

        const queueCompany =
            await companyModel.getQueueCompanyById(queue_id);

        if (!queueCompany) {
            return res.status(404).json({
                message: "Company request not found"
            });
        }

        const company =
            await companyModel.createApprovedCompany(queueCompany);

        const account =
await companyAccountModel.createCompanyAccount(
    company.company_id,
    company.company_account_no
);

        await balanceModel.createBalance(account.account_no);

        await companyModel.updateQueueStatus(
            queue_id,
            "Approved"
        );

        res.status(200).json({
            message: "Company approved successfully",
            company,
            account_no: account.account_no
        });

    } catch (error) {

        console.log(error);

        res.status(500).json({
            message: error.message
        });

    }

};

exports.rejectCompany = async (req, res) => {

    try {

        const { queue_id } = req.params;

        const company = await companyModel.rejectCompany(queue_id);

        if (!company) {
            return res.status(404).json({
                message: "Company request not found"
            });
        }

        res.status(200).json({
            message: "Company rejected successfully",
            company
        });

    } catch (error) {

        res.status(500).json({
            message: error.message
        });

    }

};


exports.checkCompanyStatus = async (req, res) => {

    try {

        const { email } = req.params;

        const result =
            await companyModel.getCompanyStatus(email);

        if (!result) {

            return res.status(404).json({
                success: false,
                message: "Company request not found"
            });

        }

        res.status(200).json({
            success: true,
            data: result
        });

    } catch (error) {

        res.status(500).json({
            success: false,
            message: error.message
        });

    }

};


exports.companyLogin = async (req, res) => {

    try {

        const {
            contact_email,
            company_account_no
        } = req.body;

        const company = await companyModel.companyLogin(
            contact_email,
            company_account_no
        );

        if (!company) {

            return res.status(401).json({
                success: false,
                message: "Invalid Email or Company Account Number"
            });

        }

        res.status(200).json({

            success: true,

            message: "Login Successful",

            company: {

                company_id: company.company_id,
                company_name: company.company_name,
                company_account_no: company.company_account_no,
                company_status: company.company_status,
                company_type: company.company_type,
                contact_email: company.contact_email,
                contact_phone: company.contact_phone

            }

        });

    } catch (error) {

        res.status(500).json({

            success: false,
            message: error.message

        });

    }

};