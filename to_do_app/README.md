<div align="center">

  # 📝 To-Do App — Offline First Task Manager

  **A modern, intuitive, and performant Task Management application built with Flutter, BLoC/Cubit, and Hive persistence.**

  ![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
  ![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
  ![BLoC](https://img.shields.io/badge/State_Management-BLoC/Cubit-blue?style=for-the-badge)
  ![Hive](https://img.shields.io/badge/Local_Storage-Hive_NoSQL-orange?style=for-the-badge)

</div>

---

## 📌 Project Overview

The **To-Do App** is an offline-first productivity client engineered to offer a seamless, high-performance task tracking experience. It addresses common local persistence bottlenecks by utilizing **Hive NoSQL**, ensuring instant boot-ups and state restoration without redundant cloud or authentication latency.

Designed adhering to modern UI/UX principles, the application provides intuitive visual focus metrics, dynamic filtering, real-time local state mutations, and a clean interface calibrated with a primary brand identity (`#00A896`).

---

## 📱 App Screenshots

<div align="center">

| Login Screen | Home View | Daily Progress Focus |
| :-: | :-: | :-: |
| <img src="assets/screenshots/login_view.png" width="220" /> | <img src="assets/screenshots/home_view.png" width="220" /> | <img src="assets/screenshots/display_tasks.png" width="220" /> |

| Add New Task | Date Picker | Delete Confirmation |
| :-: | :-: | :-: |
| <img src="assets/screenshots/add_task_view.png" width="220" /> | <img src="assets/screenshots/date_view.png" width="220" /> | <img src="assets/screenshots/delete_task_alert.png" width="220" /> |

| Action Completed | Drawer Navigation |
| :-: | :-: |
| <img src="assets/screenshots/complete_adding_alert.png" width="220" /> | <img src="assets/screenshots/drawer_view.png" width="220" /> |

</div>

---

## ✨ Key Features

- ⚡ **Offline-First Persistence:** Instant local synchronization powered by Hive NoSQL DB.
- 👤 **Seamless Onboarding:** Fast single-step username creation with session caching.
- 🎯 **Daily Focus Metrics:** Visual progress indicators calculating daily completion percentages dynamically.
- 🗓️ **Native DatePicker:** Enhanced UX for deadline selection utilizing native date pickers.
- 🔍 **Task Filtering:** Categorized view management dividing tasks between **All Tasks** and **Completed**.
- 💬 **Interactive Feedback:** Custom alert dialogs for confirmation states (Adding, Deleting).
- 🎨 **Unified Design System:** Consistent custom components (`CustomTextField`, `CustomButton`, `CustomDrawer`).

---

## 🏗️ Technical Architecture & Tech Stack

The application follows a modular, state-driven architecture separating data persistence, business logic, and UI layout layers.

| Purpose | Technology / Package |
| :--- | :--- |
| **Framework** | Flutter (Material 3) |
| **Language** | Dart |
| **State Management** | `flutter_bloc` (Cubit Pattern) |
| **Local Storage** | `hive`, `hive_flutter` |
| **Code Generation** | `build_runner`, `hive_generator` |
| **Formatting & Utilities** | `intl` |

---

## 👥 Engineering Team & Task Breakdown

The project implementation was distributed across specialized module owners for the **DEPI Initiative**:

| Role / Team Member | Engineering Area | Responsibilities |
| :--- | :--- | :--- |
| **Mohamed Khairy Roshdy Ali Ibrahim** *(Team Leader)* | **UI/UX & Design System** | Developed `HomeView`, `LogInView`, and standard component architecture (`CustomTextField`, `CustomButton`, `CustomDrawer`). |
| **Nour Amr Mohamed Sabek** | **State Management** | Implemented Cubit controllers (`UserCubit`, `TasksCubit`) and application state emission patterns (`TasksStates`, `UserStates`). |
| **Amani Ahmed Hassan Ahmed** | **Data Layer & Storage** | Built Hive models (`TaskModel`, `UserModel`), TypeAdapters, local storage encryption/boxes, and auto-login logic. |
| **Malak Hany Sayed Ahmed** | **Feature Integration & QA** | Integrated native `showDatePicker`, modal bottom sheets, confirmation dialogs, and handled overall system error boundaries. |

---

## 📂 Project Structure

```text
lib/
├── cubit/
│   ├── task_cubit/
│   │   ├── tasks_cubit.dart
│   │   └── tasks_states.dart
│   └── user_cubit/
│       ├── user_cubit.dart
│       └── user_states.dart
├── models/
│   ├── task_model.dart
│   ├── task_model.g.dart
│   ├── user_model.dart
│   └── user_model.g.dart
├── views/
│   ├── completed_tasks_view.dart
│   ├── home_view.dart
│   └── log_in_view.dart
├── widgets/
│   ├── add_task_widget.dart
│   ├── custom_button.dart
│   ├── custom_drawer.dart
│   ├── custom_text_field.dart
│   ├── no_tasks_widget.dart
│   └── task_builder.dart
└── main.dart
🚀 Getting Started
Prerequisites
Ensure you have the Flutter SDK installed on your local environment.

Bash
flutter --version
Installation Steps
Clone the repository:

Bash
git clone [https://github.com/Muhammadkhiry/DEPI_projects.git](https://github.com/Muhammadkhiry/DEPI_projects.git)
Navigate to project directory:

Bash
cd to_do_app
Install dependencies:

Bash
flutter pub get
Generate Hive Adapters (if model files are modified):

Bash
dart run build_runner build --delete-conflicting-outputs
Run the application:

Bash
flutter run
Run tests:

Bash
flutter test
🔮 Future Improvements
🏷️ Task priorities and custom categories.

🔍 Global task search and sorting options.

🔔 Local push notification reminders.

🌙 Dynamic Dark / Light theme switching.

☁️ Cloud synchronization support.

Developed with ❤️ for DEPI Initiative
