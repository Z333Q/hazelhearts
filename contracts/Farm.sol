// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./HazelHeartsToken.sol";

contract Farm is Ownable {
uint public constant MAX_FARMS = 10000;
uint public constant MAX_TREES = 10;HazelHeartsToken public hazelHeartsToken;

struct FarmData {
    address owner;
    uint numHarvests;
    uint[] treeIds;
    uint8[] treeHarvestsLeft;
}

mapping(uint => FarmData) public farms;

constructor(address _hazelHeartsTokenAddress) {
    hazelHeartsToken = HazelHeartsToken(_hazelHeartsTokenAddress);
}

function buyFarm() external {
    require(totalSupply() < MAX_FARMS, "All farms have been sold");
    require(hazelHeartsToken.balanceOf(msg.sender) >= 5, "You don't have enough HazelHearts tokens");
    uint tokenId = totalSupply() + 1;
    _mint(msg.sender, tokenId);
    farms[tokenId] = FarmData({
        owner: msg.sender,
        numHarvests: 0,
        treeIds: new uint[](MAX_TREES),
        treeHarvestsLeft: new uint8[](MAX_TREES)
    });
    for (uint i = 0; i < MAX_TREES; i++) {
        farms[tokenId].treeIds[i] = tokenId * MAX_TREES + i + 1;
        farms[tokenId].treeHarvestsLeft[i] = 2;
        hazelHeartsToken.mint(address(this), 1);
        hazelHeartsToken.approve(address(this), tokenId * MAX_TREES + i + 1, 1);
    }
    hazelHeartsToken.transferFrom(msg.sender, address(this), 5);
}

function harvestTrees(uint tokenId) external {
    require(ownerOf(tokenId) == msg.sender, "You don't own this farm");
    FarmData storage farmData = farms[tokenId];
    require(farmData.numHarvests < 1 + farmData.treeIds.length, "You've harvested all your trees this month");
    uint numTokens = 0;
    for (uint i = 0; i < MAX_TREES; i++) {
        if (farmData.treeHarvestsLeft[i] > 0) {
            farmData.treeHarvestsLeft[i]--;
            numTokens++;
            if (farmData.treeHarvestsLeft[i] == 0) {
                hazelHeartsToken.transferFrom(address(this), msg.sender, farmData.treeIds[i]);
            }
        }
    }
    hazelHeartsToken.transferFrom(address(this), msg.sender, numTokens);
    farmData.numHarvests++;
}

function addProcessingEquipment(uint tokenId) external {
    require(ownerOf(tokenId) == msg.sender, "You don't own this farm");
    require(hazelHeartsToken.balanceOf(msg.sender) >= 5, "You don't have enough HazelHearts tokens");
hazelHeartsToken.transferFrom(msg.sender, address(this), 5);
for (uint i = 0; i < MAX_TREES; i++) {
hazelHeartsToken.approve(address(this), farms[tokenId].treeIds[i], 2);
}
}
function removeProcessingEquipment(uint tokenId) external {
    require(ownerOf(tokenId) == msg.sender, "You don't own this farm");
    for (uint i = 0; i < MAX_TREES; i++) {
        hazelHeartsToken.approve(address(this), farms[tokenId].treeIds[i], 0);
    }
}

function buyFarmUpgrade(uint tokenId) external {
    require(ownerOf(tokenId) == msg.sender, "You don't own this farm");
    require(hazelHeartsToken.balanceOf(msg.sender) >= 10, "You don't have enough HazelHearts tokens");
    uint numTrees = farms[tokenId].treeIds.length;
    farms[tokenId].treeIds.length = numTrees + MAX_TREES;
    farms[tokenId].treeHarvestsLeft.length = numTrees + MAX_TREES;
    for (uint i = numTrees; i < numTrees + MAX_TREES; i++) {
        farms[tokenId].treeIds[i] = tokenId * MAX_TREES + i + 1;
        farms[tokenId].treeHarvestsLeft[i] = 2;
        hazelHeartsToken.mint(address(this), 1);
        hazelHeartsToken.approve(address(this), tokenId * MAX_TREES + i + 1, 1);
    }
    hazelHeartsToken.transferFrom(msg.sender, address(this), 10);
}
}
