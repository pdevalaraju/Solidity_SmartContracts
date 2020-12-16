pragma solidity ^0.5.0;

contract DeferredEquityPlan {
    
    address payable private employee;
    address private human_resources;
    bool active = true; // this employee is active at the start of the contract
    uint total_shares = 1000;
    uint annual_distribution = 250;
    uint fakenow = now;
    uint start_time = fakenow;
    uint unlock_time = fakenow + 365 days;
    
    uint public distributed_shares;
    
    
    constructor (address payable _employee) public {
        human_resources = msg.sender;
        employee = _employee;
       
    }
    
    function distribute() public {
        require(msg.sender == human_resources || msg.sender == employee, "You are not authorized to execute this contract.");
        require(active == true, "Contract is not active.");
        require(unlock_time <= fakenow, "Account is locked until the next vesting period");
        require (distributed_shares < total_shares, "Cannot distribute beyond the Vested shares ");
        
        unlock_time +=365 days;
        
        distributed_shares = ((fakenow - start_time)/(86400*365)) * annual_distribution;
        
        if (distributed_shares > total_shares) {
            distributed_shares = total_shares;
        }
    }
    
    
    function fastforward() public {
        fakenow += 200 days;
    }


    // human_resources and the employee can deactivate this contract at-will
    function deactivate() public {
        require(msg.sender == human_resources || msg.sender == employee, "You are not authorized to deactivate this contract.");
        active = false;
    }

    // Since we do not need to handle Ether in this contract, revert any Ether sent to the contract directly
    function() external payable {
        revert("Do not send Ether to this contract!");
    }
}
