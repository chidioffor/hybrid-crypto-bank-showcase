// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @notice External verification boundary. The public sample intentionally omits
/// proving-system details, verification keys, and any value settlement logic.
interface IEntitlementVerifier {
    function verify(
        bytes32 batchRoot,
        bytes32 policyCommitment,
        bytes32 nullifier,
        address recipient,
        bytes calldata proof
    ) external view returns (bool);
}

/// @notice Newly authored portfolio illustration. It records a batch commitment
/// and makes a verified nullifier single-use; it is not production-ready code.
contract IllustrativeAllocationRegistry {
    enum BatchState { Open, Frozen, Closed }

    struct Batch {
        bytes32 root;
        bytes32 policyCommitment;
        BatchState state;
    }

    address public immutable OPERATOR;
    IEntitlementVerifier public immutable VERIFIER;
    uint256 private guard = 1;

    mapping(uint256 => Batch) public batches;
    mapping(bytes32 => bool) public nullifierUsed;

    event BatchOpened(uint256 indexed batchId, bytes32 indexed root, bytes32 indexed policyCommitment);
    event EntitlementConsumed(uint256 indexed batchId, bytes32 indexed nullifier, address indexed recipient);

    modifier onlyOperator() {
        require(msg.sender == OPERATOR, "operator only");
        _;
    }

    modifier nonReentrant() {
        require(guard == 1, "reentrant call");
        guard = 2;
        _;
        guard = 1;
    }

    constructor(address operator_, IEntitlementVerifier verifier_) {
        require(operator_ != address(0) && address(verifier_) != address(0), "invalid dependency");
        OPERATOR = operator_;
        VERIFIER = verifier_;
    }

    function openBatch(uint256 batchId, bytes32 root, bytes32 policyCommitment) external onlyOperator {
        require(root != bytes32(0) && policyCommitment != bytes32(0), "empty commitment");
        require(batches[batchId].root == bytes32(0), "batch exists");
        batches[batchId] = Batch({
            root: root,
            policyCommitment: policyCommitment,
            state: BatchState.Open
        });
        emit BatchOpened(batchId, root, policyCommitment);
    }

    function consumeEntitlement(uint256 batchId, bytes32 nullifier, bytes calldata proof) external nonReentrant {
        Batch memory batch = batches[batchId];
        require(batch.root != bytes32(0), "unknown batch");
        require(batch.state == BatchState.Open, "batch unavailable");
        require(nullifier != bytes32(0) && !nullifierUsed[nullifier], "entitlement already consumed");
        require(
            VERIFIER.verify(batch.root, batch.policyCommitment, nullifier, msg.sender, proof),
            "invalid entitlement proof"
        );

        // Mark before any future settlement adapter call: the entitlement is single-use.
        nullifierUsed[nullifier] = true;
        emit EntitlementConsumed(batchId, nullifier, msg.sender);
    }
}
