// Check Balance

document.getElementById("checkBalanceBtn").addEventListener("click", async () => {

    const accountNo = document.getElementById("accountNo").value.trim();

    document.getElementById("error").innerHTML = "";

    document.getElementById("balanceCard").style.display = "none";

    if(accountNo === ""){

        document.getElementById("error").innerHTML = "Please enter an Account Number.";

        return;

    }

    try{

        const response = await fetch(`/balance/${accountNo}`);

        const data = await response.json();

        if(!response.ok){

            document.getElementById("error").innerHTML =
            data.message || "Account not found.";

            return;

        }

        document.getElementById("accountNumber").textContent =
        data.account_no;

  document.getElementById("customerName").textContent =
    data.customer_name || "Not Available";
    
document.getElementById("accountStatus").textContent =
"Active";
        document.getElementById("runningBalance").textContent =
        `PKR ${Number(data.running_balance).toLocaleString()}`;

        document.getElementById("balanceCard").style.display = "block";

    }

    catch(error){

        console.log(error);

        document.getElementById("error").innerHTML =
        "Unable to connect to server.";

    }

});