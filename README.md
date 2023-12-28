# Account Page

This Flutter application includes an Account Page feature that displays user information and enables users to update their display name and bio.

## Overview

The Account Page provides the following functionalities:

- Display user information retrieved from Firestore (display name and bio).
- Allow users to update their display name and bio.
- Logout functionality.

## Implementation Details

### Screens

- **CustomAccountPage**: Manages the display of user information and allows updates to the display name and bio.

### Firebase Integration

- Utilizes Firebase Authentication for user authentication.
- Connects to Firestore to retrieve and update user information.

### Usage

1. **Display User Information**: The Account Page fetches user data from Firestore and displays the user's current display name and bio.

2. **Update User Information**: Users can update their display name and bio by entering new details in the provided text fields and tapping the "Submit" button. The updated information is reflected in the Firestore database.

3. **Logout**: The app includes a logout button in the app bar, allowing users to sign out of their accounts.

## Getting Started

1. Clone the repository:

   ```bash
   git clone https://github.com/your_username/your_flutter_app.git
   ```

2. Navigate to the project directory and install dependencies:

   ```bash
   cd your_flutter_app
   flutter pub get
   ```

3. Run the application on an emulator or physical device:

   ```bash
   flutter run
   ```

4. Ensure Firebase setup:

   - Configure Firebase Authentication and Firestore in your Firebase Console.
   - Update the Firebase configurations in the Flutter app as per your Firebase project settings.

## Dependencies

The Account Page feature in this app relies on the following packages:

- `firebase_auth`: Firebase Authentication for user authentication.
- `cloud_firestore`: Firestore for data storage and retrieval.
- `flutter/material.dart`: Widgets and material design components.

## Contributors

- [Jean KHOGE](https://github.com/jeankh)
