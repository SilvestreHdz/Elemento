pragma solidity ^0.4.24;

contract ElementContract {
    address private owner = msg.sender;
    
    //Function to deposit in the contract. 80% owner, 20% contract
    function depositContract(uint amount)public payable{
        require(msg.value == amount);
        owner.transfer((amount*80)/100);
    }
    
   //Function to get the balance of the contract
   function getBalance() public view onlyBy(owner) returns(uint)  {
        return (address(this).balance);
    }
    
    //Function for owner
    modifier onlyBy(address _account)
    {
        require(
            msg.sender == _account,
            "Sender not authorized."
        );
        _;
    }
    
    //Function to tranfer an amount of cash to an owner account
    function transfer(uint amount) public onlyBy(owner){
            require(address(this).balance >= amount);
            owner.transfer(amount);
    }
}