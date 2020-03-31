// Replace the YOUR_API_ENDPOINT_URL with yours
// It should look something like this:

const API_ENDPOINT = '${api-gateway-api}/messages';

// Setup divs that will be used to display interactive messages
const errorDiv = document.getElementById('error-message')
const successDiv = document.getElementById('success-message')
const resultsDiv = document.getElementById('results-message')

// Setup easy way to reference values of the input boxes
function nameValue() { return document.getElementById('name').value }
function emailValue() { return document.getElementById('email').value }
function serviceValue() {
                            let srvc = document.getElementById('service');
                            return srvc.options[srvc.selectedIndex].text;
                        }
function subjectValue() { return document.getElementById('subject').value }

function clearNotifications() {
    // Clear any existing notifications in the browser notifications divs
    errorDiv.textContent = '';
    resultsDiv.textContent = '';
    successDiv.textContent = '';
}

// Add listeners for each button that make the API request
document.getElementById('emailButton').addEventListener('click', function(e) {
    sendData(e, 'email');
    document.getElementById('request-form').reset();
});


function sendData (e, pref) {
    // Prevent the page reloading and clear existing notifications
    e.preventDefault()
    clearNotifications()
    // Prepare the appropriate HTTP request to the API with fetch
    // create uses the root /prometheon endpoint and requires a JSON payload
    fetch(API_ENDPOINT, {
        headers:{
            "Content-type": "application/json"
        },
        method: 'POST',
        body: JSON.stringify({
            name: nameValue(),
            preference: pref,
            email: emailValue(),
            service: serviceValue(),
            subject: subjectValue()
        }),
        mode: 'cors'
    })
    .then((resp) => resp.json())
    .then(function(data) {
        console.log(data)
        successDiv.textContent = 'Looks ok!. But check the result below!';
        resultsDiv.textContent = JSON.stringify(data);
    })
    .catch(function(err) {
        errorDiv.textContent = 'Still working on this error:\n' + err.toString();
        console.log(err)
    });
};
