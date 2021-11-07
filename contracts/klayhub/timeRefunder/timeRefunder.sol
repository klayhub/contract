pragma solidity ^0.5.0;

import "../../token/KIP17/IKIP17Full.sol";
import "../../token/KIP7/IKIP7.sol";
import "../../token/KIP7/IKIP7Receiver.sol";
import "../../math/SafeMath.sol";
import "../../utils/Address.sol";
import "../../ownership/Ownable.sol";

// 추가로 필요한 기능들
// 1. hNFT 토큰 전송
// 2. 가격 변경 

contract timeRefunder is Ownable {
    using SafeMath for uint256;
    using Address for address;

    IKIP17Full public OLD_NFT;
    IKIP17Full public NEW_NFT;
    IKIP7 public PAYMENT;
    uint256 public PRICE = 100000000; // 100 dollor
    uint256 public STARTWHEN = 0; // FIXME this should be a timestamp
    address public MINTER;

    uint256 public lastSaleId=0;
    uint256 public lastRegisterId=0;
    mapping (uint256 => uint256) public NewId;

    event buy(address user, uint256 amount);

    constructor (address _OLD_NFT, address _NEW_NFT, address _PAYMENT) public {
        OLD_NFT = IKIP17Full(_OLD_NFT);
        NEW_NFT = IKIP17Full(_NEW_NFT);
        PAYMENT = IKIP7(_PAYMENT);
        MINTER = msg.sender;
    }

    function change(uint256 OldId) public payable started {
        OLD_NFT.transferFrom(msg.sender, address(this), OldId);
        PAYMENT.transferFrom(msg.sender, address(this), PRICE.mul(9));
        NEW_NFT.transferFrom(MINTER, msg.sender, NewId[OldId]);
    }

    function refund(uint256 OldId) public payable started {
        OLD_NFT.transferFrom(msg.sender, address(this), OldId);
        PAYMENT.transfer(msg.sender, PRICE.mul(1));
    }

    function register(uint256 OldId, uint256 _NewId) public onlyOwner {
        NewId[OldId] = _NewId;
    }

    function withdraw(uint256 amount) public onlyOwner {
        PAYMENT.transfer(msg.sender, amount);
    }
    

    modifier started {
        require(now >= STARTWHEN, "The sale has not started yet");
        _;
    }
}