# 🍞 BreadDiary

> ⚠️ **Note: This project is currently a work in progress**
> 
> Active development is happening in the `develop` branch

A beautiful iOS app to track and manage your bread baking journey, built with SwiftUI and The Composable Architecture.

## 📋 TODO List

- [ ] Saving recipe functionality
- [ ] Calendar view implementation
- [ ] Additional test coverage
  - Unit tests for RecipeDetailFeature
  - Integration tests for data persistence
  - UI tests for core workflows

## ✨ Features

- 📝 Create and manage your bread recipes
- 🔍 Search through your recipe collection
- ⭐️ Mark favorite recipes
- 📸 Add photos to your recipes
- 📅 Track baking dates and progress
- 🎨 Modern, clean UI design

## 🏗 Technical Stack

- **Framework**: SwiftUI
- **Architecture**: The Composable Architecture (TCA)
- **Minimum iOS Version**: iOS 16.0
- **Swift Version**: 5.9

## 🚀 Getting Started

### Prerequisites

- Xcode 15.0 or later
- iOS 16.0 or later
- Swift 5.9 or later

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/BreadDiary.git
```

2. Open the project in Xcode:
```bash
cd BreadDiary
open BreadDiary.xcodeproj
```

3. Build and run the project in Xcode

## 🏛 Architecture

BreadDiary is built using The Composable Architecture (TCA), which provides:

- Predictable state management
- Unidirectional data flow
- Composable and testable features
- Clear separation of concerns

### Key Components

- **HomeFeature**: Main screen showing recipe collection
- **RecipeDetailFeature**: Detailed view and editing of recipes
- **SearchFeature**: Recipe search functionality
- **PhotoPickerFeature**: Photo management for recipes

## 📱 Features in Detail

### Recipe Management
- Create new bread recipes
- Edit existing recipes
- Delete recipes
- Mark recipes as favorites

### Recipe Details
- Recipe name
- Baking date
- Process notes
- Rating system
- Photo attachments

### Search and Filter
- Search by recipe name
- Filter recipes
- Sort by date or name

## 🧪 Testing

The project includes comprehensive unit tests for all features. Run tests in Xcode using:
- ⌘U (Command + U) to run all tests
- ⌘6 (Command + 6) to open the Test navigator

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- [The Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture)
- [SwiftUI](https://developer.apple.com/xcode/swiftui/)
