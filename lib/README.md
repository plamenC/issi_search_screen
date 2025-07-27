# Clean Architecture Structure

This project follows Clean Architecture principles with four distinct layers and implements a dynamic theme system with light, dark, and system themes.

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry point
├── presentation/                      # 🎨 Presentation Layer
│   ├── screens/                      # UI Screens
│   │   ├── home_screen.dart
│   │   ├── court_cases_screen.dart   # Merged search & my court cases with tabs
│   │   ├── court_hearings_screen.dart # Court hearings calendar
│   │   ├── navigation_screen.dart
│   │   └── qr_scanner_screen.dart
│   └── widgets/                      # Reusable UI Components
│       ├── court_case_card.dart
│       ├── custom_app_bar.dart       # App bar with theme toggle
│       └── custom_bottom_navigation.dart
├── application/                      # 🔧 Application Layer
│   └── controllers/                  # GetX Controllers
│       ├── search_controller.dart    # Search functionality
│       ├── my_court_cases_controller.dart # My court cases management
│       └── theme_controller.dart     # Theme state management
├── domain/                          # 🧠 Domain Layer
│   ├── entities/                     # Business Objects
│   │   └── court_case.dart          # Core court case entity
│   └── repositories/                 # Repository Interfaces
│       └── court_case_repository.dart # Data access contract
└── infrastructure/                  # 🏗️ Infrastructure Layer
    ├── repositories/                 # Repository Implementations
    │   └── court_case_repository_impl.dart # Supabase implementation
    ├── theme/                       # Theme System
    │   ├── app_colors.dart          # Color definitions
    │   └── app_theme.dart           # Theme configuration & controller
    └── assets/                      # Static Assets
        └── logo.svg                 # App logo
```

## 🎨 Theme System

The app implements a dynamic theme system with three modes:

### **Theme Modes**
- **Light Theme**: Bright interface with light backgrounds
- **Dark Theme**: Dark interface with dark backgrounds  
- **System Theme**: Automatically follows device theme preference

### **Theme Features**
- **Persistent Storage**: Theme preference saved using SharedPreferences
- **Dynamic Colors**: All colors adapt to current theme mode
- **Theme Toggle**: Quick theme switching via app bar button
- **Settings Screen**: Detailed theme configuration

### **Color Palettes**
- **LightColors**: Bright color scheme for light theme
- **DarkColors**: Dark color scheme for dark theme
- **AppColorPalette**: Abstract interface for consistent color access

## 🏗️ Layer Responsibilities

### **Presentation Layer** (`presentation/`)
- **Purpose**: UI and user interaction
- **Contains**: Screens, widgets, GetX controllers
- **Dependencies**: Application layer only
- **Responsibilities**:
  - Display data to users
  - Handle user input
  - Manage UI state
  - Navigation
  - Theme-aware UI rendering

### **Application Layer** (`application/`)
- **Purpose**: Business logic and use cases
- **Contains**: Controllers, services, use cases
- **Dependencies**: Domain layer only
- **Responsibilities**:
  - Orchestrate business logic
  - Manage application state
  - Handle user actions
  - Coordinate between presentation and domain
  - Theme state management

### **Domain Layer** (`domain/`)
- **Purpose**: Core business logic and entities
- **Contains**: Entities, repository interfaces, business rules
- **Dependencies**: None (pure business logic)
- **Responsibilities**:
  - Define business entities
  - Define repository contracts
  - Implement business rules
  - Core application logic

### **Infrastructure Layer** (`infrastructure/`)
- **Purpose**: External data and services
- **Contains**: Repository implementations, API clients, databases, theme system
- **Dependencies**: Domain layer only
- **Responsibilities**:
  - Implement repository interfaces
  - Handle external API calls
  - Manage data persistence
  - External service integration
  - Theme configuration and persistence

## 🔄 Data Flow

```
User Action → Presentation → Application → Domain ← Infrastructure
     ↑                                                      ↓
     └────────────── UI Update ←────────────────────────────┘
```

## 📱 Key Features

### **Court Cases Management**
- **Unified Screen**: Single screen with tabs for search and followed cases
- **Real-time Sync**: Follow status updates across all screens
- **Search Functionality**: Case number, year, and type filtering
- **Follow/Unfollow**: Easy case tracking with confirmation dialogs

### **Navigation**
- **Bottom Navigation**: 5-tab layout with responsive design
- **Tab-based Interface**: Search and My Cases in unified view
- **Auto-refresh**: Data refreshes on tab selection

### **Theme System**
- **Dynamic Theming**: Automatic color adaptation
- **Persistent Preferences**: Theme choice remembered across sessions
- **System Integration**: Follows device theme settings

## 🎯 Benefits

1. **Separation of Concerns**: Each layer has a specific responsibility
2. **Testability**: Easy to unit test each layer independently
3. **Maintainability**: Changes in one layer don't affect others
4. **Scalability**: Easy to add new features or modify existing ones
5. **Dependency Inversion**: High-level modules don't depend on low-level modules
6. **Theme Flexibility**: Easy theme switching and customization
7. **Responsive Design**: Adaptive UI for different screen sizes

## 🚀 Getting Started

1. **Adding a new feature**:
   - Start with domain entities and repository interfaces
   - Implement infrastructure layer (API/database)
   - Create application layer controllers
   - Build presentation layer UI
   - Ensure theme compatibility

2. **Testing**:
   - Domain layer: Unit tests for business logic
   - Application layer: Unit tests for controllers
   - Infrastructure layer: Integration tests
   - Presentation layer: Widget tests
   - Theme system: Theme switching tests

3. **Dependencies**:
   - Use dependency injection with GetX
   - Follow dependency inversion principle
   - Keep layers loosely coupled
   - Use theme-aware colors throughout

## 📝 Current Implementation

- **GetX**: State management and dependency injection
- **Clean Architecture**: Four-layer separation
- **Supabase**: Real-time database integration
- **Dynamic Themes**: Light, dark, and system theme support
- **Responsive Design**: Adaptive UI for different screen sizes
- **Reactive UI**: Obx widgets for automatic UI updates
- **Persistent Storage**: SharedPreferences for theme persistence

## 🔧 Development Guidelines

1. **Use `debugPrint()` instead of `print()`** for logging
2. **Avoid `withOpacity()`** - use `.withValues()` to prevent precision loss
3. **Theme-aware colors**: Always use `AppColors` getters instead of hardcoded colors
4. **Responsive design**: Consider different screen sizes in UI components
5. **Error handling**: Implement proper error states and user feedback 