// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

abstract contract AccessRole is Ownable {
    using EnumerableSet for EnumerableSet.AddressSet;
    EnumerableSet.AddressSet private roles;

    function addRole(address role) public onlyOwner {
        roles.add(role);
    }

    function deleteRole(address role) public onlyOwner {
        roles.remove(role);
    }

    function getRole(uint256 index) public view returns (address) {
        return roles.at(index);
    }

    function exist(address account) public view returns (bool){
        return roles.contains(account);
    }

    function getRolesCount() public view returns (uint256) {
        return roles.length();
    }

    modifier roleAccessRight() {
        require(exist(_msgSender()), "AccessRole: caller is not the role");
        _;
    }

    modifier fullAccessRight(){
        require(_msgSender() == owner() || exist(_msgSender()), "AccessRole: caller has no access");
        _;
    }
}

contract TTUid is ERC721, ERC721Enumerable, AccessRole {
    constructor() ERC721("TTUid", "TTUid") {}

    function safeMint(address to, uint256 tokenId) public fullAccessRight {
        _safeMint(to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}