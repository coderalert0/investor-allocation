export function addRow() {
    // Get the investor inputs container
    const investorInputs = document.getElementsByClassName('investor-inputs')[0];

    // Create the name input field
    const nameField = document.createElement('input');
    nameField.setAttribute('type', 'text');
    nameField.setAttribute('name', 'investor_amounts[][name]');
    nameField.setAttribute('placeholder', 'Name');

    // Create the requested amount input field
    const requestedAmountField = document.createElement('input');
    requestedAmountField.setAttribute('type', 'number');
    requestedAmountField.setAttribute('name', 'investor_amounts[][requested_amount]');
    requestedAmountField.setAttribute('placeholder', 'Requested Amount');

    // Create the average amount input field
    const averageAmountField = document.createElement('input');
    averageAmountField.setAttribute('type', 'number');
    averageAmountField.setAttribute('name', 'investor_amounts[][average_amount]');
    averageAmountField.setAttribute('placeholder', 'Average Amount');

    // Append the new fields to the new row
    investorInputs.appendChild(nameField);
    investorInputs.appendChild(requestedAmountField);
    investorInputs.appendChild(averageAmountField);
}