
// async function loadAccounts() {

//     try {

//         const response = await fetch("/account/all");

//         const accounts = await response.json();

//         const deposit = document.getElementById("depositAccount");
//         const withdraw = document.getElementById("withdrawAccount");
//         const from = document.getElementById("fromAccount");
//         const to = document.getElementById("toAccount");

//         accounts.forEach(account => {

//             deposit.innerHTML += `
//                 <option value="${account.account_no}">
//                     ${account.account_no}
//                 </option>
//             `;

//             withdraw.innerHTML += `
//                 <option value="${account.account_no}">
//                     ${account.account_no}
//                 </option>
//             `;

//             from.innerHTML += `
//                 <option value="${account.account_no}">
//                     ${account.account_no}
//                 </option>
//             `;

//             to.innerHTML += `
//                 <option value="${account.account_no}">
//                     ${account.account_no}
//                 </option>
//             `;

//         });

//     } catch (error) {

//         console.log(error);

//     }

// }
function showForm(formId, button) {

    document.querySelectorAll(".form").forEach(form => {
        form.classList.remove("active");
    });

    document.querySelectorAll(".tabs button").forEach(btn => {
        btn.classList.remove("active");
    });

    document.getElementById(formId).classList.add("active");

    button.classList.add("active");

}


document.getElementById("depositBtn").addEventListener("click", async () => {

    try {

        const response = await fetch("/transaction/credit", {

            method: "POST",

            headers: {
                "Content-Type": "application/json"
            },

            body: JSON.stringify({

                to_account: document.getElementById("depositAccount").value,

                amount: document.getElementById("depositAmount").value,

                narration_line1: document.getElementById("depositNarration1").value,

                narration_line2: document.getElementById("depositNarration2").value,

                narration_line3: document.getElementById("depositNarration3").value

            })

        });

        const data = await response.json();

document.getElementById("transactionDetails").innerHTML = `
<p><strong>Message:</strong> ${data.message}</p>
<p><strong>Running Balance:</strong> PKR ${data.running_balance}</p>
`;

document.getElementById("successModal").style.display = "flex";
    }

    catch (error) {

        console.log(error);

        alert("Something went wrong.");

    }

});


document.getElementById("withdrawBtn").addEventListener("click", async () => {

    try {

        const response = await fetch("/transaction/debit", {

            method: "POST",

            headers: {
                "Content-Type": "application/json"
            },

            body: JSON.stringify({

                from_account: document.getElementById("withdrawAccount").value,

                amount: document.getElementById("withdrawAmount").value,

                narration_line1: document.getElementById("withdrawNarration1").value,

                narration_line2: document.getElementById("withdrawNarration2").value,

                narration_line3: document.getElementById("withdrawNarration3").value

            })

        });

        const data = await response.json();

document.getElementById("transactionDetails").innerHTML = `
<p><strong>Message:</strong> ${data.message}</p>
<p><strong>Running Balance:</strong> PKR ${data.running_balance}</p>
`;

document.getElementById("successModal").style.display = "flex";
    }

    catch (error) {

        console.log(error);

        alert("Something went wrong.");

    }

});


document.getElementById("transferBtn").addEventListener("click", async () => {

    try {

        const response = await fetch("/transaction/transfer", {

            method: "POST",

            headers: {
                "Content-Type": "application/json"
            },

            body: JSON.stringify({

                from_account: document.getElementById("fromAccount").value,

                to_account: document.getElementById("toAccount").value,

                amount: document.getElementById("transferAmount").value,

                narration_line1: document.getElementById("transferNarration1").value,

                narration_line2: document.getElementById("transferNarration2").value,

                narration_line3: document.getElementById("transferNarration3").value

            })

        });

        const data = await response.json();

document.getElementById("transactionDetails").innerHTML = `
<p><strong>Message:</strong> ${data.message}</p>
<p><strong>Sender Balance:</strong> PKR ${data.sender_balance}</p>
<p><strong>Receiver Balance:</strong> PKR ${data.receiver_balance}</p>
`;

document.getElementById("successModal").style.display = "flex";
    }

    catch (error) {

        console.log(error);

        alert("Something went wrong.");

    }

});

// loadAccounts();

document.getElementById("closeModal").addEventListener("click", () => {
    document.getElementById("successModal").style.display = "none";
});