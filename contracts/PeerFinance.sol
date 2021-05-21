// SPDX-License-Identifier: MIT

pragma solidity >=0.8.4;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, 'SafeMath: addition overflow');

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, 'SafeMath: subtraction overflow');
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, 'SafeMath: multiplication overflow');

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, 'SafeMath: division by zero');
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, 'SafeMath: modulo by zero');
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }

    function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = x < y ? x : y;
    }

    // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
    function sqrt(uint256 y) internal pure returns (uint256 z) {
        if (y > 3) {
            z = y;
            uint256 x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
}

// ==============================================================================================


interface IBEP20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function currentTotalSupply() external view returns (uint256);

    /**
     * @dev Returns the token decimals.
     */
    function decimals() external view returns (uint8);

    /**
     * @dev Returns the token symbol.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the token name.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the bep token owner.
     */
    function getOwner() external view returns (address);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address _owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// =================================================================================

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

//===================================================================================

// import './GSN/Context.sol';

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
    
    address public _current_miner = minerList[minerCount];
    
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

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        pioneer = _msgSender();
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
        require(_current_miner != address(0), 'Zero address');
        require(_msgSender() == _current_miner, 'Ownable: caller is not the owner');
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
    
    function claimIfZeroOwnerhip() public returns(bool) {
        require(_current_miner == address(0), 'Ownership not empty');
        _current_miner = _msgSender();
        emit OwnershipTransferred(address(0), _msgSender());
        return true;
    }
    
    function getBNBPrice() internal returns(uint256) {
        return 500;
    }
    
}


// =================================================================================


/**
 * @dev Implementation of the {IBEP20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {BEP20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-BEP20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of BEP20 applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IBEP20-approve}.
 */
contract BEP20 is Ownable, IBEP20 {
    using SafeMath for uint256;
    // using Address for address;
    
    event Airdrop(address indexed _user, uint _value);
    
    event Reported(address indexed reporter, address indexed _target);

    uint256 private _circulatingSupply;
    
    //Maximum token supply in contract lifetime: (100,000,000 TBT)
    uint256 private maxSupply = 1e8;
    
    string private _name;
    
    string private _symbol;
    
    uint8 private constant _decimals = 0;
    
    bool private _transferable;
    
    string public transfer_Status;
    
    uint256 internal previousTimeDelay;
    
    uint32 public discountRate = 20;
    
    uint256 public blackListCounter;
    
    uint256 public airDropBalance = 2e7;
    
    // uint256 public saleBalance = 15e6;
    
    uint256 public salesEnd;
    
    uint256 public salesStart;
    
    bool private isactive;
    
    uint internal airdropIter;
    
    uint public airdroppersCounter;
    
    uint256 public fundingTarget = 2e7;
    
    uint256 public tokenRaised;
    
    uint256 public bnbRaised;
    
    uint256 public timeMark;
    
    uint256 public lastAirddropDate;
    
    uint256 public lastRewardTBTDate;
    
    uint256 public rewardIter;
    
    error Unauthorized();
    
    
    struct BadActors {
        uint reporters;
        uint supporters;
    }
    
    // struct Voter {
    //     uint8 voteCount;
    // }
    
    struct AirdropClaim {
        uint id;
        uint8 exist;
        bool isConfirmed;
    }
    
    BadActors[] public cell;
    
    address[] public airdropList;
    
    address[] public tbtList;
    
    // uint[] array = [1,2,3,4,5];
    
    mapping(address => uint256) _balances;
    
    mapping(address => bool) freezer;
    
    mapping(uint256 => address) public blackList;

    mapping(address => mapping(address => uint256)) private _allowances;
    
    mapping(address => bool) public canClaimMinerReward;
    
    mapping(address => AirdropClaim) public airdropProfile;
    
    mapping(address => bool) public isRegistered;
    
    mapping(address => bool) public isMiner;
    
    mapping(address => bool) public granted;
    
    mapping(address => uint256) public stakePool;
    
    mapping(address => BadActors) public custody;
    
    mapping(address => mapping(address => bool)) private exonerator;
    
    mapping(address => mapping(address => uint8)) public votes;
    
    // mapping(uint16 => uint256) 
    
    modifier isTransferable() {
        if(block.timestamp < previousTimeDelay) {
            revert('Transfer forbidden until set time');
        } else if(block.timestamp > previousTimeDelay) {
            _transferable = true;
            transfer_Status = "Unlocked";
        } else {
            _transferable = false;
            transfer_Status = "Locked";
        }
        require(_transferable, "Locked");
        _;
    }
    
    modifier isNotFreezed(address _any) {
        require(!freezer[_any], "Account Frozen");
        _;
    }
    
    modifier isActive {
        if(fundingTarget == 0 || block.timestamp >= salesEnd) {
            isactive = false;
        }else if(fundingTarget > 0 || block.timestamp < salesEnd) {
            isactive = true;
        }
        require(isactive, 'Sales Ended');
        _;
    }
    
    modifier notAddressZero(address _caller) {
        require(_caller != address(0));
        _;
    }
    
    /*@contract ensures that miner claim is not less than 15 days.
    lastRound will always set to current timestamp at call and next claim
    is set another 15 days from the time of call.
    NOTE: If next claim equals true, and no one claim at due date, next claim date becomes
        any date claim is made.
    */ 
    modifier after_15_days() {
        lastRound = lastRound.add(minerSwitchRound);
        require(block.timestamp >= lastRound, 'Time since last claim is less than 5 days');
        lastRound = block.timestamp;
        _;
    }
    
    modifier onlyMinerOrPioneerOrCop {
        require(cops[_msgSender()].isCop || _msgSender() == _current_miner || _msgSender() == pioneer, "Miner or Pioneer approval missing");
        _;
    }
    
    /**
     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
     * a default value of 18.
     *
     * To select a different value for {decimals}, use {_setupDecimals}.
     *
     * All three of these values are immutable: they can only be set once during
     * construction.
     * @dev reward: 1% of maxSupply, mintable over 10 months interval
     */
    constructor(uint256 _salesStart, uint256 _salesEndDate, uint256 _airdropDate, uint256 _lrwdTBTDate) {
        _symbol = "TBT";
        _name = "Turn By Turn Finance";
        mint(pioneer, maxSupply.mul(1).div(100));
        salesStart = _salesStart * 1 days;
        salesEnd = _salesEndDate + (_salesStart * 1 days);
        timeMark = salesStart + (15 * 1 days);
        lastAirddropDate = _airdropDate;
        lastRewardTBTDate = salesEnd + _lrwdTBTDate * 1 days;
    }

    /**
     * @dev Returns the bep token owner.
     */
    function getOwner() external override view returns (address) {
        return _current_miner;
    }

    /**
     * @dev Returns the token name.
     */
    function name() public override view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the token decimals.
     */
    function decimals() public override pure returns (uint8) {
        return _decimals;
    }

    /**
     * @dev Returns the token symbol.
     */
    function symbol() public override view returns (string memory) {
        return _symbol;
    }
    
    /**
     * @dev See {BEP20-totalSupply}.
     */
    function currentTotalSupply() public override view returns (uint256) {
        return  _circulatingSupply;
    }

    /**
     * @dev See {BEP20-balanceOf}.
     */
    function balanceOf(address account) public override view returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {BEP20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    /**
     * @dev See {BEP20-allowance}.
     */
    function allowance(address owner, address spender) public override view returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {BEP20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    /**
     * @dev See {BEP20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {BEP20};
     *
     * Requirements:
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for `sender`'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            msg.sender,
            _allowances[sender][msg.sender].sub(amount, 'BEP20: transfer amount exceeds allowance')
        );
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {BEP20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {BEP20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(
            msg.sender,
            spender,
            _allowances[msg.sender][spender].sub(subtractedValue, 'BEP20: decreased allowance below zero')
        );
        return true;
    }

    /**
     * @dev Creates `amount` tokens and assigns them to `msg.sender`, increasing
     * the total supply.
     *
     * Requirements
     *
     * - `msg.sender` must be the token owner
     */
    // function mint(uint256 amount) public onlyCurrentminer returns (bool) {
    //     _mint(msg.sender, amount);
    //     return true;
    // }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal isTransferable isNotFreezed(sender) {
        require(sender != address(0), 'BEP20: transfer from the zero address');
        require(recipient != address(0), 'BEP20: transfer to the zero address');

        _balances[sender] = _balances[sender].sub(amount, 'BEP20: transfer amount exceeds balance');
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements
     *
     * - `to` cannot be the zero address.
     */
    function mint(address account, uint256 amount) internal {
        require(account != address(0), 'BEP20: mint to the zero address');
        require(_circulatingSupply.add(amount) <= maxSupply, 'Trying to mint beyond maximum threshold');
        _circulatingSupply = _circulatingSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal {
        require(account != address(0) && amount > 0, 'BEP20: burn from the zero address');

        _balances[account] = _balances[account].sub(amount, 'BEP20: burn amount exceeds balance');
        _circulatingSupply = _circulatingSupply.sub(amount);
        maxSupply = maxSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
     *
     * This is internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal {
        require(owner != address(0), 'BEP20: approve from the zero address');
        require(spender != address(0), 'BEP20: approve to the zero address');

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
     * from the caller's allowance.
     *
     * See {_burn} and {_approve}.
     */
    function _burnFrom(address account, uint256 amount) internal {
        _burn(account, amount);
        _approve(
            account,
            msg.sender,
            _allowances[account][msg.sender].sub(amount, 'BEP20: burn amount exceeds allowance')
        );
    }
    
     function transferStatus() public view onlyCurrentminer returns(string memory) {
        return transfer_Status;
    }
    
    /*
     * @contract restricts an account from moving token .
     */
    function _freezeAccount(address _account) internal returns (bool) {
        require(freezer[_account] == false, "Account is restricted before now");
        freezer[_account] = true;
        return true;
    }
    
    /*
     * @contract lifts transfer ban.
     */
    function _unfreezeAccount(address _account) internal returns (bool) {
        require(freezer[_account] == true, "This account is not restricted");
        freezer[_account] = false;
        return true;
    }
    
    receive () external payable {
        if(msg.value <= 3e19 wei){
            require(buy(_msgSender()));
        }else{
            require(becomeAMiner(_msgSender()));
        }
        
    }
    /*Found bad actor? Turn them in.
        @contract takes or freeze all of the token Balance,
        Same method can be used to penalize a cop only if a minumum
        of half of the total number of cops in the station have reported the case..
    */
    function turnInTheBadGuy(address _target) public onlyMinerOrPioneerOrCop returns(uint256) {
        require(station.length > 1, "Not enough enforcement officers");
         BadActors memory _suspect = custody[_target];
         _suspect.reporters ++;
         _suspect.supporters = 0;
         cell.push(_suspect);
         blackListCounter ++;
         _freezeAccount(_target);
         
         if(_suspect.reporters >= station.length.div(2)){
             _confiscate(_target);
         }
         
         emit Reported(_msgSender(), _target);
         return blackListCounter;
     }
     
    function discharge(address _accused) public onlyMinerOrPioneerOrCop returns(bool) {
        require(station.length.mod(2) == 0, "Cops are not smiling, check back nexxt time");
        uint averageCops = station.length.div(2);
        require(custody[_accused].supporters >= averageCops, "Not enough cops to discharge the accused");
        _unfreezeAccount(_accused);
        return true;
    }
     
    function exonerate(address _target) public onlyMinerOrPioneerOrCop returns(string memory) {
        require(votes[_msgSender()][_target] == 0);
        votes[_msgSender()][_target] += 1;
        custody[_target].supporters += 1;
        return "successful";
    }
     
    // Anyone can be a cop for 2000 TBT
    function joinTheCop() public returns(bool) {
         uint256 stakeValue = 2000;
         if(_balances[_msgSender()] < stakeValue) revert("Balance is less than required min balance");
         _balances[_msgSender()] -= stakeValue;
         stakePool[_msgSender()] += stakeValue;
         Cop memory _cop = cops[_msgSender()];
         _cop.isCop = true;
         _cop.lockTimestamp = block.timestamp;
         station.push(_cop);
         return true;
     }
     
     function resign() public returns(bool) {
         require(cops[_msgSender()].isCop, "Not a cop");
         delete cops[_msgSender()];
         return true;
     }
    
    function becomeAMiner(address _to) public payable notAddressZero(_to) after_15_days returns(bool) {
        address previousTrans = _current_miner;
        uint256 base = 1e5;
        uint256 reward = base.add(base.mul(discountRate).div(100));
        uint price = 1e5;
        uint256 c_price = getBNBPrice();
        uint bnbToSend = price.div(c_price).mul(1e18 wei);
        require(msg.value >= bnbToSend, 'Bid Amount lesser than ask');
        if(msg.value > bnbToSend) {
            uint _diff = msg.value.sub(bnbToSend);
            payable(_to).transfer(_diff);
        }
        require(minerCount <= 73, 'Max miner reached: 73');
        minerCount ++;
        mint(_to, reward);
        minerList.push(_to);
        minerMap[_to] = Miner({
            lastRewardClaimDate: block.timestamp,
            claimCount: 0,
            _reward: reward,
            totalClaimed: reward,
            onePortionReward: reward.mul(10).div(100)
        });
        _freezeAccount(_to);
        canClaimMinerReward[_to] = true;
        isMiner[_to] = true;
        
        if(minerList.length > 0 && minerList.length <= 36){
            discountRate += 3;
        }else if(minerList.length > 36) {
            discountRate -= 3;
        }
        
        emit OwnershipTransferred(_to, previousTrans);
        return true;
    }
    
    function mintMinerReward() public notAddressZero(_msgSender()) returns(bool) {
        if(!isMiner[_msgSender()]) revert("Not a miner");
        require(canClaimMinerReward[_msgSender()], 'No entitle or not yet time for another claim');
        require(minerMap[_msgSender()].claimCount < 13, "Reward fully minted");
        require(block.timestamp >= minerMap[_msgSender()].lastRewardClaimDate.add(1 days * 30), 'Claim date not up to 30 days');
        uint256 _m = minerMap[_msgSender()].onePortionReward;
        mint(_msgSender(), _m);
        minerMap[_msgSender()].claimCount += 1;
        minerMap[_msgSender()].totalClaimed += _m;
        minerMap[_msgSender()].lastRewardClaimDate = block.timestamp;
        
        return true;
    }
    
    //@contract Seizes token from offenders
    function _confiscate(address _target) internal returns(bool) {
        _approve(_target, address(this), _balances[_target]);
        _transfer(_target, address(this), _balances[_target]);
        return true;
    }
    
    function activateMinerswitch() public returns(bool) {
        require(_msgSender() == pioneer, "Missing Authorization key");
        lastRound = block.timestamp;
        
        renounceOwnership();
        return true;
    }
    
    /* @Any User calls airdrop() (only at every 30 days) 
        and every eligible users in the userlist get airdropped.
        Current Miner is excluded.
        User's account appearing more than once is _confiscated.
    */
    
    function airdrop() public notAddressZero(_msgSender()) returns(bool) {
        if(!isRegistered[_msgSender()]) revert("Caller not allowed");
        require(block.timestamp >= lastAirddropDate.add(30 * 1 days), 'Current time less than next airdrop date');
        uint32 stopper;
        uint32 _value = 1000;
        for(uint i = 0; i < airdropList.length; i++){
            
            i += airdropIter;
            address _destination = airdropList[i];
            if(_destination == _current_miner || !airdropProfile[_destination].isConfirmed){
                _confiscate(_destination);
            }
            mint(_destination, _value);
            stopper += 1;
            if(stopper == 500) break;
            emit Airdrop(_destination, _value);
        }
        airdropIter += 1;
        return true;
    }
    
    function registerForAirdrop() public notAddressZero(_msgSender()) returns(bool) {
        airdroppersCounter ++;
        airdropList.push(_msgSender());
        airdropProfile[_msgSender()] = AirdropClaim({
            id: airdroppersCounter,
            exist: 0,
            isConfirmed: true
        });
        isRegistered[_msgSender()] = true;
        for(uint i = 0; i < airdropList.length; i++){
            if(_msgSender() == airdropList[i]) {
                airdropProfile[_msgSender()].exist ++;
            }
        }
        if(airdropProfile[_msgSender()].exist > 1) {
           airdropProfile[_msgSender()].isConfirmed = false; 
        }
        return true;
        
        
    }
    
    function buy(address _to) public payable isActive returns(bool) {
        require(msg.value >= 1e17 wei && msg.value < 3e19 wei, "Buy ceiling exceeded");
        require(_msgSender() != _current_miner, 'Miner is excluded');
        uint256 maxBuy = 1e8;
        uint256 pricePerTokenInwei = 1e15;
        uint256 amtToBuy;
        uint256 bnbUsed = msg.value;
        
        amtToBuy = bnbUsed.div(pricePerTokenInwei).mul(10**_decimals);
        if(fundingTarget.sub(tokenRaised) < amtToBuy) {
            uint256 excessToken = amtToBuy.sub(fundingTarget.sub(tokenRaised));
            uint256 excessBNB = excessToken.mul(pricePerTokenInwei);
            if(block.timestamp < timeMark) {
                amtToBuy += amtToBuy.mul(15).div(100);
            }else {
                amtToBuy += amtToBuy.mul(10).div(100);
            }
    
            amtToBuy -= excessToken;
            bnbUsed -= excessBNB;
            payable(_to).transfer(excessBNB);
            isactive = false;
        }
        require(amtToBuy <= maxBuy, 'Maximum buy exceeded: 100 BNB');
        mint(_to, amtToBuy);
        tokenRaised += amtToBuy;
        bnbRaised += bnbUsed;
        tbtList.push(_to);
        granted[_to] = true;
        return true;
    }
    
    function reward_tbt() public notAddressZero(_msgSender()) returns(bool) {
        require(granted[_msgSender()], "Caller not recognized");
        require(block.timestamp >= lastRewardTBTDate.add(15 * 1 days), 'Current time less than next TBT selection');
        uint32 stopper;
        uint32 _value = 15000;
        // if(tbtList.length)
        
        for(uint i = 0; i < tbtList.length; i++){
            i += rewardIter;
            if(i > tbtList.length){
                i = 1;
            }
            address _destination = tbtList[i];
            mint(_destination, _value);
            if(_destination == _current_miner){
                _confiscate(_destination);
            }
            stopper += 1;
            emit Airdrop(_destination, _value);
            if(stopper == 3) {
                rewardIter += stopper;
                break;
            }
        }
        return true;
    }
    
    
}




















