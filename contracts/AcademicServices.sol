// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
contract AcademicService {
    
    CourseContract[] courses;

    constructor() {
        courses = ...
    }
}
*/

/*
contract StudentLedger (contains the students and their functions)
...
*/

contract CourseContract {

    // Smart Contracts should be small, because of gas consumption


    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///
    ///     Struct Objects and Enumerables
    ///
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


    enum Subjects_Enum {
        DTI, // = 0 (uint val)
        TFD, // = 1 (uint val)
        SD, // = 2 (uint val)
        PPC, // = 3 (uint val)
        CQ // = 4 (uint val)
    }

    struct Subject {
        address professor;
        uint credits; // starts of with 3 or 6
    }

    struct Student {
        // address addr;
        uint validity; // TODO - date to where it is valid
        //string degree_and_year;
    }


    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///
    ///     Stored State Values
    ///
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


    uint CreationDate; // Course's validity = 1 year // TODO - use a timestamp to know when it was created and go from there?


    // The admin of the contract -> the school's user address
    address admin; // course admin


    // The students
    uint maxStudents; // limiter for gas prices
    mapping(address => Student) Students;
    address[] public Students_addr;
    

    // The professors
    address[] Professors;

    
    // The course's subjects
    mapping(Subjects_Enum => Subject) Subjects; // Each subject has a professor, and will represented with an enumerable (int)
                                                // This means that adding new subjects isn't possible without changing code.



    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///
    ///     Course Contract's Initializable Constructor
    ///
    ///         Here are the hardcoded initial/default configurations for each stored state value.
    ///
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


    // The school's course function
    constructor(address[] memory students) {
        // TODO - create at least 5 subjects hardcoded

        maxStudents = 9000; // limiter for gas prices - put in constructor?

        admin = msg.sender;
        if (students.length > 0 && students.length < maxStudents) {
            for (uint256 i = 0; i < students.length; i++) {
                Student memory student = Student(0);
                Students[students[i]] = student;
                Students_addr.push(students[i]);
            }
        }
    }

    // School's course administration functions - used only by an admin
    // TODO - can only add within the first week of the contract
    function AddStudent(address student_addr) public returns (string memory) {
        bool exists = contains(Students_addr, student_addr);
         if (msg.sender != admin) {
            // log address and function?
            return "Permission level not enough.";
        } else if (Students_addr.length + 1 >= maxStudents) {
            return "Student number higher than the allowed ammount of students for this course.";
        } else if (!exists) {
            Student memory student = Student(0);
            Students[student_addr] = student;
            Students_addr.push(student_addr);
            return "Success!";
        } else if (exists) {
            // log?
            return "Student already existed.";
        } else {
            return "Failed to add new student";
        }
    }

    function AddStudents(address[] memory students) public returns (string memory) {
        bool exists = containsRange(Students_addr, students);
         if (msg.sender != admin) {
            // log address and function?
            return "Permission level not enough.";
        } else if (Students_addr.length + students.length >= maxStudents) {
            return "Student number higher than the allowed ammount of students for this course.";
        } else if (!exists) {
            for (uint256 i = 0; i < students.length; i++) {
                Student memory student_obj = Student(0);
                Students[students[i]] = student_obj;
                Students_addr.push(students[i]);
            }
            return "Success!";
        } else if (exists) {
            // log?
            return "At least one student already existed.";
        } else {
            return "Failed adding students";
        }
    }
    
    function AssignProffessor(address professor, Subject subject) public returns (string memory) { // Course can be code, like 'int course_id'
        // TODO - within the first two days of the contract

        if (msg.sender != admin) {
            // log address and function?
            return "Permission level not enough.";
        } else if () {
            return "Success!";
        } else {
            return "Failed adding students";
        }
    }
    




    // Utils
    function containsRange(address[] memory arr, address[] memory searchFor) private pure returns (bool) {
        if (arr.length == 0)
            return true;
        for (uint256 i = 0; i < arr.length; i++) {
            for (uint256 j = 0; i < searchFor.length; j++) {
                if (arr[i] == searchFor[j]) {
                    return true; // found it
                }
            }
        }
        return false; // not found
    }

    function contains(address[] memory arr, address searchFor) private pure returns (bool) {
        if (arr.length == 0)
            return true;
        for (uint256 i = 0; i < arr.length; i++) {
            if (arr[i] == searchFor) {
                return true; // found it
            }
        }
        return false; // not found
    }





    /*
    struct Contract {
        Student[] student;
        Course[] course_subjects;
    }

    struct Course {
        uint credits; // starts of with 3 or 6
    }

    /*
    struct Professor {
        
    }
    */

    //Contract[] contracts;


    

    // All this is inside a course with x subjects

    /*

    // The student's functions
    function RegisterCourse(int course_id) // payable -> pode registar até x créditos
    function RequestRevaluation(cadeira)

    // The Professor
    function // atribuir nota (string (address_str) student, int cadeira -- eng?, grade)
    function // AcceptReevaluation or ProcessReevaluation -> (string student_addr, cadeira, boolean accepted) // se aceita ou não -> 
                            // vai ao aluno, tenta remover o curso, verifica se o prof é prof do curso e finalmente, se o aluno é aluno do curso. 
                            // Se aceitar recebe o dinheiro de reavaliação e o aluno fica sem nota ou uma flag para ser reavaliado (grade=-1)
    
    // course is the contract, each "cadeira" will be a array or dictionary like the rock paper scissors game
    
    // use many odifiers and requires to make sure everything is well/ok/accectable in terms of conditions

       // The payable things will be the student's reavaluation requests - como pagar para exames em recursos, e quem recebe é o prof. Valores no enunciado. o aluno paga 2, 1 para escola e outro prof

    function CreateContract(address[] calldata students) public /*payable returns(bool)*//* {
        // if students lenght != 0
        
        // Per contract
        //create at least 5 courses
        //each course 1 professor
        Course[] memory courses = new Course[](0);
        Student memory student = new Student(payable(students[0]), 0, "0");
        Contract memory c = new Contract(student, courses);
        contracts.push(c);
    }
    */

}

/*
    prof gets the id of student, sees if student is on course, if it is the course's professor, it changes the grade
*/