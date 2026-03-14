# TimeTable Manager
### Student Timetable & Task Management System

> A Flutter mobile app with a PHP/MySQL REST API backend — allows students to manage their weekly class schedules and track subject-linked tasks with due dates, descriptions, and completion status. Supports user authentication with per-user data isolation.

---

## Overview

TimeTable Manager is a mobile productivity app built for students. Users register and log in to their own account, then manage their personal weekly class schedule and task list. The app communicates with a live PHP REST API backend over HTTPS, with local Hive caching for offline access. State is managed using the Provider pattern across three core providers: Auth, Schedule, and Task.

---

## Features

### Authentication
- User registration with name, email, and password (hashed server-side)
- Login with email and password verification
- Session persistence via Hive local storage
- Auto-login on app relaunch if session exists

### Schedules
- Add weekly class schedules with subject name, day, start/end time, room number, and teacher name
- View schedules organized by day of the week
- Edit and delete existing schedules
- Server-side time overlap detection (prevents conflicting schedules)

### Tasks
- Add tasks linked to subjects with name, description, and due date
- Toggle task completion status
- View tasks sorted by due date
- Edit and delete tasks
- Per-user data isolation — users only see their own tasks and schedules

### General
- Splash screen on launch with auto session check
- Cupertino (iOS-style) UI throughout
- Hive offline caching for schedules and tasks
- Provider-based state management

---

## App Navigation Flow

```
App Launch
    │
    ▼
SplashScreen
    ├── Check Hive (isLoggedIn)
    ├── ❌ Not logged in → LoginScreen
    │       ├── Enter email + password
    │       ├── POST /login.php
    │       ├── ❌ Failed → Show error
    │       └── ✅ Success → Save session to Hive → HomeScreen
    │
    ├── [Register link] → RegisterScreen
    │       ├── Enter name, email, password
    │       ├── POST /register.php
    │       ├── ❌ Failed (duplicate email, invalid) → Show error
    │       └── ✅ Success → Save session → HomeScreen
    │
    └── ✅ Already logged in → HomeScreen
            │
            ├── [Schedule Tab]
            │       ├── GET /get_schedules.php → Load user's schedule
            │       ├── View weekly schedule by day
            │       ├── Tap [+] → Add Schedule Form
            │       │       ├── Fields: Subject, Day, Start Time, End Time, Room, Teacher
            │       │       ├── POST /add_schedule.php
            │       │       └── ✅ Refresh schedule list
            │       ├── Tap schedule → Edit Schedule Form
            │       │       ├── POST /update_schedule.php
            │       │       └── ✅ Refresh schedule list
            │       └── Delete schedule
            │               ├── POST /delete_schedule.php
            │               └── ✅ Refresh schedule list
            │
            ├── [Tasks Tab]
            │       ├── GET /get_tasks.php → Load user's tasks (sorted by due date)
            │       ├── View all tasks with completion status
            │       ├── Tap [+] → Add Task Form
            │       │       ├── Fields: Task Name, Subject (optional), Description (optional), Due Date (optional)
            │       │       ├── POST /add_task.php
            │       │       └── ✅ Refresh task list
            │       ├── Tap task → Edit Task Form
            │       │       ├── POST /update_task.php
            │       │       └── ✅ Refresh task list
            │       ├── Toggle complete checkbox
            │       │       ├── POST /toggle_task_complete.php
            │       │       └── ✅ Update task status
            │       └── Delete task
            │               ├── POST /delete_task.php
            │               └── ✅ Refresh task list
            │
            └── [Logout]
                    ├── Clear Hive session (isLoggedIn = false)
                    └── Navigate back to LoginScreen
```

---

## Screens

| Screen | Description |
|---|---|
| SplashScreen | Launch screen — checks Hive session and routes accordingly |
| LoginScreen | Email + password login form |
| RegisterScreen | New user registration form |
| HomeScreen | Main container with Schedule and Tasks tabs |
| Schedule Tab | Weekly timetable view grouped by day |
| Add/Edit Schedule | Form for creating or updating a class schedule |
| Tasks Tab | Task list sorted by due date with completion toggle |
| Add/Edit Task | Form for creating or updating a task |

---

## Tech Stack

| Layer | Technology |
|---|---|
| Mobile App | Flutter 3.x (Dart) |
| UI Style | Cupertino (iOS-style) |
| State Management | Provider |
| Local Storage | Hive / hive_flutter |
| HTTP Client | http package |
| Backend | PHP (REST API) |
| Database | MySQL |
| Hosting | Live server (HTTPS) |
| Data Format | JSON |

---

## Backend (PHP/MySQL)

### Live Server

```
Base URL: https://devm.cpedev.site/TimeTable
```

### API Endpoints

#### Authentication

| Endpoint | Method | Input | Description |
|---|---|---|---|
| `/login.php` | POST | `email`, `password` | Login and return user info |
| `/register.php` | POST | `name`, `email`, `password` | Register new user |

#### Schedules

| Endpoint | Method | Input | Description |
|---|---|---|---|
| `/get_schedules.php` | GET | `user_id` | Get all schedules for user |
| `/add_schedule.php` | POST | schedule fields | Add new schedule (overlap check) |
| `/update_schedule.php` | POST | `id` + fields | Update existing schedule |
| `/delete_schedule.php` | POST | `id` | Delete a schedule |

#### Tasks

| Endpoint | Method | Input | Description |
|---|---|---|---|
| `/get_tasks.php` | GET | `user_id` | Get all tasks sorted by due date |
| `/add_task.php` | POST | task fields | Add a new task |
| `/update_task.php` | POST | `id` + fields | Update existing task |
| `/delete_task.php` | POST | `id` | Delete a task |
| `/toggle_task_complete.php` | POST | `id` | Toggle task completion status |

### Request / Response Format

**Login** — `POST /login.php`
```json
{
  "email": "juan@email.com",
  "password": "yourpassword"
}
```
```json
{
  "success": true,
  "user": {
    "id": 1,
    "name": "Juan Dela Cruz",
    "email": "juan@email.com"
  }
}
```

**Add Schedule** — `POST /add_schedule.php`
```json
{
  "user_id": 1,
  "subject_name": "Mobile App Development",
  "day_of_week": "Tuesday",
  "start_time": "07:00",
  "end_time": "14:00",
  "room_number": "CpE Lab",
  "teacher_name": "Prof. Cruz"
}
```

**Add Task** — `POST /add_task.php`
```json
{
  "user_id": 1,
  "task_name": "Techno Pitching",
  "subject_name": "Technopreneurship",
  "description": "Prepare slides and demo",
  "due_date": "2025-10-21"
}
```

### Database

**Database name:** `timetbl`

**users**
| Column | Type | Notes |
|---|---|---|
| id | INT | Auto-increment PK |
| name | VARCHAR | Full name |
| email | VARCHAR | Unique |
| password | VARCHAR | Hashed (password_hash) |
| created_at | TIMESTAMP | Auto |

**schedules**
| Column | Type | Notes |
|---|---|---|
| id | INT | Auto-increment PK |
| user_id | INT | FK → users (CASCADE delete) |
| subject_name | VARCHAR | Subject/course name |
| day_of_week | ENUM | Mon–Sun |
| start_time | TIME | Class start |
| end_time | TIME | Class end |
| room_number | VARCHAR | Room or lab |
| teacher_name | VARCHAR | Instructor |
| created_at | TIMESTAMP | Auto |

**tasks**
| Column | Type | Notes |
|---|---|---|
| id | INT | Auto-increment PK |
| user_id | INT | FK → users (CASCADE delete) |
| task_name | VARCHAR | Task title |
| subject_name | VARCHAR | Optional subject link |
| description | TEXT | Optional |
| due_date | DATE | Optional |
| is_completed | TINYINT | 0 = pending, 1 = done |
| created_at | TIMESTAMP | Auto |

---

## Project Structure

```
timetable-manager/
├── app/                              # Flutter Mobile App
│   ├── lib/
│   │   ├── main.dart                 # App entry point, Hive init, Provider setup
│   │   ├── constants.dart            # API URLs and Hive box/key constants
│   │   ├── providers/
│   │   │   ├── auth_provider.dart    # Login, register, logout, session
│   │   │   ├── schedule_provider.dart # Schedule CRUD state
│   │   │   └── task_provider.dart    # Task CRUD + toggle state
│   │   └── screens/
│   │       ├── splash_screen.dart    # Session check + routing
│   │       ├── login_screen.dart     # Login form
│   │       ├── register_screen.dart  # Register form
│   │       ├── home_screen.dart      # Tab container
│   │       ├── schedule_screen.dart  # Weekly schedule view
│   │       └── task_screen.dart      # Task list view
│   └── pubspec.yaml
│
├── backend/                          # PHP REST API
│   ├── config/
│   │   └── dbcon.php                 # DB connection (gitignored)
│   ├── login.php
│   ├── register.php
│   ├── get_schedules.php
│   ├── add_schedule.php
│   ├── update_schedule.php
│   ├── delete_schedule.php
│   ├── get_tasks.php
│   ├── add_task.php
│   ├── update_task.php
│   ├── delete_task.php
│   ├── toggle_task_complete.php
│   └── timetbl.sql                   # Database schema + sample data
│
├── .gitignore
└── README.md
```

---

## Mobile App Setup

### Prerequisites

- Flutter SDK 3.0+
- Dart SDK 3.0+
- Android Studio or VS Code

### Installation

```bash
cd app
flutter pub get
flutter run
```

### Server Configuration

The base URL is set in `lib/constants.dart`:

```dart
// Live server (current)
static const String baseUrl = 'https://devm.cpedev.site/TimeTable';

// For local testing with Android Emulator:
// static const String baseUrl = 'http://10.0.2.2/TimeTable';

// For local testing with real device (same WiFi):
// static const String baseUrl = 'http://YOUR_IP/TimeTable';
```

---

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  provider: ^6.1.2
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  http: ^1.5.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

---

## Developers

| Name | Role |
|---|---|
| Digman, Christian D. | Developer |

---

## Roadmap

- [ ] Weekly schedule calendar view (grid layout)
- [ ] Push notifications for upcoming tasks
- [ ] Color coding per subject
- [ ] Export timetable as image or PDF
- [ ] Dark mode
- [ ] Search and filter tasks
