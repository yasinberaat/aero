# Tech Context - Forge

## Project Identity
- **Name:** Forge
- **Package:** com.yasin.forge
- **Description:** Your productivity companion

## Platform
- Windows development environment
- Flutter SDK 3.10+
- Android target (release builds configured)

## Codebase expectations
- Clean, modular code
- Feature-based folders:
  - `features/finance` - Financial tracking with income/expense management
  - `features/work` - Task management with repeat functionality
  - `features/fitness` - Workout tracking and planning
  - `features/category` - Dynamic category system
  - `features/home` - Main dashboard

## UI / Design
- **Theme System:** Obsidian Black with light mode support
- **Color Tokens:**
  - Background: `#0b0b0b`
  - Accent (Electric Blue): `#257bf4`
  - Card: `#111418`
  - Border: `#ffffff0d`
  - Income Green: `#10b981`
  - Expense Red: `#ef4444`
- **Typography:** Inter font family
- **Components:** Custom drawer, theme toggle, category cards

## State Management
- Provider pattern (ChangeNotifierProvider)
- Providers:
  - `ThemeProvider` - Dark/light mode
  - `FinanceProvider` - Income/expense data
  - `CategoryProvider` - Dynamic categories

## Data Persistence
- **Hive** for local storage
- Models:
  - `WorkTaskModel` - Tasks with repeat functionality
  - `WorkoutModel` - Fitness tracking
  - `IncomeModel` / `ExpenseModel` - Financial data
  - `CategoryModel` - User categories

## Key Dependencies
- `provider: ^6.1.1` - State management
- `hive: ^2.2.3` + `hive_flutter: ^1.1.0` - Local database
- `fl_chart: ^0.66.0` - Charts and graphs
- `awesome_notifications: ^0.10.1` - Task reminders
- `intl: ^0.20.2` - Date/time formatting

## Build Configuration
- Release signing configured with keystore
- Application ID: `com.yasin.forge`
- Namespace: `com.yasin.forge`

---
**Last Updated:** January 30, 2026  
**Project Status:** Active Development
