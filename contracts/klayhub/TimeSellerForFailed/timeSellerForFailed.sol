pragma solidity ^0.5.0;

import "../../token/KIP17/IKIP17Full.sol";
import "../../token/KIP7/IKIP7.sol";
import "../../token/KIP7/IKIP7Receiver.sol";
import "../../math/SafeMath.sol";
import "../../utils/Address.sol";
import "../../ownership/Ownable.sol";


contract timeSellerForFailed is Ownable {
    using SafeMath for uint256;
    using Address for address;

    IKIP17Full public NFT;
    IKIP7 public PAYMENT;
    uint256 public PRICE = 0;
    uint256 public STARTWHEN = 0; // FIXME this should be a timestamp
    address public MINTER;

    uint256 public lastSaleId=0;
    uint256 public lastRegisterId=0;
    mapping (uint256 => uint256) public tokenIdById;
    mapping (address => uint256) public addressCanBuy;

    event buy(address user, uint256 amount);

    constructor (address _NFT, address _PAYMENT, uint256 _PRICE, uint256 _STARTWHEN) public {
        NFT = IKIP17Full(_NFT);
        PAYMENT = IKIP7(_PAYMENT);
        PRICE = _PRICE;
        STARTWHEN = _STARTWHEN;
        MINTER = msg.sender;
    }

    function BuyTime(uint256 amount) public payable started {
        require(lastSaleId + amount <= lastRegisterId, "There are no more tokens to buy");
        require(amount <= addressCanBuy[msg.sender], "You can't buy at most specific tokens at a time");

        uint256 _before = PAYMENT.balanceOf(address(this));
        PAYMENT.transferFrom(msg.sender, address(this), PRICE.mul(amount));
        uint256 _after = PAYMENT.balanceOf(address(this));
        uint256 value = _after.sub(_before);
        require(value == PRICE.mul(amount), "You must pay the correct amount");

        for (uint256 i = 0; i < amount; i++) {
            _BuyTime(msg.sender);
        }
        emit buy(msg.sender, amount);
    }

    function register(uint256 tokenId) public onlyOwner {
        tokenIdById[lastRegisterId++] = tokenId;
    }
    function registerById(uint256 tokenId, uint256 id) public onlyOwner {
        if(tokenIdById[id]==0){
            lastRegisterId = lastRegisterId + 1;
        }
        tokenIdById[id] = tokenId;
    }

    function _BuyTime(address account) internal {
            NFT.safeTransferFrom(MINTER, account, tokenIdById[lastSaleId++]);
    }

    function withdraw(uint256 amount) public onlyOwner {
        PAYMENT.transfer(msg.sender, amount);
    }
    
    function setRegisterId(uint256 id) public onlyOwner {
        lastRegisterId = id;
    }

    function setLastSaleId(uint256 id) public onlyOwner {
        lastSaleId = id;
    }

    function setTime(uint256 time) public onlyOwner {
        STARTWHEN = time;
    }

    function setCanBuy(address account, uint256 amount) public onlyOwner {
        addressCanBuy[account] = amount;
    }

    modifier started {
        require(now >= STARTWHEN, "The sale has not started yet");
        _;
    }

}