pragma solidity ^0.8.0;

contract AcademicService {

    // Smart Contracts should be small, because of gas consumption


    // --> The admin of the contract <--
    address course;

    // The course's subjects
    Subject[] Subjects;

    // The students
    address[] Students;
    
    // The professors
    address[] Professors;


    // The school's course function
    constructor(address[] students) {
        course = msg.sender;

        n_students = 0;
    }

    function AddStudent(address student) {
        if (msg.sender == course) {
            Students.push(student);
        } else {}
    }
    function AddStudents(address[] students) {
        if (msg.sender == course) {
            Students.push(students);
        } else {}
    }
    function AssignProffessor(address professor, Subject subject) { // Course can be code, like 'int course_id'
        if () {
            
        }
    }







    struct Contract {
        Student[] student;
        Course[] course_subjects;
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

    //Contract[] contracts;


    

    // All this is inside a course with x subjects

    

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