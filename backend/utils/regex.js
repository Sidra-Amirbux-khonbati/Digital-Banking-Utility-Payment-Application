function parseForm(text) {
    const lines = text.split('\n').map(line => line.trim()).filter(line => line.length > 0);

    const getValueForLabel = (label) => {
        const index = lines.findIndex(line => line.toLowerCase() === label.toLowerCase());

        if (index !== -1 && index + 1 < lines.length) {
            return lines[index + 1];
        }
        return "";
    };

    const office = getValueForLabel("Office / Branch");
    const date = getValueForLabel("Date");
    const title = getValueForLabel("Title (Mr, Mrs, Ms)");
    const firstname = getValueForLabel("First Name");
    const lastname = getValueForLabel("Last Name");
    
    const cardno = getValueForLabel("Personal ID Card No.");
    const nationality = getValueForLabel("Nationality");
    const dob = getValueForLabel("Date of Birth");
    const maritalstatus = getValueForLabel("Marital Status (Single, Married, Divorced, Widowed)");
    const age = getValueForLabel("Age");
    
    const guardian = getValueForLabel("Name of Guardian");
    const spousename = getValueForLabel("Spouse Name");
    const relationship = getValueForLabel("Relationship");
    
    const position = getValueForLabel("Working Position");
    const location = getValueForLabel("Office");
    
    const province = getValueForLabel("Province");
    const postalcode = getValueForLabel("Postal Code");
    const phone = getValueForLabel("Home Phone");
    const officephone = getValueForLabel("Office Phone");
    const mobile = getValueForLabel("Mobile");
    const email = getValueForLabel("Email");
    const faxno = getValueForLabel("Fax No.");
    const address = getValueForLabel("Address");

    return {
        office,
        date,
        title,
        firstname,
        lastname,
        cardno,
        nationality,
        dob,
        maritalstatus,
        age,
        guardian,
        spousename,
        relationship,
        position,
        location,
        province,
        postalcode,
        phone,
        officephone,
        mobile,
        email,
        faxno,
        address
    };
}

module.exports = parseForm;