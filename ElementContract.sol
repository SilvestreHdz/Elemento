pragma solidity ^0.4.24;

contract ElementContract {
    address private owner = msg.sender;
    
    //Function to deposit in the contract 
    function depositContract(uint amount)public payable{
        require(msg.value == amount);
        
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
}