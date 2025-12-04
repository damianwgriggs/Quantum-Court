// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title SimpleQuantumCourt
 * @dev A judicial system that relies on external quantum entropy to break ties.
 */
contract SimpleQuantumCourt {

    // --- EVENTS ---
    // These are the "Signals" the Python script is listening for.
    // They MUST match the names in your Python script exactly.
    
    // 1. Emitted when the court is stuck. Python listens for this.
    event QuantumOracleSummoned(string reason);

    // 2. Emitted when the Oracle answers. Python reads this for the receipt.
    event VerdictDelivered(uint256 quantumValue, string result);

    // --- STATE ---
    string public currentCaseStatus = "Court in Session";
    uint256 public lastQuantumValue;

    // --- FUNCTIONS ---

    /**
     * Step 1: Human triggers this from Remix.
     * This simulates a hung jury (50/50 vote) and calls the Oracle.
     */
    function simulateDeadlock() public {
        currentCaseStatus = "Awaiting Quantum Oracle...";
        // This log is what wakes up your Python script:
        emit QuantumOracleSummoned("50/50 Split detected");
    }

    /**
     * Step 2: Python Oracle calls this function.
     * It inputs raw entropy, calculates the verdict, and logs the result.
     */
    function resolveDeadlock(uint256 quantumEntropy) public {
        string memory verdict;
        
        // Math logic: Modulo operator to determine outcome based on randomness
        // If the number is even: Innocent. If odd: Guilty.
        if (quantumEntropy % 2 == 0) {
            verdict = "Innocent";
        } else {
            verdict = "Guilty";
        }

        // Update state
        lastQuantumValue = quantumEntropy;
        currentCaseStatus = verdict;

        // Emit the final log so Python can print the "Receipt"
        emit VerdictDelivered(quantumEntropy, verdict);
    }
}
