pragma solidity 0.5.16;

// import "openzeppelin-solidity/contracts/math/Math.sol";
import "../../math/SafeMath.sol";
import "../../ownership/Ownable.sol";
// import "../../token/KIP17/IKIP17Receiver.sol";
import "../../token/KIP17/PoolIKIP17.sol";
// import "../../token/KIP17/KIP17Token.sol";
// import "../../token/KIP7/IKIP7Receiver.sol";
import "../../token/KIP7/IKIP7.sol";
import "./utils.sol";


/**
 * Staking Token Wrapper
 */
pragma solidity 0.5.16;

contract TokenWrapper is Ownable, utils {
    using SafeMath for uint256;
    uint256 constant version = 1e17;
    uint256 constant price = 1e10;
    uint256 constant n = 1e5;
    uint256 constant m = 1e0;
    PoolIKIP17 public TIME;
    PoolIKIP17 public POOL;
    

    uint256 public totalSupply = 0;
    mapping(address => uint256) public balanceOf;
    
    function stake(uint256[] memory tokenIds) public {
        require(tokenIds.length <= 10, "tokens must be at least 10");
        for (uint i = 0; i < tokenIds.length; i++){

            TIME.transferFrom(msg.sender, address(this), tokenIds[i]);

            uint256 _amount = getPrice(tokenIds[i]);
            balanceOf[msg.sender] = balanceOf[msg.sender].add(_amount);
            totalSupply = totalSupply.add(_amount);

            POOL.mint(msg.sender, tokenIds[i]);
        }
    }

    function unstake(uint256[] memory tokenIds) public {
        require(tokenIds.length <= 30, "tokens must be at least 30");
        for (uint i = 0; i < tokenIds.length; i++){
            POOL.transferFrom(msg.sender, address(this), tokenIds[i]);
            POOL.burn(tokenIds[i]);

            uint256 _amount = getPrice(tokenIds[i]);
            balanceOf[msg.sender] = balanceOf[msg.sender].sub(_amount);
            totalSupply = totalSupply.sub(_amount);


            TIME.transferFrom(address(this), msg.sender, tokenIds[i]);
        }
    }

    function getPrice(uint256 tokenIds) internal returns (uint256){
        return tokenIds.sub(tokenIds.mod(price)).mod(version).div(price);
    }
}

/**
 *  Pool
 */
pragma solidity 0.5.16;

contract NFTPool is TokenWrapper {
    using SafeMath for uint256;

    IKIP7 public rewardToken;
    uint256 public DURATION;
    uint256 public startTime;
    
    uint256 public periodFinish = 0;
    uint256 public rewardRate = 0;
    uint256 public lastUpdateTime;
    uint256 public rewardPerTokenStored = 0;
    bool public isLocked = false;
    bool public isWhitelisted = false;
    bool private open = true;
    uint256 private constant _gunit = 1e18;
    mapping(address => bool) public whitelist;
    mapping(address => uint256) public userRewardPerTokenPaid;
    mapping(address => uint256) public rewards; // Unclaimed rewards

    event RewardAdded(uint256 reward);
    event Staked(address indexed user, uint256[] tokenIds);
    event UnStaked(address indexed user, uint256[] tokenIds);
    event WithdrawnRewards(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);
    event SetOpen(bool _open);

    constructor(string memory name, bool _isLocked, bool _isWhitelisted, uint256 _startTime,uint256 _DURATION, address _TIME, address _POOL, address _rewardToken) public {
        isLocked = _isLocked;
        isWhitelisted = _isWhitelisted;
        startTime = _startTime;
        DURATION = _DURATION;
        TIME = PoolIKIP17(_TIME); 
        POOL = PoolIKIP17(_POOL);
        rewardToken = IKIP7(_rewardToken);
    }

    modifier updateReward(address account) {
        rewardPerTokenStored = rewardPerToken();
        lastUpdateTime = lastTimeRewardApplicable();
        if (account != address(0)) {
            rewards[account] = earned(account);
            userRewardPerTokenPaid[account] = rewardPerTokenStored;
        }
        _;
    }

    modifier isLock(){
        require( isLocked ? block.timestamp > startTime + DURATION:true, "This pool locked until the end");
        _;
    }

    modifier isWhitelist(address account){
        require(isWhitelisted?whitelist[account]:true, "You are not whitelisted");
        _;
    }

    function addWhitelist(address account) public onlyOwner () {
        whitelist[account] = true;
    }

    function removeWhitelist(address account) public onlyOwner () {
        whitelist[account] = false;
    }

    function lastTimeRewardApplicable() public view returns (uint256) {
        return block.timestamp > periodFinish ? periodFinish : block.timestamp;
    }
    /**
     * Calculate the rewards for each token
     */
    function rewardPerToken() public view returns (uint256) {
        if (totalSupply == 0) {
            return rewardPerTokenStored;
        }
        return
            rewardPerTokenStored.add(
                lastTimeRewardApplicable()
                    .sub(lastUpdateTime)
                    .mul(rewardRate)
                    .mul(_gunit)
                    .div(totalSupply)
            );
    }

    function earned(address account) public view returns (uint256) {
        return
            balanceOf[account]
                .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
                .div(_gunit)
                .add(rewards[account]);
    }

    function stake(uint256[] memory tokenIds)
        public
        checkOpen
        checkStart
        isWhitelist(msg.sender)
        updateReward(msg.sender)
    {
        require(tokenIds.length > 0, "POOL: Cannot stake 0");
        super.stake(tokenIds);
        emit Staked(msg.sender, tokenIds);
    }

    function unstake(uint256[] memory tokenIds)
        public
        isLock
        updateReward(msg.sender)
    {
        require(tokenIds.length > 0, "POOL: Cannot stake 0");
        super.unstake(tokenIds);
        emit UnStaked(msg.sender, tokenIds);
    }

    function withdrawLeftRewards(address account, uint256 amount)
        public
        onlyOwner
    {
        require(amount > 0, "POOL: Cannot withdraw 0");
        rewardToken.safeTransfer(account, amount);
        emit WithdrawnRewards(account, amount);
    }

    function getReward() public checkStart isLock updateReward(msg.sender) {
        uint256 reward = earned(msg.sender);
        if (reward > 0) {
            rewards[msg.sender] = 0;
            rewardToken.safeTransfer(msg.sender, reward);
            emit RewardPaid(msg.sender, reward);
        }
    }

    modifier checkStart() {
        require(block.timestamp > startTime, "POOL: Not start");
        _;
    }

    modifier checkOpen() {
        require(
            open && block.timestamp < startTime + DURATION,
            "POOL: Pool is closed"
        );
        _;
    }
    modifier checkClose() {
        require(block.timestamp > startTime + DURATION, "POOL: Pool is opened");
        _;
    }
    
    function getPeriodFinish() public view returns (uint256) {
        return periodFinish;
    }

    function isOpen() public view returns (bool) {
        return open;
    }

    function setOpen(bool _open) public onlyOwner {
        open = _open;
        emit SetOpen(_open);
    }

    function notifyRewardAmount(uint256 reward)
        public
        onlyOwner
        checkOpen
        updateReward(address(0))
    {
        uint256 _before = rewardToken.balanceOf(address(this));
        rewardToken.transferFrom(msg.sender, address(this), reward);
        uint256 _after = rewardToken.balanceOf(address(this));
        reward = _after.sub(_before);

        if (block.timestamp > startTime) {
            if (block.timestamp >= periodFinish) {
                uint256 period = block
                    .timestamp
                    .sub(startTime)
                    .div(DURATION)
                    .add(1);
                periodFinish = startTime.add(period.mul(DURATION));
                rewardRate = reward.div(periodFinish.sub(block.timestamp));
            } else {
                uint256 remaining = periodFinish.sub(block.timestamp);
                uint256 leftover = remaining.mul(rewardRate);
                rewardRate = reward.add(leftover).div(remaining);
            }
            lastUpdateTime = block.timestamp;
        } else {
            uint256 b = rewardToken.balanceOf(address(this));
            rewardRate = reward.add(b).div(DURATION);
            periodFinish = startTime.add(DURATION);
            lastUpdateTime = startTime;
        }

        emit RewardAdded(reward);

        // avoid overflow to lock assets
        _checkRewardRate();
    }

    function _checkRewardRate() internal view returns (uint256) {
        return DURATION.mul(rewardRate).mul(_gunit);
    }
}