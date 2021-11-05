pragma solidity ^0.5.0;

import "../../token/KIP17/KIP17Token.sol";
import "../../math/SafeMath.sol";
import "../../utils/Address.sol";
import "../../ownership/Ownable.sol";

// 추가로 필요한 기능들
// 1. hNFT 토큰 전송
// 2. 가격 변경 

contract nftMinter is Ownable {
    using SafeMath for uint256;
    using Address for address;

    uint256 public constant version = 1e17;
    uint256 public constant price = 1e10;
    uint256 public constant n = 1e5;
    uint256 public constant m = 1e0;
    
    KIP17Token public NFT;

    constructor(address _NFT) public {
        NFT = KIP17Token(_NFT);
    }
// 100001000000100001
// 10000100000000000000001
// 100001000008400100
// 100000000000000000 - version 
// 000001000000000000 -- price, 1000 dollor 
// 000000000008400000 -- n, 84
// 000000000000000100 -- m, 100 
    function mint(address _to, uint256 _price, uint256 _n, uint256 _m ) public onlyOwner {
        for (uint256 i = _n; i <= _m; i++) {
            uint256 tokenId = 1;
            tokenId = tokenId.mul(version).add(_price.mul(price)).add(i.mul(n)).add(_m.mul(m));
            require(NFT.mintWithTokenURI(_to, tokenId, concat("https://nft.klayhub.com/metadata/", concat(uint2str(tokenId),".json"))));
            if(i.sub(_n) == 20) break;
        }
    }

    function concat(string memory _a, string memory _b) pure internal returns (string memory){
        bytes memory bytes_a = bytes(_a);
        bytes memory bytes_b = bytes(_b);
        string memory length_ab = new string(bytes_a.length + bytes_b.length);
        bytes memory bytes_c = bytes(length_ab);
        uint k = 0;
        for (uint i = 0; i < bytes_a.length; i++) bytes_c[k++] = bytes_a[i];
        for (uint i = 0; i < bytes_b.length; i++) bytes_c[k++] = bytes_b[i];
        return string(bytes_c);
    }       

    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
}