# Frontend Test Vista

A Flutter application for managing companies and their services. This frontend is designed to consume the backend API to display and manage data.

## 📋 Key Technical Choices

* **`http` Package**: Used for making direct API calls to the backend, which is a simple and effective approach for this project's scope.
* **Provider**: We've used the `provider` package for state management. This simplifies sharing the API client and data models across different screens, making the app's state predictable and easy to manage.

---

## ⚙️ Setup and Installation

### Prerequisites

* **Flutter SDK** (v3.0.0 or higher) and Dart (v3.0.0 or higher).
* **Android Studio** or **VS Code** with the Flutter and Dart plugins.
* **A running Android Emulator/iOS Simulator or a physical device.**
* **The backend API must be running.**

### Step-by-Step Guide

1.  **Clone the Repository:**
    ```bash
    git clone [https://github.com/your-username/flutter-test-vista.git](https://github.com/your-username/flutter-test-vista.git)
    cd flutter-test-vista
    ```

2.  **Install Dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Configure API URL:**
    Make sure the base URL in your Flutter code points to the correct backend address. This is a crucial step for the frontend to communicate with the backend running in Docker.
    * **For iOS Simulator/Web**: `http://localhost:3000`

4.  **Launch the Application:**
    Ensure the backend is running and then run the app on your preferred device.
    ```bash
    flutter run
    ```

---

## ⭐ Bonus Features Implemented

* **Responsive UI**: The layout is designed to be responsive, providing a good user experience on different screen sizes and orientations.