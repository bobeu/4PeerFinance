// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IBEP20.sol";
// import './GSN/Context.sol';
import './Ownable.sol';
// import './Ownable.sol';
import './SafeMath.sol';
// import './Address.sol';

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

    mapping(address => uint256) public balances;

    mapping(address => mapping(address => uint256)) private _allowances;
    
    mapping(address => bool) freezer;
    
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    bool private transferable;
    address[] public holders;

    /**
     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
     * a default value of 18.
     *
     * To select a different value for {decimals}, use {_setupDecimals}.
     *
     * All three of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory naMe, string memory symBol) {
        _name = naMe;
        _symbol = symBol;
        _decimals = 18;
    }
    
    modifier isTransferable() {
        require(transferable, "Locked"); _;
    }
    
    modifier isNotFreezed(address _any) {
        require(!freezer[_any], "Account Frozen");
        _;
    }

    /**
     * @dev Returns the bep token owner.
     */
    function getOwner() external override view returns (address) {
        return owner();
    }
    
    function transferStatus() public view onlyOwner returns(bool) {
        return transferable;
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
     * @dev Returns the totalSupply.
     */
    function totalSupply() public override view returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev Returns the token symbol.
     */
    function symbol() public override view returns (string memory) {
        return _symbol;
    }
    
    
    /**
     * @dev See {BEP20-freezeAccount}.
     */
    function freezeAccount(address _account) public override onlyOwner returns (bool) {
        require(freezer[_account] == false, "Account is already freezed");
        freezer[_account] = true;
        return true;
    }
    
     /**
     * @dev See {BEP20-unfreezeAccount}.
     */
    function unfreezeAccount(address _account) public override onlyOwner returns (bool) {
        require(freezer[_account] == true, "This account is not freezed");
        freezer[_account] = false;
        return true;
    }
    
    /**
     * @dev See {BEP20-lock}.
     */
    function lock() public override onlyOwner returns(string memory) {
        if (transferable == true) {
            transferable = false;
            return "Locked";
        } else {
            return "Account already locked";
        }
    }
    
    /**
     * @dev See {BEP20-unlock}.
     */
    function unlock() public override onlyOwner returns(string memory) {
        if (transferable == false) {
            transferable = true;
            return "unLocked";
        } else {
            return "Account already unlocked";
        }
    }

    /**
     * @dev See {BEP20-balanceOf}.
     */
    function balanceOf() public override view returns (uint256) {
        return balances[_msgSender()];
    }

    /**
     * @dev See {BEP20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(
        address recipient, 
        uint256 amount
        ) public override returns (bool) {
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
    function approve(address spender, uint256 amount) public override returns (bool) {
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
    ) public override returns (bool) {
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
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
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
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(
            msg.sender,
            spender,
            _allowances[msg.sender][spender].sub(subtractedValue, 'BEP20: decreased allowance below zero')
        );
        return true;
    }

    // /**
    //  * @dev Creates `amount` tokens and assigns them to `msg.sender`, increasing
    //  * the total supply.
    //  *
    //  * Requirements
    //  *
    //  * - `msg.sender` must be the token owner
    //  */
    function mint(address _recipient, uint256 amount) public onlyOwner returns (bool) {
        require(totalSupply().add(amount) <= 500000000, "Supply threshold exceeded");
        _mint(_recipient, amount);
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
    ) internal isTransferable  isNotFreezed(_msgSender()){
        require(sender != address(0), 'BEP20: transfer from the zero address');
        require(recipient != address(0), 'BEP20: transfer to the zero address');

        balances[sender] = balances[sender].sub(amount, 'BEP20: transfer amount exceeds balance');
        balances[recipient] = balances[recipient].add(amount);
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
        require(_totalSupply.add(amount) <= 500000000, "Cannot exceed threshold");
        require(account != address(0), 'BEP20: cannot mint to the zero address');
        balances[account] = balances[account].add(amount);
        _totalSupply += amount;
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

        balances[account] = balances[account].sub(amount, 'BEP20: burn amount exceeds balance');
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
}



// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
    * Good Wealth Endowment features a group of coy that undertake three complimentary
    * investments -: Real Estate, Haulage (Tipa Bz) and Block manufacturing.
    
    * GWEIFinance is raising fund via a public/private purchase of her token GWEIP.
        * HARDCAP: $1,500,000.00
        * SOFTCAP: $500,000.00
    * The purchase is segmented as follows:
    
        * Private Sale:
          ------------
          * This comprises 50 frontier/initial/grand investor whose purchase is in 
          * range $10,000.00 - $50,000.00 . The calibre of investors is regarded as
          * grand patron of GWEIE and have a dynamic stake x% on every declared profit.
        
        * Public Sale:
        --------------
          * Sale is open to the public until any of the sales condition is met: i.e
          on reching the hardCap or a month duration.
          
        * Investors make more money by trading the GWEIE Token on exchanges. 
*/

import '../4peer-swap-lib/BEP20.sol';
import '../4peer-swap-lib/SafeMath.sol';
import '../4peer-swap-lib/IBEP20.sol';
import '../4peer-swap-lib/Ownable.sol';

contract GoodWealthEndowment is BEP20 {
    using SafeMath for uint;
    
    uint public frontierSalesTimeStartstartDate;
    
    uint public endDate;
    
    bool paused = true;
    
    // uint public gweiAssigned = 1000000;
    
    uint public t1GweiPurchaseCount = 500000;
    
    uint public t2GweiPurchaseCount = 500000;
    
    uint public totalSalesToDate = t1GweiPurchaseCount + t2GweiPurchaseCount;
    
    uint private GWEI = 1000000000;
    
    uint40 private _pricePegInDollarNotConstant = 625;
    
    uint private _price = 1600000 gwei;
    
    uint public tokenPriceInDollar = (_pricePegInDollarNotConstant * _price) / 1000000000 gwei;
    
    //@dev get current BNB price using chainLink price oracle
    uint _currentBNBPrice;
    
    // enum Stage {NotStarted, Started, Ongoing, Ended}
    struct Tier {
        uint startTime;
        uint endTime;
    }
    
    struct Frontier {
        uint GWEIeHolding;
        uint percentageInvestment;
        uint purchaseDateStamp;
    }
    
    struct Tier2 {
        uint GWEIeHolding;
        uint percentageInvestment;
        uint purchaseDateStamp;
    }
    
    Frontier[50] private frontIiers;
    
    Tier2[] private _tier2;
    
    mapping(uint8 => Tier) public tiers;

    mapping(address => Frontier) public frontProfile;
    
    mapping(address => Tier2) public tier2Profile;
    
    // mapping(Stage => bool) private timing;
    
    mapping(string => uint256) public salesInfo;
    
    modifier tier1TiimeKeeper() {
        require(block.timestamp >= tiers[1].startTime, 'Tier1 sales: Not yet time.');
        require(block.timestamp < tiers[1].endTime, 'Tier1 sales ended');
        _;
    }
    
    modifier tier2Timekeeper() {
        require(block.timestamp >= tiers[2].startTime, 'Tier2 sales: Not yet time.');
        require(block.timestamp < tiers[2].endTime, 'Tier2 sales ended');
        _;
    }
    
    modifier isNotPaused() {
        require(!paused, 'Paused');_;
    }
    
    constructor(uint amount) BEP20('Good Wealth Endowment', 'GWEI', ((10000*GWEI)/_price) + 1){
        
        //Minimum and maximum buy for both investors.
        salesInfo['T1Max'] = 32000000000 gwei; //MaxBuy for Tier1 = $20000 @peggedPrice
        salesInfo['T1Min'] = 8000000000 gwei; //Min Buy for Tier1 = $5000 @peggedPrice
        salesInfo['T2Max'] = 16000000000 gwei; //MaxBuy for Tier2 = $10000 @peggedPrice
        salesInfo['T2Min'] = 16000000 gwei; //MinBuy for Tier2 = $10 @peggedPrice
        // salesInfo['HCP'] = 500000;
        salesInfo['T1SCP'] = 300000;
        salesInfo['T2SCP'] = 200000;
        mint(address(this), amount);
        tiers[1] = Tier({
            startTime: block.timestamp + 30 days,
            endTime: startTime + 30 days
        });
        tiers[2] = Tier({
            startTime: (tiers[1].startTime + 15 days),
            endTime: (tiers[1].endTime)
        });
    }
    
    function pause() public onlyOwner returns(sGWEIng memory) {
        paused = false;
        return 'Paused';
    }
    
    function unPause() public onlyOwner returns(sGWEIng memory) {
        paused = true;
        return 'unPaused';
    }
    
    function getBNBPrice() public view returns(uint) {
        return _currentBNBPrice;
    }
    
    function adjustPricePeg(uint40 _newPricePegInDollar) public onlyOwner returns(bool) {
        _pricePegInDollarNotConstant = _newPricePegInDollar;
        return true;
    }
    
    function _transfer_() internal returns(bool) {
        uint initBal = _msgSender().balance;
        payable(address(this)).transfer(msg.value);
        require(_msgSender().balance < initBal, 'Something went wrong');
        return true;
    }
    
    function buyGWEIF() public payable isNotPaused tier1TiimeKeeper returns(bool) {
        require(selector > 0 && selector <= 2, "BUY_GWEIEF Token: Choose either 1 or 2");
        
        uint _rPrice = 0;
        uint dollarPriceDiff = 0;
        uint _currentBNBPrice = getBNBPrice();
        if(_currentBNBPrice > _pricePegInDollarNotConstant){
            dollarPriceDiff = _currentBNBPrice.sub(_pricePegInDollarNotConstant);
            _rPrice = _currentBNBPrice;
        } else if(_currentBNBPrice < _pricePegInDollarNotConstant) {
            _rPrice = _pricePegInDollarNotConstant;
        }
        
        require(msg.value.mul(GWEI) >= salesInfo['T1Max'], 'Minimum buy: 0.1BNB');
        require(msg.value.mul(GWEI) <= salesInfo['T1Min'], 'Max Buy: 15 BNB');
        uint gWEIfAmt = msg.value.mul(GWEI).div(_price);
        if(_transfer_()) {
            _transfer(address(this), _msgSender());
            balances[address(this)] -= gWEIfAmt;
            balances[_msgSender()] += gWEIfAmt;
            t1GweiPurchaseCount += gWEIfAmt;
            freezeAccount(_msgSender());
            frontProfile[_msgSender()] = Frontier({
            GWEIeHolding: GWEIfAmt,
            percentageInvestment: ,
            dateStamp: 
        })
            
            uint _reqGWEIF = msg.value.mul(1000000000).div(_price);
            
            uint32 minBuy = 5000;
            uint32 maxBuy = 10000;
            uint _sendAmt = _cPriceInBNB.mul(maxBuy);
            require(msg.value == _sendAmt, 'Not sending exact amount');
            uint _buyAmt = msg.value.mul(1 wei).div()
            
            
            uint bnbFWD = _frontierdollarBase.div(_cPriceInDollar);
            address(this).transfer(bnbFWD);
            balances[address(this)] - 
            frontProfile[_msgSender()] = 
            require(msg.value > )
        }
    }
}