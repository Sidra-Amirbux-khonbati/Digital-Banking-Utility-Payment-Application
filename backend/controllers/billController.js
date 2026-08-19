const PDFDocument = require("pdfkit");
const fs = require("fs");
const path = require("path");
const billModel = require("../models/billModel");
const companyModel = require("../models/companyModel");
const receiptService = require("../utils/receiptService");



exports.generateBill = async (req, res) => {

    try {

        const company = await companyModel.getCompanyById(
            req.body.company_id
        );


        if (!company) {
            return res.status(404).json({
                message: "Company not found"
            });
        }


        if (company.company_status !== "Active") {
            return res.status(400).json({
                message: "Company is inactive. Bill cannot be generated."
            });
        }


        const customer =
        await billModel.checkCustomerAccount(
            req.body.customer_account_no
        );


        if(!customer){

            return res.status(404).json({
                message:"Customer account not found"
            });

        }


        const bill = await billModel.createBill(req.body);


        res.status(201).json({
            message: "Bill generated successfully",
            data: bill
        });


    } catch (error) {

        console.log(error);

        res.status(500).json({
            message:error.message
        });

    }

};





exports.getBills = async(req,res)=>{

    try{


        const bills = await billModel.getAllBills();


        res.json(bills);



    }catch(error){


        res.status(500).json({

            message:error.message

        });

    }

};


exports.getCustomerBills = async (req, res) => {

    try {

        await billModel.updateOverdueBills();

        const bills = await billModel.getBillsByAccount(
            req.params.accountNo,
            req.query.status
        );

        res.json(bills);

    } catch (error) {

        res.status(500).json({
            message: error.message
        });

    }

};

const transactionModel = require("../models/transactionModel");

exports.payBill = async (req, res) => {

    try {

        const { bill_id } = req.body;

        const bill = await billModel.getBillById(bill_id);

        if (!bill) {
            return res.status(404).json({
                message: "Bill not found"
            });
        }

        if (bill.bill_status === "Paid") {
            return res.status(400).json({
                message: "Bill is already paid"
            });
        }

        const company = await billModel.getCompanyAccount(
            bill.company_id
        );
        

        if (!company) {
            return res.status(400).json({
                message: "Company is inactive or not found"
            });
        }

        const customerBalance =
            await transactionModel.getBalance(
                bill.customer_account_no
            );

        if (!customerBalance) {
            return res.status(404).json({
                message: "Customer account not found"
            });
        }



        if (
            Number(customerBalance.running_balance) <
            Number(bill.amount)
        ) {

            return res.status(400).json({
                message: "Insufficient balance"
            });

        }

        const companyBalance =
            await transactionModel.getBalance(
                company.company_account_no
            );

        const newCustomerBalance =
            Number(customerBalance.running_balance) -
            Number(bill.amount);

        const newCompanyBalance =
            Number(companyBalance.running_balance) +
            Number(bill.amount);

        await transactionModel.updateBalance(
            bill.customer_account_no,
            newCustomerBalance
        );

        await transactionModel.updateBalance(
            company.company_account_no,
            newCompanyBalance
        );

        const transaction =
            await transactionModel.createTransaction(
                bill.customer_account_no,
                company.company_account_no,
                bill.amount,
                "Bill Payment",
                "Bill Payment",
                bill.bill_id,
                bill.consumer_no
            );

        await billModel.updateBillStatus(
            bill.bill_id
        );

        res.status(200).json({

            message: "Bill paid successfully",

            transaction,

            customer_balance: newCustomerBalance,

            company_balance: newCompanyBalance

        });

    } catch (error) {

        console.log(error);

        res.status(500).json({
            message: error.message
        });

    }

};

exports.getCompanyBillSummary = async(req,res)=>{

    try{

        const summary =
        await billModel.getCompanyBillSummary(
            req.params.company_id
        );

        res.json(summary);

    }catch(error){

        res.status(500).json({
            message:error.message
        });

    }

};

exports.getCompanyBills = async(req,res)=>{

    try{

        const bills =
        await billModel.getBillsByCompany(

            req.params.company_id,

            req.query.status

        );

        res.json(bills);

    }

    catch(error){

        res.status(500).json({

            message:error.message

        });

    }

};

exports.downloadBillPdf = async (req, res) => {

    try {

        const bill =
            await billModel.getBillWithCompany(
                req.params.bill_id
            );

        if (!bill) {

            return res.status(404).json({
                message: "Bill not found"
            });

        }

        const fileName = `${bill.bill_id}.pdf`;

        const filePath = path.join(
            __dirname,
            "..",
            "pdfs",
            fileName
        );

        const doc = new PDFDocument();

        doc.pipe(fs.createWriteStream(filePath));

        doc.fontSize(24)
            .text("Bill Express", {
                align: "center"
            });

        doc.moveDown();

        doc.fontSize(18)
            .text("Bill Details");

        doc.moveDown();

        doc.fontSize(12);

        doc.text(`Bill ID : ${bill.bill_id}`);
        doc.text(`Company : ${bill.company_name}`);
        doc.text(`Customer Account : ${bill.customer_account_no}`);
        doc.text(`Consumer No : ${bill.consumer_no}`);
        doc.text(`Billing Month : ${bill.billing_month}`);
        doc.text(`Issue Date : ${bill.bill_issue_date}`);
        doc.text(`Due Date : ${bill.due_date}`);
        doc.text(`Amount : PKR ${bill.amount}`);
        doc.text(`Status : ${bill.bill_status}`);
        doc.text(`Remarks : ${bill.remarks}`);

        doc.moveDown();

        doc.text(
            "Generated by Bill Express",
            {
                align: "center"
            }
        );

        doc.end();

        doc.on("finish", () => {

            res.download(filePath);

        });

    } catch (error) {

        res.status(500).json({
            message: error.message
        });

    }

};

exports.getBillStatistics = async(req,res)=>{

    try{

        const data =
        await billModel.getBillStatistics(
            req.params.company_id
        );


        res.json(data);


    }catch(error){

        console.log(error);

        res.status(500).json({
            message:error.message
        });

    }

};

exports.getCustomerBills = async (req, res) => {

    try {

        const { accountNo } = req.params;

        const status = req.query.status;

        const bills =
            await billModel.getCustomerBills(accountNo, status);

        res.status(200).json(bills);

    } catch (error) {

        console.log(error);

        res.status(500).json({
            message: error.message
        });

    }

};

exports.customerPayBill = async (req, res) => {

    try {

        const { bill_id } = req.body;

        const bill = await billModel.getBillById(bill_id);
        console.log("Bill:", bill);

        if (!bill) {
            return res.status(404).json({
                message: "Bill not found"
            });
        }

        if (bill.bill_status === "Paid") {
            return res.status(400).json({
                message: "Bill is already paid"
            });
        }

        const company = await billModel.getCompanyAccount(
            bill.company_id
        );

        console.log("Company:", company);


        if (!company) {
            return res.status(404).json({
                message: "Company account not found"
            });
        }

        const customerBalance =
            await transactionModel.getBalance(
                bill.customer_account_no
            );
            console.log("Customer Balance:", customerBalance);


        if (!customerBalance) {
            return res.status(404).json({
                message: "Customer account not found"
            });
        }

        if (
            Number(customerBalance.running_balance) <
            Number(bill.amount)
        ) {

            return res.status(400).json({
                message: "Insufficient Balance"
            });

        }

        const companyBalance =
            await transactionModel.getBalance(
                company.company_account_no
            );

            console.log("Company Balance:", companyBalance);

        const newCustomerBalance =
            Number(customerBalance.running_balance) -
           ( Number(bill.amount)+Number(bill.fine));

        const newCompanyBalance =
            Number(companyBalance.running_balance) +
            ( Number(bill.amount)+Number(bill.fine));

        await transactionModel.updateBalance(
            bill.customer_account_no,
            newCustomerBalance
        );

        await transactionModel.updateBalance(
            company.company_account_no,
            newCompanyBalance
        );
        const total =  Number(bill.amount) + Number(bill.fine);
        console.log(total);
        const transaction =
            await transactionModel.createTransaction(
                bill.customer_account_no,
                company.company_account_no,
                total,
                "Bill Payment",
                "Bill Payment",
                bill.bill_id,
                bill.consumer_no
            );

        await billModel.updateBillStatus(
            bill.bill_id
        );

        res.status(200).json({

            message: "Bill paid successfully",

            transaction,

            customer_balance: newCustomerBalance,

            company_balance: newCompanyBalance

        });

    } catch (error) {

        console.log(error);

        res.status(500).json({
            message: error.message
        });

    }

};


exports.downloadReceipt = async (req, res) => {

    try {

        const { bill_id } = req.params;

        const bill = await billModel.getBillById(bill_id);

        if (!bill) {
            return res.status(404).json({
                message: "Bill not found"
            });
        }

        const company =
            await billModel.getCompanyById(
                bill.company_id
            );

        const customer =
            await billModel.getCustomerByAccount(
                bill.customer_account_no
            );

        const transaction =
            await billModel.getBillTransaction(
                bill.bill_id
            );

        receiptService.generateReceipt(

            bill,
            transaction,
            company,
            customer,
            res

        );

    } catch (error) {

        console.log(error);

        res.status(500).json({
            message: error.message
        });

    }

};