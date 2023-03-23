// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract HazelHearts is Ownable {
using SafeMath for uint256;
address payable public daoTreasury;

uint256 public tierOnePrice;
uint256 public tierTwoPrice;
uint256 public tierThreePrice;
uint256 public tierFourPrice;
uint256 public tierFivePrice;

uint256 public constant maxSupply = 1000;

IERC721 public farmContract;
address public hazelHeartsGame;

constructor(
    address payable _daoTreasury,
    uint256 _tierOnePrice,
    uint256 _tierTwoPrice,
    uint256 _tierThreePrice,
    uint256 _tierFourPrice,
    uint256 _tierFivePrice,
    address _farmContract,
    address _hazelHeartsGame
) {
    daoTreasury = _daoTreasury;
    tierOnePrice = _tierOnePrice;
    tierTwoPrice = _tierTwoPrice;
    tierThreePrice = _tierThreePrice;
    tierFourPrice = _tierFourPrice;
    tierFivePrice = _tierFivePrice;
    farmContract = IERC721(_farmContract);
    hazelHeartsGame = _hazelHeartsGame;
}

function mint(address to, uint256 tokenId) external payable {
    require(tokenId < maxSupply, "Token ID out of range");
    require(msg.value >= getCurrentPrice(tokenId), "Ether value sent is not correct");

    if (tokenId >= 1 && tokenId <= 200) {
        farmContract.createFarm(to);
        HazelHeartsGame(hazelHeartsGame).mintHazelHearts(to, tokenId, 5);
    } else if (tokenId >= 201 && tokenId <= 400) {
        HazelHeartsGame(hazelHeartsGame).mintHazelHearts(to, tokenId, 10);
    } else if (tokenId >= 401 && tokenId <= 600) {
        HazelHeartsGame(hazelHeartsGame).mintHazelHearts(to, tokenId, 15);
    } else if (tokenId >= 601 && tokenId <= 800) {
        HazelHeartsGame(hazelHeartsGame).mintHazelHearts(to, tokenId, 25);
    } else if (tokenId >= 801 && tokenId <= 1000) {
        HazelHeartsGame(hazelHeartsGame).mintHazelHearts(to, tokenId, 50);
    }

    daoTreasury.transfer(msg.value);
}

function getCurrentPrice(uint256 tokenId) public view returns (uint256) {
    if (tokenId >= 1 && tokenId <= 200) {
        return tierOnePrice;
    } else if (tokenId >= 201 && tokenId <= 400) {
        return tierTwoPrice;
    } else if (tokenId >= 401 && tokenId <= 600) {
        return tierThreePrice;
       } else if (tokenId >= 601 && tokenId <= 800) {
        return tierFourPrice;
    } else if (tokenId >= 801 && tokenId <= 1000) {
        return tierFivePrice;
    }
}

function setTierOnePrice(uint256 _price) external onlyOwner {
    tierOnePrice = _price;
}

function setTierTwoPrice(uint256 _price) external onlyOwner {
    tierTwoPrice = _price;
}

function setTierThreePrice(uint256 _price) external onlyOwner {
    tierThreePrice = _price;
}

function setTierFourPrice(uint256 _price) external onlyOwner {
    tierFourPrice = _price;
}

function setTierFivePrice(uint256 _price) external onlyOwner {
    tierFivePrice = _price;
}

function setDaoTreasury(address payable _daoTreasury) external onlyOwner {
    daoTreasury = _daoTreasury;
}

