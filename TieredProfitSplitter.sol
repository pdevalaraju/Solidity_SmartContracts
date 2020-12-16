pragma solidity ^0.5.0;

contract TieredProfitSplitter {
    
    address payable private employee_one; // ceo address
    address payable private employee_two; // cto address
    address payable private employee_three; // bob's address
    uint private tier1_share;
    uint private tier2_share;
    uint private tier3_share;
    address payable owner;
    
    
    constructor (address payable ceo,  address payable cto, address payable bob, 
                    uint ceo_share, uint cto_share, uint bob_share) public {
        employee_one = ceo;
        employee_two = cto;
        employee_three = bob;
        tier1_share = ceo_share;
        tier2_share = cto_share;
        tier3_share = bob_share;
        owner = msg.sender;
        
    }
    
    function balance() public view returns(uint) {
        return (address(this).balance);
    
    }
    
     function deposit() public payable {
        require (msg.sender == owner, "You are not aythorized to operate this account"); 
        uint points = msg.value / 100; // Calculates rudimentary percentage by dividing msg.value into 100 units
        uint total;
        uint amount;
        
        amount = points * tier1_share;
        employee_one.transfer(amount);
        total += amount;
        
        amount = points * tier2_share;
        employee_two.transfer(amount);
        total += amount;
        
        amount = points * tier3_share;
        employee_three.transfer(amount);
        total += amount;
        
        
        if (total < msg.value) {
            employee_one.transfer(msg.value - total); // ceo gets the remaining tokens
        }

      }

    function fallback() external payable {
        deposit();
    }

    
}