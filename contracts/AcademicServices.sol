pragma solidity ^0.8.0;

contract Service {
    Contract[] contracts;

    function CreateContract(address[] calldata students) public /*payable returns(bool)*/ {
        // if students lenght != 0
        Contract c = new Contract(students);
        contracts.push(c);
    }

}

contract Contract {

    struct Student {
        address payable addr;
        uint validity; // TODO - date to where it is valid
        string degree_and_year;
    }

    //struct Course {

    //}

    constructor(address[] memory students) { // valid for a year

        //create at least 5 courses
    }
}