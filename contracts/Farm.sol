// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Farm is ERC721, Ownable {
    struct FarmDetails {
        uint256 hazelHeartsYield;
        bool harvestReady;
        uint256 lastHarvestTime;
        uint256 processingStartTime;
        uint256 processingEndTime;
        uint256 processingBoost;
    }

    FarmDetails[] private farms;

    constructor() ERC721("HazelHearts Farm", "HHF") {}

    function createFarm(address to) external onlyOwner returns (uint256) {
        FarmDetails memory details = FarmDetails({
            hazelHeartsYield: 0,
            harvestReady: false,
            lastHarvestTime: block.timestamp,
            processingStartTime: 0,
            processingEndTime: 0,
            processingBoost: 0
        });
        farms.push(details);
        uint256 tokenId = farms.length - 1;
        _mint(to, tokenId);
        return tokenId;
    }

    function getFarmDetails(uint256 tokenId) public view returns (FarmDetails memory) {
        return farms[tokenId];
    }

    function setHazelHeartsYield(uint256 tokenId, uint256 yield) external onlyOwner {
        farms[tokenId].hazelHeartsYield = yield;
    }

    function setHarvestReady(uint256 tokenId, bool ready) external onlyOwner {
        farms[tokenId].harvestReady = ready;
    }

    function setLastHarvestTime(uint256 tokenId, uint256 time) external onlyOwner {
        farms[tokenId].lastHarvestTime = time;
    }

    function setProcessingStartTime(uint256 tokenId, uint256 time) external onlyOwner {
        farms[tokenId].processingStartTime = time;
    }

    function setProcessingEndTime(uint256 tokenId, uint256 time) external onlyOwner {
        farms[tokenId].processingEndTime = time;
    }

    function setProcessingBoost(uint256 tokenId, uint256 boost) external onlyOwner {
        farms[tokenId].processingBoost = boost;
    }

    function tendFarm(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "Not the owner of this farm");
        FarmDetails storage details = farms[tokenId];
        require(details.harvestReady == false, "Farm already ready for harvest");

        details.processingBoost = 0;
        details.lastHarvestTime = block.timestamp;
        details.harvestReady = true;
    }

    function harvestFarm(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "Not the owner of this farm");
        FarmDetails storage details = farms[tokenId];
        require(details.harvestReady == true, "Farm not ready for harvest");

        uint256 timeSinceLastHarvest = block.timestamp - details.lastHarvestTime;
        uint256 hazelHeartsYield = details.hazelHeartsYield + details.processingBoost;
        uint256 newHazelHeartsYield = hazelHeartsYield * timeSinceLastHarvest / 1 days;

        details.hazelHeartsYield = newHazelHeartsYield;
        details.harvestReady = false;
    }

    function processFarm(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "Not the owner of this farm");
        FarmDetails storage details = farms[tokenId];
        require(details.harvestReady == true, "Farm not ready for harvest");
        require(details.processingStartTime == 0, "Farm already being processed");

        details.processingStartTime = block.timestamp;
details.processingEndTime = block.timestamp + 1 days;
}function boostProcessing(uint256 tokenId, uint256 boost) external {
    require(ownerOf(tokenId) == msg.sender, "Not the owner of this farm");
    FarmDetails storage details = farms[tokenId];
    require(details.harvestReady == true, "Farm not ready for harvest");
    require(details.processingStartTime != 0, "Farm not being processed");

    details.processingBoost = boost;
}

