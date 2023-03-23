import React, { useState, useEffect } from 'react';
import ReactDOM from 'react-dom';
import Web3 from 'web3';
import './style.css';

const hazelHeartsAbi = [
  // TODO: add HazelHearts ABI
];

const farmAbi = [
  // TODO: add Farm ABI
];

const processingEquipmentAbi = [
  // TODO: add ProcessingEquipment ABI
];

const questManagerAbi = [
  // TODO: add QuestManager ABI
];

const hazelHeartsAddress = ''; // TODO: add HazelHearts contract address
const farmAddress = ''; // TODO: add Farm contract address
const processingEquipmentAddress = ''; // TODO: add ProcessingEquipment contract address
const questManagerAddress = ''; // TODO: add QuestManager contract address

const web3 = new Web3(Web3.givenProvider || 'ws://localhost:8545');

const hazelHearts = new web3.eth.Contract(hazelHeartsAbi, hazelHeartsAddress);
const farm = new web3.eth.Contract(farmAbi, farmAddress);
const processingEquipment = new web3.eth.Contract(processingEquipmentAbi, processingEquipmentAddress);
const questManager = new web3.eth.Contract(questManagerAbi, questManagerAddress);

const App = () => {
  const [account, setAccount] = useState('');
  const [tokenId, setTokenId] = useState(0);
  const [numTokens, setNumTokens] = useState(1);
  const [processingEquipmentOwned, setProcessingEquipmentOwned] = useState(false);
  const [harvestReady, setHarvestReady] = useState(false);
  const [harvestComplete, setHarvestComplete] = useState(false);
  const [processingComplete, setProcessingComplete] = useState(false);
  const [processingReady, setProcessingReady] = useState(false);
  const [farmOwned, setFarmOwned] = useState(false);
  const [numHazelnuts, setNumHazelnuts] = useState(0);
  const [numQuests, setNumQuests] = useState(0);
  const [questCompleted, setQuestCompleted] = useState(false);
  const [questReward, setQuestReward] = useState(0);
  const [daoMember, setDaoMember] = useState(false);

  useEffect(() => {
    const loadAccount = async () => {
      const accounts = await web3.eth.getAccounts();
      setAccount(accounts[0]);
    }
    loadAccount();
  }, []);

  const handleMint = async () => {
    try {
      const tier = document.querySelector('#mint-tier').value;
      const value = numTokens;
const price = tier === '1' ? '0' : tier === '2' ? '300000000000000000' : tier === '3' ? '500000000000000000' : tier === '4' ? '1000000000000000000' : '2000000000000000000';
await hazelHearts.methods.mint(account, tokenId).send({ from: account, value: price });
alert('Minting successful!');
window.location.reload();
} catch (error) {
alert(error.message);
}
}

const handleBuyFarm = async () => {
try {
const price = '5';
await hazelHearts.methods.transferFrom(account, farm._address, price).send({ from: account });
await farm.methods.buyFarm().send({ from: account });
setFarmOwned(true);
setNumHazelnuts(10);
} catch (error) {
alert(error.message);
}
}

const handleBuyProcessingEquipment = async () => {
try {
const price = '5';
await hazelHearts.methods.transferFrom(account, processingEquipment._address, price).send({ from: account });
setProcessingEquipmentOwned(true);
} catch (error) {
alert(error.message);
}
}

const handleHarvest = async () => {
try {
const numTrees = 10;
const numHazelnutsPerTree = processingEquipmentOwned ? 1 : 0.5;
await farm.methods.harvest(numTrees, numHazelnutsPerTree).send({ from: account });
setHarvestReady(false);
setHarvestComplete(true);
setNumQuests(numQuests + 1);
} catch (error) {
alert(error.message);
}
}

const handleProcess = async () => {
try {
const numHazelnutsToProcess = numHazelnuts;
const processingMultiplier = processingEquipmentOwned ? 2 : 1;
await hazelHearts.methods.transferFrom(farm._address, processingEquipment._address, numHazelnutsToProcess).send({ from: account });
await processingEquipment.methods.process(numHazelnutsToProcess, processingMultiplier).send({ from: account });
setNumHazelnuts(numHazelnutsToProcess * processingMultiplier);
setProcessingReady(false);
setProcessingComplete(true);
setNumQuests(numQuests + 1);
} catch (error) {
alert(error.message);
}
}

const handleCompleteQuest = async () => {
try {
const reward = await questManager.methods.completeQuest(account).call({ from: account });
await questManager.methods.completeQuest(account).send({ from: account });
setQuestCompleted(true);
setQuestReward(reward);
setNumQuests(0);
setNumHazelnuts(numHazelnuts - reward);
} catch (error) {
alert(error.message);
}
}

const handleTradeIn = async () => {
try {
const numHazelnutsToTradeIn = 50;
await hazelHearts.methods.transferFrom(account, hazelHearts._address, numHazelnutsToTradeIn).send({ from: account });
await hazelHearts.methods.tradeIn().send({ from: account });
setDaoMember(true);
} catch (error) {
alert(error.message);
}
}

return (
<div className="container">
<h1 className="text-center">HazelHearts Game</h1>
<hr />
<div className="      row">
      <div className="col-md-4">
        <h2 className="text-center">Farm</h2>
        <hr />
        <img src={FarmImage} alt="Farm" className="img-fluid" />
        <hr />
        <p className="text-center">
          {farmOwned ? 'You own this farm.' : 'You do not own this farm.'}
        </p>
        <p className="text-center">Cost: 5 HazelHearts tokens</p>
        {!farmOwned && (
          <button className="btn btn-primary" onClick={handleBuyFarm} disabled={!account}>
            Buy Farm
          </button>
        )}
      </div>
      <div className="col-md-4">
        <h2 className="text-center">Hazelnut Trees</h2>
        <hr />
        <img src={TreeImage} alt="Tree" className="img-fluid" />
        <hr />
        <p className="text-center">Number of Hazelnuts: {numHazelnuts}</p>
        {!harvestReady && !harvestComplete && (
          <button className="btn btn-primary" onClick={() => setHarvestReady(true)} disabled={!account}>
            Harvest
          </button>
        )}
        {harvestReady && (
          <button className="btn btn-warning" onClick={handleHarvest} disabled={!account}>
            Harvest Now
          </button>
        )}
        {harvestComplete && (
          <div>
            <p className="text-center">Harvest complete! Process hazelnuts?</p>
            {!processingReady && !processingComplete && (
              <button className="btn btn-primary" onClick={() => setProcessingReady(true)}>
                Yes
              </button>
            )}
            {processingReady && (
              <button className="btn btn-warning" onClick={handleProcess}>
                Process Now
              </button>
            )}
            {processingComplete && (
              <p className="text-center">
                Processing complete! You now have {numHazelnuts} hazelnuts.
              </p>
            )}
          </div>
        )}
      </div>
      <div className="col-md-4">
        <h2 className="text-center">Processing Equipment</h2>
        <hr />
        <img src={ProcessingImage} alt="Processing Equipment" className="img-fluid" />
        <hr />
        <p className="text-center">
          {processingEquipmentOwned
            ? 'You own this processing equipment.'
            : 'You do not own this processing equipment.'}
        </p>
        <p className="text-center">Cost: 5 HazelHearts tokens</p>
        {!processingEquipmentOwned && (
          <button className="btn btn-primary" onClick={handleBuyProcessingEquipment} disabled={!account}>
            Buy Processing Equipment
          </button>
        )}
      </div>
    </div>
    <hr />
    <div className="row">
      <div className="col-md-12">
        <h2 className="text-center">Quests</h2>
        <hr />
        <p className="text-center">
          Number of Quests Completed: {numQuests}
        </p>
        {numQuests >= 3 && (
          <div>
            <button className="btn btn-primary" onClick={handleCompleteQuest}>
              Complete Quests
            </button>
            {questCompleted && (
              <p className="text-center">
                Quests completed! You earned {questReward} HazelHearts tokens.
              </p>
            )}
          </div>
        )}
      </div>
    </div>
    <hr />
    <div className="row">
      <div className="col-md
    <div className="row">
      <div className="col-md-12">
        <h2 className="text-center">HazelHearts DAO Membership</h2>
        <hr />
        <p className="text-center">
          {daoMembershipOwned ? 'You own a HazelHearts DAO membership.' : 'You do not own a HazelHearts DAO membership.'}
        </p>
        <p className="text-center">Cost: 50 HazelHearts tokens</p>
        {!daoMembershipOwned && (
          <button className="btn btn-primary" onClick={handleBuyDAOMembership} disabled={!account}>
            Buy DAO Membership
          </button>
        )}
      </div>
    </div>
  </div>
</div>
);
}

export default App;
