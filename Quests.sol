// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./HazelHeartsToken.sol";

contract Quests is Ownable {
uint public constant NUM_QUESTS = 5;
uint public constant REQUIRED_QUESTS = 3;
HazelHeartsToken public hazelHeartsToken;

struct QuestData {
    string description;
    bool completed;
}

mapping(uint => mapping(uint => QuestData)) public quests;

constructor(address _hazelHeartsTokenAddress) {
    hazelHeartsToken = HazelHeartsToken(_hazelHeartsTokenAddress);
    quests[1][1] = QuestData("Repost our tweet about HazelHearts", false);
    quests[1][2] = QuestData("Join our Discord server", false);
    quests[1][3] = QuestData("Follow our Instagram page", false);
    quests[1][4] = QuestData("Like our Facebook page", false);
    quests[1][5] = QuestData("Sign up for our newsletter", false);
    quests[2][1] = QuestData("Refer a friend to HazelHearts", false);
    quests[2][2] = QuestData("Create a blog post about HazelHearts", false);
    quests[2][3] = QuestData("Make a video about HazelHearts", false);
    quests[2][4] = QuestData("Submit a HazelHearts-related meme", false);
    quests[2][5] = QuestData("Attend a HazelHearts event", false);
    quests[3][1] = QuestData("Buy a HazelHearts NFT", false);
    quests[3][2] = QuestData("Harvest 10 of your hazelnut trees", false);
quests[3][3] = QuestData("Process hazelnuts with your processing equipment", false);
quests[3][4] = QuestData("Buy a second farm", false);
quests[3][5] = QuestData("Complete all quests in tier 2", false);
quests[4][1] = QuestData("Harvest 50 hazelnuts", false);
quests[4][2] = QuestData("Process 10 hazelnuts in a single transaction", false);
quests[4][3] = QuestData("Buy a third farm", false);
quests[4][4] = QuestData("Complete all quests in tier 3", false);
quests[4][5] = QuestData("Refer 5 friends to HazelHearts", false);
quests[5][1] = QuestData("Harvest 100 hazelnuts", false);
quests[5][2] = QuestData("Process 25 hazelnuts in a single transaction", false);
quests[5][3] = QuestData("Buy a fourth farm", false);
quests[5][4] = QuestData("Complete all quests in tier 4", false);
quests[5][5] = QuestData("Create a HazelHearts-related artwork", false);
}function completeQuest(uint tier, uint quest) external {
    require(tier >= 1 && tier <= NUM_QUESTS, "Invalid tier number");
    require(quest >= 1 && quest <= NUM_QUESTS, "Invalid quest number");
    QuestData storage questData = quests[tier][quest];
    require(!questData.completed, "Quest already completed");
    require(hazelHeartsToken.balanceOf(msg.sender) >= 1, "You don't have enough HazelHearts tokens");
    hazelHeartsToken.transferFrom(msg.sender, address(this), 1);
    questData.completed = true;
}

function getNumCompletedQuests(address account) external view returns (uint) {
    uint numCompleted = 0;
    for (uint i = 1; i <= NUM_QUESTS; i++) {
        if (isQuestCompleted(account, i)) {
            numCompleted++;
        }
    }
    return numCompleted;
}

function isQuestCompleted(address account, uint quest) public view returns (bool) {
    require(quest >= 1 && quest <= NUM_QUESTS, "Invalid quest number");
    uint numCompleted = 0;
    for (uint i = 1; i <= NUM_QUESTS; i++) {
        if (quests[i][quest].completed) {
            numCompleted++;
        }
    }
    return numCompleted >= REQUIRED_QUESTS && hazelHeartsToken.balanceOf(account) >= 1;
}
}
