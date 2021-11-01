pragma solidity ^0.5.0;

import "../../token/KIP17/IKIP17Full.sol";

contract timeSeller{

    IKIP17Full public NFT;

    event buy(address user, uint amount);

    constructor (address nft) public {
        NFT = IKIP17Full(nft);
    }

    function BuyTime(uint price, uint amount) public payable {
        require(msg.value == price * amount, "You must pay the correct amount");
        NFT.send
        emit buy(msg.sender, amount);
    }
}