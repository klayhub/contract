pragma solidity ^0.5.0;

import "../../token/KIP17/IKIP17Full.sol";
import "../../token/KIP7/IKIP7.sol";
import "../../token/KIP7/IKIP7Receiver.sol";
import "../../math/SafeMath.sol";
import "../../utils/Address.sol";
import "../../ownership/Ownable.sol";
import "./StructuredLinkedList.sol";


// Token = NFT token

contract MarketPlace is Ownable {
    using SafeMath for uint256;
    using Address for address;
    using StructuredLinkedList for StructuredLinkedList.List;

    StructuredLinkedList.List List;
    mapping (address => StructuredLinkedList.List) ListOfOwner;

    
    IKIP7 public KUSDT=IKIP7(0xceE8FAF64bB97a73bb51E115Aa89C17FfA8dD167);

    uint256 public cumulativeSales;
    mapping (uint256 => address payable) public OwnerById;
    mapping (uint256 => address) public TokenById;
    mapping (uint256 => uint256) public TokenIdById;
    mapping (uint256 => uint256) public PriceById;
    mapping (uint256 => bool) public IsKUSDTById;



 

    // Sell the NFT (Klay or USDT)
    function Sell(address _token, uint256 _tokenId, bool _isKUSDT, uint256 _price) public { 
        require(_tokenId != 0);
        require(_price > 0);
        require(_isKUSDT == true);

        // transfer NFT seller->Contract
        IKIP17Full(_token).transferFrom(msg.sender, address(this), _tokenId);

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
        IKIP17Full(TokenById[id]).transferFrom(address(this), msg.sender, TokenIdById[id]);

        // remove from list
        List.remove(id);
        ListOfOwner[msg.sender].remove(id);

        // Purchase the NFT
        if(IsKUSDTById[id]) 
            IKIP7(TokenById[id]).transferFrom(msg.sender, OwnerById[id], TokenIdById[id]);
        else {
            require(msg.value == PriceById[id], "You must pay the price");
            OwnerById[id].transfer(msg.value);
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
    
}