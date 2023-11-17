import React, { useState } from 'react';
import './App.css'; // You may need to create this file for styling
import Chart from 'chart.js/auto';

function App() {
  const [votes, setVotes] = useState([200, 350, 500, 800]);
  const [voteInput, setVoteInput] = useState('');
  const [modalOpen, setModalOpen] = useState(false);

  const chartRef = React.createRef();

  const updateChart = () => {
    if (chartRef.current) {
      const ctx = chartRef.current.getContext('2d');
      new Chart(ctx, {
        type: 'line',
        data: {
          labels: ['Week 1', 'Week 2', 'Week 3', 'Week 4'],
          datasets: [{
            label: 'Votes',
            data: votes,
            backgroundColor: 'rgba(247, 202, 24, 0.6)',
            borderColor: 'rgba(247, 202, 24, 1)',
            borderWidth: 2,
            fill: 'origin',
          }]
        },
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
    }
  };

  const handleVoteSubmit = (e) => {
    e.preventDefault();

    const parsedVote = parseInt(voteInput, 10);
    if (!isNaN(parsedVote)) {
      setVotes([...votes, parsedVote]);
      setVoteInput('');
      setModalOpen(false);
    } else {
      alert('Please enter a valid vote.');
    }
  };

  return (
    <div className="App">
      <header className="App-header">
        <h1>VoteChain</h1>
        <button onClick={() => setModalOpen(!modalOpen)}>Open Modal</button>
        {modalOpen && (
          <div className="modal">
            <form onSubmit={handleVoteSubmit}>
              <label>
                Enter your vote:
                <input type="number" value={voteInput} onChange={(e) => setVoteInput(e.target.value)} />
              </label>
              <button type="submit">Submit Vote</button>
            </form>
          </div>
        )}
        <canvas ref={chartRef} width="400" height="200"></canvas>
      </header>
    </div>
  );
}

export default App;
import React from 'react';

const Team = () => {
  const teamMembers = [
    { id: 1, name: 'John Doe', email: 'john@example.com' },
    { id: 2, name: 'Jane Smith', email: 'jane@example.com' },
    // Add more team members as needed
  ];

  return (
    <div className="team-container">
      <h2>Team Members</h2>
      <ul>
        {teamMembers.map(member => (
          <li key={member.id}>
            <strong>{member.name}</strong> - {member.email}
          </li>
        ))}
      </ul>
    </div>
  );
};

export default Team;
import React from 'react';
import { BrowserRouter as Router, Route, Link } from 'react-router-dom';
import './App.css';
import Team from './Team';

const App = () => {
  return (
    <Router>
      <div className="App">
        <header className="App-header">
          <h1>VoteChain</h1>
          <nav>
            <ul>
              <li><Link to="/">Home</Link></li>
              <li><Link to="/team">Team</Link></li>
            </ul>
          </nav>
          <Route path="/team" component={Team} />
        </header>
      </div>
    </Router>
  );
};

export default App;
import React, { useState } from 'react';

const VoteForm = ({ onVoteSubmit }) => {
  const [voteInput, setVoteInput] = useState('');
  const [notification, setNotification] = useState('');

  const handleVoteSubmit = (e) => {
    e.preventDefault();

    const parsedVote = parseInt(voteInput, 10);
    if (!isNaN(parsedVote)) {
      onVoteSubmit(parsedVote);
      setNotification('Vote submitted successfully!');
      setVoteInput('');
      setTimeout(() => {
        setNotification('');
      }, 5000);
    } else {
      setNotification('Please enter a valid vote.');
    }
  };

  return (
    <div className="vote-form-container">
      <h2>Submit Your Vote</h2>
      <form onSubmit={handleVoteSubmit}>
        <label>
          Enter your vote:
          <input type="number" value={voteInput} onChange={(e) => setVoteInput(e.target.value)} />
        </label>
        <button type="submit">Submit Vote</button>
      </form>
      {notification && <p className="notification">{notification}</p>}
    </div>
  );
};

export default VoteForm;
import React, { useState } from 'react';
import { BrowserRouter as Router, Route, Link } from 'react-router-dom';
import './App.css';
import Team from './Team';
import VoteForm from './VoteForm';

const App = () => {
  const [votes, setVotes] = useState([200, 350, 500, 800]);

  const handleVoteSubmit = (newVote) => {
    setVotes([...votes, newVote]);
  };

  return (
    <Router>
      <div className="App">
        <header className="App-header">
          <h1>VoteChain</h1>
          <nav>
            <ul>
              <li><Link to="/">Home</Link></li>
              <li><Link to="/team">Team</Link></li>
            </ul>
          </nav>
          <Route path="/team" component={Team} />
          <Route
            path="/"
            exact
            render={() => (
              <div>
                <VoteForm onVoteSubmit={handleVoteSubmit} />
                <canvas id="voting-chart" width="400" height="200"></canvas>
              </div>
            )}
          />
        </header>
      </div>
    </Router>
  );
};

export default App;
