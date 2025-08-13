# Formly iOS Setup Guide

This guide will help you set up the Formly iOS project for development.

## Prerequisites

- **Xcode 15.0 or later**
- **iOS 16.0+ deployment target**
- **macOS 14.0 or later**
- **Apple Developer Account** (for distribution)

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/formly-ios.git
cd formly-ios
```

### 2. Open in Xcode

```bash
open FormlyNative.xcodeproj
```

### 3. Configure Project Settings

1. **Select the project** in the navigator
2. **Set Bundle Identifier**: `com.formlyai.native`
3. **Set Team ID** for code signing
4. **Set minimum iOS version** to 16.0

### 4. Configure Capabilities

1. **iCloud**: Enable iCloud with iCloud Documents
2. **Background Modes**: Enable background fetch and processing
3. **Keychain Sharing**: Enable if needed for shared credentials

### 5. Install Dependencies

1. **Swift Package Manager** (recommended):
   - File → Add Package Dependencies
   - Add the following packages:
     - `https://github.com/ggerganov/llama.cpp.git` (for on-device LLM)
     - `https://github.com/weichsel/ZIPFoundation.git` (for backup/restore)
     - `https://github.com/kishikawakatsumi/KeychainAccess.git` (for secure storage)

2. **Alternative**: Use the Package.swift file in the project root

### 6. Download LLM Model

1. **Download a GGUF model** (1-3B parameters recommended):
   - Example: `llama-2-7b-chat.Q4_K_M.gguf`
   - Place in `FormlyNative/Resources/Models/`

2. **Update model path** in `AIService.swift`:
   ```swift
   private func createLLMProvider() -> LLMProvider? {
       let modelPath = Bundle.main.path(forResource: "llama-2-7b-chat.Q4_K_M", ofType: "gguf")
       // Implementation
   }
   ```

### 7. Build and Run

1. **Select target device** (iPhone simulator or device)
2. **Build** (⌘+B)
3. **Run** (⌘+R)

## Project Structure

```
formly-ios/
├── FormlyNative/                    # Main app target
│   ├── FormlyNativeApp.swift       # App entry point
│   ├── ContentView.swift           # Main UI
│   ├── Assets.xcassets/            # App assets
│   └── Info.plist                  # App configuration
├── Sources/Services/               # Service layer
│   ├── StorageService.swift        # Core Data management
│   ├── AIService.swift            # AI functionality
│   ├── BackupService.swift        # Backup/restore
│   ├── TemplateLoader.swift       # Template management
│   └── BackgroundTaskManager.swift # Background tasks
├── templates/                      # Form templates
│   ├── dmv-renewal.json           # DMV license renewal
│   └── ds-160.json                # DS-160 visa application
├── FormlyNative.xcdatamodeld/     # Core Data model
├── FormlyNative.xcodeproj/        # Xcode project
└── Documentation/                 # Project docs
```

## Configuration

### Core Data Setup

The project includes a complete Core Data model with entities for:
- **FormTemplate**: Form definitions and schemas
- **FormSession**: Active form sessions
- **Conversation**: Chat conversations
- **Message**: Individual messages
- **Document**: Scanned documents
- **Embedding**: Vector embeddings for RAG

### AI Configuration

The app supports three AI modes:
1. **On-Device LLM**: Uses llama.cpp with Metal acceleration
2. **RAG Only**: Uses embeddings and similarity search
3. **Rules Only**: Uses deterministic validation rules

### Privacy Settings

- All data stored locally by default
- Optional iCloud backup/restore
- No network calls for core functionality
- Data protection enabled on Core Data store

## Development Workflow

### 1. Adding New Templates

1. **Create JSON template** in `templates/` directory
2. **Follow the schema** defined in `TemplateLoader.swift`
3. **Add to bundle** in Xcode
4. **Update TemplateLoader** to include new template

### 2. Adding New Services

1. **Create service class** in `Sources/Services/`
2. **Implement protocol** if applicable
3. **Add to dependency injection** in `FormlyNativeApp.swift`
4. **Add tests** in `Tests/` directory

### 3. UI Development

1. **Create SwiftUI views** in `FormlyNative/`
2. **Follow MVVM pattern** with separate ViewModels
3. **Add accessibility** labels and hints
4. **Test on multiple devices** and orientations

## Testing

### Unit Tests

```bash
# Run unit tests
xcodebuild test -scheme FormlyNative -destination 'platform=iOS Simulator,name=iPhone 16'
```

### UI Tests

```bash
# Run UI tests
xcodebuild test -scheme FormlyNative -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:FormlyNativeUITests
```

## Distribution

### TestFlight

1. **Archive the app** (Product → Archive)
2. **Upload to App Store Connect**
3. **Distribute to TestFlight**

### App Store

1. **Configure App Store Connect**
2. **Add privacy labels** (local processing only)
3. **Submit for review**

## Troubleshooting

### Common Issues

1. **Build errors**:
   - Check Xcode version compatibility
   - Verify all dependencies are installed
   - Clean build folder (Product → Clean Build Folder)

2. **Core Data errors**:
   - Delete app from simulator/device
   - Reset Core Data model if schema changed

3. **LLM not working**:
   - Verify model file is in bundle
   - Check device memory availability
   - Fallback to RAG or rules mode

4. **Background tasks not working**:
   - Check background modes in capabilities
   - Verify task identifiers in Info.plist
   - Test on physical device

### Performance Optimization

1. **Memory usage**:
   - Monitor with Instruments
   - Use lazy loading for large documents
   - Implement proper cleanup

2. **Battery optimization**:
   - Minimize background processing
   - Use efficient algorithms
   - Implement task cancellation

## Support

- **Documentation**: See `README.md`, `ARCHITECTURE.md`, `DEVELOPMENT.md`
- **Issues**: Create GitHub issues for bugs
- **Discussions**: Use GitHub Discussions for questions
- **Contributing**: See `CONTRIBUTING.md`

## Next Steps

1. **Implement remaining services** (DocumentService, ValidationService)
2. **Add more form templates**
3. **Enhance AI capabilities**
4. **Add localization support**
5. **Implement advanced features** (voice input, document scanning)

Happy coding! 🚀
