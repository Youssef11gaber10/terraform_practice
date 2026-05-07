document.getElementById('registration-form').addEventListener('submit', function(event) {
    event.preventDefault();

    // Get form data
    const name = document.getElementById('name').value;
    const email = document.getElementById('email').value;
    const phone = document.getElementById('phone').value;
    const password = document.getElementById('password').value;

    // Create request object
    const xhr = new XMLHttpRequest();
    //get the api from my terminal
    xhr.open('POST', 'https://5x86hh70kj.execute-api.eu-north-1.amazonaws.com/register', true);
    xhr.setRequestHeader('Content-Type', 'application/json');

    // Handle response
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 200) {
                alert('Registration successful!');
                document.getElementById('registration-form').reset();
                fetchUsers(); // Refresh the users' table
            } else {
                alert('Registration failed: ' + xhr.responseText);
            }
        }
    };

    // Send data
    xhr.send(JSON.stringify({ name, email, phone, password }));
});

// Fetch and display users
function fetchUsers() {
    const xhr = new XMLHttpRequest();
    xhr.open('GET', 'https://5x86hh70kj.execute-api.eu-north-1.amazonaws.com/users', true);

    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 200) {
                try {
                    // Parse the response body into a JavaScript object
                    const response = JSON.parse(xhr.responseText);
                    const users = JSON.parse(response.body); // Parse the 'body' string into an array
                    
                    console.log(users); // Log to verify that it is an array

                    if (Array.isArray(users)) {
                        const tbody = document.getElementById('users-table').querySelector('tbody');
                        tbody.innerHTML = ''; // Clear existing rows

                        users.forEach(user => {
                            const row = `<tr>
                                <td>${user.name}</td>
                                <td>${user.email}</td>
                                <td>${user.phone}</td>
                            </tr>`;
                            tbody.innerHTML += row;
                        });
                    } else {
                        console.error('Expected an array but got:', users);
                    }
                } catch (error) {
                    console.error('Error parsing response:', error);
                }
            } else {
                console.error('Failed to fetch users:', xhr.responseText);
            }
        }
    };

    xhr.send();
}

// Load users on page load
fetchUsers();