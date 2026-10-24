# To Do App

A simple, clean task manager built with **Flutter**. It works fully offline: all data is stored locally on the device.

## Features
- Local login with a username (the app remembers you on the next launch)
- Add tasks with a title and a date (date picker)
- Edit and delete tasks (with a delete confirmation dialog)
- Mark tasks as completed / not completed
- "Daily Focus" card showing today's progress (completed / total tasks for today)
- Tabs: All Tasks and Completed
- Today's reminders (notification bell)
- Drawer with Edit Profile and Logout
- Empty state when there are no tasks
- Material 3 design with a unified teal theme

## Tech Stack
| Purpose | Package |
|---|---|
| Framework | Flutter (Material 3) |
| State management | flutter_bloc (Cubit) |
| Local storage | hive, hive_flutter |
| Code generation | hive_generator, build_runner |
| Date formatting | intl |

## Project Structure
```
lib/
├── cubit/        # TasksCubit, UserCubit + states
├── models/       # TaskModel, UserModel (Hive adapters)
├── views/        # LogInView, HomeView
├── widgets/      # AddTaskWidget (add/edit), TaskBuilder, CustomDrawer, ...
└── main.dart
```

## Getting Started
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # only if *.g.dart files are missing
flutter run
```
Run tests: `flutter test`

## Screenshots
See the `screenshots/` folder (login, home, add task, date picker, delete alert, drawer).

## Team
- Mohamed Khairy Roshdy Ali Ibrahim (Team Leader)
- Nour Amr Mohamed Sabek
- Amani Ahmed Hassan Ahmed
- Malak Hany Sayed Ahmed

## Future Improvements
Task priorities and categories, search, push notifications, dark mode, cloud sync.
