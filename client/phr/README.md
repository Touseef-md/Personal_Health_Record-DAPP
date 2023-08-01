# Personal Health Record (PHR) Mobile App with Blockchain Integration

## Overview

The Personal Health Record (PHR) Mobile App with Blockchain Integration is a cutting-edge healthcare management solution that empowers patients and doctors to securely manage and exchange medical data. This mobile application utilizes the power of blockchain technology to enhance data security, privacy, and accessibility, ensuring a seamless and trustworthy healthcare experience.

## Features

1. **User Registration and Authentication:**
   - Patients can register using their Metamask wallet account address and private key.
   - Doctors can also register themselves, providing their essential information.

2. **Comprehensive Health Records:**
   - Patients can input vital details such as name, age, blood group, weight, and height.
   - Robust Health Record objects are generated for each patient, encapsulating their medical data.

3. **Encryption and Decentralized Storage:**
   - All personal health data is encrypted using state-of-the-art RSA keys.
   - Encrypted data is stored locally on the patient's device for enhanced privacy.
   - The InterPlanetary File System (IPFS) is utilized for decentralized and redundant data storage.
   - Content Identifiers (CIDs) are generated for secure data retrieval.

4. **Smart Contract Integration:**
   - Ethereum smart contracts on the testnet facilitate secure storage of patient and doctor information.
   - Patient accounts are linked to their respective CIDs, ensuring an immutable audit trail.

5. **Patient-Doctor Interaction:**
   - Patients can request consultations with doctors by providing their Metamask account address.
   - Doctors receive consultation requests and await patient acceptance.
   - Upon acceptance, encrypted PHRs are exchanged between patients and doctors for review.

6. **Medical Condition and Appointment Management:**
   - Patients can monitor and manage their medical conditions by adding relevant data to their PHRs.
   - The app facilitates easy appointment booking with doctors for improved patient care.

7. **Prescription Management:**
   - Doctors have access to comprehensive patient health records, enabling them to add accurate prescriptions.
   - Prescriptions are securely transmitted back to patients, allowing them to update their PHRs accordingly.

## How to Run the App

1. Ensure you have the latest version of Flutter installed.
2. Clone this repository to your local machine.
3. Open the project in your favorite IDE (e.g., Android Studio or VSCode).
4. Run the app on an emulator or physical device using the `flutter run` command.

## Dependencies
- check from the pubspec.yaml
<!-- - web3dart: ^[Version]
- rsa_encrypt: ^[Version]
- firebase_core: ^[Version]
- cloud_firestore: ^[Version] -->
<!-- - ... (Add any additional dependencies here) -->

## Contribution

We welcome contributions to enhance the functionality and security of the app. Feel free to open an issue or submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE.md).

## Acknowledgments

We would like to extend our gratitude to all contributors and supporters who have made this project possible. Your dedication and enthusiasm have driven us to create a secure and user-friendly healthcare management solution. Thank you for joining us on this journey towards a healthier future.

---
*Note: Replace [Version] with the appropriate version numbers of the dependencies.*
