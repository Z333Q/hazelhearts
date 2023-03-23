// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract HazelHeartsToken is ERC721, ERC20, Ownable {
    uint public constant MAX_MEMBERSHIPS = 1000;

    uint public numMemberships;
    mapping(uint => bool) public isMembershipToken;
    mapping(uint => bool) public hasHarvested;

    constructor() ERC721("HazelHeartsToken", "HHT") ERC20("HazelHeartsToken", "HHT") {}

    function mint(address to, uint amount) external onlyOwner {
        uint tokenId = totalSupply() + 1;
        _mint(to, tokenId);
        _mint(address(this), amount);
        _approve(address(this), msg.sender, amount);
    }

    function harvest(uint tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "You don't own this token");
        require(!hasHarvested[tokenId], "You've already harvested this month");
        require(isMembershipToken[tokenId], "This token is not a membership token");
        hasHarvested[tokenId] = true;
        _mint(msg.sender, 5);
    }

    function buyMembership() external {
        require(numMemberships < MAX_MEMBERSHIPS, "All memberships have been sold");
require(balanceOf(msg.sender) >= 50, "You don't have enough HazelHearts tokens");
numMemberships++;
uint tokenId = totalSupply() + 1;
isMembershipToken[tokenId] = true;
_mint(msg.sender, tokenId);
_burn(msg.sender, 50);
}
function transferFrom(
    address from,
    address to,
    uint256 tokenId
) public virtual override {
    require(isMembershipToken[tokenId], "This token is not a membership token");
    super.transferFrom(from, to, tokenId);
}
}
