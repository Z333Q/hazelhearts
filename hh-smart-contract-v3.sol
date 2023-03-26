// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

contract HazelHeartsGame {
// Define state variables
struct Player {
    uint256 tokens;
    uint256 rareTreesOwned;
    uint256 commonTreesOwned;
    mapping(uint256 => uint256) nftBalances;
}

mapping(address => Player) public players;
uint256 public totalTokens;
uint256 public totalNfts;
uint256 public hazelHeartsPerEth;
uint256 public nftValue;
uint256 public floorPrice;
uint256 public maxSupply;
uint256 public rareTreeCost;
uint256 public rareTreeYieldMin;
uint256 public rareTreeYieldMax;
uint256 public commonTreeYieldMin;
uint256 public commonTreeYieldMax;
uint256 public seasonalYieldMultiplier;
uint256 public nftRarityValueMultipliers;
uint256 public landPurchaseCostMin;
uint256 public landPurchaseCostMax;
uint256 public resourceCostsMin;
uint256 public resourceCostsMax;
uint256 public questRewardsMin;
uint256 public questRewardsMax;
uint256 public educationalQuestRewardMin;
uint256 public educationalQuestRewardMax;
uint256 public weatherEventLossMin;
uint256 public weatherEventLossMax;
uint256 public squirrelEventLossMin;
uint256 public squirrelEventLossMax;
uint256 public protectiveMeasureCostsMin;
uint256 public protectiveMeasureCostsMax;
uint256 public milestoneRewardsMin;
uint256 public milestoneRewardsMax;
uint256 public guildQuestRewardsMin;
uint256 public guildQuestRewardsMax;
uint256 public deflationaryEventLossMin;
uint256 public deflationaryEventLossMax;
uint256 public teamAndAdvisorsAllocation;
uint256 public developmentAndOperationsAllocation;
uint256 public marketingAndPartnershipsAllocation;
uint256 public inGameRewardsAllocation;
uint256 public hazelnutVarietiesAllocation;
uint256 public treeGrowthUpgradesBreedingAllocation;
uint256 public landExpansionFarmManagementAllocation;
uint256 public dynamicQuestsCompetitionsAllocation;
uint256 public nftBasedFarmCustomizationAllocation;
uint256 public playerReputationRankingAllocation;
uint256 public guildsCommunityBuildingAllocation;
uint256 public educationalContentRealLifeApplicationsAllocation;
uint256 public deflationaryMechanicsAllocation;
uint256 public teamAndAdvisorsShare;
uint256 public teamAndAdvisorsLockTime;
uint256 public teamAndAdvisorsUnlockTime;
uint256 public startTime;
uint256 public endTime;
uint256 public nonce;

// Define events
event TokensMinted(uint256 amount);
event TokensTransferred(address indexed from, address indexed to, uint256 amount);
event NFTMinted(address indexed player, uint256 tokenId, uint256 rarity);
event NFTTransferred(address indexed from, address indexed to, uint256 tokenId);
event NFTBurned(address indexed player, uint256 tokenId);
event LandPurchased(address indexed player, uint256 cost);
event RareTreePurchased(address indexed player, uint256 cost);
event RareTreeBred(address indexed player, uint256 cost);
event CommonTreePurchased(address indexed player, uint256 cost);
event ResourcesPurchased(address indexed player, uint256 cost);
event QuestCompleted(address indexed player, uint256 reward);
event GuildQuestCompleted(address player, uint256 reward);
event MilestoneAchieved(address player, uint256 reward);
event NFTCustomizationPurchased(address player, uint256 cost);

// Constructor function
constructor() {
    // Set parameters
    total_tokens = 800000;
    total_nfts = 10000;
    hazelhearts_per_eth = 100;
    nft_value = 0;
    floor_price = 1e18;
    max_supply = 5000000;
    rare_tree_cost = 50;
    rare_tree_yield_min = 1;
    rare_tree_yield_max = 2;
    common_tree_yield_min = 0.25;
    common_tree_yield_max = 0.5;
    seasonal_yield_multiplier = 0.5;
    nft_rarity_value_multipliers = 5;
    land_purchase_cost_min = 50;
    land_purchase_cost_max = 500;
    resource_costs_min = 1;
    resource_costs_max = 10;
    quest_rewards_min = 5;
    quest_rewards_max = 50;
    educational_quest_reward_min = 5;
    educational_quest_reward_max = 20;
    weather_event_loss_min = 10;
    weather_event_loss_max = 50;
    squirrel_event_loss_min = 10;
    squirrel_event_loss_max = 30;
    protective_measure_costs_min = 5;
    protective_measure_costs_max = 50;
    milestone_rewards_min = 1;
    milestone_rewards_max = 10;
    guild_quest_rewards_min = 10;
    guild_quest_rewards_max = 100;
    deflationary_event_loss_min = 5;
    deflationary_event_loss_max = 25;
    team_and_advisors_allocation = 20;
    development_and_operations_allocation = 20;
    marketing_and_partnerships_allocation = 20;
    in_game_rewards_allocation = 30;
    hazelnut_varieties_allocation = 50;
    tree_growth_upgrades_breeding_allocation = 20;
    land_expansion_farm_management_allocation = 10;
    dynamic_quests_competitions_allocation = 10;
    nft_based_farm_customization_allocation = 5;
    player_reputation_ranking_allocation = 3;
    guilds_community_building_allocation = 1;
    educational_content_real_life_applications_allocation = 1;
    deflationary_mechanics_allocation = 10;
    team_and_advisors_share = 25;
    team_and_advisors_lock_time = 1640995200;
    team_and_advisors_unlock_time = 1672531200;
    start_time = block.timestamp;
    end_time = block.timestamp + 365 days;

    // Mint initial tokens
    players[msg.sender].tokens += total_tokens;
    emit TokensMinted(total_tokens);
}

// Define functions
function transferTokens(address recipient, uint256 amount) external {
    // Check if the sender has enough tokens
    require(players[msg.sender].tokens >= amount, "Insufficient tokens");

    // Subtract tokens from the sender
    players[msg.sender].tokens -= amount;

    // Add tokens to the recipient
    players[recipient].tokens += amount;

    emit TokensTransferred(msg.sender, recipient, amount);
}

function mintNFT() external {
    // Check if there are any NFTs left to mint
    require(nfts_sold < total_nfts, "All NFTs have been sold");

    // Check if the sender has enough tokens to purchase the NFT
    require(players[msg.sender].tokens >= nft_value, "Insufficient tokens");

    // Increment the NFT sold counter
    nfts_sold++;

// Update the NFT value based on token value and rarity
        nft_value = calculateNftValue();

        // Mint the NFT to the buyer
        players[msg.sender].nft_balances[nfts_sold] += 1;

        // Emit an event
        emit NftMinted(msg.sender, nfts_sold, rarity);
    }

    // Transfer the tokens from the buyer to the seller
    players[msg.sender].tokens -= current_price;
    players[recipient].tokens += current_price;

    // Emit an event
    emit TokensTransferred(msg.sender, recipient, current_price);

    // Update the floor price
    floor_price = next_price;

    // Update the hazelhearts per eth rate
    hazelhearts_per_eth += hazelhearts_per_eth / 1000;

    // Return the updated state variables
    return (players[msg.sender].tokens, players[recipient].tokens, nft_value, floor_price, hazelhearts_per_eth, max_supply, total_tokens, total_nfts);
}

/**
 * @dev Purchase a rare tree for the given price.
 */
function purchaseRareTree() external {
    // Check that the buyer has enough tokens
    require(players[msg.sender].tokens >= rare_tree_cost, "Insufficient tokens to purchase rare tree");

    // Increment the number of rare trees owned by the buyer
    players[msg.sender].rare_trees_owned++;

    // Subtract the cost of the rare tree from the buyer's tokens
    players[msg.sender].tokens -= rare_tree_cost;

    // Emit an event
    emit RareTreePurchased(msg.sender, rare_tree_cost);
}

/**
 * @dev Breed two rare trees for the given price.
 */
function breedRareTree(uint256 tree1, uint256 tree2) external {
    // Check that the buyer has enough rare trees to breed
    require(players[msg.sender].rare_trees_owned >= 2, "Insufficient rare trees to breed");

    // Check that the tree IDs are valid
    require(tree1 > 0 && tree1 <= players[msg.sender].rare_trees_owned && tree2 > 0 && tree2 <= players[msg.sender].rare_trees_owned, "Invalid tree IDs");

    // Get the rarity of each tree
    uint256 rarity1 = getRandomNumber(1, 100);
    uint256 rarity2 = getRandomNumber(1, 100);

    // Calculate the cost of breeding the two trees
    uint256 breeding_cost = getRandomNumber(rare_tree_cost * 2, rare_tree_cost * 5);

    // Check that the buyer has enough tokens to pay for the breeding cost
    require(players[msg.sender].tokens >= breeding_cost, "Insufficient tokens to breed rare tree");

    // Subtract the cost of breeding from the buyer's tokens
    players[msg.sender].tokens -= breeding_cost;

    // Mint a new rare tree NFT to the buyer
    uint256 new_tree_id = total_nfts + 1;
    uint256 new_rarity = (rarity1 + rarity2) / 2;
    players[msg.sender].nft_balances[new_tree_id] += 1;
    total_nfts++;

    // Decrement the number of rare trees owned by the buyer
    players[msg.sender].rare_trees_owned -= 2;

    // Emit an event
    emit RareTreeBred(msg.sender, breeding_cost);

    // Transfer any excess tokens back to the buyer
    uint256 excess_tokens = players[msg.sender].tokens - breeding_cost;
    if (excess_tokens > 0) {
        players[msg.sender].tokens
+= excess_tokens;
}
// Emit events
emit RareTreeBred(msg.sender, breeding_cost);
emit TokensTransferred(msg.sender, address(this), breeding_cost);
}

/**

@dev Allows a player to purchase a common tree for a specified cost.
*/
function purchaseCommonTree() external {
require(players[msg.sender].tokens >= common_tree_cost, "Insufficient tokens to purchase a common tree");

// Decrement player tokens and increment tree count
players[msg.sender].tokens -= common_tree_cost;
players[msg.sender].common_trees_owned++;

// Emit events
emit CommonTreePurchased(msg.sender, common_tree_cost);
emit TokensTransferred(msg.sender, address(this), common_tree_cost);
}

/**

@dev Allows a player to purchase resources for a specified cost.

@param resource_type The type of resource being purchased.

@param quantity The amount of the resource being purchased.
*/
function purchaseResources(uint256 resource_type, uint256 quantity) external {
require(resource_type < resources.length, "Invalid resource type");
require(quantity > 0, "Quantity must be greater than zero");
require(players[msg.sender].tokens >= resource_costs[resource_type] * quantity, "Insufficient tokens to purchase resources");

// Decrement player tokens and increment resource count
uint256 cost = resource_costs[resource_type] * quantity;
players[msg.sender].tokens -= cost;
players[msg.sender].resources_owned[resource_type] += quantity;

// Emit events
emit ResourcesPurchased(msg.sender, cost);
emit TokensTransferred(msg.sender, address(this), cost);
}

/**

@dev Allows a player to complete a quest and earn a reward.

@param quest_type The type of quest being completed.
*/
function completeQuest(uint256 quest_type) external {
require(quest_type < quests.length, "Invalid quest type");

// Generate a random reward within the specified range
uint256 reward = getRandomNumber(quest_rewards_min[quest_type], quest_rewards_max[quest_type]);

// Increment player tokens
players[msg.sender].tokens += reward;

// Emit events
emit QuestCompleted(msg.sender, reward);
emit TokensTransferred(address(this), msg.sender, reward);
}

/**

@dev Allows a player to complete a guild quest and earn a reward.

@param quest_type The type of guild quest being completed.
*/
function completeGuildQuest(uint256 quest_type) external {
require(quest_type < guild_quests.length, "Invalid guild quest type");

// Generate a random reward within the specified range
uint256 reward = getRandomNumber(guild_quest_rewards_min, guild_quest_rewards_max);

// Increment player tokens
players[msg.sender].tokens += reward;

// Emit events
emit GuildQuestCompleted(msg.sender, reward);
emit TokensTransferred(address(this), msg.sender, reward);
}

/**

@dev Allows a player to achieve a milestone and earn a reward.

@param milestone_type The type of milestone being achieved.
*/
function achieveMilestone(uint256 milestone_type) external {
require(milestone_type < milestones.length, "Invalid milestone type");

// Generate a random reward within the specified range
uint256 reward = getRandomNumber(milestone_rewards_min, milestone_rewards_max);

// Increment player tokens
players[msg.sender].tokens += reward;

// Emit events
emit MilestoneAchieved(msg.sender, reward);
emit TokensTransferred(address(this), msg.sender, reward);
}

/**

@dev Allows a player to purchase an NFT-based farm customization option for a specified cost.
@param nft_type The type of NFT being purchased.
*/
function purchaseNFTCustomization(uint256 nft_type, uint256 nft_index) external {
// Ensure that the player has enough tokens to purchase the NFT customization
require(players[msg.sender].tokens >= nft_value, "Insufficient tokens to purchase NFT customization");
// Ensure that the specified NFT index exists for the given NFT type
    require(nft_index < players[msg.sender].nft_balances[nft_type], "Invalid NFT index");
    
    // Subtract tokens from the player's account and add the NFT customization to their inventory
    players[msg.sender].tokens -= nft_value;
    players[msg.sender].nft_balances[nft_type] -= 1;
    players[msg.sender].nft_balances[nft_index] += 1;
    
    emit NFTCustomizationPurchased(msg.sender, nft_value);
}

/**
 * @dev Calculate the value of an NFT based on its rarity and the current value of HazelHearts tokens.
 * 
 * @param rarity The rarity value of the NFT.
 * 
 * @return The calculated value of the NFT.
 */
function calculateNFTValue(uint256 rarity) internal view returns (uint256) {
    uint256 rarity_multiplier = nft_rarity_value_multipliers ** rarity;
    uint256 current_price = floor_price * hazelhearts_per_eth;
    return rarity_multiplier * current_price;
}

/**
 * @dev Calculate the current price of HazelHearts tokens based on the current floor price and the total supply.
 * 
 * @return The calculated price of HazelHearts tokens.
 */
function calculateTokenPrice() internal view returns (uint256) {
    uint256 current_price = floor_price * hazelhearts_per_eth;
    uint256 supply_ratio = total_tokens / total_tokens;
    uint256 next_price = current_price * (supply_ratio ** (-1));
    return next_price;
}

/**
 * @dev Update the price of HazelHearts tokens based on market demand and supply.
 */
function updateTokenPrice() internal {
    uint256 current_price = calculateTokenPrice();
    hazelhearts_per_eth = current_price / floor_price;
}

/**
 * @dev Mint new HazelHearts tokens and distribute them according to the specified allocations.
 * 
 * @param amount The total number of HazelHearts tokens to mint.
 */
function mintTokens(uint256 amount) internal {
    // Mint new tokens and add them to the total supply
    total_tokens += amount;
    
    // Distribute tokens to the specified allocations
    uint256 team_and_advisors_share = amount * team_and_advisors_allocation;
    uint256 development_and_operations_share = amount * development_and_operations_allocation;
    uint256 marketing_and_partnerships_share = amount * marketing_and_partnerships_allocation;
    uint256 in_game_rewards_share = amount * in_game_rewards_allocation;
    uint256 hazelnut_varieties_share = amount * hazelnut_varieties_allocation;
    uint256 tree_growth_upgrades_breeding_share = amount * tree_growth_upgrades_breeding_allocation;
    uint256 land_expansion_farm_management_share = amount * land_expansion_farm_management_allocation;
    uint256 dynamic_quests_competitions_share = amount * dynamic_quests_competitions_allocation;
    uint256 nft_based_farm_customization_share = amount * nft_based_farm_customization_allocation;
    uint256 player_reputation_ranking_share = amount * player_reputation_ranking_allocation;
    uint256 guilds_community_building_share = amount * guilds_community_building_allocation;
    uint256 educational_content_real_life_applications_share = amount * educational_content_real_life_applications_allocation
    / 100;
uint256 deflationary_mechanics_share = amount
    * deflationary_mechanics_allocation
    / 100;

// Update state variables
hazelhearts_per_eth += hazelhearts_per_eth * in_game_rewards_share / amount;
rare_tree_yield_min += rare_tree_yield_min * hazelnut_varieties_share / amount;
rare_tree_yield_max += rare_tree_yield_max * hazelnut_varieties_share / amount;
common_tree_yield_min += common_tree_yield_min * hazelnut_varieties_share / amount;
common_tree_yield_max += common_tree_yield_max * hazelnut_varieties_share / amount;
seasonal_yield_multiplier += seasonal_yield_multiplier * hazelnut_varieties_share / amount;
rare_tree_cost += rare_tree_cost * tree_growth_upgrades_breeding_share / amount;
land_purchase_cost_min += land_purchase_cost_min * land_expansion_farm_management_share / amount;
land_purchase_cost_max += land_purchase_cost_max * land_expansion_farm_management_share / amount;
resource_costs_min += resource_costs_min * land_expansion_farm_management_share / amount;
resource_costs_max += resource_costs_max * land_expansion_farm_management_share / amount;
quest_rewards_min += quest_rewards_min * dynamic_quests_competitions_share / amount;
quest_rewards_max += quest_rewards_max * dynamic_quests_competitions_share / amount;
educational_quest_reward_min += educational_quest_reward_min * educational_content_real_life_applications_share / amount;
educational_quest_reward_max += educational_quest_reward_max * educational_content_real_life_applications_share / amount;
weather_event_loss_min += weather_event_loss_min * deflationary_mechanics_share / amount;
weather_event_loss_max += weather_event_loss_max * deflationary_mechanics_share / amount;
squirrel_event_loss_min += squirrel_event_loss_min * deflationary_mechanics_share / amount;
squirrel_event_loss_max += squirrel_event_loss_max * deflationary_mechanics_share / amount;
protective_measure_costs_min += protective_measure_costs_min * deflationary_mechanics_share / amount;
protective_measure_costs_max += protective_measure_costs_max * deflationary_mechanics_share / amount;
milestone_rewards_min += milestone_rewards_min * player_reputation_ranking_share / amount;
milestone_rewards_max += milestone_rewards_max * player_reputation_ranking_share / amount;
guild_quest_rewards_min += guild_quest_rewards_min * guilds_community_building_share / amount;
guild_quest_rewards_max += guild_quest_rewards_max * guilds_community_building_share / amount;
deflationary_event_loss_min += deflationary_event_loss_min * deflationary_mechanics_share / amount;
deflationary_event_loss_max += deflationary_event_loss_max * deflationary_mechanics_share / amount;

// Distribute tokens to team and advisors, development and operations, and marketing and partnerships
uint256 team_and_advisors_tokens = amount * team_and_advisors_share / 100;
uint256 development_and_operations_tokens = amount * development_and_operations_allocation / 100;
uint256 marketing_and_partnerships_tokens = amount * marketing_and_partnerships_allocation / 100;

// Vest tokens for team and advisors
if (team_and_advisors_tokens > 0) {
    players[team_and_advisors_wallet].tokens += team_and_advisors_tokens;
    players[team_and_advisors_wallet].tokens_vesting +=
        team_and_advisors_tokens * team_and_advisors_lock_time / 100;
// Calculate the unlock time for team and advisors tokens
team_and_advisors_unlock_time = start_time + (team_and_advisors_lock_time * 1 days);

// Initialize state variables
total_tokens = in_game_rewards_allocation + hazelnut_varieties_allocation + tree_growth_upgrades_breeding_allocation +
land_expansion_farm_management_allocation + dynamic_quests_competitions_allocation + nft_based_farm_customization_allocation +
player_reputation_ranking_allocation + guilds_community_building_allocation + educational_content_real_life_applications_allocation +
deflationary_mechanics_allocation;

total_nfts = nft_based_farm_customization_allocation;

hazelhearts_per_eth = 1000;

nft_value = 1 ether;

floor_price = 1;

max_supply = 1000000;

rare_tree_cost = 20;

rare_tree_yield_min = 5;

rare_tree_yield_max = 10;

common_tree_yield_min = 1;

common_tree_yield_max = 3;

seasonal_yield_multiplier = 2;

nft_rarity_value_multipliers = [1, 2, 5];

land_purchase_cost_min = 50;

land_purchase_cost_max = 500;

resource_costs_min = 1;

resource_costs_max = 10;

quest_rewards_min = 5;

quest_rewards_max = 50;

educational_quest_reward_min = 5;

educational_quest_reward_max = 20;

weather_event_loss_min = 10;

weather_event_loss_max = 50;

squirrel_event_loss_min = 10;

squirrel_event_loss_max = 30;

protective_measure_costs_min = 5;

protective_measure_costs_max = 50;

milestone_rewards_min = 1;

milestone_rewards_max = 10;

guild_quest_rewards_min = 10;

guild_quest_rewards_max = 100;

deflationary_event_loss_min = 5;

deflationary_event_loss_max = 25;

// Set allocation percentages
team_and_advisors_allocation = 10;

development_and_operations_allocation = 20;

marketing_and_partnerships_allocation = 20;

in_game_rewards_allocation = 50;

hazelnut_varieties_allocation = 50;

tree_growth_upgrades_breeding_allocation = 20;

land_expansion_farm_management_allocation = 10;

dynamic_quests_competitions_allocation = 10;

nft_based_farm_customization_allocation = 5;

player_reputation_ranking_allocation = 3;

guilds_community_building_allocation = 1;

educational_content_real_life_applications_allocation = 1;

deflationary_mechanics_allocation = 10;

// Set team and advisors share and lock time
team_and_advisors_share = 10;

team_and_advisors_lock_time = 365;

// Set start and end times
start_time = block.timestamp;

end_time = start_time + (30 * 1 days);

// Mint team and advisors tokens
mintTokens(team_and_advisors_tokens, team_and_advisors_share, team_and_advisors_unlock_time);

// Mint development and operations tokens
mintTokens(total_tokens * development_and_operations_allocation / 100, 0, 0);

// Mint marketing and partnerships tokens
mintTokens(total_tokens * marketing_and_partnerships_allocation / 100, 0, 0);

// Mint hazelnut varieties tokens
mintTokens(total_tokens * hazelnut_varieties_allocation / 100, 0, 0);

// Mint tree growth, upgrades, and breeding tokens
mintTokens(total_tokens * tree_growth_upgrades_breeding_allocation / 100, 0, 0);

// Mint land expansion and farm management tokens
mintTokens(total_tokens * land_expansion_farm
/**

@dev Mint land expansion and farm management tokens
Mints new tokens to be distributed for land expansion and farm management
purposes. The amount of tokens minted is proportional to the land_expansion_farm_management_allocation
parameter defined at contract creation.
Emits a {TokensMinted} event.
*/
function mintLandExpansionFarmManagementTokens() external onlyOwner {
uint256 amount = total_tokens * land_expansion_farm_management_allocation / 100;
total_tokens += amount;
players[owner].tokens += amount;
emit TokensMinted(amount);
}
/**

@dev Purchase a plot of land
Allows the player to purchase a plot of land using their tokens. The cost of
the plot of land is randomly generated within a range defined by the
land_purchase_cost_min and land_purchase_cost_max parameters.
Emits a {LandPurchased} event.
*/
function purchaseLand() external {
uint256 cost = getRandomNumber(land_purchase_cost_min, land_purchase_cost_max);
require(players[msg.sender].tokens >= cost, "Insufficient tokens to purchase land");
players[msg.sender].tokens -= cost;
emit LandPurchased(msg.sender, cost);
}
/**

@dev Purchase a rare tree
Allows the player to purchase a rare tree using their tokens. The cost of the
rare tree is defined by the rare_tree_cost parameter.
Emits a {RareTreePurchased} event.
*/
function purchaseRareTree() external {
require(players[msg.sender].tokens >= rare_tree_cost, "Insufficient tokens to purchase rare tree");
players[msg.sender].tokens -= rare_tree_cost;
players[msg.sender].rare_trees_owned++;
emit RareTreePurchased(msg.sender, rare_tree_cost);
}
/**

@dev Breed a rare tree

Allows the player to breed two rare trees they own to create a new one. The

cost of breeding is defined by the rare_tree_cost parameter.

Emits a {RareTreeBred} event.
*/
function breedRareTree(uint256 tree1, uint256 tree2) external {
require(players[msg.sender].rare_trees_owned >= 2, "Insufficient rare trees to breed");
require(players[msg.sender].nft_balances[tree1] > 0, "Tree1 does not belong to player");
require(players[msg.sender].nft_balances[tree2] > 0, "Tree2 does not belong to player");
require(tree1 != tree2, "Cannot breed tree with itself");
require(players[msg.sender].tokens >= rare_tree_cost, "Insufficient tokens to breed rare tree");

// Burn the parent trees
players[msg.sender].nft_balances[tree1]--;
players[msg.sender].nft_balances[tree2]--;
if (players[msg.sender].nft_balances[tree1] == 0) {
nft_value -= calculateNFTValue(tree1);
emit NFTBurned(msg.sender, tree1);
}
if (players[msg.sender].nft_balances[tree2] == 0) {
nft_value -= calculateNFTValue(tree2);
emit NFTBurned(msg.sender, tree2);
}

// Mint the new tree and transfer the breeding cost
uint256 new_tree_rarity = (getRandomNumber(1, 100) <= 5) ? 2 : 1; // 5% chance of legendary rarity
uint256 new_tree_id = total_nfts + new_tree_rarity * 10 ** (total_nfts_digits -
// Increase the number of NFTs owned by the recipient
    players[recipient].nft_balances[tokenId]++;
    // Emit NFT transfer event
    emit NFTTransferred(msg.sender, recipient, tokenId);
}

/**
 * @dev Burns an NFT owned by the caller.
 * @param tokenId The ID of the NFT to burn.
 */
function burnNFT(uint256 tokenId) external {
    require(players[msg.sender].nft_balances[tokenId] > 0, "You don't own this NFT");

    // Extract the rarity value from the token ID
    uint256 rarity = (tokenId / 10 ** (total_nfts_digits - 1)) % 10;
    // Update the total supply and value of NFTs
    total_nfts--;
    nft_value -= rarity * nft_rarity_value_multipliers;
    // Reduce the number of NFTs owned by the caller
    players[msg.sender].nft_balances[tokenId]--;
    // Emit NFT burn event
    emit NFTBurned(msg.sender, tokenId);
}

/**
 * @dev Purchases a rare tree for the caller.
 */
function purchaseRareTree() external {
    require(players[msg.sender].tokens >= rare_tree_cost, "Insufficient tokens to purchase rare tree");

    // Mint the rare tree
    mintRareTree();
    // Decrement the caller's token balance by the cost of the rare tree
    players[msg.sender].tokens -= rare_tree_cost;
    // Increment the number of rare trees owned by the caller
    players[msg.sender].rare_trees_owned++;
    // Emit rare tree purchase event
    emit RareTreePurchased(msg.sender, rare_tree_cost);
}

/**
 * @dev Breeds two rare trees owned by the caller to create a new rare tree.
 * @param tree1 The ID of the first rare tree.
 * @param tree2 The ID of the second rare tree.
 */
function breedRareTree(uint256 tree1, uint256 tree2) external {
    require(players[msg.sender].rare_trees_owned >= 2, "Insufficient rare trees to breed");
    require(players[msg.sender].nft_balances[tree1] > 0 && players[msg.sender].nft_balances[tree2] > 0, "You don't own one or both of these trees");

    // Extract the rarity values of the parent trees
    uint256 rarity1 = (tree1 / 10 ** (total_nfts_digits - 1)) % 10;
    uint256 rarity2 = (tree2 / 10 ** (total_nfts_digits - 1)) % 10;
    // Determine the rarity of the offspring tree
    uint256 offspring_rarity = (rarity1 + rarity2) / 2;
    // Calculate the breeding cost based on the rarity of the offspring tree
    uint256 breeding_cost = rare_tree_cost * (offspring_rarity + 1);
    // Check if the caller has enough tokens to cover the breeding cost
    require(players[msg.sender].tokens >= breeding_cost, "Insufficient tokens to breed rare tree");

    // Mint the new rare tree
    mintRareTree();
    // Decrement the caller's token balance by the breeding cost
    players[msg.sender].tokens -= breeding_cost;
    // Increment the number of rare trees owned by the caller
    players[msg.sender].rare_trees_owned++;
    // Emit rare tree breeding event
    emit RareTreeBred(msg.sender, breeding_cost);
    // Transfer any excess tokens back to the buyer
    uint256 excess_tokens = players[msg.sender].tokens - breeding_cost
function breedRareTree(uint256 tree1, uint256 tree2) external {
require(players[msg.sender].rare_trees_owned >= 2, "Insufficient rare trees to breed");
require(players[msg.sender].nft_balances[tree1] > 0, "You do not own the first tree");
require(players[msg.sender].nft_balances[tree2] > 0, "You do not own the second tree");
require(tree1 != tree2, "Cannot breed a tree with itself");
// Determine the rarity of the offspring tree
uint256 rarity1 = (tree1 / 10 ** (total_nfts_digits - 1)) % 10;
uint256 rarity2 = (tree2 / 10 ** (total_nfts_digits - 1)) % 10;
uint256 rarity = (rarity1 + rarity2) / 2;

// Mint the new rare tree NFT and transfer to the breeder
uint256 new_tree_id = total_nfts + 1;
players[msg.sender].nft_balances[new_tree_id] = 1;
total_nfts++;

emit NFTMinted(msg.sender, new_tree_id, rarity);
emit RareTreeBred(msg.sender, rare_tree_cost);

// Deduct the breeding cost and update the number of rare trees owned by the breeder
players[msg.sender].rare_trees_owned++;
players[msg.sender].tokens -= rare_tree_cost;
}
function burnNFT(uint256 tokenId) external {
require(players[msg.sender].nft_balances[tokenId] > 0, "Player does not own this NFT");
// Extract the rarity value from the token ID
    uint256 rarity = (tokenId / 10 ** (total_nfts_digits - 1)) % 10;
    
    // Decrease NFT balance and update player's tokens based on NFT rarity value
    players[msg.sender].nft_balances[tokenId]--;
    players[msg.sender].tokens += nft_rarity_value_multipliers[rarity] * nft_value;
    
    emit NFTBurned(msg.sender, tokenId);
}

/**
 * @dev Purchase a land expansion, increasing the maximum number of trees that can be owned.
 * Emits a {LandPurchased} event indicating the player, cost and new maximum tree limit.
 * 
 * Requirements:
 * - The player must have enough tokens to purchase the land.
 */
function purchaseLandExpansion() external {
    require(players[msg.sender].tokens >= land_purchase_cost_min, "Insufficient tokens to purchase land expansion");
    
    // Deduct tokens from the player and increase max tree limit
    players[msg.sender].tokens -= land_purchase_cost_min;
    max_supply += 50;
    
    emit LandPurchased(msg.sender, land_purchase_cost_min, max_supply);
}

/**
 * @dev Purchase a rare tree, increasing the player's rare tree count and decreasing their token balance.
 * Emits a {RareTreePurchased} event indicating the player and cost.
 * 
 * Requirements:
 * - The player must have enough tokens to purchase the tree.
 */
function purchaseRareTree() external {
    require(players[msg.sender].tokens >= rare_tree_cost, "Insufficient tokens to purchase rare tree");
    
    // Deduct tokens from the player and increase rare tree count
    players[msg.sender].tokens -= rare_tree_cost;
    players[msg.sender].rare_trees_owned++;
    
    emit RareTreePurchased(msg.sender, rare_tree_cost);
}

/**
 * @dev Breed two rare trees together, creating a new rare tree and decreasing the player's token balance.
 * Emits a {RareTreeBred} event indicating the player and cost.
 * 
 * Requirements:
 * - The player must own at least two rare trees.
 * - The player must have enough tokens to pay for the breeding.
 */
function breedRareTree(uint256 tree1, uint256 tree2) external {
    require(players[msg.sender].rare_trees_owned >= 2, "Insufficient rare trees to breed");
    require(players[msg.sender].tokens >= rare_tree_cost, "Insufficient tokens to breed rare tree");
    
    // Deduct tokens from the player and increase rare tree count
    players[msg.sender].tokens -= rare_tree_cost;
    players[msg.sender].rare_trees_owned++;
    
    emit RareTreeBred(msg.sender, rare_tree_cost);
}

/**
 * @dev Purchase a common tree, increasing the player's common tree count and decreasing their token balance.
 * Emits a {CommonTreePurchased} event indicating the player and cost.
 * 
 * Requirements:
 * - The player must have enough tokens to purchase the tree.
 */
function purchaseCommonTree() external {
    require(players[msg.sender].tokens >= common_tree_cost, "Insufficient tokens to purchase common tree");
    
    // Deduct tokens from the player and increase common tree count
    players[msg.sender].tokens -= common_tree_cost;
    players[msg.sender].common_trees_owned++;
    
    emit CommonTreePriceased(msg.sender, common_tree_cost);
// Increment the number of common trees owned by the player
players[msg.sender].common_trees_owned++;

// Transfer tokens from the buyer to the contract owner
players[msg.sender].tokens -= common_tree_cost;
players[owner].tokens += common_tree_cost;
}

/**

@dev Allows a player to purchase resources.

@param resource_type The type of resource being purchased.
*/
function purchaseResources(uint256 resource_type) external {
// Get the cost of the resource
uint256 resource_cost = getRandomNumber(resource_costs_min, resource_costs_max);

// Ensure the player has enough tokens to purchase the resource
require(players[msg.sender].tokens >= resource_cost, "Insufficient tokens to purchase resources");

// Decrement the player's token balance and increment the total token supply
players[msg.sender].tokens -= resource_cost;
total_tokens += resource_cost;

// Emit a purchase event
emit ResourcesPurchased(msg.sender, resource_cost);

// Distribute resources based on the resource type
if (resource_type == 1) {
// Increase the player's common tree yield multiplier
players[msg.sender].common_tree_yield_multiplier++;
} else if (resource_type == 2) {
// Increase the player's rare tree yield multiplier
players[msg.sender].rare_tree_yield_multiplier++;
} else if (resource_type == 3) {
// Increase the player's seasonal yield multiplier
players[msg.sender].seasonal_yield_multiplier++;
} else {
revert("Invalid resource type");
}
}

/**

@dev Allows a player to complete a quest and receive a reward.

@param quest_type The type of quest being completed.
*/
function completeQuest(uint256 quest_type) external {
// Get the reward for the quest
uint256 quest_reward;
if (quest_type == 1) {
quest_reward = getRandomNumber(quest_rewards_min, quest_rewards_max);
} else if (quest_type == 2) {
quest_reward = getRandomNumber(educational_quest_reward_min, educational_quest_reward_max);
} else {
revert("Invalid quest type");
}

// Increase tokens of the player
players[msg.sender].tokens += quest_reward;

// Emit a quest completion event
emit QuestCompleted(msg.sender, quest_reward);
}

/**

@dev Allows a player to complete a guild quest and receive a reward.
*/
function completeGuildQuest() external {
// Get the reward for the guild quest
uint256 guild_quest_reward = getRandomNumber(guild_quest_rewards_min, guild_quest_rewards_max);

// Increase tokens of the sender
players[msg.sender].tokens += guild_quest_reward;

// Emit a guild quest completion event
emit GuildQuestCompleted(msg.sender, guild_quest_reward);
}

/**

@dev Allows a player to achieve a milestone and receive a reward.
*/
function achieveMilestone() external {
// Get the reward for the milestone
uint256 milestone_reward = getRandomNumber(milestone_rewards_min, milestone_rewards_max);

// Increase tokens of the player
players[msg.sender].tokens += milestone_reward;

// Emit a milestone achievement event
emit MilestoneAchieved(msg.sender, milestone_reward);
}

/**

@dev Allows a player to purchase an NFT customization.

@param nft_type The type of NFT being customized.
*/
function purchaseNFTCustomization(uint256 nft_type) external {
// Get the cost of the customization
uint256 customization_cost = getRandomNumber(nft_customization_costs_min, nft_customization_costs_max);

// Ensure the player has enough tokens to purchase the customization
require(players[msg.sender].tokens
// Calculate the cost of the customization
uint256 customization_cost = calculateNFTCustomizationCost(nft_type);

// Transfer tokens from the player to the contract
players[msg.sender].tokens -= customization_cost;
players[address(this)].tokens += customization_cost;

// Mint the customized NFT and transfer it to the player
total_nfts++;
uint256 new_nft_id = total_nfts;
uint256 rarity = nft_type % 10;
uint256 customization = getRandomNumber(1, 101);
uint256 new_nft_value = calculateNFTValue(rarity, customization);
players[msg.sender].nft_balances[new_nft_id] = new_nft_value;
emit NFTMinted(msg.sender, new_nft_id, rarity);
emit TokensTransferred(msg.sender, address(this), customization_cost);

// Update the value of the NFT
updateNFTValue();

return new_nft_id;

