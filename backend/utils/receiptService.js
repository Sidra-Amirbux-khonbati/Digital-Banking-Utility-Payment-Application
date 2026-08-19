const PDFDocument = require("pdfkit");
const doc = new PDFDocument();

const generateReceipt = (bill, transaction, company, customer, res) => {

    const doc = new PDFDocument({
        margin: 50,
        size: "A4",
    });

    res.setHeader("Content-Type", "application/pdf");

    res.setHeader(
        "Content-Disposition",
        `attachment; filename=Receipt_${bill.bill_id}.pdf`
    );



    doc.pipe(res);

    // Title
    doc
        .fontSize(22)
        .text("Finova Bank", {
            align: "center",
        });

    doc.moveDown();

    doc
        .fontSize(18)
        .text("Payment Receipt", {
            align: "center",
        });

    doc.moveDown(2);

    doc.fontSize(12);

    doc.text(`Receipt No : ${transaction.transaction_id}`);
    doc.text(`Bill ID : ${bill.bill_id}`);

    doc.moveDown();

    doc.text(`Customer Account : ${bill.customer_account_no}`);
    doc.text(`Company : ${company.company_name}`);
    doc.text(`Consumer No : ${bill.consumer_no}`);

    doc.moveDown();
    const total=Number(bill.amount)+Number(bill.fine);
    doc.text(`Billing Month : ${bill.billing_month}`);
    doc.text(`Amount : PKR ${bill.amount}`);
    doc.text(`Fine : PKR ${bill.fine}`);
    doc.text(`Total : PKR ${total}`);
    doc.text(`Status : PAID`);

    doc.moveDown();

    doc.text(
        `Payment Date : ${new Date().toLocaleString()}`
    );

    doc.moveDown(3);

    doc
        .fontSize(14)
        .text(
            "Thank you for using Finova Bank.",
            {
                align: "center",
            }
        );

    doc.end();

};

module.exports = {
    generateReceipt,
};