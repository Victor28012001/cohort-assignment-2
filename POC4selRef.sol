pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract SafeNFT is ERC721Enumerable {
    uint256 public price;
    uint256 public pot;
    address public winner;
    mapping(address => bool) public canClaim;

    constructor(string memory tokenName, string memory tokenSymbol, uint256 _price) ERC721(tokenName, tokenSymbol) {
        price = _price; // e.g. price = 0.01 ETH
    }

    function buyNFT() external payable {
        require(price == msg.value, "INVALID_VALUE");
        canClaim[msg.sender] = true;
    }

    function claim() external {
        require(canClaim[msg.sender], "CANT_MINT");
        _safeMint(msg.sender, totalSupply());
        canClaim[msg.sender] = false;
    }

    function selectWinner() external {
        require(winner == address(0), "Winner already selected");
        winner = msg.sender;
    }

    function refund() external {
        require(winner == address(0), "Winner already selected");
        require(msg.sender != winner, "Winner cannot refund");
        payable(msg.sender).transfer(price);
    }
}