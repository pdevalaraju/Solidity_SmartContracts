pragma solidity ^0.5.0;

contract ProfitSplitter {
    
    address payable private employee_one;
    address payable private employee_two;
    address payable private employee_three;
    address payable owner;


    constructor (address payable _one, address payable _two, address payable _three) public {
    
        employee_one = _one;
        employee_two = _two;
        employee_three = _three;
        owner = msg.sender;
     }


    function balance() public view returns(uint) {
        return (address(this).balance);
    
    }

    function deposit() public payable {
        require (msg.sender == owner, "You are not the Owner of this account");
        
        uint amount = msg.value / 3;

        employee_one.transfer(amount);
        employee_two.transfer(amount);
        employee_three.transfer(amount);
        
        if (msg.value % 3 != 0) {
            owner.transfer(msg.value - amount * 3);
        }
        
        balance();
    }

    function fallback() external payable {
        deposit();
    }

}