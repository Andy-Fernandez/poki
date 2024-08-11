// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GovernanceDAO {
    address public owner;
    uint public proposalCount = 0;

    struct Proposal {
        uint id;
        string description;
        uint voteCount;
        bool executed;
        mapping(address => bool) votes;
    }

    mapping(uint => Proposal) public proposals;

    event ProposalCreated(uint id, string description);
    event Voted(uint proposalId, address voter);
    event ProposalExecuted(uint id);

    modifier onlyOwner() {
        require(msg.sender == owner, "Solo el propietario puede realizar esta accion");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createProposal(string memory description) public onlyOwner {
        Proposal storage proposal = proposals[proposalCount];
        proposal.id = proposalCount;
        proposal.description = description;
        proposal.executed = false;

        emit ProposalCreated(proposalCount, description);
        proposalCount++;
    }

    function vote(uint proposalId) public {
        Proposal storage proposal = proposals[proposalId];
        require(!proposal.votes[msg.sender], "Ya has votado en esta propuesta");

        proposal.votes[msg.sender] = true;
        proposal.voteCount++;

        emit Voted(proposalId, msg.sender);
    }

    function executeProposal(uint proposalId) public onlyOwner {
        Proposal storage proposal = proposals[proposalId];
        require(!proposal.executed, "La propuesta ya fue ejecutada");
        require(proposal.voteCount > 0, "La propuesta no tiene suficientes votos");

        proposal.executed = true;

        // Lógica para ejecutar la propuesta...
        emit ProposalExecuted(proposalId);
    }
}
