// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import "./HazelHeartsToken.sol";

contract HazelHearts {
    uint public constant MAX_FARMS = 10000;
    uint public constant MAX_FREE_MINTS = 200;

    address public owner;
    uint public numMinted;
    HazelHeartsToken public hazelHeartsToken;

    constructor(address _hazelHeartsTokenAddress) {
        owner = msg.sender;
        hazelHeartsToken = HazelHeartsToken(_hazelHeartsTokenAddress);
    }

    function mint(address to) external {
        require(numMinted < MAX_FARMS, "All farms have been minted");
        if (numMinted < MAX_FREE_MINTS) {
            hazelHeartsToken.mint(to, 5);
        } else if (numMinted < MAX_FREE_MINTS + 200) {
            require(msg.value == 300000000000000000, "Payment amount is incorrect");
            hazelHeartsToken.mint(to, 10);
        } else if (numMinted < MAX_FREE_MINTS + 400) {
            require(msg.value == 500000000000000000, "Payment amount is incorrect");
            hazelHeartsToken.mint(to, 15);
        } else if (numMinted < MAX_FREE_MINTS + 600) {
            require(msg.value == 1000000000000000000, "Payment amount is incorrect");
            hazelHeartsToken.mint(to, 25);
        } else {
            require(msg.value == 2000000000000000000, "Payment amount is incorrect");
            hazelHeartsToken.mint(to, 50);
        }
        numMinted++;
    }

    function getTokens() external {
        hazelHeartsToken.transfer(msg.sender, 10);
    }

    function withdraw() external {
        require(msg.sender == owner, "Only the owner can withdraw");
        payable(owner).transfer(address(this).balance);
    }

    receive() external payable {}
}
