// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @notice Newly authored portfolio illustration of role- and state-gated
/// escrow decisions. It moves no funds and is not deployed or production-ready.
contract IllustrativeEscrowLifecycle {
    enum State { Created, Funded, Completed, Disputed, Cancelled, Released }

    struct CaseRecord {
        address payer;
        address payee;
        address arbiter;
        State state;
        bytes32 agreementCommitment;
    }

    uint256 public nextCaseId;
    mapping(uint256 => CaseRecord) public cases;

    event StateChanged(uint256 indexed caseId, State nextState, address indexed actor);

    function create(address payee, address arbiter, bytes32 agreementCommitment) external returns (uint256 caseId) {
        require(payee != address(0) && arbiter != address(0), "missing participant");
        require(agreementCommitment != bytes32(0), "missing agreement");
        caseId = nextCaseId++;
        cases[caseId] = CaseRecord({
            payer: msg.sender,
            payee: payee,
            arbiter: arbiter,
            state: State.Created,
            agreementCommitment: agreementCommitment
        });
        emit StateChanged(caseId, State.Created, msg.sender);
    }

    function markFunded(uint256 caseId) external {
        CaseRecord storage item = cases[caseId];
        require(msg.sender == item.payer && item.state == State.Created, "funding not allowed");
        item.state = State.Funded;
        emit StateChanged(caseId, State.Funded, msg.sender);
    }

    function raiseDispute(uint256 caseId) external {
        CaseRecord storage item = cases[caseId];
        require(msg.sender == item.payer || msg.sender == item.payee, "party only");
        require(item.state == State.Funded || item.state == State.Completed, "dispute unavailable");
        item.state = State.Disputed;
        emit StateChanged(caseId, State.Disputed, msg.sender);
    }

    function resolve(uint256 caseId, bool refundPayer) external {
        CaseRecord storage item = cases[caseId];
        require(msg.sender == item.arbiter && item.state == State.Disputed, "resolution not allowed");
        item.state = refundPayer ? State.Cancelled : State.Released;
        emit StateChanged(caseId, item.state, msg.sender);
    }
}
