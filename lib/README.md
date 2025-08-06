# Clean Architecture with Riverpod

This project follows Clean Architecture principles with four distinct layers and implements a dynamic theme system with light, dark, and system themes. The app uses **Riverpod** for state management and **Supabase** for backend services.

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry point with Riverpod ProviderScope
├── presentation/                      # 🎨 Presentation Layer
│   ├── screens/                      # UI Screens
│   │   ├── home_screen.dart          # WebView with address bar
│   │   ├── court_cases_screen.dart   # Unified search & my court cases with tabs
│   │   ├── court_hearings_screen.dart # Court hearings calendar
│   │   ├── navigation_screen.dart    # Bottom navigation
│   │   ├── qr_scanner_screen.dart    # QR code scanning
│   │   └── theme_settings_screen.dart # Theme configuration
│   ├── pages/                        # Page Components
│   │   └── court_cases_page.dart     # Court cases display with search
│   └── widgets/                      # Reusable UI Components
│       ├── court_case_card.dart      # Individual court case display
│       ├── court_case_list.dart      # List with loading/error states
│       ├── custom_app_bar.dart       # App bar with theme toggle
│       ├── custom_bottom_navigation.dart # Bottom navigation bar
│       ├── loading_state.dart        # Standardized loading UI
│       └── error_state.dart          # Error display with retry
├── application/                      # 🔧 Application Layer
│   └── providers/                    # Riverpod State Management
│       ├── court_case_provider.dart  # General court case operations
│       ├── search_provider.dart      # Search-specific UI state
│       ├── my_court_cases_provider.dart # Followed cases management
│       ├── theme_provider.dart       # Theme state management
│       ├── court_case_repository_provider.dart # Data operations
│       ├── search_ui_provider.dart   # Search form UI state
│       └── pagination_provider.dart  # Pagination logic
├── domain/                          # 🧠 Domain Layer
│   ├── models/                      # Business Entities
│   │   └── court_case.dart          # Core court case entity
│   └── repositories/                 # Repository Interfaces
│       └── court_case_repository.dart # Data access contract
├── infrastructure/                  # 🏗️ Infrastructure Layer
│   ├── repositories/                 # Repository Implementations
│   │   └── court_case_repository.dart # Supabase implementation
│   ├── services/                     # External Services
│   │   └── device_service.dart      # Device-specific operations
│   ├── theme/                       # Theme System
│   │   ├── app_colors.dart          # Color definitions
│   │   └── app_theme.dart           # Theme configuration
│   └── assets/                      # Static Assets
│       ├── logo.svg                 # App logo
│       └── fonts/                   # Custom fonts
├── data/                            # 📊 Data Layer
│   └── cache/                       # Caching System
│       └── court_case_cache.dart    # In-memory cache with expiry
└── core/                           # 🔧 Core Utilities
    ├── constants/                   # Application Constants
    │   └── app_constants.dart      # Centralized constants
    ├── errors/                      # Error Handling
    │   └── result.dart             # Result<T> sealed class
    └── utils/                       # Utility Classes
        └── debouncer.dart          # Debouncing utilities
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
- **Contains**: Screens, widgets, pages
- **Dependencies**: Application layer only
- **Responsibilities**:
  - Display data to users using Riverpod consumers
  - Handle user input and navigation
  - Manage UI state through providers
  - Theme-aware UI rendering
  - WebView integration with platform-specific handling

### **Application Layer** (`application/`)
- **Purpose**: Business logic and state management
- **Contains**: Riverpod providers, state notifiers
- **Dependencies**: Domain layer only
- **Responsibilities**:
  - Orchestrate business logic through providers
  - Manage application state with Riverpod
  - Handle user actions and state updates
  - Coordinate between presentation and domain
  - Theme state management with persistence

### **Domain Layer** (`domain/`)
- **Purpose**: Core business logic and entities
- **Contains**: Models, repository interfaces, business rules
- **Dependencies**: None (pure business logic)
- **Responsibilities**:
  - Define business entities and models
  - Define repository contracts
  - Implement business rules
  - Core application logic

### **Infrastructure Layer** (`infrastructure/`)
- **Purpose**: External data and services
- **Contains**: Repository implementations, API clients, theme system
- **Dependencies**: Domain layer only
- **Responsibilities**:
  - Implement repository interfaces
  - Handle external API calls (Supabase)
  - Manage data persistence
  - External service integration
  - Theme configuration and persistence

### **Data Layer** (`data/`)
- **Purpose**: Data caching and persistence
- **Contains**: Cache implementations, local storage
- **Dependencies**: Domain layer only
- **Responsibilities**:
  - In-memory caching with expiry
  - Local data persistence
  - Cache invalidation strategies

### **Core Layer** (`core/`)
- **Purpose**: Shared utilities and constants
- **Contains**: Error handling, utilities, constants
- **Dependencies**: None
- **Responsibilities**:
  - Consistent error handling with Result<T>
  - Utility functions (debouncing, etc.)
  - Application constants
  - Core abstractions

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
- **Search Functionality**: Case number, year, and type filtering with debouncing
- **Follow/Unfollow**: Easy case tracking with confirmation dialogs
- **Pagination**: Efficient data loading in chunks
- **Caching**: In-memory cache with automatic expiry

### **WebView Integration**
- **Platform-specific**: Handles Android, iOS, and Web platforms
- **Address Bar**: URL input with navigation controls
- **State Preservation**: Maintains navigation history across screen switches
- **Loading States**: Visual feedback during page loads

### **Navigation**
- **Bottom Navigation**: 5-tab layout with responsive design
- **Tab-based Interface**: Search and My Cases in unified view
- **Auto-refresh**: Data refreshes on tab selection

### **Theme System**
- **Dynamic Theming**: Automatic color adaptation
- **Persistent Preferences**: Theme choice remembered across sessions
- **System Integration**: Follows device theme settings

### **Error Handling**
- **Consistent States**: Loading, error, and success states
- **Retry Mechanisms**: Easy error recovery
- **User Feedback**: Clear error messages and actions

## 🎯 Benefits

1. **Separation of Concerns**: Each layer has a specific responsibility
2. **Testability**: Easy to unit test each layer independently
3. **Maintainability**: Changes in one layer don't affect others
4. **Scalability**: Easy to add new features or modify existing ones
5. **Dependency Inversion**: High-level modules don't depend on low-level modules
6. **Theme Flexibility**: Easy theme switching and customization
7. **Responsive Design**: Adaptive UI for different screen sizes
8. **State Management**: Predictable state updates with Riverpod
9. **Caching**: Improved performance with intelligent caching
10. **Error Resilience**: Robust error handling throughout the app

## 🚀 Getting Started

1. **Adding a new feature**:
   - Start with domain models and repository interfaces
   - Implement infrastructure layer (API/database)
   - Create application layer providers with Riverpod
   - Build presentation layer UI with consumers
   - Ensure theme compatibility and error handling

2. **Testing**:
   - Domain layer: Unit tests for business logic
   - Application layer: Unit tests for providers
   - Infrastructure layer: Integration tests
   - Presentation layer: Widget tests
   - Theme system: Theme switching tests

3. **Dependencies**:
   - Use Riverpod for state management and dependency injection
   - Follow dependency inversion principle
   - Keep layers loosely coupled
   - Use theme-aware colors throughout
   - Implement proper error handling with Result<T>

## 📝 Current Implementation

- **Riverpod**: State management and dependency injection
- **Clean Architecture**: Four-layer separation with data and core layers
- **Supabase**: Real-time database integration
- **WebView**: Platform-specific WebView implementation
- **Dynamic Themes**: Light, dark, and system theme support
- **Responsive Design**: Adaptive UI for different screen sizes
- **Reactive UI**: Consumer widgets for automatic UI updates
- **Persistent Storage**: SharedPreferences for theme persistence
- **Caching**: In-memory cache with automatic expiry
- **Error Handling**: Consistent error states with Result<T>
- **Pagination**: Efficient data loading in chunks
- **Debouncing**: Optimized search input handling

## 🔧 Development Guidelines

1. **Use `debugPrint()` instead of `print()`** for logging
2. **Avoid `withOpacity()`** - use `.withValues()` to prevent precision loss
3. **Theme-aware colors**: Always use `AppColors` getters instead of hardcoded colors
4. **Responsive design**: Consider different screen sizes in UI components
5. **Error handling**: Implement proper error states with Result<T>
6. **Riverpod patterns**: Use `ref.watch()` for reactive data and `ref.read()` for actions
7. **Caching**: Use the cache layer for frequently accessed data
8. **Platform-specific code**: Handle WebView and other platform differences
9. **State management**: Keep providers focused on specific concerns
10. **Repository pattern**: Use repositories for all data access 