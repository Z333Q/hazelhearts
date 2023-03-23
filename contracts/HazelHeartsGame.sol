// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./HazelHeartsToken.sol";
import "./MembershipToken.sol";
import "./Farm.sol";
import "./Quests.sol";

contract HazelHeartsGame is Ownable {
HazelHeartsToken public hazelHeartsToken;
MembershipToken public membershipToken;
Farm public farm;
Quests public quests;
constructor(
    address _hazelHeartsTokenAddress,
    address _membershipTokenAddress,
    address _farmAddress,
    address _questsAddress
) {
    hazelHeartsToken = HazelHeartsToken(_hazelHeartsTokenAddress);
    membershipToken = MembershipToken(_membershipTokenAddress);
    farm = Farm(_farmAddress);
quests = Quests(_questsAddress);
}
function buyHazelHeartsNFT() external payable {
    require(msg.value == 0.1 ether, "You must send 0.1 ETH to buy an NFT");
    uint tokenId = hazelHeartsToken.totalSupply() + 1;
    require(tokenId <= 1000, "All NFTs have been minted");
    if (tokenId >= 801 && tokenId <= 1000) {
        require(msg.value == 2 ether, "You must send 2 ETH to buy this NFT");
    } else if (tokenId >= 601 && tokenId <= 800) {
        require(msg.value == 1 ether, "You must send 1 ETH to buy this NFT");
    } else if (tokenId >= 401 && tokenId <= 600) {
        require(msg.value == 0.5 ether, "You must send 0.5 ETH to buy this NFT");
    } else if (tokenId >= 201 && tokenId <= 400) {
        require(msg.value == 0.3 ether, "You must send 0.3 ETH to buy this NFT");
    } else {
        require(tokenId <= 200, "This NFT can no longer be minted for free");
    }
    hazelHeartsToken.mint(msg.sender, tokenId);
    if (tokenId <= 200) {
        hazelHeartsToken.transferFrom(address(this), msg.sender, 5);
    } else if (tokenId <= 400) {
        hazelHeartsToken.transferFrom(address(this), msg.sender, 10);
    } else if (tokenId <= 600) {
        hazelHeartsToken.transferFrom(address(this), msg.sender, 15);
    } else if (tokenId <= 800) {
        hazelHeartsToken.transferFrom(address(this), msg.sender, 25);
    } else {
        hazelHeartsToken.transferFrom(address(this), msg.sender, 50);
    }
}

function buyHazelNutFarm() external {
    uint tokenId = hazelHeartsToken.tokenOfOwnerByIndex(msg.sender, 0);
    require(farm.ownerOf(tokenId) == address(0), "You already own a farm");
    hazelHeartsToken.transferFrom(msg.sender, address(this), 5);
    hazelHeartsToken.approve(address(farm), tokenId);
    farm.createFarm(msg.sender, tokenId);
}

function buyProcessingEquipment(uint tokenId) external {
    require(farm.ownerOf(tokenId) == msg.sender, "You don't own this farm");
    require(hazelHeartsToken.balanceOf(msg.sender) >= 5, "You don't have enough HazelHearts tokens");
    hazelHeartsToken.transferFrom(msg.sender, address(this), 5);
    for (uint i = 0; i < Farm.MAX_TREES; i++) {
        hazelHeartsToken.approve(address(this), farm.trees(tokenId, i), 2);
    }
}

function removeProcessingEquipment(uint tokenId) external {
    require(farm.ownerOf(tokenId) == msg.sender, "You don't own this farm");
    for (uint i = 0; i < Farm.MAX_TREES; i++) {
        hazelHeartsToken.approve(address(this), farm.trees(tokenId, i), 0);
    }
}

function buyFarmUpgrade(uint tokenId) external {
    require(farm.ownerOf(tokenId) == msg.sender, "You don't own this farm");
    require(hazelHeartsToken.balanceOf(msg.sender) >= 10, "You don't have enough HazelHearts tokens");
hazelHeartsToken.transferFrom(msg.sender, address(this), 10);
farm.upgradeFarm(tokenId);
}

function tendToFarm(uint tokenId) external {
    require(farm.ownerOf(tokenId) == msg.sender, "You don't own this farm");
    require(farm.readyToHarvest(tokenId), "Your farm isn't ready to harvest yet");
    require(quests.isQuestCompleted(msg.sender, 2), "You must complete the processing equipment quest");
    uint numTrees = farm.getNumTrees(tokenId);
    uint hazelnutsHarvested = 0;
    for (uint i = 0; i < numTrees; i++) {
        if (farm.getTreeHarvestReady(tokenId, i)) {
            hazelnutsHarvested++;
        }
    }
    require(hazelnutsHarvested >= 10, "You must harvest at least 10 hazelnuts");
    hazelHeartsToken.transferFrom(address(this), msg.sender, numTrees / 2);
    farm.resetHarvestTime(tokenId);
    quests.completeQuest(1, 3);
}

function processHazelnuts(uint tokenId) external {
    require(farm.ownerOf(tokenId) == msg.sender, "You don't own this farm");
    require(quests.isQuestCompleted(msg.sender, 3), "You must complete the processing equipment quest");
    uint numTrees = farm.getNumTrees(tokenId);
    uint hazelnutsProcessed = 0;
    for (uint i = 0; i < numTrees; i++) {
        if (farm.getTreeHarvestReady(tokenId, i)) {
            farm.setTreeHarvestReady(tokenId, i, false);
            hazelnutsProcessed++;
        }
    }
    require(hazelnutsProcessed >= 10, "You must process at least 10 hazelnuts");
    hazelHeartsToken.transferFrom(address(this), msg.sender, numTrees);
    quests.completeQuest(2, 2);
}

function buySecondFarm(uint tokenId) external {
    require(farm.ownerOf(tokenId) == msg.sender, "You don't own this farm");
    require(hazelHeartsToken.balanceOf(msg.sender) >= 10, "You don't have enough HazelHearts tokens");
    hazelHeartsToken.transferFrom(msg.sender, address(this), 10);
    hazelHeartsToken.approve(address(farm), tokenId);
    farm.createFarm(msg.sender, tokenId);
    quests.completeQuest(3, 4);
}

function harvestHazelnuts(uint tokenId) external {
    require(farm.ownerOf(tokenId) == msg.sender, "You don't own this farm");
    require(farm.readyToHarvest(tokenId), "Your farm isn't ready to harvest yet");
    require(quests.isQuestCompleted(msg.sender, 4), "You must buy a third farm");
    uint numTrees = farm.getNumTrees(tokenId);
    uint hazelnutsHarvested = 0;
    for (uint i = 0; i < numTrees; i++) {
        if (farm.getTreeHarvestReady(tokenId, i)) {
            hazelnutsHarvested++;
        }
    }
    require(hazelnutsHarvested >= 25, "You must harvest at least 25 hazelnuts");
    hazelHeartsToken.transferFrom(address(this), msg.sender, numTrees / 2);
    farm.resetHarvestTime(tokenId);
    quests.completeQuest(4, 2);
}

function buyThirdFarm(uint tokenId) external {
    require(farm.ownerOf(tokenId) == msg.sender, "You don't own this farm");
require(hazelHeartsToken.balanceOf(msg.sender) >= 20, "You don't have enough HazelHearts tokens");
hazelHeartsToken.transferFrom(msg.sender, address(this), 20);
hazelHeartsToken.approve(address(farm), tokenId);
farm.createFarm(msg.sender, tokenId);
quests.completeQuest(5, 5);
}
function tradeHazelHearts() external {
    require(hazelHeartsToken.balanceOf(msg.sender) >= 50, "You don't have enough HazelHearts tokens");
    hazelHeartsToken.transferFrom(msg.sender, address(this), 50);
    hazelHeartsDAO.grantMembership(msg.sender);
    quests.completeQuest(6, 1);
}
}

contract Farm is ERC721URIStorage, Ownable {
using Counters for Counters.Counter;
Counters.Counter private _tokenIds;
Counters.Counter private _harvestTimes;
mapping(uint => mapping(uint => bool)) private _treeHarvestReady;
mapping(uint => uint) private _numTrees;
uint public constant MAX_TREES = 10;
uint public constant HARVEST_INTERVAL = 30 days;
address public constant HAZEL_HEARTS_ADDRESS = 0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9;
HazelHeartsToken private hazelHeartsToken;
constructor() ERC721("HazelNut Farm", "FARM") {
hazelHeartsToken = HazelHeartsToken(HAZEL_HEARTS_ADDRESS);
}
function createFarm(address to, uint tokenId) external onlyOwner {
    require(_tokenIds.current() == tokenId - 1, "Token ID must be the next available ID");
    _tokenIds.increment();
    _safeMint(to, tokenId);
    _setTokenURI(tokenId, string(abi.encodePacked("https://hazelhearts.com/farm/", Strings.toString(tokenId))));
    _numTrees[tokenId] = MAX_TREES;
    _harvestTimes[tokenId] = block.timestamp + HARVEST_INTERVAL;
}

function upgradeFarm(uint tokenId) external {
    require(ownerOf(tokenId) == msg.sender, "You don't own this farm");
    require(hazelHeartsToken.balanceOf(msg.sender) >= 10, "You don't have enough HazelHearts tokens");
    hazelHeartsToken.transferFrom(msg.sender, address(this), 10);
    _numTrees[tokenId] += MAX_TREES;
}

function resetHarvestTime(uint tokenId) external {
    require(ownerOf(tokenId) == msg.sender, "You don't own this farm");
    _harvestTimes[tokenId] = block.timestamp + HARVEST_INTERVAL;
}

function getNumTrees(uint tokenId) external view returns (uint) {
    return _numTrees[tokenId];
}

function getTreeHarvestReady(uint tokenId, uint treeIndex) external view returns (bool) {
    return _treeHarvestReady[tokenId][treeIndex];
}

function setTreeHarvestReady(uint tokenId, uint treeIndex, bool harvestReady) external {
    require(ownerOf(tokenId) == msg.sender, "You don't own this farm");
    _treeHarvestReady[tokenId][treeIndex] = harvestReady;
}

function readyToHarvest(uint tokenId) external view returns (bool) {
    return block.timestamp >= _harvestTimes[tokenId];
}

function harvest(uint tokenId, uint treeIndex) external {
    require(ownerOf(tokenId) == msg.sender, "You don't own this farm");
require(_treeHarvestReady[tokenId][treeIndex], "This tree isn't ready to harvest yet");
hazelHeartsToken.transferFrom(address(this), msg.sender, 1);
_treeHarvestReady[tokenId][treeIndex] = false;
}
}

contract ProcessingEquipment is Ownable {
address public constant HAZEL_HEARTS_ADDRESS = 0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9;
HazelHeartsToken private hazelHeartsToken;
mapping(address => bool) private _processingUnits;
constructor() {
hazelHeartsToken = HazelHeartsToken(HAZEL_HEARTS_ADDRESS);
}
function buyProcessingEquipment() external {
    require(hazelHeartsToken.balanceOf(msg.sender) >= 5, "You don't have enough HazelHearts tokens");
    hazelHeartsToken.transferFrom(msg.sender, address(this), 5);
    _processingUnits[msg.sender] = true;
}

function hasProcessingEquipment(address account) external view returns (bool) {
    return _processingUnits[account];
}
}

contract Quests is Ownable {
mapping(address => mapping(uint => bool)) private _quests;
event QuestCompleted(address indexed account, uint questId);
function completeQuest(uint questId, uint numTimes) external {
    _quests[msg.sender][questId] = true;
    emit QuestCompleted(msg.sender, questId);
}

function isQuestCompleted(address account, uint questId) external view returns (bool) {
    return _quests[account][questId];
}
}

contract HazelHeartsDAO is Ownable {
using Counters for Counters.Counter;
Counters.Counter private _membershipIds;
mapping(address => bool) private _members;
uint public constant MAX_MEMBERSHIPS = 1000;
function grantMembership(address account) external onlyOwner {
    require(_membershipIds.current() < MAX_MEMBERSHIPS, "Membership limit reached");
    require(!_members[account], "Account is already a member");
    _members[account] = true;
    _membershipIds.increment();
}

function isMember(address account) external view returns (bool) {
    return _members[account];
}
}

contract HazelHeartsGame is Ownable {
HazelHeartsToken private hazelHeartsToken;
Farm private farm;
ProcessingEquipment private processingEquipment;
Quests private quests;
HazelHeartsDAO private hazelHeartsDAO;
constructor() {
    hazelHeartsToken = new HazelHeartsToken();
    farm = new Farm();
    processingEquipment = new ProcessingEquipment();
    quests = new Quests();
    hazelHeartsDAO = new HazelHeartsDAO();
}

function getHazelHeartsToken() external view returns (address) {
    return address(hazelHeartsToken);
}

function getFarm() external view returns (address) {
    return address(farm);
}

function getProcessingEquipment() external view returns (address) {
    return address(processingEquipment);
}

function getQuests() external view returns (address) {
    return address(quests);
}

function getHazelHeartsDAO() external view returns (address) {
    return address(hazelHeartsDAO);
}
}

// Front-end Code

// Connect to HazelHeartsGame smart contract
const hazelHeartsGameAddress = '0x123...'; // replace with actual address
const hazelHeartsGameABI = [...]; // replace with actual ABI
const hazelHeartsGame = new web
3j.eth.Contract(hazelHeartsGameABI, hazelHeartsGameAddress);

// Connect to other smart contracts
const hazelHeartsTokenABI = [...]; // replace with actual ABI
const hazelHeartsTokenAddress = await hazelHeartsGame.methods.getHazelHeartsToken().call();
const hazelHeartsToken = new web3.eth.Contract(hazelHeartsTokenABI, hazelHeartsTokenAddress);

const farmABI = [...]; // replace with actual ABI
const farmAddress = await hazelHeartsGame.methods.getFarm().call();
const farm = new web3.eth.Contract(farmABI, farmAddress);

const processingEquipmentABI = [...]; // replace with actual ABI
const processingEquipmentAddress = await hazelHeartsGame.methods.getProcessingEquipment().call();
const processingEquipment = new web3.eth.Contract(processingEquipmentABI, processingEquipmentAddress);

const questsABI = [...]; // replace with actual ABI
const questsAddress = await hazelHeartsGame.methods.getQuests().call();
const quests = new web3.eth.Contract(questsABI, questsAddress);

const hazelHeartsDAOABI = [...]; // replace with actual ABI
const hazelHeartsDAOAddress = await hazelHeartsGame.methods.getHazelHeartsDAO().call();
const hazelHeartsDAO = new web3.eth.Contract(hazelHeartsDAOABI, hazelHeartsDAOAddress);

// Helper function to display hazelhearts balance
async function displayHazelHeartsBalance() {
const hazelHeartsBalance = await hazelHeartsToken.methods.balanceOf(account).call();
document.getElementById('hazelhearts-balance').innerText = hazelHeartsBalance;
}

// Helper function to display farm details
async function displayFarmDetails() {
const tokenId = document.getElementById('farm-token-id').value;
const owner = await farm.methods.ownerOf(tokenId).call();
const numTrees = await farm.methods.getNumTrees(tokenId).call();
const harvestReady = await farm.methods.readyToHarvest(tokenId).call();
document.getElementById('farm-owner').innerText = owner;
document.getElementById('farm-num-trees').innerText = numTrees;
document.getElementById('farm-harvest-ready').innerText = harvestReady;
}

// Helper function to display processing equipment status
async function displayProcessingEquipmentStatus() {
const hasEquipment = await processingEquipment.methods.hasProcessingEquipment(account).call();
document.getElementById('has-processing-equipment').innerText = hasEquipment;
}

// Helper function to display quest completion status
async function displayQuestStatus() {
const quest1Completed = await quests.methods.isQuestCompleted(account, 1).call();
const quest2Completed = await quests.methods.isQuestCompleted(account, 2).call();
const quest3Completed = await quests.methods.isQuestCompleted(account, 3).call();
const quest4Completed = await quests.methods.isQuestCompleted(account, 4).call();
const quest5Completed = await quests.methods.isQuestCompleted(account, 5).call();
const quest6Completed = await quests.methods.isQuestCompleted(account, 6).call();
document.getElementById('quest-1-status').innerText = quest1Completed ? 'Completed' : 'Incomplete';
document.getElementById('quest-2-status').innerText = quest2Completed ? 'Completed' : 'Incomplete';
document.getElementById('quest-3-status').innerText = quest3Completed ? 'Completed' : 'Incomplete';
document.getElementById('quest-4-status').innerText = quest4Completed ? 'Completed' : 'Incomplete';
document.getElementById('quest-5-status').innerText = quest5Completed ? 'Completed' : 'Incomplete';
document.getElementById('quest-6-status').innerText = quest6Completed ? 'Completed' : 'Incomplete';
}

// Helper function to display DAO membership status
async function displayMembershipStatus() {
const isMember = await hazelHeartsDAO.methods.isMember(account).call();
document.getElementById('is-member').innerText = isMember ? 'Yes' : 'No';
}

// Connect to MetaMask
const connectButton = document.getElementById('connect-button');
connectButton.addEventListener('click', async () => {
await window.ethereum.enable();
account = await web3.eth.getAccounts()[0];
displayHazelHeartsBalance();
displayFarmDetails();
displayProcessingEquipmentStatus();
displayQuestStatus();
displayMembershipStatus();
});

// Mint NFT and hazelhearts token on button click
const mintButton = document.getElementById('mint-button');
mintButton.addEventListener('click', async () => {
const tokenId = document.getElementById('mint-token-id').value;
await hazelHeartsToken.methods.mint(account, tokenId).send({from: account});
await farm.methods.createFarm(tokenId).send({from: account});
await hazelHeartsToken.methods.transfer(account, 5).send({from: account});
displayHazelHeartsBalance();
displayFarmDetails();
});

// Buy processing equipment on button click
const buyProcessingEquipmentButton = document.getElementById('buy-processing-equipment-button');
buyProcessingEquipmentButton.addEventListener('click', async () => {
await processingEquipment.methods.buyProcessingEquipment().send({from: account});
displayProcessingEquipmentStatus();
});

// Harvest hazelnuts on button click
const harvestButton = document.getElementById('harvest-button');
harvestButton.addEventListener('click', async () => {
const tokenId = document.getElementById('harvest-token-id').value;
const treeIndex = document.getElementById('harvest-tree-index').value;
await farm.methods.harvest(tokenId, treeIndex).send({from: account});
await hazelHeartsToken.methods.transfer(account, 0.5).send({from: account});
displayHazelHeartsBalance();
displayFarmDetails();
});

// Complete quest on button click
const completeQuestButton = document.getElementById('complete-quest-button');
completeQuestButton.addEventListener('click', async () => {
const questId = document.getElementById('complete-quest-id').value;
await quests.methods.completeQuest(questId, 1).send({from: account});
displayQuestStatus();
});

// Grant membership on button click
const grantMembershipButton = document.getElementById('grant-membership-button');
grantMembershipButton.addEventListener('click', async () => {
const accountToGrant = document.getElementById('grant-membership-account').value;
await hazelHeartsDAO.methods.grantMembership(accountToGrant).send({from: account});
displayMembershipStatus();
});

// Initial display of account data
let account = null;
if (window.ethereum) {
account = await web3.eth.getAccounts()[0];
displayHazelHeartsBalance();
displayFarmDetails();
displayProcessingEquipmentStatus();
displayQuestStatus();
displayMembershipStatus();
} else {
console.log('MetaMask not detected');
}
// Update HTML elements for Bootstrap and 8-bit style

<div class="container">
  <div class="row mt-4 mb-4">
    <div class="col-md-4 col-sm-12">
      <div class="card hazelhearts-card">
        <div class="card-body text-center">
          <h5 class="card-title">HazelHearts Balance</h5>
          <p class="card-text hazelhearts-balance">0</p>
        </div>
      </div>
    </div>
    <div class="col-md-4 col-sm-12">
      <div class="card farm-card">
        <div class="card-body text-center">
          <h5 class="card-title">Farm Details</h5>
          <div class="form-group">
            <label for="farm-token-id">Farm Token ID</label>
            <input type="text" class="form-control" id="farm-token-id" placeholder="Enter token ID">
          </div>
          <p class="card-text">Owner: <span class="farm-owner"></span></p>
          <p class="card-text">Number of Trees: <span class="farm-num-trees"></span></p>
          <p class="card-text">Harvest Ready: <span class="farm-harvest-ready"></span></p>
        </div>
      </div>
    </div>
    <div class="col-md-4 col-sm-12">
      <div class="card processing-equipment-card">
        <div class="card-body text-center">
          <h5 class="card-title">Processing Equipment</h5>
          <p class="card-text">Owned: <span class="has-processing-equipment"></span></p>
          <button type="button" class="btn btn-primary" id="buy-processing-equipment-button">Buy Processing Equipment</button>
        </div>
      </div>
    </div>
  </div>
  <div class="row mt-4 mb-4">
    <div class="col-md-4 col-sm-12">
      <div class="card hazelnuts-card">
        <div class="card-body text-center">
          <h5 class="card-title">Harvest Hazelnuts</h5>
          <div class="form-group">
            <label for="harvest-token-id">Farm Token ID</label>
            <input type="text" class="form-control" id="harvest-token-id" placeholder="Enter token ID">
          </div>
          <div class="form-group">
            <label for="harvest-tree-index">Tree Index</label>
            <input type="text" class="form-control" id="harvest-tree-index" placeholder="Enter tree index">
          </div>
          <button type="button" class="btn btn-primary" id="harvest-button">Harvest</button>
        </div>
      </div>
    </div>
    <div class="col-md-4 col-sm-12">
      <div class="card quests-card">
        <div class="card-body text-center">
          <h5 class="card-title">Quests</h5>
          <table class="table table-striped table-bordered">
            <thead>
              <tr>
                <th scope="col">Quest</th>
                <th scope="col">Status</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <th scope="row">1</th>
                <td><span id="quest-1-status"></span></td>
              </tr>
              <tr>
                <th scope="row">
                2</th>
<td><span id="quest-2-status"></span></td>
</tr>
<tr>
<th scope="row">3</th>
<td><span id="quest-3-status"></span></td>
</tr>
<tr>
<th scope="row">4</th>
<td><span id="quest-4-status"></span></td>
</tr>
<tr>
<th scope="row">5</th>
<td><span id="quest-5-status"></span></td>
</tr>
<tr>
<th scope="row">6</th>
<td><span id="quest-6-status"></span></td>
</tr>
</tbody>
</table>
<div class="form-group">
<label for="complete-quest-id">Complete Quest</label>
<input type="text" class="form-control" id="complete-quest-id" placeholder="Enter quest ID">
</div>
<button type="button" class="btn btn-primary" id="complete-quest-button">Complete Quest</button>
</div>
</div>
</div>
<div class="col-md-4 col-sm-12">
<div class="card dao-card">
<div class="card-body text-center">
<h5 class="card-title">HazelHearts DAO Membership</h5>
<p class="card-text">Member: <span id="is-member"></span></p>
<div class="form-group">
<label for="grant-membership-account">Grant Membership</label>
<input type="text" class="form-control" id="grant-membership-account" placeholder="Enter account address">
</div>
<button type="button" class="btn btn-primary" id="grant-membership-button">Grant Membership</button>
</div>
</div>
</div>

  </div>
</div>
// Add Bootstrap styles

<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
// Update CSS styles for 8-bit style
.hazelhearts-card {
background-color: #EA6B4A;
}

.farm-card {
background-color: #2C2E43;
color: #FFF;
}

.processing-equipment-card {
background-color: #F6CA3E;
}

.hazelnuts-card {
background-color: #008037;
color: #FFF;
}

.quests-card {
background-color: #D72638;
color: #FFF;
}

.dao-card {
background-color: #1379C2;
color: #FFF;
}

table {
border: 2px solid #FFF;
}

th {
border: 1px solid #FFF;
}

td {
border: 1px solid #FFF;
}

// Update JavaScript to interact with Polygon network
const hazelHeartsToken = new web3.eth.Contract(hazelHeartsTokenAbi, '0x52e7ed91a06bd1b7c6efb99f7537a19ad96e6ed7');
const farm = new web3.eth.Contract(farmAbi, '0x6a3c6b09d6fdc6a5f6d5a74cf5a5');
const processingEquipment = new web3.eth.Contract(processingEquipmentAbi, '0xd784dd29fb244292e92a5a23025d8c7fc44f0d07');
const quests = new web3.eth.Contract(questsAbi, '0x9c89b59bb8be29c46b97dd1e530201a51a8a7b67');
const daoMembership = new web3.eth.Contract(daoMembershipAbi, '0x4d7b1afec740017f39ce4a79e88ef9d738a2b77e');

const hazelheartsBalanceElement = document.querySelector('.hazelhearts-balance');
const farmOwnerElement = document.querySelector('.farm-owner');
const farmNumTreesElement = document.querySelector('.farm-num-trees');
const farmHarvestReadyElement = document.querySelector('.farm-harvest-ready');
const hasProcessingEquipmentElement = document.querySelector('.has-processing-equipment');
const quest1StatusElement = document.querySelector('#quest-1-status');
const quest2StatusElement = document.querySelector('#quest-2-status');
const quest3StatusElement = document.querySelector('#quest-3-status');
const quest4StatusElement = document.querySelector('#quest-4-status');
const quest5StatusElement = document.querySelector('#quest-5-status');
const quest6StatusElement = document.querySelector('#quest-6-status');
const isMemberElement = document.querySelector('#is-member');

// Get account and network information
web3.eth.getAccounts()
.then(accounts => {
const account = accounts[0];
web3.eth.net.getId()
.then(networkId => {
// Update contract instances with network ID
hazelHeartsToken.options.address = hazelHeartsTokenAddresses[networkId];
farm.options.address = farmAddresses[networkId];
processingEquipment.options.address = processingEquipmentAddresses[networkId];
quests.options.address = questsAddresses[networkId];
daoMembership.options.address = daoMembershipAddresses[networkId];
// Update HTML elements with account and network information
web3.eth.getBalance(account)
.then(balance => {
hazelheartsBalanceElement.textContent = ${web3.utils.fromWei(balance)} MATIC;
});
farm.methods.ownerOf(0).call()
.then(owner => {
farmOwnerElement.textContent = owner;
});
farm.methods.getFarmDetails(0).call()
.then(details => {
farmNumTreesElement.textContent = details.numTrees;
farmHarvestReadyElement.textContent = details.harvestReady;
});
processingEquipment.methods.hasProcessingEquipment(account).call()
.then(hasProcessingEquipment => {
hasProcessingEquipmentElement.textContent = hasProcessingEquipment ? 'Yes' : 'No';
});
daoMembership.methods.isMember(account).call()
.then(isMember => {
isMemberElement.textContent = isMember ? 'Yes' : 'No';
});
// Add event listeners for button clicks
document.querySelector('#buy-processing-equipment-button').addEventListener('click', () => {
processingEquipment.methods.buyProcessingEquipment().send({from: account})
.then(() => {
alert('Processing equipment purchased!');
window.location.reload();
})
.catch(error => {
alert(error.message);
});
});
document.querySelector('#harvest-button').addEventListener('click', () => {
const tokenId = document.querySelector('#harvest-token-id').value;
const treeIndex = document.querySelector('#harvest-tree-index').value;
farm.methods.harvest(tokenId, treeIndex).send({from: account})
.then(() => {
alert('Hazelnuts harvested!');
window.location.reload();
})
.catch(error => {
alert(error.message);
});
});
document.querySelector('#buy-farm-button').addEventListener('click', () => {
const numFarms = document.querySelector('#buy-farm-num').value;
farm.methods.buyFarm(numFarms).send({from: account, value: web3.utils.toWei((numFarms * 10).toString(), 'ether')})
.then(() => {
alert('Farm purchased!');
window.location.reload();
})
.catch(error => {
alert(error.message);
});
});
document.querySelector('#complete-quest-button').addEventListener('click', () => {
const questId = document.querySelector('#complete-quest-id').value;
quests.methods.completeQuest(questId).send({from: account})
.then(() => {
alert('Quest completed!');
window.location.reload();
})
.catch(error => {
alert(error.message);
});
});
document.querySelector('#grant-membership-button').addEventListener('click', () => {
const member = document.querySelector('#grant-membership-account').value;
daoMembership.methods.grantMembership(member).send({from: account})
.then(() => {
alert('Membership granted!');
window.location.reload();
})
.catch(error => {
alert(error.message);
});
});
});
});
// Add event listener for farm details form submission
document.querySelector('#farm-details-form').addEventListener('submit', event => {
event.preventDefault();
const tokenId = document.querySelector('#farm-token-id').value;
farm.methods.ownerOf(tokenId).call()
.then(owner => {
farmOwnerElement.textContent = owner;
});
farm.methods.getFarmDetails(tokenId).call()
.then(details => {
farmNumTreesElement.textContent = details.numTrees;
farmHarvestReadyElement.textContent = details.harvestReady;
});
});

// Add event listener for processing equipment form submission
document.querySelector('#processing-equipment-form').addEventListener('submit', event => {
event.preventDefault();
const account = web3.eth.accounts[0];
processingEquipment.methods.hasProcessingEquipment(account).call()
.then(hasProcessingEquipment => {
hasProcessingEquipmentElement.textContent = hasProcessingEquipment ? 'Yes' : 'No';
});
});

// Add event listener for quest status form submission
document.querySelector('#quest-status-form').addEventListener('submit', event => {
event.preventDefault();
const account = web3.eth.accounts[0];
quests.methods.getQuestStatus(account, 1).call()
.then(status => {
quest1StatusElement.textContent = status ? 'Completed' : 'Incomplete';
});
quests.methods.getQuestStatus(account, 2).call()
.then(status => {
quest2StatusElement.textContent = status ? 'Completed' : 'Incomplete';
});
quests.methods.getQuestStatus(account, 3).call()
.then(status => {
quest3StatusElement.textContent = status ? 'Completed' : 'Incomplete';
});
quests.methods.getQuestStatus(account, 4).call()
.then(status => {
quest4StatusElement.textContent = status ? 'Completed' : 'Incomplete';
});
quests.methods.getQuestStatus(account, 5).call()
.then(status => {
quest5StatusElement.textContent = status ? 'Completed' : 'Incomplete';
});
quests.methods.getQuestStatus(account, 6).call()
.then(status => {
quest6StatusElement.textContent = status ? 'Completed' : 'Incomplete';
});
});

// Add event listener for membership form submission
document.querySelector('#membership-form').addEventListener('submit', event => {
event.preventDefault();
const account = web3.eth.accounts[0];
daoMembership.methods.isMember(account).call()
.then(isMember => {
isMemberElement.textContent = isMember ? 'Yes' : 'No';
});
});

// Add event listener for buy farm form submission
document.querySelector('#buy-farm-form').addEventListener('submit', event => {
event.preventDefault();
const account = web3.eth.accounts[0];
const numFarms = document.querySelector('#buy-farm-num').value;
farm.methods.buyFarm(numFarms).send({from: account, value: web3.utils.toWei((numFarms * 10).toString(), 'ether')})
.then(() => {
alert('Farm purchased!');
window.location.reload();
})
.catch(error => {
alert(error.message);
});
});

// Add event listener for grant membership form submission
document.querySelector('#grant-membership-form').addEventListener('submit', event => {
event.preventDefault();
const account = web3.eth.accounts[0];
const member = document.querySelector('#grant-membership-account').value;
daoMembership.methods.grantMembership(member).send({from: account})
.then(() => {
alert('Membership granted!');
window.location.reload();
})
.catch(error => {
alert(error.message);
});
});

// Add event listener for buy processing equipment form submission
document.querySelector('#buy-processing-equipment-form').addEventListener('submit', event => {
event.preventDefault();
const account = web3.eth.accounts[0];
processingEquipment.methods.hasProcessingEquipment(account).call()
.then(hasProcessingEquipment => {
if (hasProcessingEquipment) {
alert('You already have processing equipment!');
} else {
processingEquipment.methods.buyProcessingEquipment().send({from: account, value: web3.utils.toWei('5', 'ether')})
.then(() => {
alert('Processing equipment purchased!');
window.location.reload();
})
.catch(error => {
alert(error.message);
});
}
});
});

// Add event listener for tend farm form submission
document.querySelector('#tend-farm-form').addEventListener('submit', event => {
event.preventDefault();
const account = web3.eth.accounts[0];
const tokenId = document.querySelector('#tend-farm-token-id').value;
farm.methods.getFarmDetails(tokenId).call()
.then(details => {
if (details.harvestReady) {
farm.methods.tendFarm(tokenId).send({from: account})
.then(() => {
alert('Farm tended!');
window.location.reload();
})
.catch(error => {
alert(error.message);
});
} else {
alert('Farm not ready for harvest!');
}
});
});

// Add event listener for harvest farm form submission
document.querySelector('#harvest-farm-form').addEventListener('submit', event => {
event.preventDefault();
const account = web3.eth.accounts[0];
const tokenId = document.querySelector('#harvest-farm-token-id').value;
farm.methods.getFarmDetails(tokenId).call()
.then(details => {
if (details.harvestReady) {
farm.methods.harvestFarm(tokenId).send({from: account})
.then(() => {
alert('Farm harvested!');
window.location.reload();
})
.catch(error => {
alert(error.message);
});
} else {
alert('Farm not ready for harvest!');
}
});
});

// Add event listener for processing farm form submission
document.querySelector('#process-farm-form').addEventListener('submit', event => {
event.preventDefault();
const account = web3.eth.accounts[0];
const tokenId = document.querySelector('#process-farm-token-id').value;
farm.methods.getFarmDetails(tokenId).call()
.then(details => {
if (details.harvestReady) {
processingEquipment.methods.hasProcessingEquipment(account).call()
.then(hasProcessingEquipment => {
if (hasProcessingEquipment) {
farm.methods.processFarm(tokenId).send({from: account})
.then(() => {
alert('Farm processed!');
window.location.reload();
})
.catch(error => {
alert(error.message);
});
} else {
alert('You need processing equipment to process your harvest!');
}
});
} else {
alert('Farm not ready for harvest!');
}
});
});

// Add event listener for mint button click
document.querySelector('#mint-button').addEventListener('click', () => {
const numTokens = document.querySelector('#num-tokens').value;
const tier = document.querySelector('#mint-tier').value;
const price = tier === '1' ? '0' : tier === '2' ? '0.3' : tier === '3' ? '0.5' : tier === '4' ? '1' : '2';
const priceInWei = web3.utils.toWei(price, 'ether');
hazelHearts.methods.mint(numTokens).send({from: web3.eth.accounts[0], value: priceInWei})
.then(() => {
alert('Minting successful!');
window.location.reload();
})
.catch(error => {
alert(error.message);
});
});


