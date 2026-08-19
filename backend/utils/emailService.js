require("dotenv").config();
const nodemailer = require("nodemailer");
const { generateWelcomePDF } = require("../utils/pdfService");

const transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
        user: process.env.EMAIL,
        pass: process.env.APP_PASSWORD
    }
});

const sendAccountEmail = async (toEmail, customerName, accountNo, pdfPath) => {
    await transporter.sendMail({
        from: process.env.EMAIL,
        to: toEmail,
        subject: "Welcome to Finova Bank - Your Account Has Been Created",
        html: `
        <div style="max-width:650px;margin:auto;font-family:Arial,Helvetica,sans-serif;background:#ffffff;border:1px solid #dcdcdc;">
        <div style="background:#0B6E4F;padding:20px;text-align:center;">
        <h1 style="color:white;margin:0;">Finova Bank</h1>
        <p style="color:white;margin:5px 0 0 0;">Finova Bank Limited</p>
        </div>
        <div style="padding:30px;line-height:1.7;color:#333;">
        <h2 style="color:#0B6E4F;">Account Created Successfully</h2>
        <p>Dear <strong>${customerName}</strong>,</p>
        <p>
        Congratulations! We are pleased to inform you that your account has been
        successfully created with <strong>Finova Bank</strong>.
        </p>
        <table style="width:100%;border-collapse:collapse;margin:25px 0;">
        <tr style="background:#f5f5f5;">
                <td style="padding:12px;font-weight:bold;">Account Number</td>
                <td style="padding:12px;">${accountNo}</td>
        </tr>
        <tr>
                <td style="padding:12px;font-weight:bold;">Account Type</td>
                <td style="padding:12px;">Saving</td>
        </tr>
        <tr style="background:#f5f5f5;">
                <td style="padding:12px;font-weight:bold;">Status</td>
                <td style="padding:12px;color:green;"><strong>Active</strong></td>
        </tr>
        </table>
        <p>Please keep your account number secure. You may use this account for your banking services and future transactions.</p>
        <p>If you have any questions, please contact our Customer Support team.</p>
        <br>
        <p>Thank you for choosing <strong>Finova Bank</strong>. We look forward to serving you.</p>
        <br>
        <p>Regards,<br><strong>Customer Services Department</strong><br>Finova Bank Limited</p>
        </div>
        <div style="background:#f4f4f4;padding:15px;font-size:12px;color:#666;text-align:center;">This is an automated email. Please do not reply to this message.</div>
        </div>
        `,
        attachments: [
    {
        filename: "WelcomeLetter.pdf",
        path: pdfPath
    }
]
    });
};

module.exports = {
    sendAccountEmail
};