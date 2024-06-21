pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract SafeNFT is ERC721Enumerable {
    uint256 public price;
    mapping(address => bool) public canClaim;
    address public owner;
    uint256 public totalFees;

    constructor(string memory tokenName, string memory tokenSymbol, uint256 _price) ERC721(tokenName, tokenSymbol) {
        price = _price; // e.g. price = 0.01 ETH
        owner = msg.sender;
    }

    function buyNFT() external payable {
        require(price == msg.value, "INVALID_VALUE");
        canClaim[msg.sender] = true;
        totalFees += msg.value;
    }

    function claim() external {
        require(canClaim[msg.sender], "CANT_MINT");
        _safeMint(msg.sender, totalSupply());
        canClaim[msg.sender] = false;
    }

    function withdrawFees(uint256 amount) external {
        require(msg.sender == owner, "Only owner can withdraw");
        require(amount == totalFees, "Withdraw amount must equal total fees");
        
        totalFees = 0;
        payable(owner).transfer(amount);
    }

    // Function to check total fees accumulated
    function getTotalFees() external view returns (uint256) {
        return totalFees;
    }
}