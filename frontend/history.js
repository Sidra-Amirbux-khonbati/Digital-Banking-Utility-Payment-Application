document.getElementById("searchBtn").addEventListener("click", loadHistory);

async function loadHistory() {

    const accountNo = document.getElementById("accountNo").value.trim();

    if (!accountNo) {

        alert("Enter Account Number");

        return;

    }

    try {

        const response = await fetch(`/history/${accountNo}`);

        const data = await response.json();

        const tbody = document.getElementById("historyBody");

        tbody.innerHTML = "";

        if (!data.success || data.transactions.length === 0) {

            tbody.innerHTML = `
            <tr>
                <td colspan="7">
                    No Transactions Found
                </td>
            </tr>
            `;

            return;

        }

        data.transactions.forEach(transactions => {

            let typeClass = "";

            if (transactions.transaction_type === "Credit") {

                typeClass = "credit";

            }

            else if (transactions.transaction_type === "Debit") {

                typeClass = "debit";

            }

            else {

                typeClass = "transfer";

            }

            tbody.innerHTML += `

            <tr>

                <td>${transactions.transaction_id}</td>

                <td>${new Date(transactions.created_at).toLocaleString()}</td>

                <td class="${typeClass}">
                    ${transactions.transaction_type}
                </td>

                <td>${transactions.from_account ?? "-"}</td>

                <td>${transactions.to_account ?? "-"}</td>

                <td>PKR ${transactions.amount}</td>

                <td>

                    ${transactions.narration_line1}<br>

                    ${transactions.narration_line2}<br>

                    ${transactions.narration_line3}

                </td>

            </tr>

            `;

        });

    }

    catch(error){

        console.log(error);

        alert("Unable to load history.");

    }

}