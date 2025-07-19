# SDK Todo - Field Work Task Manager

A simple and elegant to-do app built with Flutter, specifically designed for field work teams to manage their daily tasks efficiently. The app helps teams prepare their to-do lists for the day and manage them while working in the field.

## ✨ Features

### Core Functionality
- ✅ **Add Tasks**: Create new tasks with title and optional description
- ✅ **Mark Complete/Incomplete**: Toggle task completion status with visual feedback
- ✅ **Edit Tasks**: Modify task title, description, due date, priority, and category
- ✅ **Delete Tasks**: Remove tasks with confirmation dialog
- ✅ **Local Persistence**: All data stored locally using Hive database

### User Interface
- ✅ **Task List**: Clean, organized view of all tasks
- ✅ **Visual Distinction**: Completed tasks shown with strikethrough and check icons
- ✅ **Filtering**: Filter tasks by "All", "Completed", and "Incomplete"
- ✅ **Dark Mode**: Full dark/light theme support with toggle
- ✅ **Drag to Reorder**: Reorder tasks by dragging (with persistence)

### Additional Features
- 📅 **Date Selection**: Filter tasks by specific dates
- 🏷️ **Categories**: Organize tasks with custom categories
- ⚡ **Priority Levels**: Set task priority (Low, Medium, High)
- 📊 **Progress Tracking**: Visual progress indicator and completion stats
- 🎨 **Beautiful UI**: Modern, clean design with smooth animations
- 📱 **Responsive**: Works on different screen sizes

## 🏗️ State Management Approach

The app uses **GetX** for state management, providing:

- **Reactive State**: Automatic UI updates when data changes
- **Dependency Injection**: Clean controller management
- **Route Management**: Simple navigation between screens
- **Theme Management**: Persistent theme switching

### Key Controllers:
- `TodoController`: Manages all task operations (CRUD, filtering, sorting)
- `ThemeController`: Handles dark/light mode switching
- `SplashController`: Manages app initialization

## 💾 Data Persistence

**Hive Database** is used for local storage:
- **Fast Performance**: NoSQL database optimized for Flutter
- **Type Safety**: Strongly typed data models
- **Offline First**: Works without internet connection
- **Automatic Persistence**: All changes saved immediately

### Data Structure:
```dart
Todo Model:
- id: Unique identifier
- name: Task title
- description: Optional description
- isCompleted: Completion status
- date: Due date
- category: Optional category
- priority: Priority level (1-3)
- createdAt/updatedAt: Timestamps
- sortOrder: Custom ordering
```

## 🚀 How to Run the App

### Prerequisites
- Flutter SDK (3.7.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd sdk_todo
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate model files**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Build for Release
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## 📱 App Structure

```
lib/
├── features/
│   ├── data/
│   │   ├── model/          # Data models (Todo)
│   │   └── source/         # Data sources (Hive service)
│   └── presentation/
│       ├── bindings/       # Dependency injection
│       ├── controllers/    # State management
│       ├── routes/         # Navigation routes
│       ├── views/          # Screen widgets
│       └── widgets/        # Reusable components
├── utils/
│   ├── constants/          # App constants (colors, fonts, strings)
│   └── helpers/            # Utility functions
└── main.dart              # App entry point
```

## 🎯 Field Work Team Benefits

This app is specifically designed for field work teams:

- **Offline Capability**: Works without internet connection
- **Quick Task Management**: Fast add/edit/complete tasks
- **Daily Planning**: Date-based task organization
- **Priority System**: Focus on important tasks first
- **Category Organization**: Group tasks by work type
- **Progress Tracking**: Monitor daily completion rates
- **Dark Mode**: Better visibility in various lighting conditions

## 📋 Requirements Satisfaction

| Requirement | Status | Implementation |
|-------------|--------|----------------|
| Add new task | ✅ | Add Task screen with title & description |
| Mark completed/uncompleted | ✅ | Tap checkbox or swipe gesture |
| Edit task | ✅ | Edit Task screen with full editing |
| Delete task | ✅ | Swipe gesture or delete button |
| Local persistence | ✅ | Hive database with auto-save |
| Task list display | ✅ | Beautiful list with all task info |
| Visual distinction | ✅ | Strikethrough, opacity, check icons |
| Filter (All/Completed/Incomplete) | ✅ | Filter chips with instant updates |
| Dark mode support | ✅ | Full theme switching with persistence |
| Drag to reorder | ✅ | ReorderableListView with persistence |

## 🔧 Technical Notes

### Assumptions Made:
- Tasks are organized by date (daily planning focus)
- Categories are user-defined and persistent
- Priority levels are fixed (Low/Medium/High)
- Reordering is maintained per filter view
- Theme preference persists across app restarts

### Code Quality:
- **Clean Architecture**: Separation of concerns
- **SOLID Principles**: Maintainable and extensible code
- **Error Handling**: Graceful error management
- **Type Safety**: Strong typing throughout
- **Documentation**: Comprehensive code comments
- **Consistent Styling**: Unified UI components

## 🎨 Design Philosophy

The app follows Material Design principles with:
- **Intuitive Navigation**: Easy-to-understand user flow
- **Consistent Theming**: Unified color scheme and typography
- **Smooth Animations**: Engaging user interactions
- **Accessibility**: Support for different screen sizes and themes
- **Performance**: Optimized for smooth operation

## 📄 License

This project is created as a demonstration of Flutter development skills for field work task management.

---

**Built with ❤️ using Flutter & GetX**