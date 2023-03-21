pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract HazelHearts is ERC721, Ownable {
    uint256 public constant MAX_TOKENS = 1000;
    uint256 public constant FREE_TIER_LIMIT = 200;
    uint256 public constant TIER_TWO_LIMIT = 400;
    uint256 public constant TIER_THREE_LIMIT = 600;
    uint256 public constant TIER_FOUR_LIMIT = 800;
    uint256 public constant TIER_FIVE_LIMIT = 1000;
    uint256 public constant TIER_TWO_PRICE = 300000000000000000;
    uint256 public constant TIER_THREE_PRICE = 500000000000000000;
    uint256 public constant TIER_FOUR_PRICE = 1000000000000000000;
    uint256 public constant TIER_FIVE_PRICE = 2000000000000000000;
    uint256 public constant FARM_COST = 5;
    uint256 public constant EQUIPMENT_COST = 5;
    uint256 public constant HARVEST_AMOUNT = 50;

    string private baseURI;

    bool public mintingAllowed = true;

    struct Farm {
        uint256 trees;
        uint256 equipment;
        uint256 harvestTime;
        bool readyToHarvest;
    }

    mapping(address => Farm[]) public farms;

    constructor() ERC721("HazelHearts", "HAZEL") {}

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function setBaseURI(string memory _newBaseURI) external onlyOwner {
        baseURI = _newBaseURI;
    }

    function mintToken(uint256 _tokenId) public payable {
        require(mintingAllowed, "Minting is not allowed at this time.");
        require(_tokenId > 0 && _tokenId <= MAX_TOKENS, "Invalid token ID.");
        require(msg.value >= getPrice(_tokenId), "Invalid payment amount.");

        _safeMint(msg.sender, _tokenId);
    }

    function getPrice(uint256 _tokenId) public view returns (uint256) {
        require(_tokenId > 0 && _tokenId <= MAX_TOKENS, "Invalid token ID.");

        if (_tokenId <= FREE_TIER_LIMIT) {
            return 0;
        } else if (_tokenId <= TIER_TWO_LIMIT) {
            return TIER_TWO_PRICE;
        } else if (_tokenId <= TIER_THREE_LIMIT) {
            return TIER_THREE_PRICE;
        } else if (_tokenId <= TIER_FOUR_LIMIT) {
            return TIER_FOUR_PRICE;
        } else {
            return TIER_FIVE_PRICE;
        }
    }

    function allowMinting() external onlyOwner {
        mintingAllowed = true;
    }

    function pauseMinting() external onlyOwner {
        mintingAllowed = false;
    }

    function buyFarm(uint256 _tokenId) external {
        require(ownerOf(_tokenId) == msg.sender, "You do not own this token.");
        require(balanceOf(msg.sender) >= FARM_COST, "Insufficient funds to purchase a farm.");

        Farm memory newFarm = Farm({
            trees: 10,
            equipment: 0,
            harvestTime: 0,
            readyToHarvest: false
        });

        farms[msg.sender].push(newFarm);

        _burn(_tokenId);
    }

    function buyEquipment(uint256 _tokenId, uint256 _farmIndex) external {
        require(ownerOf(_tokenId) == msg.sender, "You do not own this token.");
require(_farmIndex < farms[msg.sender].length, "Invalid farm index.");
require(balanceOf(msg.sender) >= EQUIPMENT_COST, "Insufficient funds to purchase equipment.");
    farms[msg.sender][_farmIndex].equipment = farms[msg.sender][_farmIndex].equipment + 1;

    _burn(_tokenId);
}

function harvest(uint256 _farmIndex) external {
    require(_farmIndex < farms[msg.sender].length, "Invalid farm index.");

    Farm storage farm = farms[msg.sender][_farmIndex];

    require(farm.trees > 0, "No trees on this farm.");

    if (farm.readyToHarvest) {
        uint256 harvestAmount = farm.trees;

        if (farm.equipment > 0) {
            harvestAmount = harvestAmount * 2;
        }

        transferHarvestReward(msg.sender, harvestAmount);

        farm.harvestTime = 0;
        farm.readyToHarvest = false;
    } else {
        require(farm.harvestTime == 0, "Harvest in progress.");
        farm.harvestTime = block.timestamp + 30 days;
        farm.readyToHarvest = true;
    }
}

function transferHarvestReward(address _to, uint256 _amount) internal {
    require(balanceOf(address(this)) >= _amount, "Insufficient funds to transfer harvest reward.");

    for (uint256 i = 0; i < _amount; i++) {
        uint256 tokenId = randomTokenId();
        _safeTransfer(address(this), _to, tokenId, "");
    }
}

function randomTokenId() internal view returns (uint256) {
    uint256 totalSupply = totalSupply();

    while (true) {
        uint256 randomId = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, totalSupply)));
        if (!exists(randomId)) {
            return randomId;
        }
    }
}

function tendFarm() external pure {
    // This function is just a placeholder to simulate tending to a farm
    // In a real implementation, it would perform some on-chain verification of a user's activity
}

function joinDao() external {
    require(balanceOf(msg.sender) >= HARVEST_AMOUNT, "Insufficient tokens to join the DAO.");

    for (uint256 i = 0; i < HARVEST_AMOUNT; i++) {
        uint256 tokenId = tokenOfOwnerByIndex(msg.sender, i);
        _burn(tokenId);
    }

    // Add user to DAO membership
}


