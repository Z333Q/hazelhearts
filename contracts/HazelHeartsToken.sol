pragma solidity 0.8.18;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract HazelHeartsToken is ERC20, Ownable {
    constructor() ERC20("HazelHeartsToken", "HHT") {}

    function mintTokens(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}

contract HazelHeartsMembership is ERC721Enumerable, Ownable {
    uint256 public constant MAX_MEMBERSHIPS = 1000;

    uint256 public numMemberships;
    mapping(uint256 => bool) public isMembershipToken;
    mapping(uint256 => bool) public hasHarvested;

    HazelHeartsToken public hht;

    constructor(HazelHeartsToken _hht) ERC721("HazelHeartsMembership", "HHM") {
        hht = _hht;
    }

    function mint(address to, uint256 amount) external onlyOwner {
        hht.mintTokens(to, amount);
    }

    function harvest(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "You don't own this token");
        require(!hasHarvested[tokenId], "You've already harvested this month");
        require(
            isMembershipToken[tokenId],
            "This token is not a membership token"
        );
        hasHarvested[tokenId] = true;
        hht.mintTokens(msg.sender, 5);
    }

    function buyMembership() external {
        require(
            numMemberships < MAX_MEMBERSHIPS,
            "All memberships have been sold"
        );
        require(
            hht.balanceOf(msg.sender) >= 50,
            "You don't have enough HazelHearts tokens"
        );
        numMemberships++;
        uint256 tokenId = super.totalSupply() + 1;
        isMembershipToken[tokenId] = true;
        _mint(msg.sender, tokenId);
        hht.transferFrom(msg.sender, address(this), 50);
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override(ERC721, IERC721) {
        require(
            isMembershipToken[tokenId],
            "This token is not a membership token"
        );
        super.transferFrom(from, to, tokenId);
    }
}
