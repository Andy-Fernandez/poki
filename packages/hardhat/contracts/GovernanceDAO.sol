// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GovernanceDAO {
    address public owner;
    uint public proposalCount = 0;
    mapping(uint => Proposal) public proposals;
    mapping(address => mapping(uint => bool)) private votes;

    struct Proposal {
        uint id;
        string description;
        uint voteCount;
        bool executed;
    }

    event ProposalCreated(uint id, string description);
    event Voted(uint proposalId, address voter);
    event ProposalExecuted(uint id);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createProposal(string memory description) public onlyOwner {
        proposals[proposalCount] = Proposal({
            id: proposalCount,
            description: description,
            voteCount: 0,
            executed: false
        });

        emit ProposalCreated(proposalCount, description);
        proposalCount++;
    }

    function vote(uint proposalId) public {
        Proposal storage proposal = proposals[proposalId];
        require(proposal.id == proposalId, "Proposal does not exist");
        require(!votes[msg.sender][proposalId], "Already voted for this proposal");

        votes[msg.sender][proposalId] = true;
        proposal.voteCount++;

        emit Voted(proposalId, msg.sender);
    }

    function executeProposal(uint proposalId) public onlyOwner {
        Proposal storage proposal = proposals[proposalId];
        require(proposal.id == proposalId, "Proposal does not exist");
        require(!proposal.executed, "Proposal already executed");
        require(proposal.voteCount > 0, "Not enough votes");

        proposal.executed = true;

        // Logic to execute the proposal...
        emit ProposalExecuted(proposalId);
    }
}
