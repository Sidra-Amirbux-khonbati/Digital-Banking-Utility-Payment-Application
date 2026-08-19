const PDFDocument = require("pdfkit");
const fs = require("fs");
const path = require("path");

const generateWelcomePDF = (customerName, accountNo) => {

        const pdfFolder = path.join(__dirname, "../generated_pdfs");

    if (fs.existsSync(pdfFolder)) {
        fs.readdirSync(pdfFolder).forEach((file) => {
            if (file.endsWith(".pdf")) {
                fs.unlinkSync(path.join(pdfFolder, file));
            }
        });
    } else {
        fs.mkdirSync(pdfFolder);
    }
    const fileName = `Welcome_${accountNo}.pdf`;
    const filePath = path.join(__dirname, "../generated_pdfs", fileName);

    const doc = new PDFDocument({
        size: "A4",
        margin: 50
    });

    doc.pipe(fs.createWriteStream(filePath));
    doc.rect(0, 0, 595, 100).fill("#003366");

    doc
        .fillColor("white")
        .font("Helvetica-Bold")
        .fontSize(28)
        .text("FINOVA BANK", 0, 28, {
            align: "center"
        });

    doc
        .font("Helvetica")
        .fontSize(14)
        .text("Banking Made Simple", {
            align: "center"
        });

    doc.moveDown(4);

    doc
        .fillColor("#0B6E4F")
        .font("Helvetica-Bold")
        .fontSize(22)
        .text("WELCOME TO FINOVA BANK", {
            align: "center"
        });

    doc.moveDown(2);

    doc
        .fillColor("black")
        .font("Helvetica")
        .fontSize(13);

    doc.text(`  Dear ${customerName},`);

    doc.moveDown();

    doc.text("  Congratulations!");

    doc.moveDown(0.5);

    doc.text(
        "   We are delighted to welcome you to Finova Bank."
    );

    doc.moveDown(0.5);

    doc.text(
        "   Your account has been successfully created and is now ready to use."
    );

    doc.moveDown(2);

    const startX = 60;
    const startY = doc.y;

    doc
        .lineWidth(1)
        .roundedRect(startX, startY, 470, 150, 8)
        .stroke("#003366");

    doc
        .fillColor("#003366")
        .font("Helvetica-Bold")
        .fontSize(16)
        .text("ACCOUNT INFORMATION", startX + 15, startY + 15);

    doc
        .moveTo(startX, startY + 45)
        .lineTo(startX + 470, startY + 45)
        .stroke();

    doc
        .fillColor("black")
        .font("Helvetica")
        .fontSize(12);

    doc.text(`Customer Name : ${customerName}`, startX + 20, startY + 60);
    doc.text(`Account Number : ${accountNo}`, startX + 20, startY + 85);
    doc.text(`Account Type : Saving`, startX + 20, startY + 110);
    doc.text(`Status : Active`, startX + 20, startY + 135);
    doc.y = startY + 180;

    doc.moveDown();

    doc.text(
        "Thank you for choosing Finova Bank."
    );

    doc.moveDown();

    doc.text(
        "We are committed to providing secure, reliable and innovative banking services."
    );

    doc.moveDown();

    doc.text(
        "We look forward to serving your banking needs."
    );

    doc.moveDown(2);

    doc
        .font("Helvetica-Bold")
        .text("Kind Regards,");

    doc
        .font("Helvetica")
        .text("Customer Services Department");

    doc.text("Finova Bank");



    doc.moveDown(3);

    doc.moveTo(50, doc.y).lineTo(545, doc.y).stroke("#999999");

    doc.moveDown();

    doc
        .fillColor("gray")
        .fontSize(10)
        .text(
            "This is a system-generated document and does not require a signature.",
            {
                align: "center"
            }
        );

    doc.end();

    return filePath;
};

module.exports = {
    generateWelcomePDF
};