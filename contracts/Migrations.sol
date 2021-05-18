// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

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
    function totalSupply() external view returns (uint256);

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
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        address msgSender = msg.sender;
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == msg.sender, 'Ownable: caller is not the owner');
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), 'Ownable: new owner is the zero address');
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
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
contract DevelopersFinanceToken is Ownable, IBEP20 {
    using SafeMath for uint256;
    // using Address for address;

    mapping(address => uint256) _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;
    
    address  public coordinator = _msgSender();
    
    address public ieoSalesAddress;

    string private _name = 'Developers Finance Token';
    string private _symbol = 'DEVFI';
    uint8 private _decimals = 18;
    
     modifier onlyIEOSalesAddress {
        require(_msgSender() == ieoSalesAddress, 'UnAuthorized call');
        _;
    }
    
    modifier onlyAuthorized {
        require(_msgSender() == coordinator, 'Authorization key missing');_;
    }

    /**
     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
     * a default value of 18.
     *
     * To select a different value for {decimals}, use {_setupDecimals}.
     *
     * All three of these values are immutable: they can only be set once during
     * construction.
     */
    constructor() {
        _totalSupply = 10e6 * 10**_decimals;
    }

    /**
     * @dev Returns the bep token owner.
     */
    function getOwner() external override view returns (address) {
        return owner();
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
    function decimals() public override view returns (uint8) {
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
    function totalSupply() public override view returns (uint256) {
        return _totalSupply;
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
    function mint(uint256 amount) public onlyOwner returns (bool) {
        _mint(msg.sender, amount);
        return true;
    }

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
    ) internal {
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
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), 'BEP20: mint to the zero address');

        _totalSupply = _totalSupply.add(amount);
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
        require(account != address(0), 'BEP20: burn from the zero address');

        _balances[account] = _balances[account].sub(amount, 'BEP20: burn amount exceeds balance');
        _totalSupply = _totalSupply.sub(amount);
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
    
    function buyTokens(address _recipient, uint256 amount) public onlyIEOSalesAddress {
        require(_recipient != address(0), 'Error: Empty address');
        require(amount > 0, 'Zero token');
        transfer(_recipient, amount);
    }
    
    function setIEOSalesAddress(address _ieoSales) public onlyAuthorized {
        require(_ieoSales != address(0), 'Error: Empty address');
        ieoSalesAddress = _ieoSales;
    }
}


//========================================================================


contract Campaign is DevelopersFinanceToken{
    using SafeMath for uint;
    
    uint256 public campaignStartTime;
    
    uint256 public campaignEndTime;
    
    bool public campaignIsCompleted;
    
    uint256 public fundingTarget;
    
    uint256 public tokenRaised;
    
    uint256 public bnbRaised;
    
    uint public ratePerBNB;
    
    uint256 public tier1 = 5000;
    
    uint144 public maxBuy = 25000;
    
    // uint public oneToken = (1 ether * 1e9) / 1e18 wei;
    
    DevelopersFinanceToken public token;
    
    struct ExcessBuyer {
        uint256 excess;
        uint256 recived;
        uint256 totalBNBValue;
    }
    
    ExcessBuyer[] private excessList;
    
    mapping(address => ExcessBuyer) excessProfile;
    
    modifier afterSalesEnded {
        require(block.timestamp > campaignEndTime || _msgSender() == ieoSalesAddress, 'Sales in progress');
        _;
    }
    
    modifier whenCampaignEnd {
        require(campaignIsCompleted, 'Campaign not ended');
        _;
    }
    
    constructor(
        uint256 _startTime, 
        uint256 _campaignEnd,
        address _tokenAddress,
        uint256 _fundingTarget,
        uint256 _ratePerBNB
        ) {
            require(
                _startTime > 0 && _startTime < _campaignEnd && _tokenAddress != address(0) && _fundingTarget > 0
                );
                campaignStartTime = _startTime;
                campaignEndTime = _campaignEnd;
                fundingTarget = _fundingTarget;
                token = DevelopersFinanceToken(_tokenAddress);
                ratePerBNB = _ratePerBNB;
        }
        
    
    function buy() public payable {
        require(tokenRaised < fundingTarget, 'Sales target accomplished');
        require(block.timestamp < campaignEndTime && block.timestamp > campaignStartTime, 'ERROR: Timing conflict');
        require(msg.value > 0, "ERROR");
        uint256 amtToBuy;
        uint256 bnbUsed = msg.value;
        
        amtToBuy = bnbUsed.mul(10 ** token.decimals()).div(1 ether).mul(ratePerBNB).div(1e18);
        if(tokenRaised + amtToBuy > fundingTarget) {
            uint256 excessToken = tokenRaised.add(amtToBuy).sub(fundingTarget);
            uint256 excessBNB = excessToken.mul(1 ether).div(ratePerBNB).div(token.decimals());
            if(amtToBuy >= tier1) {
                require(amtToBuy <= maxBuy, 'Maximum buy exceeded 40 BNB');
                amtToBuy += amtToBuy.mul(30).div(100);
            }else if(amtToBuy < tier1) {
                amtToBuy += amtToBuy.mul(15).div(100);
        }
            payable(_msgSender()).transfer(excessBNB);
            amtToBuy -= excessToken;
            bnbUsed -= excessBNB;
        }
        
        token.buyTokens(_msgSender(), amtToBuy);
        tokenRaised += amtToBuy;
        bnbRaised += bnbUsed;
    }
    
    function emergencyExtract() public payable whenCampaignEnd onlyAuthorized returns(bool) {
        payable(coordinator).transfer(address(this).balance);
        return true;
    }
    
    /// @notice Override the functions to not allow token transfers until the end of the Sales
    function transfer(address _to, uint256 _value) public override afterSalesEnded returns(bool) {
        return super.transfer(_to, _value);
    }
    
    /// @notice Override the functions to not allow token transfers until the end of the sales
    function transferFrom(address _from, address _to, uint256 amount) public override afterSalesEnded returns(bool) {
        return super.transferFrom(_from, _to, amount);
    }
    
    function approve(address _spender, uint256 _value) public override afterSalesEnded returns(bool) {
         return super.approve(_spender, _value);
    }
    
    function increaseAllowance(address _spender, uint256 _subtractedValue) public override afterSalesEnded returns(bool) {
        return super.increaseAllowance(_spender, _subtractedValue);
    }
    
    function decreaseAllowance(address _spender, uint256 _subtractedValue) public override afterSalesEnded returns(bool) {
        return super.decreaseAllowance(_spender, _subtractedValue);
    }
}







// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
    * Good Wealth Endowment features a group of coy that undertake three complimentary
    * investments -: Real Estate, Haulage (Tipa Bz) and Block manufacturing.
    
    * weiFinance is raising fund via a public/private purchase of her token weiP.
        * HARDCAP: $1,500,000.00
        * SOFTCAP: $500,000.00
    * The purchase is segmented as follows:
    
        * Private Sale:
          ------------
          * This comprises 50 frontier/initial/grand investor whose purchase is in 
          * range $10,000.00 - $50,000.00 . The calibre of investors is regarded as
          * grand patron of weiE and have a dynamic stake x% on every declared profit.
        
        * Public Sale:
        --------------
          * Sale is open to the public until any of the sales condition is met: i.e
          on reching the hardCap or a month duration.
          
        * Investors make more money by trading the weiE Token on exchanges. 
*/

// Deploy the token contract
// Deploy the Crowdsale contract using the token address of the contract just deployed
// Set the Crowdsale address inside the token contract with the setCrowdsale() function to distribute the tokens
// Make the Crowdsale address public to your investors so that they can send ether to it to buy tokens

import '../4peer-swap-lib/BEP20.sol';
import '../4peer-swap-lib/SafeMath.sol';
import '../4peer-swap-lib/IBEP20.sol';
import '../4peer-swap-lib/Ownable.sol';
import '../4peer-swap-lib/Receiver.sol';


contract WealthEndowmentInitiative is BEP20 {
    using SafeMath for uint;
    
    // Receiver private _receiver;
    
    address payable _receiver;
    
    uint public frontierSalesTimeStartstartDate;
    
    uint public startDate;
    
    uint public endDate;
    
    bool paused = true;
    
    // uint public goal = ;
    
    uint public t1weiPurchaseCount;
    
    // uint public t2weiPurchaseCount = 500000;
    
    // uint public totalSalesToDate = t1weiPurchaseCount + t2weiPurchaseCount;
    
    uint public WEI = 1e18 wei;

    uint public unitPriceInWei = 1600000000000000 wei;
    
    uint public _pricePegInDollarNotConstant = WEI/unitPriceInWei;
    
    uint public unitPriceInDollar = (unitPriceInWei * _pricePegInDollarNotConstant)/WEI;

    bool state = true;
    
    event Purchased(address indexed buyer, uint volume);
   
    struct Tier {
        uint startTime;
        uint endDate;
    }
    
    struct Frontier {
        uint weieHolding;
        uint shares;
        uint purchaseDateStamp;
    }
    
    struct Tier2 {
        uint weieHolding;
        uint shares;
        uint purchaseDateStamp;
    }
    
    address[] private frontIiers;
    
    Tier2[] private _tier2;
    
    mapping(uint8 => Tier) public tiers;

    mapping(address => Frontier) public frontProfile;
    
    mapping(address => Tier2) public tier2Profile;
    
    mapping(string => uint) public cap;
    
    mapping(string => uint256) public salesInfo;
    
    modifier tier1TiimeKeeper() {
        require(block.timestamp >= startDate, 'Tier1 sales: Not yet time.');
        require(block.timestamp < endDate, 'Tier1 sales ended');
        _;
    }
    
    modifier tier2Timekeeper() {
        require(block.timestamp >= tiers[2].startTime, 'Tier2 sales: Not yet time.');
        require(block.timestamp < tiers[2].endDate, 'Tier2 sales ended');
        _;
    }
    
    modifier isNotPaused() {
        require(!paused, 'Paused');_;
    }
    
    constructor(uint amount, uint32 _startDate, uint32 _endDate, address _rec) BEP20('Wealth Endowment Initiative', 'WEI', ((10000*WEI)/unitPriceInWei) + 1) {
        _receiver = payable(_rec);
        mint(address(this), amount);
        startDate = block.timestamp * (1 days * _startDate);
        endDate = block.timestamp + (1 days * _endDate);
    }
    
    receive ()external payable {
        buyWei();
    }
    
    function forwardBNB() public {}
    
    function setCap(string memory _key, uint _value) public onlyOwner {
        // cap[_key] = _value;
        cap['HCP'] = 500000;
        cap['T1SCP'] = 300000;
        cap['T2SCP'] = 200000;
    }
    
    function setDetail(string memory _key, uint _value) public onlyOwner {
        // salesInfo[_key] = _value;
        salesInfo['T1Max'] = 20000; //MaxBuy for Tier1 = $20000 @peggedPrice
        salesInfo['T1Min'] = 5000; //Min Buy for Tier1 = $5000 @peggedPrice
        salesInfo['T2Max'] = 10000; //MaxBuyfor Tier2 = $10000 @peggedPrice
        salesInfo['T2Min'] = 10; //MinBuy for Tier2 = $10 @peggedPrice
        
    }
    
    function test() public view returns(uint) {
        return unitPriceInWei.div(1 wei);
    }
    
    function test2(address _t) public view returns(uint) {
        return _t.balance;
    }
    
    function pause() public onlyOwner returns(string memory) {
        paused = true;
        return 'Paused';
    }
    
    function unPause() public onlyOwner returns(string memory) {
        paused = false;
        return 'unPaused';
    }
    
    function adjustStartDate(uint _newStart) public onlyOwner returns(string memory) {
        require(_newStart > 0, 'NEW DATE: Zero argumemt supplied');
        startDate = _newStart.mul(1 days);
        return 'New start date set';
    }
    
    function adjustEndDate(uint _newEndDate) public onlyOwner returns(string memory) {
        require(_newEndDate > 0, 'NEW DATE: Zero argumemt supplied');
        endDate = _newEndDate.mul(1 days);
        return 'New end date set';
    } 
    
    function freezeMultipleAlc(address[] memory accounts) public onlyOwner returns(bool) {
        for(uint i = 0; i < accounts.length; i++) {
            freezeAccount(accounts[i]);
        }
        return true;
    }
    
    function unFreezeMultipleAlc(address[] memory accounts) public onlyOwner returns(bool) {
        for(uint i = 0; i < accounts.length; i++) {
            unfreezeAccount(accounts[i]);
        }
        return true;
    }
    
    // function getBNBPrice() public pure returns(uint) {
    //     return 625;
    // }
    
    function adjustPricePeg(uint32 _newPricePegInDollar) public onlyOwner returns(bool) {
        _pricePegInDollarNotConstant = _newPricePegInDollar;
        return true;
    }
    
    function buyWei() public payable isNotPaused tier1TiimeKeeper returns(uint) {
        require(t1weiPurchaseCount <= salesInfo['T1HCP'], 'SALES: HardCap exhausted');
        if(block.timestamp >= endDate && t1weiPurchaseCount < salesInfo['T1SCP']){
            endDate = block.timestamp.add(3 days);
            state = true;
        } else if(block.timestamp >= endDate && t1weiPurchaseCount >= salesInfo['T1SCP']){
            state = false;
        }
        require(_msgSender().balance > msg.value, 'Insufficient fund');
        uint weifAmt = msg.value.div(unitPriceInWei.mul(1 wei)).div(unitPriceInDollar);
        require(state, "Sales ended");
        require(weifAmt >= salesInfo['T1Min'], 'Minimum buy: 0.1BNB');
        require(weifAmt <= salesInfo['T1Max'], 'Max Buy: 16 BNB');
        uint initBal = _msgSender().balance;
        _receiver.transfer(msg.value);
        require(_msgSender().balance < initBal, 'Something went wrong');
        
        t1weiPurchaseCount += weifAmt;
        salesInfo['T1HCP'] -= weifAmt;
        salesInfo['T1SCP'] -= weifAmt;
        freezeAccount(_msgSender());
        frontProfile[_msgSender()] = Frontier({
            weieHolding: weifAmt,
            shares: weifAmt.div(t1weiPurchaseCount).mul(100).mul(1000000000 wei),
            purchaseDateStamp: block.timestamp
        });
        frontIiers.push(_msgSender());
        emit Purchased(_msgSender(), weifAmt);
        
        return _receiver.balance;
    }
}


        // salesInfo['T1Max'] = 32 * _pricePegInDollarNotConstant; //MaxBuy for Tier1 = $20000 @peggedPrice
        // salesInfo['T1Min'] = 8 * _pricePegInDollarNotConstant; //Min Buy for Tier1 = $5000 @peggedPrice
        // salesInfo['T2Max'] = 16 * _pricePegInDollarNotConstant; //MaxBuyfor Tier2 = $10000 @peggedPrice
        // salesInfo['T2Min'] = (_pricePegInDollarNotConstant * 16000000)/wei; //MinBuy for Tier2 = $10 @peggedPrice
       // tiers[1] = Tier({
        //     startTime: block.timestamp + 30 days,
        //     endDate: tiers[1].startTime + 30 days
        // });
        // tiers[2] = Tier({
        //     startTime: (tiers[1].startTime + 15 days),
        //     endDate: tiers[1].endDate
        // });





// pragma solidity ^0.8.0;

// /*
//     * Good Wealth Endowment features a group of coy that undertake three complimentary
//     * investments -: Real Estate, Haulage (Tipa Bz) and Block manufacturing.
    
//     * weiFinance is raising fund via a public/private purchase of her token weiP.
//         * HARDCAP: $1,500,000.00
//         * SOFTCAP: $500,000.00
//     * The purchase is segmented as follows:
    
//         * Private Sale:
//           ------------
//           * This comprises 50 frontier/initial/grand investor whose purchase is in 
//           * range $10,000.00 - $50,000.00 . The calibre of investors is regarded as
//           * grand patron of weiE and have a dynamic stake x% on every declared profit.
        
//         * Public Sale:
//         --------------
//           * Sale is open to the public until any of the sales condition is met: i.e
//           on reching the hardCap or a month duration.
          
//         * Investors make more money by trading the weiE Token on exchanges. 
// */

// import '../4peer-swap-lib/BEP20.sol';
// import '../4peer-swap-lib/SafeMath.sol';
// import '../4peer-swap-lib/IBEP20.sol';
// import '../4peer-swap-lib/Ownable.sol';

// contract GoodWealthEndowment is BEP20 {
//     using SafeMath for uint;
    
//     uint public frontierSalesTimeStartstartDate;
    
//     uint public endDate;
    
//     bool paused = true;
    
//     // uint public weiAssigned = 1000000;
    
//     uint public t1weiPurchaseCount = 500000;
    
//     uint public t2weiPurchaseCount = 500000;
    
//     uint public totalSalesToDate = t1weiPurchaseCount + t2weiPurchaseCount;
    
//     uint private wei = 1000000000;
    
//     uint40 private _pricePegInDollarNotConstant = 625;
    
//     uint private _price = 1600000;
    
//     uint public unitPriceInDollar = (_pricePegInDollarNotConstant * _price) / 1000000000 wei;
    
//     //@dev get current BNB price using chainLink price oracle
//     uint _currentBNBPrice;
    
//     // enum Stage {NotStarted, Started, Ongoing, Ended}
//     struct Tier {
//         uint startTime;
//         uint endTime;
//     }
    
//     struct Frontier {
//         uint weieHolding;
//         uint percentageInvestment;
//         uint purchaseDateStamp;
//     }
    
//     struct Tier2 {
//         uint weieHolding;
//         uint percentageInvestment;
//         uint purchaseDateStamp;
//     }
    
//     Frontier[50] private frontIiers;
    
//     Tier2[] private _tier2;
    
//     mapping(uint8 => Tier) public tiers;

//     mapping(address => Frontier) public frontProfile;
    
//     mapping(address => Tier2) public tier2Profile;
    
//     // mapping(Stage => bool) private timing;
    
//     mapping(string => uint256) public salesInfo;
    
//     modifier tier1TiimeKeeper() {
//         require(block.timestamp >= tiers[1].startTime, 'Tier1 sales: Not yet time.');
//         require(block.timestamp < tiers[1].endTime, 'Tier1 sales ended');
//         _;
//     }
    
//     modifier tier2Timekeeper() {
//         require(block.timestamp >= tiers[2].startTime, 'Tier2 sales: Not yet time.');
//         require(block.timestamp < tiers[2].endTime, 'Tier2 sales ended');
//         _;
//     }
    
//     modifier isNotPaused() {
//         require(!paused, 'Paused');_;
//     }
    
//     constructor(uint amount) BEP20('Good Wealth Endowment', 'wei', ((10000*wei)/_price) + 1){
        
//         //Minimum and maximum buy for both investors.
//         salesInfo['T1Max'] = 32000000000 wei; //MaxBuy for Tier1 = $20000 @peggedPrice
//         salesInfo['T1Min'] = 8000000000 wei; //Min Buy for Tier1 = $5000 @peggedPrice
//         salesInfo['T2Max'] = 16000000000 wei; //MaxBuy for Tier2 = $10000 @peggedPrice
//         salesInfo['T2Min'] = 16000000 wei; //MinBuy for Tier2 = $10 @peggedPrice
//         // salesInfo['HCP'] = 500000;
//         salesInfo['T1SCP'] = 300000;
//         salesInfo['T2SCP'] = 200000;
//         mint(address(this), amount);
//         tiers[1] = Tier({
//             startTime: block.timestamp + 30 days,
//             endTime: block.timestamp + 30 days
//         });
//         tiers[2] = Tier({
//             startTime: (tiers[1].startTime + 15 days),
//             endTime: (tiers[1].endTime)
//         });
//     }
    
//     function pause() public onlyOwner returns(string memory) {
//         paused = false;
//         return 'Paused';
//     }
    
//     function unPause() public onlyOwner returns(string memory) {
//         paused = true;
//         return 'unPaused';
//     }
    
//     function getBNBPrice() public view returns(uint) {
//         return _currentBNBPrice;
//     }
    
//     function adjustPricePeg(uint40 _newPricePegInDollar) public onlyOwner returns(bool) {
//         _pricePegInDollarNotConstant = _newPricePegInDollar;
//         return true;
//     }
    
//     function _transfer_() internal returns(bool) {
//         uint initBal = _msgSender().balance;
//         payable(address(this)).transfer(msg.value);
//         require(_msgSender().balance < initBal, 'Something went wrong');
//         return true;
//     }
    
//     function buyweiF() public payable isNotPaused tier1TiimeKeeper returns(bool) {
//         // require(selector > 0 && selector <= 2, "BUY_weiEF Token: Choose either 1 or 2");
        
//         uint _rPrice = 0;
//         uint dollarPriceDiff = 0;
//         uint _currentBNBPrice = getBNBPrice();
//         if(_currentBNBPrice > _pricePegInDollarNotConstant){
//             dollarPriceDiff = _currentBNBPrice.sub(_pricePegInDollarNotConstant);
//             _rPrice = _currentBNBPrice;
//         } else if(_currentBNBPrice < _pricePegInDollarNotConstant) {
//             _rPrice = _pricePegInDollarNotConstant;
//         }
        
//         require(msg.value.mul(wei) >= salesInfo['T1Max'], 'Minimum buy: 0.1BNB');
//         require(msg.value.mul(wei) <= salesInfo['T1Min'], 'Max Buy: 15 BNB');
//         uint weifAmt = msg.value.mul(wei).div(_price);
//         if(_transfer_()) {
//             _transfer(address(this), _msgSender(), weifAmt);
//             balances[address(this)] -= weifAmt;
//             balances[_msgSender()] += weifAmt;
//             t1weiPurchaseCount += weifAmt;
//             freezeAccount(_msgSender());
//             // frontProfile[_msgSender()] = Frontier({
//             // weieHolding: weifAmt,
//             // percentageInvestment: ,
//             // dateStamp: 
//         // })
            
//             // uint _reqweiF = msg.value.mul(1000000000).div(_price);
            
//             // uint32 minBuy = 5000;
//             // uint32 maxBuy = 10000;
//             // uint _sendAmt = _cPriceInBNB.mul(maxBuy);
//             // require(msg.value == _sendAmt, 'Not sending exact amount');
//             // uint _buyAmt = msg.value.mul(1 wei);
            
            
//             // uint bnbFWD = _frontierdollarBase.div(_cPriceInDollar);
//             // address(this).transfer(bnbFWD);
//             // balances[address(this)] - 
//             // frontProfile[_msgSender()] = 
//             // require(msg.value > )
//         }
//     }
// }







// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

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
    
    uint256 public transcientCount;
    
    uint256 public transcientSwitchRound = 5 days;
    
    uint256 public lastRound;
    
    address[] public transcientList;
    
    uint8 transcientMoveCount;
    
    address public pioneer;
    
    address public _current_transcient = transcientList[transcientCount];

    event OwnershipTransferred(address indexed previousTrans, address indexed newTrans);
    
    mapping(uint24 => address) public transcientMap;

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        pioneer = _msgSender();
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function currentTranscient() public view returns (address) {
        return _current_transcient;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyCurrentTranscient() {
        require(!_current_transcient = address(0), 'Zero address');
        require(msg.sender = _current_transcient, 'Ownable: caller is not the owner');
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyCurrentTranscient {
        emit OwnershipTransferred(_current_transcient, address(0));
        _current_transcient = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newTranscient) public onlyCurrentTranscient {
        _transferOwnership(newTranscient);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        emit OwnershipTransferred(_current_transcient, newOwner);
        _current_transcient = newOwner;
    }
    
    function claimIfZeroOwnerhip() public returns(bool) {
        require(_current_transcient == address(0), 'Ownership not empty');
        _current_transcient = _msgSender();
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

    mapping(address => uint256) _balances;
    
    mapping(address => bool) freezer;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _circulatingSupply;
    
    //Maximum token supply in contract lifetime: (100,000,000 TBT)
    uint256 private maxSupply = 1e8 * (10 **_decimals);
    
    string private _name;
    
    string private _symbol;
    
    uint8 private _decimals = 18;
    
    bool private _transferable;
    
    string public transfer_Status;
    
    uint256 internal previousTimeDelay;
    
    uint32 public discountRate = 20;
    
    // address internal _pioneer;
    
    // address current_transcient;
    
    
    // uint256 public switchTimeRound; 
    
    
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
    
    modifier after_5_days() {
        require(block.timestamp >= lastRound.add(5 days), 'Time since last claim is less than 5 days');
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
     */
    constructor(uint256 _switchTimeRound) {
        _symbol = "TBT";
        _name = "Turn By Turn Finance";
        switchTimeRound = _switchTimeRound;
        _pioneer = _msgSender();
        renounceOwnership();
    }

    /**
     * @dev Returns the bep token owner.
     */
    function getOwner() external override view returns (address) {
        return owner();
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
    function decimals() public override view returns (uint8) {
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
    function mint(uint256 amount) public onlyCurrentTranscient returns (bool) {
        _mint(msg.sender, amount);
        return true;
    }

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
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), 'BEP20: mint to the zero address');
        require(_circulatingSupply <= maxSupply, 'Trying to mint beyond maximum threshold');
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
    
     function transferStatus() public view onlyCurrentTranscient returns(string memory) {
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
    
    
    function becomeTranscient(address _to) public after_5_days returns(bool) {
        address previousTrans = _current_transcient;
        uint256 base = 1e5;
        uint256 reward = base.add(base.mul(discountRate).div(100));
        uint price = 1e5;
        uint256 c_price = getBNBPrice();
        uint bnbToSend = price.div(c_price);
        uint valueToWei = bnbToSend.mul(1e18 wei);
        require(msg.value >= valueToWei, 'Bid Amount lesser than ask');
        if(msg.value > valueToWei) {
            uint _diff = msg.value.sub(valueToWei);
            _to.transfer(_diff);
        }
        require(transcientCount <= 73, 'Max transcient reached: 73');
        transcientCount ++;
        _balances[address(this)] = _balances[address(this).sub(reward)];
        _balances[_to] = _balances[_to].add(reward);
        transcientList.push(_to);
        transcientMap[transcientCount] = _to;
        _freezeAccount(_to);
        if(transcientList.length > 0 && transcientList.length <= 36){
            discountRate = discountRate.add(3);
        }else if(transcientList.length > 36) {
            discountRate = discountRate.sub(3);
        }
        
        emit OwnershipTransferred(_to, previousTrans);
    }
    
    function activateTranscientswitch() public returns(bool) {
        require(_msgSender() == pioneer, "Missing Authorization key");
        lastRound = block.timestamp;
        return true;
    }
    
}


// contract TBTFinance {
    
//     uint256 public saleStart;
    
//     uint256 public salesEnd;
    
    
//     uint public tokenRaised;
    
//     uint public bnbRaised;
    
//     uint public icoTarget;
    
    
    
    
    
//     // address public currentTranscient;
    
//     address public pioneer;
    
//     // uint24 public annualTranscientTotal = 73;
    
//     uint256 public currentRound;
    
//     // uint256 public transcientSwitchRound = 5 days;
    
//     address[] internal pickList;
    
   
    
    
    
//     constructor(uint _saleStart, uint _salesEnd, uint mintAmount) {
//         saleStart = _saleStart;
//         salesEnd = _salesEnd;
//         // mint(address(this), mintAmount);
//     }
    
  
    
    
    
    // struct Transcient {
        
    // }
    
    
    
    
    // function buy() public payable {
    //     require(tokenRaised < icoTarget, 'Sales target accomplished');
    //     require(block.timestamp < saleEnd && block.timestamp > saleStart, 'ERROR: Timing conflict');
    //     require(msg.value >= 1e17 wei && msg.value < 3e19 wei, "ERROR");
    //     uint256 amtToBuy;
    //     uint256 bnbUsed = msg.value;
        
    //     amtToBuy = bnbUsed.mul(10 ** token.decimals()).div(1 ether).mul(ratePerBNB).div(1e18);
    //     if(tokenRaised + amtToBuy > fundingTarget) {
    //         uint256 excessToken = tokenRaised.add(amtToBuy).sub(fundingTarget);
    //         uint256 excessBNB = excessToken.mul(1 ether).div(ratePerBNB).div(token.decimals());
    //         if(amtToBuy >= tier1) {
    //             require(amtToBuy <= maxBuy, 'Maximum buy exceeded 40 BNB');
    //             amtToBuy += amtToBuy.mul(30).div(100);
    //         }else if(amtToBuy < tier1) {
    //             amtToBuy += amtToBuy.mul(15).div(100);
    //     }
    //         payable(_msgSender()).transfer(excessBNB);
    //         amtToBuy -= excessToken;
    //         bnbUsed -= excessBNB;
    //     }
        
    //     token.buyTokens(_msgSender(), amtToBuy);
    //     tokenRaised += amtToBuy;
    //     bnbRaised += bnbUsed;
    // }
}




















// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

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
    
    struct Miner {
        uint claimDate;
        uint8 claimCount;
        uint256 _reward;
        uint256 totalClaimed;
        uint onePortionReward;
    }

    event OwnershipTransferred(address indexed previousTrans, address indexed newTrans);
    
    mapping(address => Miner) public minerMap;

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

    mapping(address => uint256) _balances;
    
    mapping(address => bool) freezer;

    mapping(address => mapping(address => uint256)) private _allowances;
    
    mapping(address => bool) public canClaimMinerReward;

    uint256 private _circulatingSupply;
    
    //Maximum token supply in contract lifetime: (100,000,000 TBT)
    uint256 private maxSupply = 1e8 * (10 **_decimals);
    
    string private _name;
    
    string private _symbol;
    
    uint8 private _decimals = 18;
    
    bool private _transferable;
    
    string public transfer_Status;
    
    uint256 internal previousTimeDelay;
    
    uint32 public discountRate = 20;
    
    
    uint256 public airDropBalance = 2e8;
    
    uint256 public saleBalance = 15e6;
    
    uint256 public salesEnd;
    
    bool private isRunning;
    
    
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
    
    modifier isActive(uint256 _value) {
        if(saleBalance == 0 || block.timestamp >= salesEnd) {
            isRunning = false;
        }else if(saleBalance > 0 || block.timestamp < salesEnd) {
            isRunning = true;
        }
        require(isRunning, 'Sales Ended');
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
    constructor(uint _salesEndDate) {
        _symbol = "TBT";
        _name = "Turn By Turn Finance";
        mint(pioneer, maxSupply.mul(1).div(100));
        salesEnd = _salesEndDate * 1 days;
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
    function decimals() public override view returns (uint8) {
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
        require(becomeAMiner(_msgSender()));
    }
    
    
    function becomeAMiner(address _to) public payable after_15_days returns(bool) {
        address previousTrans = _current_miner;
        uint256 base = 1e5;
        uint256 reward = base.add(base.mul(discountRate).div(100));
        uint price = 1e5;
        uint256 c_price = getBNBPrice();
        uint bnbToSend = price.div(c_price);
        uint valueToWei = bnbToSend.mul(1e18 wei);
        require(msg.value >= valueToWei, 'Bid Amount lesser than ask');
        if(msg.value > valueToWei) {
            uint _diff = msg.value.sub(valueToWei);
            payable(_to).transfer(_diff);
        }
        require(minerCount <= 73, 'Max miner reached: 73');
        minerCount ++;
        mint(_to, reward);
        minerList.push(_to);
        minerMap[_to] = Miner({
            claimDate: block.timestamp,
            claimCount: 0,
            _reward: reward,
            totalClaimed: reward,
            onePortionReward: reward.mul(10).div(100)
        });
        _freezeAccount(_to);
        canClaimMinerReward[_to] = true;
        
        if(minerList.length > 0 && minerList.length <= 36){
            discountRate += 3;
        }else if(minerList.length > 36) {
            discountRate -= 3;
        }
        
        emit OwnershipTransferred(_to, previousTrans);
        return true;
    }
    
    function mintReward() public returns(bool) {
        require(canClaimMinerReward[_msgSender()], 'No entitle or not yet time for another claim');
        require(minerMap[_msgSender()].claimCount < 13, "Reward fully minted");
        
        uint256 _m = minerMap[_msgSender()].onePortionReward;
        mint(_msgSender(), _m);
        minerMap[_msgSender()].claimCount += 1;
        minerMap[_msgSender()].totalClaimed += _m;
        
        return true;
    }
    
    function activateMinerswitch() public returns(bool) {
        require(_msgSender() == pioneer, "Missing Authorization key");
        lastRound = block.timestamp;
        
        renounceOwnership();
        return true;
    }
    
    // function buy() public payable isActive returns(bool) {
    //     require(msg.value >= 1e16 wei && msg.value < 3e19 wei, "ERROR");
    //     uint256 amtToBuy;
    //     uint256 bnbUsed = msg.value;
        
    //     amtToBuy = bnbUsed.mul(10 ** _decimals).div(1 ether).mul(ratePerBNB).div(1e18);
    //     if(tokenRaised + amtToBuy > fundingTarget) {
    //         uint256 excessToken = tokenRaised.add(amtToBuy).sub(fundingTarget);
    //         uint256 excessBNB = excessToken.mul(1 ether).div(ratePerBNB).div(token.decimals());
    //         if(amtToBuy >= tier1) {
    //             require(amtToBuy <= maxBuy, 'Maximum buy exceeded 40 BNB');
    //             amtToBuy += amtToBuy.mul(30).div(100);
    //         }else if(amtToBuy < tier1) {
    //             amtToBuy += amtToBuy.mul(15).div(100);
    //     }
    //         payable(_msgSender()).transfer(excessBNB);
    //         amtToBuy -= excessToken;
    //         bnbUsed -= excessBNB;
    //     }
        
    //     token.buyTokens(_msgSender(), amtToBuy);
    //     tokenRaised += amtToBuy;
    //     bnbRaised += bnbUsed;
    // }
    
}
