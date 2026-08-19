const API = "http://localhost:3000";

async function loadCompanies(){
    try{
        const response = await fetch(
            `${API}/company/pending`
        );
        const result = await response.json();

const table = document.getElementById("companyTable");

table.innerHTML = "";

if (!result.success) {
    alert(result.message);
    return;
}

const companies = result.data;

companies.forEach(company => {
            table.innerHTML += `
            <tr>
                <td>${company.queue_id}</td>

                <td>${company.company_name}</td>

                <td>${company.company_type}</td>

                <td>${company.contact_email}</td>

                <td>${company.contact_phone}</td>

                <td>${company.status}</td>


                <td>

                <button 
                class="approve"
                onclick="approveCompany(${company.queue_id})">
                Approve
                </button>


                <button 
                class="reject"
                onclick="rejectCompany(${company.queue_id})">
                Reject
                </button>


                </td>


            </tr>

            `;


        });



    }
    catch(error){

        console.log(error);

    }
}
function closeModal(){
    document.getElementById("successModal").style.display="none";
}

function closeRejectModal(){
    document.getElementById("rejectModal").style.display = "none";
}

async function approveCompany(queue_id){

    try{

        const response = await fetch(
            `${API}/company/approve/${queue_id}`,
            {
                method:"PATCH"
            }
        );

        const data = await response.json();

        document.getElementById("companyDetails").innerHTML = `
            <p><strong>Company Name:</strong> ${data.company.company_name}</p>

            <p><strong>Company ID:</strong> ${data.company.company_id}</p>

            <p><strong>Company Account No:</strong> ${data.company.company_account_no}</p>


            <p><strong>Status:</strong> ${data.company.company_status}</p>
        `;

        document.getElementById("successModal").style.display = "flex";

        loadCompanies();

    }
    catch(error){
        console.log(error);
    }
}

async function rejectCompany(queue_id){

    try{

        const response = await fetch(

            `${API}/company/reject/${queue_id}`,

            {
                method:"PATCH"
            }

        );

        const data = await response.json();

        document.getElementById("rejectDetails").innerHTML = `
            <p><strong>Queue ID:</strong> ${queue_id}</p>

            <p><strong>Status:</strong> Rejected</p>

            <p>This company request has been rejected successfully.</p>
        `;

        document.getElementById("rejectModal").style.display = "flex";
        loadCompanies();

    }
    catch(error){
        console.log(error);
    }

}

loadCompanies();