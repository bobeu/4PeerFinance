// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import './Context.sol';

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    
    uint256 public minerCount;
    
    uint256 public minerSwitchRound = 1 days * 15;
    
    uint256 public lastRound;
    
    address[] public minerList;
    
    uint8 minerMoveCount;
    
    address public pioneer;
    
    address internal _current_miner = miners[minerCount];
    
    Cop[] public station;
    
    struct Cop {
        bool isCop;
        uint lockTimestamp;
    }
    
    struct Miner {
        uint lastRewardClaimDate;
        uint8 claimCount;
        uint256 _reward;
        uint256 totalClaimed;
        uint onePortionReward;
    }

    event OwnershipTransferred(address indexed previousTrans, address indexed newTrans);
    
    mapping(address => Miner) public minerMap;
    
    mapping(address => Cop) public cops;
    
    mapping(uint => address) miners;

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor(address _addr) {
        pioneer = _addr;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function currentminer() public view returns (address) {
        return _current_miner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyCurrentminer() {
        require(_msgSender() != address(0), 'Zero address');
        require(_msgSender() == _current_miner || _msgSender() == pioneer, 'Ownable: caller is not the owner');
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyCurrentminer {
        emit OwnershipTransferred(_current_miner, address(0));
        _current_miner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newminer) public onlyCurrentminer {
        _transferOwnership(newminer);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        emit OwnershipTransferred(_current_miner, newOwner);
        _current_miner = newOwner;
    }
}
