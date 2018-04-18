pragma solidity 0.4.21;

contract Crowdfund {
    
    address public beneficiary;
    uint public goal;
    uint public deadline;
    
    mapping(address => uint) private funders ;
    address[] public totalFundersArr;
    
    event Contribution(uint _amount, uint _amountRemaining);
    
    modifier onlyBeneficiary() {
        if (msg.sender != beneficiary) revert();
        _;
    }
    
    function Crowdfund(address _beneficiary, uint _goal, uint _deadline) public {
        beneficiary = _beneficiary;
        goal = _goal;
        deadline = block.timestamp + _deadline;
    }
    
    function currentFunding() public constant returns (uint){
        return address(this).balance;
    }
    
    function totalFunders() public constant returns(uint){
        return totalFundersArr.length;
    }
    
    function contribute() public payable {
        if(funders[msg.sender] == 0) totalFundersArr.push(msg.sender);
        funders[msg.sender] += msg.value;
        emit Contribution(msg.value, goal - address(this).balance);
    }
    
    function payout() public {
        if (block.timestamp > deadline && address(this).balance >= goal){
            beneficiary.transfer(address(this).balance);
        }
    }
    
    function refund() public{
        if (block.timestamp > deadline && this.balance < goal){
            msg.sender.transfer(funders[msg.sender]);
            funders[msg.sender] = 0;
        }
    }
    
    function disable() public onlyBeneficiary {
        if (this.balance != 0) revert();
        selfdestruct(beneficiary);
    }
}