// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract HealthRecord {
    mapping(address => Doctor) doctorRecords;
    mapping(address => bool) isPatient;
    mapping(address => bool) isDoctor;
    mapping(address => string) patientRecords;
    mapping(address => Patient) patients;

    struct Patient {
        address patientAddr;
        mapping(address => bool) allowedDoctor;
        address[] doctors;
        // string [] appointments;
        string cid;
    }
    struct Doctor {
        string name;
        string email;
        string imageUrl;
        string publicKey;
        address doctorAddr;
        address[] patients;
        mapping(address => bool) Ispatients;
        //
        // address addr;
    }

    function getIsPatient(address patientAddr) public view returns (bool) {
        if (isPatient[patientAddr] == true) {
            return true;
        }
        return false;
    }

    function getPatient(
        address patientAddr
    ) public view returns (string memory) {
        require(
            getIsPatient(patientAddr) == true,
            "Account address not a registered patient."
        );
        return patientRecords[patientAddr];
    }

    function addNewPatient(
        address patientAddr,
        string calldata cid
    ) public returns (bool) {
        require(
            getIsDoctor(patientAddr) == false,
            "This address is registered for a doctor."
        );
        require(
            getIsPatient(patientAddr) == false,
            "A patient is already registered using this account address."
        );
        isPatient[patientAddr] = true;
        patientRecords[patientAddr] = cid;
        Patient storage patient = patients[patientAddr];
        patient.patientAddr = patientAddr;
        patient.cid = cid;
        return true;
    }
    function removePatient(address patientAddr)public{
        isPatient[patientAddr]=false;
    }

    function getIsDoctor(address doctorAddr) public view returns (bool) {
        if (isDoctor[doctorAddr] == true) {
            return true;
        }
        return false;
    }

    // function getDoctorHelper(address doctorAddr) internal view returns(Doctor storage){
    //     return doctorRecords[doctorAddr];
    // }
    function getDoctor(
        address doctorAddr
    )
        public
        view
        returns (
            string memory,
            string memory,
            string memory,
            address,
            address[] memory,
            string memory
        )
    {
        // require(
        //     getIsDoctor(doctorAddr) == true,
        //     "Account address is not registered as doctor."
        // );
        // address[] arr;
        // for(uint i=0)
        return (
            doctorRecords[doctorAddr].name,
            doctorRecords[doctorAddr].email,
            doctorRecords[doctorAddr].imageUrl,
            doctorRecords[doctorAddr].doctorAddr,
            doctorRecords[doctorAddr].patients,
            doctorRecords[doctorAddr].publicKey
        );
        // return getDoctorHelper(doctorAddr);
        // return doctorRecords[doctorAddr];
    }

    function addNewDoctor(
        address doctorAddr,
        string calldata publicKey,
        string calldata name,
        string calldata email,
        string calldata imageUrl
    ) public returns (bool) {
        require(
            getIsDoctor(doctorAddr) == false,
            "Account address is already registered as doctor."
        );
        require(
            getIsPatient(doctorAddr) == false,
            "Account address is already registered as patient."
        );
        isDoctor[doctorAddr] = true;
        Doctor storage newDoctor = doctorRecords[doctorAddr];
        newDoctor.doctorAddr = doctorAddr;
        newDoctor.email = email;
        newDoctor.imageUrl = imageUrl;
        newDoctor.name = name;
        newDoctor.publicKey = publicKey;
        return true;
    }

    function addDoctorForPatient(
        address doctorAddr,
        address patientAddr
    ) public {
        require(
            getIsPatient(patientAddr) == true,
            "Account address is not of a registered Patient."
        );
        Patient storage patient = patients[patientAddr];
        if (patient.allowedDoctor[doctorAddr] == false) {
            patient.doctors.push(doctorAddr);
        }
        patient.allowedDoctor[doctorAddr] = true;
    }

    function getDoctorForPatient(
        address patientAddr
    ) public view returns (address[] memory) {
        require(
            getIsPatient(patientAddr) == true,
            "This address is not of a registered patient"
        );
        Patient storage storedPatient = patients[patientAddr];
        return storedPatient.doctors;
        // return patients[patientAddr].patients;
    }

    function addPatientForDoctor(
        address patientAddr,
        address doctorAddr
    ) public {
        require(
            getIsDoctor(doctorAddr) == true,
            "addPatientForDoctor() function is triggered by non-doctor address."
        );
        doctorRecords[doctorAddr].patients.push(patientAddr);
        doctorRecords[doctorAddr].Ispatients[patientAddr] = true;
    }

    function updateHealthRecord(
        address patientAddr,
        string calldata cid
    ) public {
        require(
            getIsPatient(patientAddr) == true,
            "A patient is not a registered on this account address."
        );
        patientRecords[patientAddr] = cid;
        Patient storage patient = patients[patientAddr];
        patient.cid = cid;
    }
}
