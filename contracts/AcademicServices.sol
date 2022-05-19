pragma solidity ^0.8.0;

contract AcademicService {
    struct Contract {
        Student[] student;
        Course[] courses;
    }
    
    struct Student {
        string addr;
        uint validity; // TODO - date to where it is valid
        string degree_and_year;
    }

    struct Course {
        uint credits; // starts of with 3 or 6
    }

    /*
    struct Professor {
        
    }
    */

    Contract[] contracts;
    address[] students;

    // All this is inside a course with x "cadeiras"

    // The school's function
    constructor(address[] students)
    function AddStudent(address)
    function AddStudents(address[])
    function AssignProffessor(address, cadeira) // Course can be code, like 'int course_id'

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

    function CreateContract(address[] calldata students) public /*payable returns(bool)*/ {
        // if students lenght != 0
        
        // Per contract
        //create at least 5 courses
        //each course 1 professor
        Course[] memory courses = new Course[](0);
        Student memory student = new Student(payable(students[0]), 0, "0");
        Contract memory c = new Contract(student, courses);
        contracts.push(c);
    }

}

/*
    prof gets the id of student, sees if student is on course, if it is the course's professor, it changes the grade
*/