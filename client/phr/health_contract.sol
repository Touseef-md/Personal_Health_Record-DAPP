// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract HealthRecord {
    mapping(address => Doctor) doctorRecords;
    mapping(address => bool) isPatient;
    mapping(address => bool) isDoctor;
    mapping(address => string) patientRecords;
    // struct patientRecord{

    // }a
    struct Doctor {
        string name;
        string email;
        string imageUrl;
        address doctorAddr;
        // address addr;
    }

    function getIsPatient(address patientAddr) public view returns (bool) {
        if(isPatient[patientAddr]==true){
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
    }

    function getIsDoctor(address doctorAddr) public view returns (bool) {
        if(isDoctor[doctorAddr]==true){
            return true;
        }
        return false;
    }

    function getDoctor(address doctorAddr) public view {

    }
}
