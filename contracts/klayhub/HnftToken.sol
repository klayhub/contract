pragma solidity >=0.4.25 <0.7.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";

contract hnftToken is ERC20,ERC20Detailed {

    constructor () public ERC20Detailed("hNFT Token", "hNFT", 18) {
        _mint(msg.sender, 1000000 * (10 ** 18));
    }
}