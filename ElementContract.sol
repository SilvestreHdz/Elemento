pragma solidity ^0.8.2;

contract ElementContract {
    address private owner = msg.sender;
    struct Account{
        address addr;
        uint numberTrx;
        uint depositAmount;
        uint depositCounter;
        uint depositYields;
    }
    
    mapping(address => Account[]) private accounts;
    mapping(address => bool) private joinedAccounts;
    
    //Function to deposit in the contract: 80% owner, 20% contract
    function invest(uint amount)public payable{
        require(msg.value == amount);
        payable(owner).transfer((amount*80)/100);
        join(amount);
    }
    
   //Function to save data of personal accounts in map accounts
    function join(uint amount) private{
        if(accountJoined(msg.sender)){
            uint count = accounts[msg.sender].length;
            Account memory account = accounts[msg.sender][count-1];
            uint numberTrxAux = (account.numberTrx+1);
            
            accounts[msg.sender].push(Account(msg.sender,numberTrxAux,amount,0,0));
        }else{
            accounts[msg.sender].push(Account(msg.sender,1,amount,0,0));
        }
        joinedAccounts[msg.sender] = true;
    }
    
    //Function to deposit yields in an Account
    function depositYields( uint amount,address to,uint transactionNumber) private{
         Account storage accountAux = accounts[to][transactionNumber-1];
         uint numberTrx = accountAux.numberTrx;
         uint depositAmount =accountAux.depositAmount;
         uint depositCounter = (accountAux.depositCounter+1);
         uint depostiYields =(accountAux.depositYields+amount);
         accounts[to][transactionNumber-1]=(Account(to,numberTrx,depositAmount,depositCounter,depostiYields));
    }
    
    
   //Function to get the balance of the contract
   function getBalance() public view onlyBy(owner) returns(uint)  {
        return (address(this).balance);
    }
    
    //Function to tranfer an amount of cash to an owner account
    function transferToOwner(uint amount) public onlyBy(owner){
        require(address(this).balance >= amount,
            "Insufficient balance amount");
        payable(owner).transfer(amount);
    }
    
    //Function to tranfer an amount of cash to an account
    function transferTo(uint amount, address to, uint transactionNumber)public onlyBy(owner){
        require(accountJoined(to),
            "Account not registered.");
        require(address(this).balance >= amount);
        require(to != address(0));
        depositYields(amount,to,transactionNumber);
        payable(to).transfer(amount);
    }
    
    //Function to get info about personal accounts
    function getAccountBalance() public view returns(Account[] memory){
        require(accountJoined(msg.sender),
            "Account not registered.");
        uint count = accounts[msg.sender].length;  
        Account[] memory array = new Account[](count);
        for (uint i = 0; i < count; i++) {
            array[i] = accounts[msg.sender][i];
        }
        return array;
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
