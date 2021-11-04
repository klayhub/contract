pragma solidity ^0.5.0;

import "./timeSeller.sol";

// 추가로 필요한 기능들
// 1. hNFT 토큰 전송
// 2. 가격 변경 

contract timeSeller5000 is timeSeller {
    constructor (address _NFT, address _PAYMENT, uint256 _PRICE, uint256 _STARTWHEN) public timeSeller(_NFT, _PAYMENT, _PRICE, _STARTWHEN) {
        // solhint-disable-previous-line no-empty-blocks
    }
}