# Formly iOS Development Guide

## Getting Started

### Prerequisites
- Xcode 15.0 or later
- iOS 16.0+ deployment target
- macOS 14.0 or later
- Apple Developer Account (for distribution)

### Initial Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-org/formly-ios.git
   cd formly-ios
   ```

2. **Open in Xcode**
   ```bash
   open FormlyNative.xcodeproj
   ```

3. **Configure project settings**
   - Set Bundle Identifier: `com.formlyai.native`
   - Set Team ID for code signing
   - Configure capabilities (iCloud, Background Modes)

4. **Install dependencies**
   ```bash
   # Using Swift Package Manager (preferred)
   # Add packages in Xcode: File > Add Package Dependencies
   
   # Required packages:
   # - llama.cpp (for on-device LLM)
   # - ZIPFoundation (for backup/restore)
   # - KeychainAccess (for secure storage)
   ```

## Project Structure

```
FormlyNative/
├── App/
│   ├── FormlyNativeApp.swift          # App entry point
│   └── AppDelegate.swift              # App delegate
├── Models/
│   ├── CoreData/                      # Core Data model files
│   ├── DTOs/                          # Data transfer objects
│   └── Extensions/                    # Model extensions
├── Views/
│   ├── Main/                          # Main app views
│   ├── Conversation/                  # Chat interface
│   ├── Templates/                     # Template selection
│   ├── Review/                        # Form review
│   └── Settings/                      # App settings
├── ViewModels/
│   ├── ConversationViewModel.swift
│   ├── TemplatesViewModel.swift
│   └── SettingsViewModel.swift
├── Services/
│   ├── Storage/                       # Core Data and file management
│   ├── AI/                           # AI service implementations
│   ├── Backup/                       # Backup and restore
│   ├── Document/                     # Document processing
│   └── Validation/                   # Form validation
├── Utils/
│   ├── Extensions/                   # Swift extensions
│   ├── Helpers/                      # Utility functions
│   └── Constants/                    # App constants
├── Resources/
│   ├── Templates/                    # JSON template files
│   ├── Localization/                 # Localized strings
│   └── Assets/                       # App assets
└── Tests/
    ├── UnitTests/                    # Unit tests
    └── UITests/                      # UI tests
```

## Development Workflow

### 1. Feature Development

1. **Create feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Follow TDD approach**
   - Write tests first
   - Implement feature
   - Ensure all tests pass

3. **Code review checklist**
   - [ ] All tests pass
   - [ ] No memory leaks
   - [ ] Accessibility implemented
   - [ ] Localization strings added
   - [ ] Documentation updated

### 2. Testing Strategy

#### Unit Tests
```swift
// Example test structure
class ConversationEngineTests: XCTestCase {
    var engine: ConversationEngine!
    var mockAIService: MockAIService!
    
    override func setUp() {
        super.setUp()
        mockAIService = MockAIService()
        engine = ConversationEngine(aiService: mockAIService)
    }
    
    func testProcessUserInput_ValidatesField() async throws {
        // Given
        let input = "John Doe"
        
        // When
        let response = try await engine.processUserInput(input)
        
        // Then
        XCTAssertEqual(response.updates.count, 1)
        XCTAssertEqual(response.updates.first?.fieldId, "fullName")
    }
}
```

#### UI Tests
```swift
class ConversationUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launchArguments = ["UI-Testing"]
        app.launch()
    }
    
    func testDMVRenewalFlow() {
        // Navigate and test complete flow
        app.buttons["Templates"].tap()
        app.buttons["DMV License Renewal"].tap()
        // ... continue with flow
    }
}
```

### 3. Code Standards

#### Swift Style Guide
- Follow [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/)
- Use SwiftLint for code formatting
- Maximum line length: 120 characters
- Use trailing closures where appropriate

#### Naming Conventions
```swift
// Protocols
protocol StorageServiceProtocol { }

// Classes
class ConversationEngine { }

// Structs
struct FormTemplate { }

// Enums
enum AIProvider { }

// Variables
let storageService: StorageServiceProtocol
var currentStep: ConversationStep?

// Functions
func processUserInput(_ input: String) async throws -> ConversationResponse { }
```

#### Documentation
```swift
/// Processes user input and generates appropriate form updates
/// - Parameter input: The user's text input
/// - Returns: A conversation response with field updates and next step
/// - Throws: `ConversationError` if processing fails
func processUserInput(_ input: String) async throws -> ConversationResponse {
    // Implementation
}
```

## AI Integration

### On-Device LLM Setup

1. **Download model**
   ```bash
   # Download a GGUF model (1-3B parameters recommended)
   # Example: llama-2-7b-chat.Q4_K_M.gguf
   ```

2. **Add to project**
   - Drag model file to project
   - Ensure it's included in app bundle
   - Set target membership

3. **Initialize LLM**
   ```swift
   class LlamaCppProvider: LLMProvider {
       private var llamaContext: OpaquePointer?
       
       func loadModel() async throws {
           // Initialize llama.cpp with Metal backend
           // Load model from bundle
           // Configure parameters
       }
   }
   ```

### RAG System

1. **Embedding generation**
   ```swift
   class EmbeddingService {
       private let coreMLModel: MLModel
       
       func generateEmbeddings(_ text: String) async throws -> [Float] {
           // Use Core ML sentence transformer
           // Return normalized vector
       }
   }
   ```

2. **Vector storage**
   ```swift
   // Store in Core Data as BLOB
   let embedding = Embedding(context: context)
   embedding.vector = Data(embeddings)
   embedding.dim = Int32(embeddings.count)
   ```

## Performance Optimization

### Memory Management
- Use lazy loading for large documents
- Implement proper cleanup in `deinit`
- Monitor memory usage with Instruments

### Battery Optimization
- Minimize background processing
- Use efficient algorithms for embeddings
- Implement proper task cancellation

### Storage Optimization
- Compress large files before storage
- Implement cleanup for old sessions
- Use efficient Core Data queries

## Security Implementation

### Data Protection
```swift
// Set Core Data protection level
let coordinator = persistentContainer.persistentStoreCoordinator
try coordinator.setMetadata([
    NSPersistentStoreFileProtectionKey: FileProtectionType.complete
], for: store)
```

### Keychain Usage
```swift
class KeychainService {
    func store(_ data: Data, forKey key: String) throws {
        let query: [String: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data,
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        // Store in keychain
    }
}
```

## Localization

### String Resources
```swift
// Localizable.strings
"dmv.renewal.title" = "DMV License Renewal";
"dmv.renewal.description" = "Renew your driver's license";

// Usage
Text("dmv.renewal.title")
```

### Template Localization
```json
{
  "metadata": {
    "languageSupport": ["en", "es", "fr"]
  },
  "localizedStrings": {
    "en": {
      "title": "DMV License Renewal"
    },
    "es": {
      "title": "Renovación de Licencia DMV"
    }
  }
}
```

## Debugging

### Debug Configuration
```swift
#if DEBUG
    // Debug-only code
    print("Debug: Processing user input")
#endif
```

### Logging
```swift
import os.log

let logger = Logger(subsystem: "com.formlyai.native", category: "conversation")
logger.debug("Processing user input: \(input)")
```

### Testing on Device
1. Connect device
2. Select device in Xcode
3. Build and run
4. Use Console app for logs

## Distribution

### App Store Preparation
1. **App Store Connect setup**
   - Create app record
   - Configure metadata
   - Upload screenshots

2. **Privacy labels**
   - Data not linked to user
   - Data not used for tracking
   - Local processing only

3. **TestFlight**
   ```bash
   # Archive app
   Product > Archive
   
   # Upload to App Store Connect
   # Distribute to TestFlight
   ```

### Code Signing
```bash
# Automatic signing (recommended)
# Configure in Xcode project settings

# Manual signing
# Use certificates and provisioning profiles
```

## Troubleshooting

### Common Issues

1. **Core Data migration errors**
   - Check model version compatibility
   - Implement migration policy

2. **Memory issues with LLM**
   - Reduce model size
   - Implement proper cleanup
   - Monitor memory usage

3. **Background task failures**
   - Check background modes
   - Implement proper task handling
   - Monitor task completion

### Performance Profiling
```bash
# Use Instruments for profiling
# Monitor CPU, memory, and battery usage
# Identify bottlenecks
```

## Contributing

### Pull Request Process
1. Fork repository
2. Create feature branch
3. Implement changes
4. Add tests
5. Update documentation
6. Submit pull request

### Code Review Guidelines
- Ensure all tests pass
- Check for memory leaks
- Verify accessibility
- Review security implications
- Test on multiple devices

This development guide provides a comprehensive overview of the development process for the Formly iOS app.
