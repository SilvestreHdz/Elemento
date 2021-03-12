pragma solidity ^0.4.24;

contract ElementContract {
    address private owner = msg.sender;
    struct Account{
        string name;
        string lastName;
        address addr;
        uint numberTrx;
        uint depositAmount;
        uint depositCounter;
    }
    
    mapping(address => Account) private accounts;
    mapping(address => bool) private joinedAccounts;
    
    //Function to deposit in the contract. 80% owner, 20% contract
    function depositContract(string name, string lastName, uint amount)public payable{
        require(msg.value == amount);
        owner.transfer((amount*80)/100);
        join(name, lastName, amount);
    }
    
    //Function to save data of personal accounts in map accounts
    function join(string name, string lastName, uint amount) private{
        
        if(accountJoined(msg.sender)){
            Account storage accountAux = accounts[msg.sender];
            accountAux.numberTrx = accountAux.numberTrx + 1;
            accountAux.depositAmount = accountAux.depositAmount +amount;
        }else{
            Account storage account = accounts[msg.sender];
            account.name = name;
            account.lastName = lastName;
            account.addr = msg.sender;
            account.numberTrx = 1;
            account.depositAmount = amount;
            account.depositCounter = 0;
        }
        joinedAccounts[msg.sender] = true;
    }
    
   //Function to get the balance of the contract
   function getBalance() public view onlyBy(owner) returns(uint)  {
        return (address(this).balance);
    }
    
    //Function to tranfer an amount of cash to an owner account
    function transferOwner(uint amount) public onlyBy(owner){
            require(address(this).balance >= amount);
            owner.transfer(amount);
    }
    
    //Function to tranfer an amount of cash to an account
    function transferTo(uint amount, address to)public onlyBy(owner){
        require(accountJoined(msg.sender),
            "Account not registered.");
        require(address(this).balance >= amount);
        require(to != address(0));
        to.transfer(amount);
    }
    
    //Function to get info about personal accounts
    function getAccount(address addr) public view returns(string, string, address, uint, uint, uint){
        require(accountJoined(msg.sender),
            "Account not registered.");
        Account memory account = accounts[addr];
        return (account.name, account.lastName, account.addr, account.numberTrx, account.depositAmount, account.depositCounter);
    }
    
    //Function to validate if an account exist
    function accountJoined(address addr) private view returns(bool){
        return joinedAccounts[addr];
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
