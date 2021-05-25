// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "https://github.com/0xcert/ethereum-erc721/src/contracts/tokens/nf-token.sol";
import "https://github.com/0xcert/ethereum-erc721/src/contracts/tokens/erc721.sol";
import "https://github.com/0xcert/ethereum-erc721/src/contracts/tokens/nf-token-metadata.sol";
import "https://github.com/0xcert/ethereum-erc721/src/contracts/ownership/ownable.sol";


contract BillionDollarHomepageNFT is NFTokenMetadata, Ownable {

  constructor() {
    nftName = "Billion Dollar Homepage";
    nftSymbol = "BDH";
  }

     function uint2str(
      uint256 _i
    )
      internal
      pure
      returns (string memory str)
    {
      if (_i == 0)
      {
        return "0";
      }
      uint256 j = _i;
      uint256 length;
      while (j != 0)
      {
        length++;
        j /= 10;
      }
      bytes memory bstr = new bytes(length);
      uint256 k = length;
      j = _i;
      while (j != 0)
      {
        bstr[--k] = bytes1(uint8(48 + j % 10));
        j /= 10;
      }
      str = string(bstr);
    }

    function append(string memory a, string memory b, string memory c, string memory d, string memory e, string memory f, string memory g) internal pure returns (string memory) {
        return string(abi.encodePacked(a, b, c, d, e, f, g));
    }

    function coordinates(uint256 _tokenId) private pure returns (string memory xStr, string memory yStr) {
        uint x = _tokenId / 10;
        uint y = _tokenId % 10 + 1;
        
        xStr = string(uint2str(x));
        yStr = string(uint2str(y));
    }
    
    function newURI(uint256 _tokenId, string memory imgHash) private pure returns (string memory uri) {
        (string memory x, string memory y) = coordinates(_tokenId);
        uri = append('{"x": "', x, '", "y": "', y, '", "imgHash":"', imgHash,'"}');
    }

    /* 
    0    1   2   3   4   5   6   7   8   9
    10  11  12  13  14  15  16  17  18  19
    20  21  22  23  24  25
    
        x, y
    0 = 0, 0
    1 = 1, 0
    2 = 2, 0
    ...
    10 = 0, 1
    25 =
      y = 25 / 10 = 2
      x = 25 % 10 = 5 + 1
    42 =
      y = 42 / 10 = 4
      x = 42 % 10 = 2 + 1
    100 =
      y = 100 / 10 = 10
      x = 100 % 10 = 0
    */
  function mint(address _to, uint256 _tokenId) public onlyOwner {
    super._mint(_to, _tokenId);
    string memory imgHash = 'QmdCDJLHfAUxW65f5tmtmUvjQQP9rTWcqWHibmmb9E72My';
    string memory uri = newURI(_tokenId, imgHash);
    super._setTokenUri(_tokenId, uri);
  }
  
  
  function update(uint256 _tokenId, string calldata ipfsCID) external onlyOwner {
    address ownerId = super.ownerOf(_tokenId);
    assert (msg.sender == ownerId);
    string memory uri = newURI(_tokenId, ipfsCID);
    super._setTokenUri(_tokenId, uri);
  }
  
  function mintAll(uint startIndex) public onlyOwner {
    for (uint256 x = startIndex * 10; x < (startIndex * 10) + 10; x++) {
        mint(msg.sender, x);
    }
  }
  function ownerOf(
    uint256 _tokenId
  )
    external
    override
    view
    returns (address _owner)
  {
    _owner = idToOwner[_tokenId];
    require(_owner != address(0), NOT_VALID_NFT);
  }
 
}
