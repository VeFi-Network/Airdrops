pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Airdrop is Context, Ownable {
  struct Drop {
    address _recipient;
    uint256 _amount;
  }

  address _token;
  address[] _all;

  mapping(address => uint256) _amounts;

  constructor(address token_) Ownable() {
    _token = token_;
  }

  function addRecipients(Drop[] memory _drops) external onlyOwner {
    uint256 _total = 0;

    for (uint256 i = 0; i < _drops.length; i++)
      _total = _total + _drops[i]._amount;

    require(
      IERC20(_token).balanceOf(address(this)) >= _total,
      "Not enough tokens"
    );

    for (uint256 i = 0; i < _drops.length; i++) {
      bool _isPresent = false;
      for (uint256 j = 0; j < _all.length; j++) {
        if (_all[j] == _drops[i]._recipient) {
          _isPresent = true;
        }
      }
      if (!_isPresent) _all.push(_drops[i]._recipient);
    }

    for (uint256 i = 0; i < _drops.length; i++)
      _amounts[_drops[i]._recipient] = _drops[i]._amount;
  }

  function executeAirdrop() external onlyOwner {
    for (uint256 i = 0; i < _all.length; i++) {
      require(
        IERC20(_token).transfer(_all[i], _amounts[_all[i]]),
        "Error occured while transfering tokens"
      );
      _amounts[_all[i]] = 0;
    }
    uint256 _length = _all.length;

    while (_length > 0) {
      _all.pop();
      _length = _length - 1;
    }
  }

  function reclaimTokens(uint256 _amount) external onlyOwner {
    require(IERC20(_token).transfer(owner(), _amount), "Reclaim failed");
  }

  function setToken(address token_) external onlyOwner {
    _token = token_;
  }

  function getAllRecipients() external view returns (address[] memory) {
    return _all;
  }
}
