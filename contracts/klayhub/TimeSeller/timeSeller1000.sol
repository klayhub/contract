pragma solidity ^0.5.0;

import "./timeSeller.sol";

// 추가로 필요한 기능들
// 1. hNFT 토큰 전송
// 2. 가격 변경 

contract timeSeller1000 is timeSeller {
    constructor (address nft, uint256 _PRICE, uint256 _startWhen) public timeSeller(nft, _PRICE, _startWhen) {
        // solhint-disable-previous-line no-empty-blocks
    }
}