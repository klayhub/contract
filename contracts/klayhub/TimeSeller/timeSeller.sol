pragma solidity ^0.5.0;

import "../../token/KIP17/IKIP17Full.sol";
import "../../math/SafeMath.sol";
import "../../utils/Address.sol";
import "../../ownership/Ownable.sol";

// 추가로 필요한 기능들
// 1. hNFT 토큰 전송
// 2. 가격 변경 

contract timeSeller is Ownable {
    using SafeMath for uint256;
    using Address for address;

    IKIP17Full public NFT;
    uint256 public PRICE = 0;
    uint256 public startWhen = 0; // FIXME this should be a timestamp

    address public minter;
    uint256 public lastSaleId=0;
    uint256 public lastRegisterId=0;
    mapping (uint256 => uint256) public tokenIdById;

    event buy(address user, uint256 amount);

    constructor (address nft, uint256 _PRICE, uint256 _startWhen) public {
        NFT = IKIP17Full(nft);
        PRICE = _PRICE;
        startWhen = _startWhen;
        minter = msg.sender;
    }

    function BuyTime(uint256 amount) public payable started {
        require(msg.value == PRICE * amount, "You must pay the correct amount");
        require(lastSaleId + amount <= lastRegisterId, "There are no more tokens to buy");
        for (uint256 i = 0; i < amount; i++) {
            _BuyTime(msg.sender);
        }
        emit buy(msg.sender, amount);
    }

    function register(uint256 tokenId) public onlyOwner {
        tokenIdById[lastRegisterId++] = tokenId;
    }

    function _BuyTime(address account) internal {
            NFT.transferFrom(minter, account, tokenIdById[lastSaleId++]);
    }

    modifier started {
        require(now >= startWhen, "The sale has not started yet");
        _;
    }
}