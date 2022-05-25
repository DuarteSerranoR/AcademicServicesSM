// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
contract AcademicService {
    
    CourseContract[] courses;

    constructor() {
        courses = ...
    }

    function newCourse(students)

    /// ... all the other functions from each course contract
}
*/

/*
contract StudentLedger (contains the students and their functions) (?)
...
*/



contract CourseContract {

    // Smart Contracts should be small, because of gas consumption


    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///
    ///     Struct Objects and Enumerables
    ///
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


    /// When changed, update the SubjectEnumByIndex and SubjectEnumByString functions
    enum Subjects_Enum {
        DTI, // = 0 (uint val)
        TFD, // = 1 (uint val)
        SD, // = 2 (uint val)
        PPC, // = 3 (uint val)
        CQ // = 4 (uint val)
    } function SetupSubjects() private {
        Subjects[Subjects_Enum.DTI] = Subject(address(0),6,new address[](0), new uint[](0), new bool[](0));
        Subjects[Subjects_Enum.TFD] = Subject(address(0),6,new address[](0), new uint[](0), new bool[](0));
        Subjects[Subjects_Enum.SD] = Subject(address(0),3,new address[](0), new uint[](0), new bool[](0));
        Subjects[Subjects_Enum.PPC] = Subject(address(0),6,new address[](0), new uint[](0), new bool[](0));
        Subjects[Subjects_Enum.CQ] = Subject(address(0),3,new address[](0), new uint[](0), new bool[](0));
        subjectNum = 5;
    } function SubjectEnum(uint i) private pure returns (Subjects_Enum) {
        if (i==0) return Subjects_Enum.DTI;
        else if (i==1) return Subjects_Enum.TFD;
        else if (i==2) return Subjects_Enum.SD;
        else if (i==3) return Subjects_Enum.PPC;
        else if (i==4) return Subjects_Enum.CQ;
        else revert("Unkown Subjects_Enum index.");
    } function SubjectEnum(string memory str) private pure returns (Subjects_Enum) {
        if (equals(str,"DTI")) return Subjects_Enum.DTI;
        else if (equals(str,"TFD")) return Subjects_Enum.TFD;
        else if (equals(str,"SD")) return Subjects_Enum.SD;
        else if (equals(str,"PPC")) return Subjects_Enum.PPC;
        else if (equals(str,"CQ")) return Subjects_Enum.CQ;
        else revert("Unkown Subjects_Enum string.");
    } function getCredits(address student) private view returns (uint) {
        uint credits = 0;
        for (uint i = 0; i < subjectNum; i++) {
            if (contains(Subjects[SubjectEnum(i)].students, student)) {
                credits += Subjects[SubjectEnum(i)].credits;
            }
        }
        return credits;
    }

    struct Subject {
        address professor;
        uint credits; // starts of with 3 or 6
        address[] students;
        uint[] grades; // nested mappings don't work
        bool[] reevalRequests;
        // each student will have the same index as the grade and reevaluation requests
    }

    struct StudentSubject {
        Subjects_Enum subject;
        uint grade;
    }

    struct Student {
        Subjects_Enum[] subjects;
        //string degree_and_year;
    }



    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///
    ///     Stored State Values
    ///
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


    uint256 CreationDate; // Course's validity = 1 year // TODO - use a timestamp to know when it was created and go from there?
    uint256 FinneyRate;
    uint256 year;
    uint256 month;

    uint subjectNum;

    // balances
    mapping(address => uint) balances;

    // The admin of the contract -> the school's user address
    address admin; // course admin


    // The students
    uint maxStudents; // limiter for gas prices
                      // TODO - convert to assert <------------------
    mapping(address => Student) Students; // TODO - might revert back to only have a address array?
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
        year = 365 days; // could be changed in each deployment of the contract, depending on the year's number of days
        month = 30 days; // We are also assuming that a month is 30 days,, whatever the month may be!!


        //FinneyRate = 0.001;
        FinneyRate = 10**3;

        CreationDate = block.timestamp; // TODO - vulnerability or is this good here?
                                        //      - Since it is being used as a DateTime record, and not a randomness implementation variable, it should be fine.
                                        //      -> https://stackoverflow.com/questions/71000103/solidity-block-timestamp-vulnerability
                                        //      -> https://ethereum.stackexchange.com/questions/108033/what-do-i-need-to-be-careful-about-when-using-block-timestamp
        admin = msg.sender;
        if (students.length > 0 && students.length < maxStudents) {
            for (uint256 i = 0; i < students.length; i++) {
                Student memory student = Student(new Subjects_Enum[](0));
                Students[students[i]] = student;
                Students_addr.push(students[i]);
            }
        }
        SetupSubjects();
    }


    // General balance functions
    function deposit() payable public {
        require(msg.value > 0, "Invalid deposit value.");
        balances[msg.sender] += msg.value / FinneyRate;
    }

    function withdrawal(uint val) public payable {
        require(msg.value > 0, "Invalid withdrawal value.");
        require(balances[msg.sender] >= val, "Not enough balance to perform withdrawal.");
        require(address(this).balance >= val, "Contract without enough balance to pay the ammount. Please contact an administrator.");

        val = val*FinneyRate;
        payable(msg.sender).transfer(val);
        balances[msg.sender] -= msg.value;
    }

    function balance() public view returns (uint) {
        return balances[msg.sender];
    }

    // School's course administration functions - used only by an admin
    function AddStudent(address student_addr) public {
        bool exists = contains(Students_addr, student_addr);
        require(valid(), "Invalid Contract.");
        require(CreationDate + 1 weeks >= block.timestamp, "At least one week has passed since the creation of the contract, so you cannot add another student.");
        require(msg.sender == admin, "Permission level not enough.");
        require(Students_addr.length + 1 < maxStudents, "Student number higher than the allowed ammount of students for this course.");
        require(!exists, "Student already existed.");
        
        Student memory student = Student(new Subjects_Enum[](0));
        Students[student_addr] = student;
        Students_addr.push(student_addr);
    }

    function AddStudents(address[] memory students) public {
        bool exists = containsRange(Students_addr, students);
        require(valid(), "Invalid Contract.");
        require(CreationDate + 1 weeks >= block.timestamp, "At least one week has passed since the creation of the contract, so you cannot add more students.");
        require(msg.sender == admin, "Permission level not enough.");
        require(Students_addr.length + students.length + 1 < maxStudents, "Student number higher than the allowed ammount of students for this course.");
        require(!exists, "At least one student already existed.");
        for (uint256 i = 0; i < students.length; i++) {
            Student memory student_obj = Student(new Subjects_Enum[](0));
            Students[students[i]] = student_obj;
            Students_addr.push(students[i]);
        }
    }
    
    function AssignProfessor(address professor, uint subject) public {
        Subjects_Enum s = SubjectEnum(subject);
        AssignProfessor(professor, s);
    }
    
    function AssignProfessor(address professor, string memory subject) public {
        Subjects_Enum s = SubjectEnum(subject);
        AssignProfessor(professor, s);
    }
    
    function AssignProfessor(address professor, Subjects_Enum subject) private {
        require(valid(), "Invalid Contract.");
        require(CreationDate + 2 days >= block.timestamp, "At least two days have passed since the creation of the contract, so you cannot assign professors.");
        require(msg.sender == admin, "Permission level not enough.");

        if(!contains(Professors, professor)) {
            Professors.push(professor);
        }
        Subjects[subject].professor = professor;
    }
    
    // The student's functions
    function RegisterSubject(uint subject) public {
        Subjects_Enum s = SubjectEnum(subject);
        RegisterSubject(s);
    }
    function RegisterSubject(string memory subject) public {
        Subjects_Enum s = SubjectEnum(subject);
        RegisterSubject(s);
    }
    function RegisterSubject(Subjects_Enum subject) private {
        require(valid(), "Invalid Contract.");
        require(CreationDate + 2 weeks >= block.timestamp, "At least two weeks have passed since the creation of the contract, there cannot be any more student registerations to subjects in the contract.");
        require(contains(Students_addr, msg.sender), "Student not registered in the contract to be assign a subject. If you are a student, contact the faculty!");
        require(Subjects[subject].professor != address(0), "Subject with no assigned professor.");
        require(!contains(Subjects[subject].students, msg.sender), "Student was already registered in this subject.");
        
        uint credits = getCredits(msg.sender);
        uint payValue = 0;
        if (credits < 18 && Subjects[subject].credits + credits > 18) {
            payValue = Subjects[subject].credits + credits - 18;
        } else if (credits > 18) {
            payValue = Subjects[subject].credits;
        }

        if (payValue != 0) {
            require(balances[msg.sender] >= payValue, "Not enough balance.");
            balances[msg.sender] -= payValue;
        }

        if (Subjects[subject].students.length == Subjects[subject].grades.length && 
                Subjects[subject].students.length == Subjects[subject].reevalRequests.length) { // This should allways happen, but to go around any vulnerability, we implement other conditions
            
            Subjects[subject].students.push(msg.sender);
            Subjects[subject].grades.push(0);
            Subjects[subject].reevalRequests.push(false);
        } else if (Subjects[subject].students.length < Subjects[subject].grades.length &&
                Subjects[subject].reevalRequests.length < Subjects[subject].grades.length) {

            Subjects[subject].students.push(msg.sender); // As this function stops working after 2 weeks, we assume they are not stored in the system
            Subjects[subject].reevalRequests.push(false);
        } else if (Subjects[subject].students.length < Subjects[subject].reevalRequests.length &&
                Subjects[subject].grades.length < Subjects[subject].reevalRequests.length) {

            Subjects[subject].students.push(msg.sender);
            Subjects[subject].grades.push(0);
        } else if (Subjects[subject].students.length < Subjects[subject].reevalRequests.length &&
                Subjects[subject].students.length < Subjects[subject].reevalRequests.length) {

            Subjects[subject].students.push(msg.sender);
        } else {
            while (Subjects[subject].students.length > Subjects[subject].grades.length) {
                Subjects[subject].grades.push(0);
            }
            while (Subjects[subject].students.length > Subjects[subject].reevalRequests.length) {
                Subjects[subject].reevalRequests.push(false);
            }
            Subjects[subject].students.push(msg.sender);
            Subjects[subject].grades.push(0);
            Subjects[subject].reevalRequests.push(false);
        }
    }
    function RequestReevaluation(uint subject) public {
        Subjects_Enum s = SubjectEnum(subject);
        RequestReevaluation(s);
    }
    function RequestReevaluation(string memory subject) public {
        Subjects_Enum s = SubjectEnum(subject);
        RequestReevaluation(s);
    }
    function RequestReevaluation(Subjects_Enum subject) private {
        require(valid(), "Invalid Contract.");
        require(CreationDate + 2 weeks >= block.timestamp, "At least two weeks have passed since the creation of the contract, there cannot be any more student registerations to subjects in the contract.");
        require(contains(Subjects[subject].students, msg.sender), "Student not registered in the subject to request reevaluation.");
        uint i = index(Subjects[subject].students,msg.sender);
        require(Subjects[subject].grades[i] < 10, "You passed the subject so requesting a reevaluation is not possible.");
        require(balances[msg.sender] >= 2, "Not enough balance to request a reevaluation. The price is 2 Finneys.");

        Subjects[subject].reevalRequests[i] = true;
        balances[msg.sender] -= 2; // pays 2 finney ahead so it cannot be withdrawn
    }
    function UnregisterSubject(uint subject) public {
        Subjects_Enum s = SubjectEnum(subject);
        UnregisterSubject(s);
    }
    function UnregisterSubject(string memory subject) public {
        Subjects_Enum s = SubjectEnum(subject);
        UnregisterSubject(s);
    }
    function UnregisterSubject(Subjects_Enum subject) private {
        require(valid(), "Invalid Contract.");
        require(CreationDate + month >= block.timestamp, "At least one month has passed since the creation of the contract, there cannot be any more student unregisterations from subjects in the contract.");
        require(contains(Subjects[subject].students, msg.sender), "Student already is not registered in the subject.");
        uint i = index(Subjects[subject].students,msg.sender);
        require(Subjects[subject].grades[i] < 10, "You passed the subject so requesting a reevaluation is not possible.");
        require(balances[msg.sender] >= 2, "Not enough balance to request a reevaluation. The price is 2 Finneys.");

        Subjects[subject].reevalRequests[i] = true;
        balances[msg.sender] -= 2; // pays 2 finney ahead so it cannot be withdrawn
    }

    // The Professor
    //function // atribuir nota (string (address_str) student, int cadeira -- eng?, grade)
    //function // AcceptReevaluation or ProcessReevaluation -> (string student_addr, cadeira, boolean accepted) // se aceita ou não -> 
                            // vai ao aluno, tenta remover o curso, verifica se o prof é prof do curso e finalmente, se o aluno é aluno do curso. 
                            // Se aceitar recebe o dinheiro de reavaliação e o aluno fica sem nota ou uma flag para ser reavaliado (grade=-1)

    
    // TODO - instead of ifs, use many 'modifier's and 'require()'s to make sure everything is well/ok/accectable in terms of conditions

/*
    prof gets the id of student, sees if student is on course, if it is the course's professor, it changes the grade
*/


    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///
    ///     Utils
    ///
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


    function valid() private view returns (bool) {
        return CreationDate + year > block.timestamp;
    }

    function containsRange(address[] memory arr, address[] memory searchFor) private pure returns (bool) {
        if (arr.length == 0)
            return false;
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
            return false;
        for (uint256 i = 0; i < arr.length; i++) {
            if (arr[i] == searchFor) {
                return true; // found it
            }
        }
        return false; // not found
    }

    function equals(string memory s1, string memory s2) private pure returns (bool) {
        return keccak256(abi.encodePacked(s1)) == keccak256(abi.encodePacked(s2));
    }

    function index(address[] memory arr, address target) private pure returns (uint) {
        uint n;

        for (uint256 i = 0; i < arr.length; i++) {
            if (arr[i] == target) {
                n = i; // 0'd index
                break;
            }
        }

        return n;
    }




    /*



    // The payable things will be the student's reavaluation requests - como pagar para exames em recursos, e quem recebe é o prof. Valores no enunciado. o aluno paga 2, 1 para escola e outro prof

    */

}