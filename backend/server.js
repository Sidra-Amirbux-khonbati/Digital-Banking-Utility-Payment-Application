require("dotenv").config();
const express = require("express");
const path = require("path");
const fs = require("fs");
const multer = require("multer");
const pdfParse = require("pdf-parse");
const parseForm = require("./utils/regex");
const customerRoutes = require("./routes/customerRoutes");
const accountRoutes = require("./routes/accountRoutes");
const transactionRoutes = require("./routes/transactionRoutes");
const balanceRoutes = require("./routes/balanceRoutes");
const historyRoutes = require("./routes/historyRoutes");
const companyRoutes = require("./routes/companyRoutes");
const billRoutes = require("./routes/billRoutes");
const dashboardRoutes = require("./routes/dashboardRoutes");


const app = express();
const pdfFolder = path.join(__dirname, "generate_pdf");

if (fs.existsSync(pdfFolder)) {
    fs.readdirSync(pdfFolder).forEach((file) => {
        fs.unlinkSync(path.join(pdfFolder, file));
    });
}

app.use(express.json());

app.use(express.static(path.join(__dirname, "../frontend")));
app.use("/customer", customerRoutes);
app.use("/account", accountRoutes);
app.use("/transaction", transactionRoutes);
app.use("/balance", balanceRoutes);
app.use("/history", historyRoutes);
app.use("/company", companyRoutes);
app.use("/bill", billRoutes);
app.use("/dashboard", dashboardRoutes);

app.use(express.urlencoded({extended:true}));
const PORT = 3000;

const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, "uploads/");
    },

    filename: function (req, file, cb) {
        cb(null, Date.now() + "-" + file.originalname);
    }
});

const upload = multer({ storage });
    app.post("/upload", upload.single("formImage"), async (req, res) => {

    console.log("UPLOAD API CALLED");

    try {
        if (!req.file) {
    return res.status(400).json({
        success: false,
        message: "Please upload a file."
    });
}

    if (req.file.mimetype === "application/pdf") {
    const buffer = fs.readFileSync(req.file.path);
    const pdfData = await pdfParse(buffer);
    console.log(pdfData.text);

    const formData = parseForm(pdfData.text);
    fs.unlinkSync(req.file.path);

    return res.json({
        success: true,
        message: "PDF uploaded successfully!",
        formData
    });
} else {
            return res.status(400).json({
                success: false,
                message: "Unsupported file type."
            });
        }
    }
    catch (err) {
        console.log(err);
        return res.status(500).json({
            success: false,
            message: "Something went wrong."
        });
    }
});
app.listen(PORT, () => {
    console.log(`Server running at http://localhost:${PORT}`);
});