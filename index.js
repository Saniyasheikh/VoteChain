// Modal
const modal = document.querySelector('.modal');
const modalToggle = document.querySelector('.modal-toggle');
const modalClose = document.querySelector('.modal-close');

modalToggle.addEventListener('click', () => {
    modal.style.display = 'flex';
});

modalClose.addEventListener('click', () => {
    modal.style.display = 'none';
});

// Responsive Navigation Menu
const menuToggle = document.querySelector('.menu-toggle');
const navMenu = document.querySelector('nav ul');

menuToggle.addEventListener('click', () => {
    navMenu.classList.toggle('show');
});

// Smooth Scrolling for Navigation Links
document.querySelectorAll('nav a').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();

        document.querySelector(this.getAttribute('href')).scrollIntoView({
            behavior: 'smooth'
        });

        if (window.innerWidth <= 768) {
            navMenu.classList.remove('show');
        }
    });
});




// Form Validation and Submission
const form = document.querySelector('form');

form.addEventListener('submit', function (e) {
    e.preventDefault();

    // Simple form validation (you can enhance this based on your needs)
    const nameInput = document.getElementById('name');
    const emailInput = document.getElementById('email');
    const messageInput = document.getElementById('message');

    if (!nameInput.value || !emailInput.value || !messageInput.value) {
        alert('Please fill in all fields.');
        return;
    }

    // Simulate form submission (replace this with your actual form submission logic)
    alert('Form submitted successfully!');
    form.reset();
});

// Fetch and Display Team Members
const teamContainer = document.querySelector('#team');

// Simulating fetching team members from an API
const fetchTeamMembers = async () => {
    try {
        // In a real scenario, you would fetch data from an API endpoint
        const response = await fetch('https://jsonplaceholder.typicode.com/users');
        const data = await response.json();

        // Display team members on the page
        data.forEach(member => {
            const memberElement = document.createElement('div');
            memberElement.classList.add('team-member');
            memberElement.innerHTML = `
                <img src="team-member-placeholder.jpg" alt="${member.name}">
                <h3>${member.name}</h3>
                <p>${member.email}</p>
            `;
            teamContainer.appendChild(memberElement);
        });
    } catch (error) {
        console.error('Error fetching team members:', error.message);
    }
};

// Call the fetchTeamMembers function to load team members when the page loads
fetchTeamMembers();




// Image Slideshow for Team Members
const teamSlideshow = document.querySelector('#team-slideshow');
const teamMembers = document.querySelectorAll('.team-member');
let currentTeamMember = 0;

function showTeamMember(index) {
    teamMembers.forEach((member, i) => {
        member.style.display = i === index ? 'block' : 'none';
    });
}

function nextTeamMember() {
    currentTeamMember = (currentTeamMember + 1) % teamMembers.length;
    showTeamMember(currentTeamMember);
}

function prevTeamMember() {
    currentTeamMember = (currentTeamMember - 1 + teamMembers.length) % teamMembers.length;
    showTeamMember(currentTeamMember);
}

// Auto-advance team slideshow every 5 seconds
setInterval(nextTeamMember, 5000);

// Smooth Scrolling for Section Transitions
document.querySelectorAll('nav a').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();

        const targetSection = document.querySelector(this.getAttribute('href'));

        // Smooth scroll to the target section
        targetSection.scrollIntoView({
            behavior: 'smooth'
        });

        if (window.innerWidth <= 768) {
            // Close the navigation menu on mobile
            navMenu.classList.remove('show');
        }
    });
});






// Countdown Timer
const electionDate = new Date('2023-12-01T00:00:00').getTime();

function updateCountdown() {
    const now = new Date().getTime();
    const timeDifference = electionDate - now;

    const days = Math.floor(timeDifference / (1000 * 60 * 60 * 24));
    const hours = Math.floor((timeDifference % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
    const minutes = Math.floor((timeDifference % (1000 * 60 * 60)) / (1000 * 60));
    const seconds = Math.floor((timeDifference % (1000 * 60)) / 1000);

    document.getElementById('countdown').innerHTML = `
        ${days}d ${hours}h ${minutes}m ${seconds}s
    `;
}

// Update the countdown every second
setInterval(updateCountdown, 1000);

// Scroll-to-Top Button
const scrollToTopButton = document.getElementById('scroll-to-top');

window.addEventListener('scroll', () => {
    // Show or hide the button based on the scroll position
    if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
        scrollToTopButton.style.display = 'block';
    } else {
        scrollToTopButton.style.display = 'none';
    }
});

scrollToTopButton.addEventListener('click', () => {
    // Smooth scroll to the top of the page
    document.body.scrollTop = 0;
    document.documentElement.scrollTop = 0;
});





// Chart.js for Voting Trends
const chartCanvas = document.getElementById('voting-chart').getContext('2d');

const votingData = {
    labels: ['Week 1', 'Week 2', 'Week 3', 'Week 4'],
    datasets: [{
        label: 'Votes',
        data: [200, 350, 500, 800],
        backgroundColor: 'rgba(247, 202, 24, 0.6)',
        borderColor: 'rgba(247, 202, 24, 1)',
        borderWidth: 2,
        fill: 'origin',
    }]
};

const votingChart = new Chart(chartCanvas, {
    type: 'line',
    data: votingData,
    options: {
        scales: {
            x: {
                grid: {
                    display: false
                }
            },
            y: {
                beginAtZero: true,
                grid: {
                    color: 'rgba(0, 0, 0, 0.1)',
                    lineWidth: 1
                }
            }
        }
    }
});

// Form Submission with Fetch API
const form = document.querySelector('form');

form.addEventListener('submit', async function (e) {
    e.preventDefault();

    const nameInput = document.getElementById('name');
    const emailInput = document.getElementById('email');
    const messageInput = document.getElementById('message');

    if (!nameInput.value || !emailInput.value || !messageInput.value) {
        alert('Please fill in all fields.');
        return;
    }

    const formData = new FormData(this);

    try {
        const response = await fetch('https://api.example.com/submit-form', {
            method: 'POST',
            body: formData
        });

        if (response.ok) {
            alert('Form submitted successfully!');
            form.reset();
        } else {
            throw new Error('Form submission failed.');
        }
    } catch (error) {
        console.error('Error submitting form:', error.message);
        alert('There was an error submitting the form. Please try again.');
    }
});




// Team Member Search
const teamSearchInput = document.getElementById('team-search');
const teamMembersContainer = document.getElementById('team');

teamSearchInput.addEventListener('input', function () {
    const searchTerm = this.value.toLowerCase();

    teamMembers.forEach(member => {
        const memberName = member.querySelector('h3').innerText.toLowerCase();

        if (memberName.includes(searchTerm)) {
            member.style.display = 'block';
        } else {
            member.style.display = 'none';
        }
    });
});

// Light/Dark Mode Toggle
const themeToggle = document.getElementById('theme-toggle');
const body = document.body;

themeToggle.addEventListener('click', () => {
    body.classList.toggle('dark-theme');

    // Save the user's preference to localStorage
    const isDarkMode = body.classList.contains('dark-theme');
    localStorage.setItem('darkMode', isDarkMode);
});

// Check for user's preference in localStorage on page load
const savedDarkMode = localStorage.getItem('darkMode');

if (savedDarkMode === 'true') {
    body.classList.add('dark-theme');
}






// Dynamic Progress Bar for Countdown Timer
const progressBar = document.getElementById('countdown-progress');

function updateProgressBar() {
    const now = new Date().getTime();
    const timeDifference = electionDate - now;
    const totalDuration = electionDate - new Date('2023-11-01T00:00:00').getTime(); // Adjust start date as needed

    const progressPercentage = ((totalDuration - timeDifference) / totalDuration) * 100;
    progressBar.style.width = `${progressPercentage}%`;
}

// Update the progress bar every second
setInterval(updateProgressBar, 1000);

// Notifications for Form Submission
const formNotification = document.getElementById('form-notification');

form.addEventListener('submit', async function (e) {
    e.preventDefault();

    const nameInput = document.getElementById('name');
    const emailInput = document.getElementById('email');
    const messageInput = document.getElementById('message');

    if (!nameInput.value || !emailInput.value || !messageInput.value) {
        alert('Please fill in all fields.');
        return;
    }

    const formData = new FormData(this);

    try {
        const response = await fetch('https://api.example.com/submit-form', {
            method: 'POST',
            body: formData
        });

        if (response.ok) {
            form.reset();
            formNotification.textContent = 'Form submitted successfully!';
            formNotification.classList.remove('error');
            formNotification.classList.add('success');
            setTimeout(() => {
                formNotification.textContent = '';
            }, 5000);
        } else {
            throw new Error('Form submission failed.');
        }
    } catch (error) {
        console.error('Error submitting form:', error.message);
        formNotification.textContent = 'There was an error submitting the form. Please try again.';
        formNotification.classList.remove('success');
        formNotification.classList.add('error');
    }
});

// Reset the notification when the user starts typing in the form again
form.addEventListener('input', function () {
    formNotification.textContent = '';
});







// Highlight Active Section in Navigation
const sections = document.querySelectorAll('section');
const navLinks = document.querySelectorAll('nav a');

function highlightActiveSection() {
    let scrollPosition = window.scrollY + 100;

    sections.forEach((section, index) => {
        const sectionTop = section.offsetTop;
        const sectionHeight = section.clientHeight;

        if (scrollPosition >= sectionTop && scrollPosition < sectionTop + sectionHeight) {
            navLinks.forEach(link => link.classList.remove('active'));
            navLinks[index].classList.add('active');
        }
    });
}

// Update the active section on scroll
document.addEventListener('scroll', highlightActiveSection);

// "Back to Top" Button
const backToTopButton = document.getElementById('scroll-to-top');

// Show or hide the "Back to Top" button based on the scroll position
function toggleBackToTopButton() {
    if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
        backToTopButton.style.display = 'block';
    } else {
        backToTopButton.style.display = 'none';
    }
}

// Smooth scroll to the top when the button is clicked
backToTopButton.addEventListener('click', () => {
    document.body.scrollTop = 0;
    document.documentElement.scrollTop = 0;
});

// Update the "Back to Top" button visibility on scroll
document.addEventListener('scroll', toggleBackToTopButton);









// Smooth Scroll to Section
document.querySelectorAll('nav a').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();

        const targetSection = document.querySelector(this.getAttribute('href'));

        // Smooth scroll to the target section
        targetSection.scrollIntoView({
            behavior: 'smooth'
        });

        // Highlight the clicked navigation link as active
        navLinks.forEach(link => link.classList.remove('active'));
        this.classList.add('active');
    });
});

// Dynamic Progress Bar for "Back to Top" Button
const backToTopProgressBar = document.getElementById('back-to-top-progress');

function updateBackToTopProgressBar() {
    const scrollPercentage = (document.body.scrollTop || document.documentElement.scrollTop) / (document.documentElement.scrollHeight - document.documentElement.clientHeight) * 100;
    backToTopProgressBar.style.width = `${scrollPercentage}%`;
}

// Update the progress bar for the "Back to Top" button on scroll
document.addEventListener('scroll', updateBackToTopProgressBar);

// Reset the progress bar when the user starts scrolling again
document.addEventListener('scroll', () => {
    if (backToTopProgressBar.style.width !== '0%') {
        backToTopProgressBar.style.width = '0%';
    }
});









// Dynamic Team Member Details
const teamMembers = document.querySelectorAll('.team-member');

teamMembers.forEach(member => {
    member.addEventListener('click', () => {
        const memberName = member.querySelector('h3').innerText;
        const memberEmail = member.querySelector('p').innerText;

        // Display a modal with team member details
        alert(`Team Member: ${memberName}\nEmail: ${memberEmail}`);
    });
});

// Voting Chart Modal
const votingChartModal = document.getElementById('voting-chart-modal');
const chartModalContent = document.getElementById('chart-modal-content');

// Simulate voting chart data
const chartData = {
    labels: ['Week 1', 'Week 2', 'Week 3', 'Week 4'],
    datasets: [{
        label: 'Votes',
        data: [200, 350, 500, 800],
        backgroundColor: 'rgba(247, 202, 24, 0.6)',
        borderColor: 'rgba(247, 202, 24, 1)',
        borderWidth: 2,
        fill: 'origin',
    }]
};

// Display modal with detailed information when clicking on a chart data point
votingChart.canvas.addEventListener('click', (event) => {
    const activePoint = votingChart.getElementsAtEvent(event)[0];

    if (activePoint) {
        const weekNumber = activePoint.index + 1;
        const votes = chartData.datasets[0].data[activePoint.index];

        chartModalContent.innerHTML = `
            <h2>Week ${weekNumber} Voting Details</h2>
            <p>Total Votes: ${votes}</p>
        `;

        // Display the modal
        votingChartModal.style.display = 'flex';
    }
});

// Close the modal when clicking outside the modal content
votingChartModal.addEventListener('click', (event) => {
    if (event.target === votingChartModal) {
        votingChartModal.style.display = 'none';
    }
});

// Close the modal when clicking the close button
document.getElementById('chart-modal-close').addEventListener('click', () => {
    votingChartModal.style.display = 'none';
});












// Toggle Visibility of Voting Chart and Team Members
const toggleChartButton = document.getElementById('toggle-chart');
const toggleTeamButton = document.getElementById('toggle-team');
const votingChartContainer = document.getElementById('voting-chart-container');
const teamMembersContainer = document.getElementById('team');

toggleChartButton.addEventListener('click', () => {
    votingChartContainer.classList.toggle('hidden');
});

toggleTeamButton.addEventListener('click', () => {
    teamMembersContainer.classList.toggle('hidden');
});

// Dynamic Loading of Additional Team Members
const loadMoreButton = document.getElementById('load-more-team');
const teamContainer = document.getElementById('team');

loadMoreButton.addEventListener('click', async () => {
    try {
        // Simulate fetching additional team members from a JSON file
        const response = await fetch('team-members.json');
        const newTeamMembers = await response.json();

        // Display the new team members on the page
        newTeamMembers.forEach(member => {
            const memberElement = document.createElement('div');
            memberElement.classList.add('team-member');
            memberElement.innerHTML = `
                <img src="${member.image}" alt="${member.name}">
                <h3>${member.name}</h3>
                <p>${member.email}</p>
            `;
            teamContainer.appendChild(memberElement);
        });
    } catch (error) {
        console.error('Error loading additional team members:', error.message);
    }
});











// Vote Submission Form
const voteForm = document.getElementById('vote-form');
const voteInput = document.getElementById('vote-input');

voteForm.addEventListener('submit', async (e) => {
    e.preventDefault();

    const voteValue = parseInt(voteInput.value, 10);

    if (!isNaN(voteValue)) {
        try {
            // Simulate submitting the vote to a server (replace with actual server logic)
            // For simplicity, we'll just update the chart locally
            chartData.datasets[0].data.push(voteValue);
            votingChart.update();

            // Display a success message (you can replace this with a more sophisticated notification)
            alert('Vote submitted successfully!');
        } catch (error) {
            console.error('Error submitting vote:', error.message);
            alert('There was an error submitting the vote. Please try again.');
        }
    } else {
        alert('Please enter a valid vote.');
    }
});

// Reset the form when the user starts typing
voteForm.addEventListener('input', () => {
    alert('Your previous vote has been cleared. Please submit your new vote.');
    voteInput.value = '';
});

// Update Voting Chart Modal on Chart Click
votingChart.canvas.addEventListener('click', (event) => {
    const activePoint = votingChart.getElementsAtEvent(event)[0];

    if (activePoint) {
        const weekNumber = activePoint.index + 1;
        const votes = chartData.datasets[0].data[activePoint.index];

        chartModalContent.innerHTML = `
            <h2>Week ${weekNumber} Voting Details</h2>
            <p>Total Votes: ${votes}</p>
            <button id="submit-modal-vote">Submit Vote</button>
        `;

        // Display the modal
        votingChartModal.style.display = 'flex';

        // Handle submitting a vote from the modal
        document.getElementById('submit-modal-vote').addEventListener('click', () => {
            const modalVoteValue = prompt('Enter your vote for this week:');
            const parsedModalVote = parseInt(modalVoteValue, 10);

            if (!isNaN(parsedModalVote)) {
                chartData.datasets[0].data[activePoint.index] = parsedModalVote;
                votingChart.update();
                alert('Vote submitted successfully!');
            } else {
                alert('Please enter a valid vote.');
            }
        });
    }
});



