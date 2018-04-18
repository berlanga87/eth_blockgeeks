pragma solidity 0.4.21;

contract Coin {
    
    address owner;
    uint public totalSupply;
    
    mapping (address => uint) public balances;
    
    // indexed means you can search the logs for them
    event Transfer(address indexed _to, address indexed _from, uint _value);
    event NewCoinLog(address _to, uint _amount, uint _newSupply);
    
    modifier onlyOwner() {
        if (msg.sender != owner) revert();
        _;
    }
    
    // constructor function
    function Coin (uint _supply) public {
        owner = msg.sender;
        totalSupply = _supply;
        balances[owner] += _supply; // owner gets all supply
    }
    
    // constant - doesn't change states so doesn't need gas
    function getBalance (address _addr) public constant returns (uint){ 
        return balances[_addr];
    }
    
    function transfer(address _to, uint _amount) public returns (bool) {
        if (balances[msg.sender] < _amount) revert();
        
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
        emit Transfer(_to, msg.sender, _amount);
        return true;
    }
    
    function mint(uint _amount) public onlyOwner returns (bool){
        totalSupply += _amount;
        balances[owner] += _amount;
        emit NewCoinLog(owner, _amount, totalSupply);
        return true;
    }
    
    function disable() public onlyOwner {
        // will return all remaining funds to the owner
        selfdestruct(owner);
    }
}