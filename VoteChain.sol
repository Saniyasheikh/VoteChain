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
