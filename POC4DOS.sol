pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract SafeNFT is ERC721Enumerable {
    uint256 public price;
    mapping(address => bool) public canClaim;
    address[] public participants;
    bool public winnerSelected;

    constructor(string memory tokenName, string memory tokenSymbol, uint256 _price) ERC721(tokenName, tokenSymbol) {
        price = _price; // e.g. price = 0.01 ETH
    }

    function buyNFT() external payable {
        require(price == msg.value, "INVALID_VALUE");
        canClaim[msg.sender] = true;
        participants.push(msg.sender); // Add participant
    }

    function claim() external {
        require(canClaim[msg.sender], "CANT_MINT");
        _safeMint(msg.sender, totalSupply());
        canClaim[msg.sender] = false;
    }

    function selectWinner() external {
        require(!winnerSelected, "Winner already selected");
        winnerSelected = true;
        // Simulate some selection logic (e.g., random selection)
        uint256 index = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % participants.length;
        address winner = participants[index];
        // Reward the winner
        // In a real scenario, you would transfer tokens or perform some action
        // For simplicity, we'll emit an event here
        emit WinnerSelected(winner);
    }

    function refund() external {
        require(!winnerSelected, "Winner already selected");
        // Simulate refund logic (return funds to participants)
        for (uint256 i = 0; i < participants.length; i++) {
            payable(participants[i]).transfer(price);
        }
        delete participants; // Clear participants array
    }

    event WinnerSelected(address winner);
}