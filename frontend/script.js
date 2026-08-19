function toggleMenu(){

document.getElementById("menu").classList.toggle("active");
}
const fileInput = document.getElementById("formImage");
const fileNameSpan = document.getElementById("fileName");

fileInput.addEventListener("change", async (e) => {
    if (fileInput.files.length === 0) {
        fileNameSpan.textContent = "No file selected";
        return;
    }

    const file = fileInput.files[0];
    fileNameSpan.textContent = file.name;

    const formData = new FormData();
    formData.append("formImage", file);

    try {
        document.getElementById("result").innerHTML = "<h3>Processing...</h3>";

        const response = await fetch("/upload", {
            method: "POST",
            body: formData
        });

        const data = await response.json();

        if (!data.success) {
            document.getElementById("result").innerHTML = `<h3>${data.message}</h3>`;
            return;
        }

        const formDataAI = data.formData;

        console.log("Form Data:");
        console.log(formDataAI);
        
        document.getElementById("office").value = formDataAI.office || "";
        document.getElementById("date").value = formDataAI.date || "";
        document.getElementById("title").value = formDataAI.title || "";
        document.getElementById("firstname").value = formDataAI.firstname || "";
        document.getElementById("lastname").value = formDataAI.lastname || "";
        document.getElementById("cardno").value = formDataAI.cardno || "";
        document.getElementById("nationality").value = formDataAI.nationality || "";
        document.getElementById("dob").value = formDataAI.dob || "";
        document.getElementById("maritalstatus").value = formDataAI.maritalstatus || "";
        document.getElementById("age").value = formDataAI.age || "";
        document.getElementById("guardian").value = formDataAI.guardian || "";
        document.getElementById("spousename").value = formDataAI.spousename || "";
        document.getElementById("relationship").value = formDataAI.relationship || "";
        document.getElementById("position").value = formDataAI.position || "";
        document.getElementById("location").value = formDataAI.location || "";
        document.getElementById("province").value = formDataAI.province || "";
        document.getElementById("postalcode").value = formDataAI.postalcode || "";
        document.getElementById("phone").value = formDataAI.phone || "";
        document.getElementById("officephone").value = formDataAI.officephone || "";
        document.getElementById("mobile").value = formDataAI.mobile || "";
        document.getElementById("email").value = formDataAI.email || "";
        document.getElementById("faxno").value = formDataAI.faxno || "";
        document.getElementById("address").value = formDataAI.address || "";

        document.getElementById("result").innerHTML = `<h3>${data.message}</h3>`;

    } catch (err) {
        console.error(err);
        document.getElementById("result").innerHTML = "<h3>Something went wrong!</h3>";
    }
});

document.getElementById("savebtn").addEventListener("click", async () => {

    try {
        const customerData = {
            office_name: document.getElementById("office").value,
            joining_date: document.getElementById("date").value,
            title: document.getElementById("title").value,
            first_name: document.getElementById("firstname").value,
            last_name: document.getElementById("lastname").value,
            card_no: document.getElementById("cardno").value,
            nationality: document.getElementById("nationality").value,
            dob: document.getElementById("dob").value,
            age: parseInt(document.getElementById("age").value),
            marital_status: document.getElementById("maritalstatus").value,
            guardian_name: document.getElementById("guardian").value,
            spouse_name: document.getElementById("spousename").value,
            relationship: document.getElementById("relationship").value,
            working_position: document.getElementById("position").value,
            office_location: document.getElementById("location").value,
            address: document.getElementById("address").value,
            province: document.getElementById("province").value,
            postal_code: document.getElementById("postalcode").value,
            home_phone: document.getElementById("phone").value,
            office_phone: document.getElementById("officephone").value,
            mobile: document.getElementById("mobile").value,
            email: document.getElementById("email").value,
            fax_no: document.getElementById("faxno").value
        };

        const customerResponse = await fetch("/customer/add", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(customerData)
        });

        const customer = await customerResponse.json();

        const accountResponse = await fetch("/account/add", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                customer_id: customer.customer_id
            })
        });

        const account = await accountResponse.json();

//console.log(account);

// alert(`
// Account Created Successfully!
// Customer ID: ${customer.customer_id}
// Account Number: ${account.account_no}
// --SMS Service--
// To: ${account.mockSMS.to}
// ${account.mockSMS.message}
// Status: ${account.mockSMS.status}
// `);

// const parentDoc = window.parent.document;

// parentDoc.getElementById("customerDetails").innerHTML = `
// <p><strong>Customer ID:</strong> ${customer.customer_id}</p>
// <p><strong>Account Number:</strong> ${account.account_no}</p>
// <p><strong>Mobile:</strong> ${account.mockSMS.to}</p>
// <p><strong>Status:</strong> ${account.mockSMS.status}</p>
// `;

// parentDoc.getElementById("successModal").style.display = "flex";

// parentDoc.getElementById("goHomeBtn").onclick = function () {
//     window.parent.location.href = "index.html";
// };

document.getElementById("customerDetails").innerHTML = `
<p><strong>Customer ID:</strong> ${customer.customer_id}</p>
<p><strong>Account Number:</strong> ${account.account_no}</p>
<p><strong>Mobile:</strong> ${account.mockSMS.to}</p>
<p><strong>Status:</strong> ${account.mockSMS.status}</p>
`;

document.getElementById("successModal").style.display = "flex";

document.getElementById("goHomeBtn").onclick = function () {
    window.location.href = "accountForm.html";
};
    
// window.parent.location.href = "index.html";
    } catch (err) {
        console.error(err);
        alert("Something went wrong!");
    }
});

