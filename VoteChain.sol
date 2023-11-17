// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VoteChain {
    address public admin;
    uint256 public electionEndTime;
    mapping(address => bool) public hasVoted;
    mapping(uint256 => uint256) public votes;

    event VoteCast(address indexed voter, uint256 candidate);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not authorized");
        _;
    }

    modifier onlyDuringElection() {
        require(block.timestamp < electionEndTime, "Election has ended");
        _;
    }

    constructor(uint256 _durationInMinutes) {
        admin = msg.sender;
        electionEndTime = block.timestamp + (_durationInMinutes * 1 minutes);
    }

    function vote(uint256 _candidate) external onlyDuringElection {
        require(!hasVoted[msg.sender], "You have already voted");
        require(_candidate > 0 && _candidate <= 5, "Invalid candidate");

        hasVoted[msg.sender] = true;
        votes[_candidate]++;
        emit VoteCast(msg.sender, _candidate);
    }

    function getVotes(uint256 _candidate) external view returns (uint256) {
        require(_candidate > 0 && _candidate <= 5, "Invalid candidate");
        return votes[_candidate];
    }

    function endElection() external onlyAdmin {
        require(block.timestamp >= electionEndTime, "Election has not ended");
        selfdestruct(payable(admin));
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VoteChain {
    address public admin;
    uint256 public nextElectionId;
    mapping(uint256 => Election) public elections;
    mapping(address => bool) public hasVoted;

    struct Election {
        uint256 id;
        string name;
        uint256 endTime;
        mapping(uint256 => uint256) votes;
        mapping(uint256 => Candidate) candidates;
        uint256 candidateCount;
        bool isActive;
    }

    struct Candidate {
        string name;
        address candidateAddress;
    }

    event VoteCast(uint256 indexed electionId, address indexed voter, uint256 candidateId);
    event ElectionCreated(uint256 indexed electionId, string name, uint256 endTime);
    event CandidateRegistered(uint256 indexed electionId, uint256 candidateId, string name);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not authorized");
        _;
    }

    modifier onlyDuringElection(uint256 _electionId) {
        require(elections[_electionId].isActive, "Election is not active");
        require(block.timestamp < elections[_electionId].endTime, "Election has ended");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function createElection(string memory _name, uint256 _durationInMinutes) external onlyAdmin {
        uint256 electionEndTime = block.timestamp + (_durationInMinutes * 1 minutes);
        elections[nextElectionId] = Election(nextElectionId, _name, electionEndTime, 0, 0, true);
        emit ElectionCreated(nextElectionId, _name, electionEndTime);
        nextElectionId++;
    }

    function registerCandidate(uint256 _electionId, string memory _name) external onlyAdmin onlyDuringElection(_electionId) {
        uint256 candidateId = elections[_electionId].candidateCount;
        elections[_electionId].candidates[candidateId] = Candidate(_name, msg.sender);
        elections[_electionId].candidateCount++;
        emit CandidateRegistered(_electionId, candidateId, _name);
    }

    function vote(uint256 _electionId, uint256 _candidateId) external onlyDuringElection(_electionId) {
        require(!hasVoted[msg.sender], "You have already voted");
        require(_candidateId < elections[_electionId].candidateCount, "Invalid candidate");

        hasVoted[msg.sender] = true;
        elections[_electionId].votes[_candidateId]++;
        emit VoteCast(_electionId, msg.sender, _candidateId);
    }

    function getVotes(uint256 _electionId, uint256 _candidateId) external view returns (uint256) {
        require(_candidateId < elections[_electionId].candidateCount, "Invalid candidate");
        return elections[_electionId].votes[_candidateId];
    }

    function endElection(uint256 _electionId) external onlyAdmin onlyDuringElection(_electionId) {
        elections[_electionId].isActive = false;
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VoteChain {
    address public admin;
    uint256 public nextElectionId;
    mapping(uint256 => Election) public elections;
    mapping(address => bool) public hasVoted;

    struct Election {
        uint256 id;
        string name;
        uint256 endTime;
        mapping(uint256 => uint256) votes;
        mapping(uint256 => Candidate) candidates;
        uint256 candidateCount;
        bool isActive;
        uint256 quorum;
    }

    struct Candidate {
        string name;
        address candidateAddress;
    }

    event VoteCast(uint256 indexed electionId, address indexed voter, uint256 candidateId);
    event ElectionCreated(uint256 indexed electionId, string name, uint256 endTime, uint256 quorum);
    event CandidateRegistered(uint256 indexed electionId, uint256 candidateId, string name);
    event ElectionEnded(uint256 indexed electionId, string name, uint256 quorumMet);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not authorized");
        _;
    }

    modifier onlyDuringElection(uint256 _electionId) {
        require(elections[_electionId].isActive, "Election is not active");
        require(block.timestamp < elections[_electionId].endTime, "Election has ended");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function createElection(string memory _name, uint256 _durationInMinutes, uint256 _quorum) external onlyAdmin {
        uint256 electionEndTime = block.timestamp + (_durationInMinutes * 1 minutes);
        elections[nextElectionId] = Election(nextElectionId, _name, electionEndTime, 0, 0, true, _quorum);
        emit ElectionCreated(nextElectionId, _name, electionEndTime, _quorum);
        nextElectionId++;
    }

    function registerCandidate(uint256 _electionId, string memory _name) external onlyAdmin onlyDuringElection(_electionId) {
        uint256 candidateId = elections[_electionId].candidateCount;
        elections[_electionId].candidates[candidateId] = Candidate(_name, msg.sender);
        elections[_electionId].candidateCount++;
        emit CandidateRegistered(_electionId, candidateId, _name);
    }

    function vote(uint256 _electionId, uint256 _candidateId) external onlyDuringElection(_electionId) {
        require(!hasVoted[msg.sender], "You have already voted");
        require(_candidateId < elections[_electionId].candidateCount, "Invalid candidate");

        hasVoted[msg.sender] = true;
        elections[_electionId].votes[_candidateId]++;
        emit VoteCast(_electionId, msg.sender, _candidateId);
    }

    function revokeVote(uint256 _electionId) external onlyDuringElection(_electionId) {
        require(hasVoted[msg.sender], "You haven't voted yet");
        hasVoted[msg.sender] = false;
    }

    function getVotes(uint256 _electionId, uint256 _candidateId) external view returns (uint256) {
        require(_candidateId < elections[_electionId].candidateCount, "Invalid candidate");
        return elections[_electionId].votes[_candidateId];
    }

    function endElection(uint256 _electionId) external onlyAdmin onlyDuringElection(_electionId) {
        elections[_electionId].isActive = false;

        uint256 totalVotes = 0;
        for (uint256 i = 0; i < elections[_electionId].candidateCount; i++) {
            totalVotes += elections[_electionId].votes[i];
        }

        if (totalVotes >= elections[_electionId].quorum) {
            emit ElectionEnded(_electionId, elections[_electionId].name, totalVotes);
        }
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VoteChain {
    address public admin;
    uint256 public nextElectionId;
    mapping(uint256 => Election) public elections;
    mapping(address => bool) public hasVoted;
    mapping(address => uint256) public voterRewards;

    struct Election {
        uint256 id;
        string name;
        uint256 endTime;
        mapping(uint256 => uint256) votes;
        mapping(uint256 => Candidate) candidates;
        uint256 candidateCount;
        bool isActive;
        uint256 quorum;
        uint256 rewardPerVote;
        uint256 bonusEndTime;
        uint256 bonusMultiplier;
    }

    struct Candidate {
        string name;
        address candidateAddress;
    }

    event VoteCast(uint256 indexed electionId, address indexed voter, uint256 candidateId);
    event ElectionCreated(uint256 indexed electionId, string name, uint256 endTime, uint256 quorum, uint256 rewardPerVote, uint256 bonusEndTime, uint256 bonusMultiplier);
    event CandidateRegistered(uint256 indexed electionId, uint256 candidateId, string name);
    event ElectionEnded(uint256 indexed electionId, string name, uint256 quorumMet, uint256 totalVotes);
    event RewardClaimed(address indexed voter, uint256 amount);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not authorized");
        _;
    }

    modifier onlyDuringElection(uint256 _electionId) {
        require(elections[_electionId].isActive, "Election is not active");
        require(block.timestamp < elections[_electionId].endTime, "Election has ended");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function createElection(
        string memory _name,
        uint256 _durationInMinutes,
        uint256 _quorum,
        uint256 _rewardPerVote,
        uint256 _bonusEndTime,
        uint256 _bonusMultiplier
    ) external onlyAdmin {
        uint256 electionEndTime = block.timestamp + (_durationInMinutes * 1 minutes);
        elections[nextElectionId] = Election(
            nextElectionId,
            _name,
            electionEndTime,
            0,
            0,
            true,
            _quorum,
            _rewardPerVote,
            _bonusEndTime,
            _bonusMultiplier
        );
        emit ElectionCreated(nextElectionId, _name, electionEndTime, _quorum, _rewardPerVote, _bonusEndTime, _bonusMultiplier);
        nextElectionId++;
    }

    function registerCandidate(uint256 _electionId, string memory _name) external onlyAdmin onlyDuringElection(_electionId) {
        uint256 candidateId = elections[_electionId].candidateCount;
        elections[_electionId].candidates[candidateId] = Candidate(_name, msg.sender);
        elections[_electionId].candidateCount++;
        emit CandidateRegistered(_electionId, candidateId, _name);
    }

    function vote(uint256 _electionId, uint256 _candidateId) external onlyDuringElection(_electionId) {
        require(!hasVoted[msg.sender], "You have already voted");
        require(_candidateId < elections[_electionId].candidateCount, "Invalid candidate");

        hasVoted[msg.sender] = true;
        elections[_electionId].votes[_candidateId]++;

        // Apply bonus if within the bonus period
        if (block.timestamp <= elections[_electionId].bonusEndTime) {
            elections[_electionId].votes[_candidateId] *= elections[_electionId].bonusMultiplier;
        }

        // Calculate and award reward
        uint256 reward = elections[_electionId].rewardPerVote;
        voterRewards[msg.sender] += reward;

        emit VoteCast(_electionId, msg.sender, _candidateId);
    }

    function revokeVote(uint256 _electionId) external onlyDuringElection(_electionId) {
        require(hasVoted[msg.sender], "You haven't voted yet");
        hasVoted[msg.sender] = false;
    }

    function getVotes(uint256 _electionId, uint256 _candidateId) external view returns (uint256) {
        require(_candidateId < elections[_electionId].candidateCount, "Invalid candidate");
        return elections[_electionId].votes[_candidateId];
    }

    function endElection(uint256 _electionId) external onlyAdmin onlyDuringElection(_electionId) {
        elections[_electionId].isActive = false;

        uint256 totalVotes = 0;
        for (uint256 i = 0; i < elections[_electionId].candidateCount; i++) {
            totalVotes += elections[_electionId].votes[i];
        }

        if (totalVotes >= elections[_electionId].quorum) {
            emit ElectionEnded(_electionId, elections[_electionId].name, totalVotes, elections[_electionId].quorum);
        }
    }

    function claimReward() external {
        require(hasVoted[msg.sender], "You haven't voted yet");
        require(voterRewards[msg.sender] > 0, "No rewards to claim");

        uint256 rewardAmount = voterRewards[msg.sender];
        voterRewards[msg.sender] = 0;

        // Transfer reward to the voter
        payable(msg.sender).transfer(rewardAmount);

        emit RewardClaimed(msg.sender, rewardAmount);
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VoteChain {
    address public admin;
    uint256 public nextElectionId;
    mapping(uint256 => Election) public elections;
    mapping(address => bool) public hasVoted;
    mapping(address => uint256) public voterReputation;
    mapping(address => uint256) public candidateFunds;
    mapping(address => uint256) public voterRewards;
    uint256 public rewardsPool;

    struct Election {
        uint256 id;
        string name;
        uint256 endTime;
        mapping(uint256 => uint256) votes;
        mapping(uint256 => Candidate) candidates;
        uint256 candidateCount;
        bool isActive;
        uint256 quorum;
        uint256 rewardPerVote;
        uint256 bonusEndTime;
        uint256 bonusMultiplier;
    }

    struct Candidate {
        string name;
        address candidateAddress;
        bool isRegistered;
    }

    event VoteCast(uint256 indexed electionId, address indexed voter, uint256 candidateId);
    event ElectionCreated(uint256 indexed electionId, string name, uint256 endTime, uint256 quorum, uint256 rewardPerVote, uint256 bonusEndTime, uint256 bonusMultiplier);
    event CandidateRegistered(uint256 indexed electionId, uint256 candidateId, string name);
    event ElectionEnded(uint256 indexed electionId, string name, uint256 quorumMet, uint256 totalVotes);
    event RewardClaimed(address indexed voter, uint256 amount);
    event CandidateWithdrawal(address indexed candidate, uint256 amount);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not authorized");
        _;
    }

    modifier onlyDuringElection(uint256 _electionId) {
        require(elections[_electionId].isActive, "Election is not active");
        require(block.timestamp < elections[_electionId].endTime, "Election has ended");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function createElection(
        string memory _name,
        uint256 _durationInMinutes,
        uint256 _quorum,
        uint256 _rewardPerVote,
        uint256 _bonusEndTime,
        uint256 _bonusMultiplier
    ) external onlyAdmin {
        uint256 electionEndTime = block.timestamp + (_durationInMinutes * 1 minutes);
        elections[nextElectionId] = Election(
            nextElectionId,
            _name,
            electionEndTime,
            0,
            0,
            true,
            _quorum,
            _rewardPerVote,
            _bonusEndTime,
            _bonusMultiplier
        );
        emit ElectionCreated(nextElectionId, _name, electionEndTime, _quorum, _rewardPerVote, _bonusEndTime, _bonusMultiplier);
        nextElectionId++;
    }

    function registerCandidate(uint256 _electionId, string memory _name) external onlyAdmin onlyDuringElection(_electionId) {
        require(!elections[_electionId].candidates[msg.sender].isRegistered, "You are already registered as a candidate");
        uint256 candidateId = elections[_electionId].candidateCount;
        elections[_electionId].candidates[msg.sender] = Candidate(_name, msg.sender, true);
        elections[_electionId].candidateCount++;
        emit CandidateRegistered(_electionId, candidateId, _name);
    }

    function vote(uint256 _electionId, uint256 _candidateId) external onlyDuringElection(_electionId) {
        require(!hasVoted[msg.sender], "You have already voted");
        require(_candidateId < elections[_electionId].candidateCount, "Invalid candidate");

        hasVoted[msg.sender] = true;
        elections[_electionId].votes[_candidateId]++;

        // Update voter's reputation
        voterReputation[msg.sender]++;

        // Apply bonus if within the bonus period
        if (block.timestamp <= elections[_electionId].bonusEndTime) {
            elections[_electionId].votes[_candidateId] *= elections[_electionId].bonusMultiplier;
        }

        // Calculate and award reward
        uint256 reward = elections[_electionId].rewardPerVote;
        voterRewards[msg.sender] += reward;

        emit VoteCast(_electionId, msg.sender, _candidateId);
    }

    function revokeVote(uint256 _electionId) external onlyDuringElection(_electionId) {
        require(hasVoted[msg.sender], "You haven't voted yet");
        hasVoted[msg.sender] = false;
    }

    function getVotes(uint256 _electionId, uint256 _candidateId) external view returns (uint256) {
        require(_candidateId < elections[_electionId].candidateCount, "Invalid candidate");
        return elections[_electionId].votes[_candidateId];
    }

    function endElection(uint256 _electionId) external onlyAdmin onlyDuringElection(_electionId) {
        elections[_electionId].isActive = false;

        uint256 totalVotes = 0;
        for (uint256 i = 0; i < elections[_electionId].candidateCount; i++) {
            totalVotes += elections[_electionId].votes[i];
        }

        if (totalVotes
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VoteChain {
    address public admin;
    uint256 public nextElectionId;
    mapping(uint256 => Election) public elections;
    mapping(address => bool) public hasVoted;
    mapping(address => uint256) public voterReputation;
    mapping(address => uint256) public candidateFunds;
    mapping(address => uint256) public voterRewards;
    uint256 public rewardsPool;

    struct Election {
        uint256 id;
        string name;
        uint256 endTime;
        mapping(uint256 => uint256) votes;
        mapping(uint256 => Candidate) candidates;
        uint256 candidateCount;
        bool isActive;
        uint256 quorum;
        uint256 rewardPerVote;
        uint256 bonusEndTime;
        uint256 bonusMultiplier;
    }

    struct Candidate {
        string name;
        address candidateAddress;
        bool isRegistered;
        string promise; // Candidate's promise to voters
        uint256 donationReceived;
    }

    event VoteCast(uint256 indexed electionId, address indexed voter, uint256 candidateId);
    event ElectionCreated(uint256 indexed electionId, string name, uint256 endTime, uint256 quorum, uint256 rewardPerVote, uint256 bonusEndTime, uint256 bonusMultiplier);
    event CandidateRegistered(uint256 indexed electionId, uint256 candidateId, string name, string promise);
    event ElectionEnded(uint256 indexed electionId, string name, uint256 quorumMet, uint256 totalVotes);
    event RewardClaimed(address indexed voter, uint256 amount);
    event CandidateWithdrawal(address indexed candidate, uint256 amount);
    event VoterDonation(address indexed donor, address indexed candidate, uint256 amount);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not authorized");
        _;
    }

    modifier onlyDuringElection(uint256 _electionId) {
        require(elections[_electionId].isActive, "Election is not active");
        require(block.timestamp < elections[_electionId].endTime, "Election has ended");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function createElection(
        string memory _name,
        uint256 _durationInMinutes,
        uint256 _quorum,
        uint256 _rewardPerVote,
        uint256 _bonusEndTime,
        uint256 _bonusMultiplier
    ) external onlyAdmin {
        uint256 electionEndTime = block.timestamp + (_durationInMinutes * 1 minutes);
        elections[nextElectionId] = Election(
            nextElectionId,
            _name,
            electionEndTime,
            0,
            0,
            true,
            _quorum,
            _rewardPerVote,
            _bonusEndTime,
            _bonusMultiplier
        );
        emit ElectionCreated(nextElectionId, _name, electionEndTime, _quorum, _rewardPerVote, _bonusEndTime, _bonusMultiplier);
        nextElectionId++;
    }

    function registerCandidate(uint256 _electionId, string memory _name, string memory _promise) external onlyDuringElection(_electionId) {
        require(!elections[_electionId].candidates[msg.sender].isRegistered, "You are already registered as a candidate");
        uint256 candidateId = elections[_electionId].candidateCount;
        elections[_electionId].candidates[msg.sender] = Candidate(_name, msg.sender, true, _promise, 0);
        elections[_electionId].candidateCount++;
        emit CandidateRegistered(_electionId, candidateId, _name, _promise);
    }

    function vote(uint256 _electionId, uint256 _candidateId) external onlyDuringElection(_electionId) {
        require(!hasVoted[msg.sender], "You have already voted");
        require(_candidateId < elections[_electionId].candidateCount, "Invalid candidate");

        hasVoted[msg.sender] = true;
        elections[_electionId].votes[_candidateId]++;

        // Update voter's reputation
        voterReputation[msg.sender]++;

        // Apply bonus if within the bonus period
        if (block.timestamp <= elections[_electionId].bonusEndTime) {
            elections[_electionId].votes[_candidateId] *= elections[_electionId].bonusMultiplier;
        }

        // Calculate and award reward
        uint256 reward = elections[_electionId].rewardPerVote;
        voterRewards[msg.sender] += reward;

        emit VoteCast(_electionId, msg.sender, _candidateId);
    }

    function revokeVote(uint256 _electionId) external onlyDuringElection(_electionId) {
        require(hasVoted[msg.sender], "You haven't voted yet");
        hasVoted[msg.sender] = false;
    }

    function donateToCandidate(uint256 _electionId, uint256 _candidateId) external payable onlyDuringElection(_electionId) {
        require(_candidateId < elections[_electionId].candidateCount, "Invalid candidate");
        address candidateAddress = elections[_electionId].candidates[_candidateId].candidateAddress;

        // Update candidate's funds
        candidateFunds[candidateAddress] += msg.value;

        // Update candidate's donationReceived
        elections[_electionId].candidates[_candidateId].donationReceived += msg.value;

        emit VoterDonation(msg.sender, candidateAddress, msg.value);
    }

    function getVotes(uint256 _electionId, uint256 _candidateId) external view returns (uint256) {
        require(_candidateId < elections[_electionId].candidateCount, "Invalid candidate");
        return elections[_electionId].votes[_candidateId];
    }

    function endElection(uint256 _electionId) external onlyAdmin onlyDuringElection(_electionId) {
        elections[_electionId].isActive = false;

        uint256 totalVotes = 0;
        for (uint256 i = 0; i < elections[_electionId].candidateCount; i++) {
            totalVotes += elections[_electionId].votes[i];
        }

        if (totalVotes >= elections[_electionId].quorum) {
            emit ElectionEnded(_electionId, elections[_electionId].name, totalVotes, elections[_electionId].quorum);
        }
    }

    function claimReward() external {
        require(hasVoted[msg.sender], "You haven't voted yet");
        require(voterRewards[msg.sender] > 0, "No rewards to claim");

        uint256 rewardAmount = voterRewards[msg.sender];
        voterRewards[msg.sender] = 0;

        // Transfer reward to the voter
        payable(msg.sender).transfer(rewardAmount);

        emit RewardClaimed(msg.sender, rewardAmount);
    }

    function withdrawCandidateFunds() external {
        require(elections[nextElectionId - 1].isActive == false, "Election is still active");
        require(elections[nextElectionId - 1].candidates[msg.sender].isRegistered, "You are not a registered candidate");
        require(candidateFunds[msg.sender] > 0, "No funds to withdraw");

        uint256 withdrawalAmount = candidateFunds[msg.sender];
        candidateFunds[msg.sender] = 0;

        // Transfer funds to the candidate
        payable(msg.sender).transfer(withdrawalAmount
Certainly! Let's continue enhancing the Solidity code for the VoteChain project. In this iteration, we'll add a feature for candidates to propose additional functionalities and a voting mechanism for these proposals.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VoteChain {
    address public admin;
    uint256 public nextElectionId;
    mapping(uint256 => Election) public elections;
    mapping(address => bool) public hasVoted;
    mapping(address => uint256) public voterReputation;
    mapping(address => uint256) public candidateFunds;
    mapping(address => uint256) public voterRewards;
    uint256 public rewardsPool;

    struct Election {
        uint256 id;
        string name;
        uint256 endTime;
        mapping(uint256 => uint256) votes;
        mapping(uint256 => Candidate) candidates;
        mapping(uint256 => Proposal) proposals;
        uint256 candidateCount;
        uint256 proposalCount;
        bool isActive;
        uint256 quorum;
        uint256 rewardPerVote;
        uint256 bonusEndTime;
        uint256 bonusMultiplier;
    }

    struct Candidate {
        string name;
        address candidateAddress;
        bool isRegistered;
        string promise; // Candidate's promise to voters
        uint256 donationReceived;
    }

    struct Proposal {
        string description;
        address proposer;
        uint256 votesFor;
        uint256 votesAgainst;
        bool isOpen;
    }

    event VoteCast(uint256 indexed electionId, address indexed voter, uint256 candidateId);
    event ElectionCreated(uint256 indexed electionId, string name, uint256 endTime, uint256 quorum, uint256 rewardPerVote, uint256 bonusEndTime, uint256 bonusMultiplier);
    event CandidateRegistered(uint256 indexed electionId, uint256 candidateId, string name, string promise);
    event ElectionEnded(uint256 indexed electionId, string name, uint256 quorumMet, uint256 totalVotes);
    event RewardClaimed(address indexed voter, uint256 amount);
    event CandidateWithdrawal(address indexed candidate, uint256 amount);
    event VoterDonation(address indexed donor, address indexed candidate, uint256 amount);
    event ProposalCreated(uint256 indexed electionId, uint256 proposalId, string description, address proposer);
    event VoteForProposal(uint256 indexed electionId, uint256 proposalId, address indexed voter);
    event VoteAgainstProposal(uint256 indexed electionId, uint256 proposalId, address indexed voter);
    event ProposalClosed(uint256 indexed electionId, uint256 proposalId, bool passed);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not authorized");
        _;
    }

    modifier onlyDuringElection(uint256 _electionId) {
        require(elections[_electionId].isActive, "Election is not active");
        require(block.timestamp < elections[_electionId].endTime, "Election has ended");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function createElection(
        string memory _name,
        uint256 _durationInMinutes,
        uint256 _quorum,
        uint256 _rewardPerVote,
        uint256 _bonusEndTime,
        uint256 _bonusMultiplier
    ) external onlyAdmin {
        uint256 electionEndTime = block.timestamp + (_durationInMinutes * 1 minutes);
        elections[nextElectionId] = Election(
            nextElectionId,
            _name,
            electionEndTime,
            0,
            0,
            true,
            _quorum,
            _rewardPerVote,
            _bonusEndTime,
            _bonusMultiplier
        );
        emit ElectionCreated(nextElectionId, _name, electionEndTime, _quorum, _rewardPerVote, _bonusEndTime, _bonusMultiplier);
        nextElectionId++;
    }

    function registerCandidate(uint256 _electionId, string memory _name, string memory _promise) external onlyDuringElection(_electionId) {
        require(!elections[_electionId].candidates[msg.sender].isRegistered, "You are already registered as a candidate");
        uint256 candidateId = elections[_electionId].candidateCount;
        elections[_electionId].candidates[msg.sender] = Candidate(_name, msg.sender, true, _promise, 0);
        elections[_electionId].candidateCount++;
        emit CandidateRegistered(_electionId, candidateId, _name, _promise);
    }

    function vote(uint256 _electionId, uint256 _candidateId) external onlyDuringElection(_electionId) {
        require(!hasVoted[msg.sender], "You have already voted");
        require(_candidateId < elections[_electionId].candidateCount, "Invalid candidate");

        hasVoted[msg.sender] = true;
        elections[_electionId].votes[_candidateId]++;

        // Update voter's reputation
        voterReputation[msg.sender]++;

        // Apply bonus if within the bonus period
        if (block.timestamp <= elections[_electionId].bonusEndTime) {
            elections[_electionId].votes[_candidateId] *= elections[_electionId].bonusMultiplier;
        }

        // Calculate and award reward
        uint256 reward = elections[_electionId].rewardPerVote;
        voterRewards[msg.sender] += reward;

        emit VoteCast(_electionId, msg.sender, _candidateId);
    }

    function revokeVote(uint256 _electionId) external onlyDuringElection(_electionId) {
        require(hasVoted[msg.sender], "You haven't voted yet");
        hasVoted[msg.sender] = false;
    }

    function donateToCandidate(uint256 _electionId, uint256 _candidateId) external payable onlyDuringElection(_electionId) {
        require(_candidateId < elections[_electionId].candidateCount, "Invalid candidate");
        address candidateAddress = elections[_electionId].candidates[_candidateId].candidateAddress;

        // Update candidate's funds
        candidateFunds[candidateAddress] += msg.value;

        // Update candidate's donationReceived
        elections[_electionId].candidates[_candidateId].donationReceived += msg.value;

        emit VoterDonation(msg.sender, candidateAddress, msg.value);
    }

    function proposeFunctionality(uint256 _electionId, string memory _description) external onlyDuringElection(_electionId) {
        require(elections[_electionId].candidates[msg.sender].isRegistered, "You must be a registered candidate");
       
