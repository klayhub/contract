pragma solidity ^0.5.0;

import "../../token/KIP17/IKIP17Full.sol";
import "../../token/KIP7/IKIP7.sol";
import "../../token/KIP7/IKIP7Receiver.sol";
import "../../math/SafeMath.sol";
import "../../utils/Address.sol";
import "../../ownership/Ownable.sol";
import "./StructuredLinkedList.sol";


// Token = NFT token

contract NFT is IKIP17Full, Ownable {}

contract MarketPlace is Ownable {
    using SafeMath for uint256;
    using Address for address;
    using StructuredLinkedList for StructuredLinkedList.List;

    StructuredLinkedList.List List;
    mapping (address => StructuredLinkedList.List) ListOfOwner;

    
    IKIP7 private KUSDT=IKIP7(0xceE8FAF64bB97a73bb51E115Aa89C17FfA8dD167);

    uint256 private cumulativeSales;
    mapping (uint256 => address payable) private OwnerById;
    mapping (uint256 => address) private TokenById;
    mapping (uint256 => uint256) private TokenIdById;
    mapping (uint256 => uint256) private PriceById;
    mapping (uint256 => bool) private IsKUSDTById;

    address payable private Foundation;
    uint256 private FoundationFeeRate;
    mapping (address => address payable) private OriginatorByToken;
    mapping (address => uint256) private OriginatorFeeRateByToken;

    // Sell the NFT (Klay or USDT)
    function Sell(address _token, uint256 _tokenId, bool _isKUSDT, uint256 _price) public { 
        require(_tokenId != 0);
        require(_price > 0);
        require(_isKUSDT == true);

        // transfer NFT seller->Contract
        NFT(_token).transferFrom(msg.sender, address(this), _tokenId);

        // make offer
        uint256 id = cumulativeSales++;
        OwnerById[id] = msg.sender;
        TokenById[id] = _token;
        TokenIdById[id] = _tokenId;
        PriceById[id] = _price;
        IsKUSDTById[id] = _isKUSDT;

        // add to list
        List.push(id, true);
        ListOfOwner[msg.sender].push(id, true);

    }

    // Buy the NFT 
    function Buy(uint256 id) public payable {
        require(List.nodeExists(id), "Offer does not exist");

        // transfer NFT Contract->buyer
        NFT(TokenById[id]).transferFrom(address(this), msg.sender, TokenIdById[id]);

        // remove from list
        List.remove(id);
        ListOfOwner[msg.sender].remove(id);

        // Purchase the NFT
        uint256 price = PriceById[id];
        uint256 FeeOriginator = price.div(10000).mul(OriginatorFeeRateByToken[TokenById[id]]);
        uint256 FeeFoundation = price.div(10000).mul(FoundationFeeRate); 
        uint256 FeeTotal = FeeOriginator + FeeFoundation;
        if(IsKUSDTById[id]){
            if(FeeOriginator>0) IKIP7(TokenById[id]).transferFrom(msg.sender, OriginatorByToken[TokenById[id]], FeeOriginator);
            if(FeeFoundation>0) IKIP7(TokenById[id]).transferFrom(msg.sender, Foundation, FeeFoundation);
            IKIP7(TokenById[id]).transferFrom(msg.sender, OwnerById[id], price.sub(FeeTotal));
        }
        else {
            require(msg.value == PriceById[id], "You must pay the price");
            if(FeeOriginator>0) OriginatorByToken[TokenById[id]].transfer(FeeOriginator);
            if(FeeFoundation>0) Foundation.transfer(FeeFoundation);
            OwnerById[id].transfer(price.sub(FeeTotal));
        }

    }


    
    function ListCount() public view returns (uint256) {
        return List.sizeOf();
    }
    function ListCount(address Owner) public view returns (uint256) {
        return ListOfOwner[Owner].sizeOf();
    }

    function ListOffer(uint256 offset, uint256 size) public view returns (uint256[] memory tokenIds) {
        uint256[] memory ids = new uint256[](size);
        bool exists;
        uint256 id;
        ids[0] = offset;

        for(uint256 i = 0; i < size; i++) {
            (exists, id) = List.getNextNode(ids[i]);
            if(!exists) break;
            ids[i+1] = id;
        }
        
        return ids;
    }

    function ListOffer(address Owner, uint256 offset, uint256 size) public view returns (uint256[] memory tokenIds) {
        uint256[] memory ids = new uint256[](size);
        bool exists;
        uint256 id;

        ids[0] = offset;
        for(uint256 i = 0; i < size; i++) {
            (exists, id) = ListOfOwner[Owner].getNextNode(ids[i]);
            if(!exists) break;
            ids[i+1] = id;
        }
        
        return ids;
    }

    function Info(uint256 id) public view returns (address owner, address token, uint256 tokenId, uint256 price, bool isKUSDT) {
        return (OwnerById[id], TokenById[id], TokenIdById[id], PriceById[id], IsKUSDTById[id]);
    }



    function Addr2uint(address Addr) internal pure returns(uint256) {
        return uint256(uint160(Addr));
    }

    // set foundation fee rate
    function SetFoundationFeeRate(uint256 _foundationFeeRate) public onlyOwner {
        FoundationFeeRate = _foundationFeeRate;
    }

    // set foundation address
    function SetFoundation(address payable _foundation) public onlyOwner {
        Foundation = _foundation;
    }

    // set originator fee rate
    function SetOriginatorFeeRate(address _token, uint256 _originatorFeeRate) public {
        require(OriginatorByToken[_token] == msg.sender, "You are not the originator of this token");
        OriginatorFeeRateByToken[_token] = _originatorFeeRate;
    }

    // set originator address
    function SetOriginator(address _token, address payable _originator) public onlyOwner {
        OriginatorByToken[_token] = _originator;
    }

    // set originator for token owner
    function SetOriginator(address _token) public {
        require(NFT(_token).isOwner(), "Invalid originator");
        SetOriginator(_token, msg.sender);
    }
    
}