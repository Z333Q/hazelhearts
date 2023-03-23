// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./HazelHeartsToken.sol";

contract Farm {

    struct FarmDetails {
        bool exists;
        address owner;
        uint256 hazelheartsYield;
        uint256 lastHarvestTime;
        uint256 harvestReadyTime;
        uint256 processingStartTime;
        bool harvestReady;
    }

    HazelHeartsToken private _hazelHeartsToken;

    mapping(uint256 => FarmDetails) private _farmDetails;

    uint256 public constant HARVEST_COOLDOWN = 30 days;
    uint256 public constant PROCESSING_TIME = 1 days;
    uint256 public constant HAZELHEARTS_PER_TREE = 0.5 ether;
    uint256 public constant TREES_PER_FARM = 10;

    constructor(address hazelHeartsTokenAddress) {
        _hazelHeartsToken = HazelHeartsToken(hazelHeartsTokenAddress);
    }

    function _createFarm(uint256 tokenId) internal {
        _farmDetails[tokenId] = FarmDetails({
            exists: true,
            owner: msg.sender,
            hazelheartsYield: 0,
            lastHarvestTime: block.timestamp,
            harvestReadyTime: block.timestamp + HARVEST_COOLDOWN,
            processingStartTime: 0,
            harvestReady: false
        });
    }

    function getFarmDetails(uint256 tokenId) public view returns (
        bool exists,
        address owner,
        uint256 hazelheartsYield,
        uint256 lastHarvestTime,
        uint256 harvestReadyTime,
        uint256 processingStartTime,
        bool harvestReady
    ) {
        require(_farmDetails[tokenId].exists, "Farm does not exist");
        return (
            true,
            _farmDetails[tokenId].owner,
            _farmDetails[tokenId].hazelheartsYield,
            _farmDetails[tokenId].lastHarvestTime,
            _farmDetails[tokenId].harvestReadyTime,
            _farmDetails[tokenId].processingStartTime,
            _farmDetails[tokenId].harvestReady
        );
    }

    function createFarm(uint256 tokenId) public {
        require(!_farmDetails[tokenId].exists, "Farm already exists");
        _createFarm(tokenId);
        _hazelHeartsToken.mint(msg.sender, TREES_PER_FARM);
    }

    function tendFarm(uint256 tokenId) public {
        require(_farmDetails[tokenId].exists, "Farm does not exist");
        require(_farmDetails[tokenId].owner == msg.sender, "Not farm owner");
        require(block.timestamp >= _farmDetails[tokenId].harvestReadyTime, "Harvest not ready");
        _farmDetails[tokenId].lastHarvestTime = block.timestamp;
        _farmDetails[tokenId].harvestReadyTime = block.timestamp + HARVEST_COOLDOWN;
        _farmDetails[tokenId].processingStartTime = block.timestamp;
        _farmDetails[tokenId].harvestReady = false;
    }

    function harvestFarm(uint256 tokenId) public {
        require(_farmDetails[tokenId].exists, "Farm does not exist");
        require(_farmDetails[tokenId].owner == msg.sender, "Not farm owner");
        require(_farmDetails[tokenId].harvestReady, "Harvest not ready");
        uint256 hazelheartsYield = _farmDetails[tokenId].hazelheartsYield;
        _farmDetails[tokenId].hazelheartsYield = 0;
        _farmDetails[tokenId].harvestReady = false;
        _hazelHeartsToken.mint(msg.sender, hazelheartsYield);
    emit FarmHarvested(tokenId, msg.sender, hazelheartsYield);
}

function processFarm(uint256 tokenId) public {
    require(_farmDetails[tokenId].exists, "Farm does not exist");
    require(_farmDetails[tokenId].owner == msg.sender, "Not farm owner");
    require(_farmDetails[tokenId].processingStartTime + PROCESSING_TIME <= block.timestamp, "Processing not complete");
    _farmDetails[tokenId].hazelheartsYield = TREES_PER_FARM * HAZELHEARTS_PER_TREE;
    _farmDetails[tokenId].harvestReady = true;
    emit FarmProcessed(tokenId, msg.sender);
}

event FarmHarvested(uint256 tokenId, address indexed owner, uint256 indexed hazelheartsYield);
event FarmProcessed(uint256 tokenId, address indexed owner);


