pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Airdrop is Context, Ownable {
  uint256 _dropAmountPerAddress;
  address _token;

  constructor(uint256 dropAmountPerAddress_, address token_) Ownable() {
    _dropAmountPerAddress = dropAmountPerAddress_;
    _token = token_;
  }

  function execAirdrop(address[] memory _addresses) external onlyOwner() returns (bool) {
    require(IERC20(_token).balanceOf(address(this)) >= (_dropAmountPerAddress * _addresses.length), "Not enough tokens");

    for (uint i = 0; i < _addresses.length; i++) {
      require(IERC20(_token).transfer(_addresses[i], _dropAmountPerAddress), "Could not transfer tokens");
    }

    return true;
  }

  function setToken(address token_) external onlyOwner() {
    _token = token_;
  }

  function setDropAmountPerAddress(uint256 dropAmountPerAddress_) external onlyOwner() {
    _dropAmountPerAddress = dropAmountPerAddress_;
  }
}