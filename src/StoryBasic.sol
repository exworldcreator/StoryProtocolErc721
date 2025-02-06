// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { IPAssetRegistry } from "@storyprotocol/core/registries/IPAssetRegistry.sol";

contract StoryNft is ERC721, Ownable {
    IPAssetRegistry public immutable IP_ASSET_REGISTRY;

    uint256 public constant MAX_SUPPLY = 2222;
    uint256 public constant WHITELIST_PRICE = 0 ether;
    uint256 public constant WHITELIST_MAX_P_WALLET = 2;
    uint256 public constant PUBLIC_MAX_P_WALLET = 2;
    bool public whitelistMintEnabled = false;
    bool public publicMintEnabled = false;
    uint256 private _totalSupply = 0;

    mapping(address => bool) private whitelist;
    mapping(address => uint256) public addressValue;

    string public constant BASE_URI = "ipfs://youruri";

    event Minted(address indexed _from, uint _tokenId, uint _timestamp);
    event PublicMintStatusChanged(bool _enabled, uint _timestamp);
    event WhitelistMintStatusChanged(bool _enabled, uint _timestamp);
    event WhitelistUpdated(address _address, bool _added, uint _timestamp);
    
    constructor(address ipAssetRegistryAddress)
        ERC721("Collection Name", "SNFT")
        Ownable(msg.sender)
    {
        require(ipAssetRegistryAddress != address(0), "Invalid IP Asset Registry address");
        IP_ASSET_REGISTRY = IPAssetRegistry(ipAssetRegistryAddress);
    }

    function _baseURI() internal pure override returns (string memory) {
        return BASE_URI;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_ownerOf(tokenId) != address(0), "Token does not exist");
        return string(abi.encodePacked(BASE_URI, uint2str(tokenId), ".json"));
    }

    function addToWhitelist(address _address) external onlyOwner {
        whitelist[_address] = true;
        emit WhitelistUpdated(_address, true, block.timestamp);
    }

    function removeFromWhitelist(address _address) external onlyOwner {
        whitelist[_address] = false;
        emit WhitelistUpdated(_address, false, block.timestamp);
    }

    function isWhitelisted(address _address) public view returns (bool) { 
        return whitelist[_address];
    }

    function setWhitelistMintEnabled(bool _state) external onlyOwner {
        whitelistMintEnabled = _state;
        emit WhitelistMintStatusChanged(_state, block.timestamp);
    }

    function setPublicMintEnabled(bool _state) external onlyOwner {
        publicMintEnabled = _state;
        emit PublicMintStatusChanged(_state, block.timestamp);
    }

    function viewTotalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function whitelistMint() external payable {
        require(whitelistMintEnabled, "Whitelist mint is not active");
        require(addressValue[msg.sender] < WHITELIST_MAX_P_WALLET, "Whitelist mint limit reached");
        require(whitelist[msg.sender], "Not whitelisted");
        require(_totalSupply < MAX_SUPPLY, "Max supply reached");
        
        _mintNFT(msg.sender);
    }

    function publicMint() external payable {
        require(publicMintEnabled, "Public mint is not active");
        require(addressValue[msg.sender] < PUBLIC_MAX_P_WALLET, "Public mint limit reached");
        require(_totalSupply < MAX_SUPPLY, "Max supply reached");

        _mintNFT(msg.sender);
    }

    function _mintNFT(address recipient) internal {
        _totalSupply++;
        _safeMint(recipient, _totalSupply);
        addressValue[recipient]++;
        _registerAsIPAsset(_totalSupply);
        emit Minted(recipient, _totalSupply, block.timestamp);
    }

    function _registerAsIPAsset(uint256 tokenId) internal {
        try IP_ASSET_REGISTRY.register(block.chainid, address(this), tokenId) {
        } catch Error(string memory reason) {
            revert(reason);
        } catch {
            revert("IP Asset registration failed");
        }
    }

    function uint2str(uint256 _i) internal pure returns (string memory str) {
        if (_i == 0) return "0";
        uint256 j = _i;
        uint256 length;
        while (j != 0) {
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        j = _i;
        while (j != 0) {
            bstr[--length] = bytes1(uint8(48 + j % 10));
            j /= 10;
        }
        return string(bstr);
    }
}