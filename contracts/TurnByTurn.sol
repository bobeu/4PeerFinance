// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import './SafeMath.sol';
import './IBEP20.sol';
import './Ownable.sol';

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
contract TurnByTurn is IBEP20, Ownable {

    using SafeMath for uint256;
    // using Address for address;
    
    event Airdrop(address indexed _user, uint _value);
    
    event Reported(address indexed reporter, address indexed _target);

    uint256 private _circulatingSupply;
    
    //Maximum token supply in contract lifetime: (100,000,000 TBT)
    uint256 private maxSupply = 1e8;
    
    string private _name = "Turn By Turn Finance";
    
    string private _symbol = "TBT";
    
    uint8 private constant _decimals = 0;
    
    bool private _transferable;
    
    string private transfer_Status = "Unlocked";
    
    uint256 internal _previousTimeDelay;
    
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
    
    uint64 private fotron;
    
    uint64 public judgesCounter;
    
    
    struct BadActors {
        uint reporters;
        uint supporters;
    }
    
    struct Judges {
        uint64 id;
        bool isJudge;
        uint256 timeLocked;
    }
    
    struct AirdropClaim {
        uint id;
        uint8 exist;
        bool isConfirmed;
    }
    
    // struct User {
        
    // }
    
    BadActors[] public cell;
    
    address[] public judgeslist;
    
    address[] public airdropList;
    
    address[] public tbtList;
    
    // uint[] array = [1,2,3,4,5];
    
    mapping(address => uint256) _balances;
    
    mapping(address => bytes32) public presidings;
    
    mapping(address => Judges) public judges;
    
    mapping(address => bool) public freezer;
    
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
    
    mapping(address => uint256) public judgesVault;
    
    // mapping(uint16 => uint256) 
    
    modifier isTransferable() {
        if(block.timestamp < _previousTimeDelay) {
            revert('Transfer forbidden until set time');
        } else if(block.timestamp > _previousTimeDelay) {
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
    constructor(uint256 _delay, uint256 _salesStart, uint256 _salesEnd, uint256 _airdropDate, uint256 _lrwdTBTDate) Ownable(_msgSender()) {
        mint(pioneer, maxSupply * 1/100);
        salesStart = block.timestamp + (_salesStart * 1 days);
        salesEnd = salesStart + (_salesEnd * 1 days);
        timeMark = salesStart + (15 * 1 days);
        lastAirddropDate = block.timestamp + (_airdropDate * 1 days);
        lastRewardTBTDate = salesEnd + (_lrwdTBTDate * 1 days);
        _previousTimeDelay = block.timestamp + (_delay * 1 days);
    }

    function getBNBPrice() internal pure returns(uint256) {
        return 500;
    }
    
    function checkContractBNBBalance() public payable returns(uint256) {
        return address(this).balance;
    }
    
    
    function claimIfZeroOwnerhip() public payable returns(bool) {
        require(_current_miner == address(0), 'Ownership not empty');
        if(_balances[_msgSender()] < 50000) revert("Not enough consideration provided");
        _balances[_msgSender()] -= 49999;
        _balances[address(this)] += 49999;
        _current_miner = _msgSender();
        emit OwnershipTransferred(address(0), _msgSender());
        return true;
    }
    
    function becomeAjudge() public returns(string memory) {
        judgesCounter += 1;
        uint256 criteria = 20000;
        address g = _msgSender();
        require(_balances[g] >= criteria, "Does not meet criteria");
        require(judgeslist.length < 51, "Only 50 allowed as judges");
        _balances[g] -= criteria;
        judgesVault[g] += criteria;
        Judges memory _judge;
        _judge.id = judgesCounter;
        _judge.isJudge = true;
        _judge.timeLocked = block.timestamp;
        judges[g] = _judge;
        presidings[g] = keccak256(abi.encode(_msgSender(), "IS_JUDGE"));
        judgeslist.push(g);
        return "Successful";
    }
    
    function restrictGlobalTransfer() public returns(string memory) {
        address g = _msgSender();
        bytes32 signedPetition = keccak256(abi.encode(_msgSender(), "IS_JUDGE"));
        require(!freezer[g] && judges[g].isJudge, 'Account not qualified');

        if(presidings[g] == signedPetition) {
            _freezeAccount(_msgSender());
            return 'Penalized: Not a member of this calibre: Your account is freezed';
        }
        uint64 id = judges[g].id;
        presidings[g] = signedPetition;
        fotron += id;
        uint256 totalNoOfJudges = judgeslist.length;
        uint256 ids_sum;
        
        for(uint i = 0; i < totalNoOfJudges; i++){
            ids_sum += judges[judgeslist[i]].id;
        }
        if(fotron >= ids_sum.div(2)) {
            _lock();
            fotron = 0;
            for(uint i = 0; i < totalNoOfJudges; i++){
            delete presidings[judgeslist[i]];
            }
        }
        return "PRECIDED";
    }
    
    function removeTransferRestriction() public returns(string memory) {
        address g = _msgSender();
        bytes32 signedPetition = keccak256(abi.encode(_msgSender(), "IS_JUDGE"));
        require(!freezer[g] && judges[g].isJudge, 'Account not qualified');

        if(presidings[g] == signedPetition) {
            _freezeAccount(_msgSender());
            return 'Penalized: Not a member of this calibre: Your account is freezed';
        }
        uint64 id = judges[g].id;
        presidings[g] = signedPetition;
        fotron += id;
        uint256 totalNoOfJudges = judgeslist.length;
        uint ids_sum;
        
        for(uint i = 0; i < totalNoOfJudges; i++){
            ids_sum += judges[judgeslist[i]].id;
        }
        if(fotron >= ids_sum.div(2)) {
            _unlock();
            fotron = 0;
            for(uint i = 0; i < totalNoOfJudges; i++){
            delete presidings[judgeslist[i]];
            }
        }
        return "PRECIDED";
    }
    
    // function restrictTransferGenerally() public isNotFreezed(_msgSender()) returns(string memory) {
    //     bytes32 _precided = presidings[_msgSender()];
    //     if(_precided != keccak256(abi.encode(_msgSender(), "IS_JUDGE"))) {
    //         _freezeAccount(_msgSender());
    //         revert("False misrepresentation");
    //     } else if(_precided == keccak256(abi.encode(_msgSender(), "IS_JUDGE"))) {
    //         require(!freezer[_msgSender()]);
    //         require(fotron >= 636, "Not enough presidings");
    //         ff
    //     }
    // }

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
        require(_balances[sender] > 0 && _balances[sender] > amount && amount > 0, "Insufficient balance");

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
     * @contract lifts transfer ban on an individual account.
     */
    function _unfreezeAccount(address _account) internal returns (bool) {
        require(freezer[_account] == true, "This account is not restricted");
        freezer[_account] = false;
        return true;
    }
    
    function unfreezeAccount(address _target) public onlyMinerOrPioneerOrCop {
        _unfreezeAccount(_target);
    }
    
    /**
     * @dev See {BEP20-lock}.
     */
    function _lock() internal returns(string memory) {
        if (_transferable == true) {
            _transferable = false;
            _previousTimeDelay = block.timestamp.add(3 days);
            return "Locked";
        } else {
            return "Account already locked";
        }
    }
    
    /**
     * @dev See {BEP20-unlock}.
     */
    function _unlock() internal returns(string memory) {
        if (_transferable == false) {
            _transferable = true;
            _previousTimeDelay = 0;
            return "unLocked";
        } else {
            return "Account already unlocked";
        }
    }
    
    function unfreezeYourself() public returns(bool) {
        address _tg = _msgSender();
        if(freezer[_tg]) {
            uint256 penalty = _balances[_tg].mul(10).div(100);
            _balances[_tg] -= penalty;
            _balances[address(this)] += penalty; 
            _unfreezeAccount(_msgSender());
        }
        return true;
    }
    
    receive () external payable {
        if(msg.value <= 3e19 wei){
            require(buy());
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
        miners[minerCount] = _to;
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
    
    function buy() public payable isActive returns(bool) {
        require(msg.value >= 1e17 wei && msg.value < 3e19 wei, "Buy ceiling low or exceeded");
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
            payable(_msgSender()).transfer(excessBNB);
            isactive = false;
        }
        require(amtToBuy <= maxBuy, 'Maximum buy exceeded: 100 BNB');
        mint(_msgSender(), amtToBuy);
        tokenRaised += amtToBuy;
        bnbRaised += bnbUsed;
        tbtList.push(_msgSender());
        granted[_msgSender()] = true;
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
