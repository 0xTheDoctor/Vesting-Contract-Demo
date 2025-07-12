
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0 ;

interface ERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract Vesting {
    address public tokenAddress;
    address public owner;
    uint256 public vestingDuration;
    uint256 public vestingStart;
    uint256 public vestingEnd;
    uint256 public cliffDuration;
    uint256 public cliffEnd;

    struct Beneficiary {
        uint256 totalAllocation;
        uint256 totalClaimed;
    }

    mapping(address => Beneficiary) public beneficiaries;

    constructor() {
        owner = msg.sender;
    }

    function setTokenAddress(address _tokenAddress) public onlyOwner {
        require(_tokenAddress != address(0), "Zero address");
        tokenAddress = _tokenAddress;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function addBeneficiary(address _beneficiary, uint256 _totalAllocation) external onlyOwner {
        beneficiaries[_beneficiary].totalAllocation = _totalAllocation;
    }

    function setCliffandVestinDuration(uint256 _vestingDuration, uint256 _cliffDuration) external onlyOwner {
        vestingDuration = _vestingDuration;
        cliffDuration = _cliffDuration;
    }

    function start() external onlyOwner {
        require(vestingStart == 0, "Vesting already started");
        require(vestingDuration > 0 && cliffDuration > 0, "Durations not set");
        vestingStart = block.timestamp;
        vestingEnd = vestingStart + vestingDuration;
        cliffEnd = vestingStart + cliffDuration;
    }

    function calculateClaimableAmount(address _beneficiary) public view returns (uint256) {
        
        if (beneficiaries[_beneficiary].totalAllocation == 0) {
            return 0;
        }
        
        
        if (vestingStart == 0) {
            return 0;
        }
        
        if (block.timestamp < cliffEnd) {
            return 0;
        }
        
        if (block.timestamp >= vestingEnd) {
            return beneficiaries[_beneficiary].totalAllocation - beneficiaries[_beneficiary].totalClaimed;
        }
        
        
        uint256 vestingPeriod = vestingDuration - cliffDuration;
        require(vestingPeriod > 0, "Invalid vesting period");
        
        uint256 timeSinceCliffEnd = block.timestamp - cliffEnd;
        uint256 totalReleasable = (beneficiaries[_beneficiary].totalAllocation * timeSinceCliffEnd) / vestingPeriod;
        uint256 claimable = totalReleasable - beneficiaries[_beneficiary].totalClaimed;
        
        
        return claimable > beneficiaries[_beneficiary].totalAllocation ? 
               beneficiaries[_beneficiary].totalAllocation - beneficiaries[_beneficiary].totalClaimed : 
               claimable;
    }

    function claim() external {
        
        require(beneficiaries[msg.sender].totalAllocation > 0, "Not a beneficiary");
        
        uint256 claimable = calculateClaimableAmount(msg.sender);
        require(claimable > 0, "No claimable amount");
        
        
        require(ERC20(tokenAddress).balanceOf(address(this)) >= claimable, "Insufficient contract balance");
        
        beneficiaries[msg.sender].totalClaimed += claimable;
        
        bool success = ERC20(tokenAddress).transfer(msg.sender, claimable);
        require(success, "Token transfer failed");
    }

    function getVestingInfo(address _beneficiary) public view returns (uint256 totalAllocation, uint256 totalClaimed) {
        return (beneficiaries[_beneficiary].totalAllocation, beneficiaries[_beneficiary].totalClaimed);
    }

    function emergencyWithdraw(uint256 amount) external onlyOwner {
        require(ERC20(tokenAddress).transfer(msg.sender, amount), "Token transfer failed");
    }
}
