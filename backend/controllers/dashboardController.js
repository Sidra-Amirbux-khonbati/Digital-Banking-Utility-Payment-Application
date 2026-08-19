const dashboardModel = require("../models/dashboardModel");

const getDashboard = async (req, res) => {

    try {

        const account_no = req.params.account_no;

        const dashboard =
            await dashboardModel.getDashboard(account_no);

        res.status(200).json(dashboard);

    } catch (error) {

        console.log(error);

        res.status(500).json({
            message: error.message
        });

    }

};

module.exports = {
    getDashboard
};