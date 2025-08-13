# Formly iOS Architecture

## Overview
This document provides detailed technical architecture for the Formly iOS native app, focusing on the offline-first, privacy-preserving design with on-device AI capabilities.

## Core Architecture Principles

### 1. Offline-First Design
- All core functionality works without internet connectivity
- Local storage with optional iCloud backup/restore
- On-device AI processing with graceful degradation

### 2. Privacy by Design
- No data leaves the device unless explicitly exported by user
- On-device LLM as baseline AI provider
- Local RAG system for context retrieval
- Clear data lifecycle management

### 3. Modular Service Architecture
- Pluggable AI providers (LLM, RAG, Rules)
- Independent service modules with clear interfaces
- Dependency injection for testability

## Service Layer Architecture

### Core Services

#### 1. StorageService
```swift
protocol StorageServiceProtocol {
    // Core Data operations
    func saveContext() throws
    func fetch<T: NSManagedObject>(_ request: NSFetchRequest<T>) throws -> [T]
    
    // File operations
    func saveDocument(_ data: Data, filename: String, sessionId: UUID?) throws -> URL
    func getDocumentsDirectory() -> URL
    func createBackup() throws -> URL
    func restoreFromBackup(_ url: URL) throws
}
```

#### 2. AIService
```swift
protocol AIServiceProtocol {
    var currentProvider: AIProvider { get }
    
    func generateResponse(
        template: FormTemplate,
        step: ConversationStep,
        context: ConversationContext
    ) async throws -> AIResponse
    
    func generateEmbeddings(_ text: String) async throws -> [Float]
    func findSimilarContent(_ query: String, limit: Int) async throws -> [RetrievedContent]
}

enum AIProvider {
    case onDeviceLLM
    case ragOnly
    case rulesOnly
}
```

#### 3. ConversationEngine
```swift
class ConversationEngine: ObservableObject {
    @Published var currentStep: ConversationStep?
    @Published var session: FormSession?
    
    func processUserInput(_ input: String) async throws -> ConversationResponse
    func validateField(_ field: FormField, value: Any) -> ValidationResult
    func moveToNextStep() throws
    func saveProgress() throws
}
```

#### 4. DocumentService
```swift
protocol DocumentServiceProtocol {
    func scanDocument() async throws -> ScannedDocument
    func extractText(from image: UIImage) async throws -> String
    func createPDF(from template: FormTemplate, answers: [String: Any]) throws -> URL
    func processOCR(_ image: UIImage) async throws -> OCRResult
}
```

#### 5. BackupService
```swift
protocol BackupServiceProtocol {
    func createBackup() async throws -> URL
    func restoreFromBackup(_ url: URL) async throws
    func exportToiCloud() async throws
    func importFromiCloud() async throws -> URL
}
```

## Data Models

### Core Data Entities

#### FormTemplate
```swift
@objc(FormTemplate)
public class FormTemplate: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var category: String
    @NSManaged public var description: String?
    @NSManaged public var estimatedTime: Int16
    @NSManaged public var difficulty: String
    @NSManaged public var jsonSchema: Data
    @NSManaged public var version: String
    @NSManaged public var languageSupport: [String]
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date
}
```

#### FormSession
```swift
@objc(FormSession)
public class FormSession: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var templateId: UUID
    @NSManaged public var status: String
    @NSManaged public var progress: Double
    @NSManaged public var state: Data?
    @NSManaged public var answers: Data?
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date
    @NSManaged public var conversation: Conversation?
    @NSManaged public var documents: Set<Document>?
}
```

#### Conversation
```swift
@objc(Conversation)
public class Conversation: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var sessionId: UUID
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date
    @NSManaged public var messages: Set<Message>?
    @NSManaged public var session: FormSession?
}
```

#### Message
```swift
@objc(Message)
public class Message: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var conversationId: UUID
    @NSManaged public var role: String
    @NSManaged public var content: String
    @NSManaged public var metadata: Data?
    @NSManaged public var createdAt: Date
    @NSManaged public var conversation: Conversation?
}
```

#### Document
```swift
@objc(Document)
public class Document: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var sessionId: UUID?
    @NSManaged public var type: String
    @NSManaged public var fileURL: String
    @NSManaged public var textIndex: Data?
    @NSManaged public var createdAt: Date
    @NSManaged public var session: FormSession?
}
```

#### Embedding
```swift
@objc(Embedding)
public class Embedding: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var ownerType: String
    @NSManaged public var ownerId: UUID
    @NSManaged public var vector: Data
    @NSManaged public var dim: Int32
    @NSManaged public var createdAt: Date
}
```

## AI Layer Implementation

### On-Device LLM Integration

#### LLM Provider Interface
```swift
protocol LLMProvider {
    func loadModel() async throws
    func generateResponse(
        systemPrompt: String,
        userPrompt: String,
        context: [String]
    ) async throws -> String
    func isAvailable() -> Bool
    func getModelInfo() -> ModelInfo
}

struct ModelInfo {
    let name: String
    let size: Int64
    let quantization: String
    let maxContextLength: Int
}
```

#### Llama.cpp Integration
```swift
class LlamaCppProvider: LLMProvider {
    private var llamaContext: OpaquePointer?
    private let modelPath: String
    
    init(modelPath: String) {
        self.modelPath = modelPath
    }
    
    func loadModel() async throws {
        // Initialize llama.cpp with Metal backend
        // Load GGUF model file
        // Configure context and parameters
    }
    
    func generateResponse(
        systemPrompt: String,
        userPrompt: String,
        context: [String]
    ) async throws -> String {
        // Format prompt with system/user/context
        // Generate response with llama.cpp
        // Parse and validate JSON output
        // Return structured response
    }
}
```

### RAG System Implementation

#### Embedding Generation
```swift
class EmbeddingService {
    private let coreMLModel: MLModel
    
    func generateEmbeddings(_ text: String) async throws -> [Float] {
        // Use Core ML sentence transformer model
        // Tokenize and encode text
        // Return normalized embedding vector
    }
    
    func cosineSimilarity(_ a: [Float], _ b: [Float]) -> Float {
        // Compute cosine similarity between vectors
    }
}
```

#### Vector Storage and Retrieval
```swift
class RAGService {
    private let embeddingService: EmbeddingService
    private let storageService: StorageServiceProtocol
    
    func indexDocument(_ document: Document) async throws {
        let text = try await extractText(from: document)
        let embeddings = try await embeddingService.generateEmbeddings(text)
        
        // Store embeddings in Core Data
        let embedding = Embedding(context: storageService.viewContext)
        embedding.id = UUID()
        embedding.ownerType = "document"
        embedding.ownerId = document.id
        embedding.vector = Data(embeddings)
        embedding.dim = Int32(embeddings.count)
        embedding.createdAt = Date()
        
        try storageService.saveContext()
    }
    
    func retrieveSimilarContent(_ query: String, limit: Int = 5) async throws -> [RetrievedContent] {
        let queryEmbedding = try await embeddingService.generateEmbeddings(query)
        
        // Fetch all embeddings from Core Data
        let request: NSFetchRequest<Embedding> = Embedding.fetchRequest()
        let embeddings = try storageService.fetch(request)
        
        // Compute similarities and return top matches
        let similarities = embeddings.map { embedding in
            let vector = Array(embedding.vector as Data)
            let similarity = embeddingService.cosineSimilarity(queryEmbedding, vector)
            return (embedding, similarity)
        }
        
        return similarities
            .sorted { $0.1 > $1.1 }
            .prefix(limit)
            .compactMap { embedding, _ in
                // Convert to RetrievedContent
            }
    }
}
```

## UI Architecture (SwiftUI + MVVM)

### View Models
```swift
@MainActor
class ConversationViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var currentStep: ConversationStep?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let conversationEngine: ConversationEngine
    private let aiService: AIServiceProtocol
    
    func sendMessage(_ text: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await conversationEngine.processUserInput(text)
            await updateUI(with: response)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func updateUI(with response: ConversationResponse) async {
        // Update messages and current step
        // Trigger UI updates
    }
}
```

### Views
```swift
struct ConversationView: View {
    @StateObject private var viewModel: ConversationViewModel
    @State private var messageText = ""
    
    var body: some View {
        VStack {
            // Progress header
            ProgressHeaderView(step: viewModel.currentStep)
            
            // Messages list
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.messages) { message in
                            MessageView(message: message)
                        }
                    }
                }
                .onChange(of: viewModel.messages.count) { _ in
                    withAnimation {
                        proxy.scrollTo(viewModel.messages.last?.id, anchor: .bottom)
                    }
                }
            }
            
            // Input area
            MessageInputView(
                text: $messageText,
                onSend: { text in
                    Task {
                        await viewModel.sendMessage(text)
                        messageText = ""
                    }
                }
            )
        }
        .navigationTitle("Form Assistant")
    }
}
```

## Background Processing

### Background Tasks
```swift
class BackgroundTaskManager {
    static let shared = BackgroundTaskManager()
    
    func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: "com.formlyai.native.backup",
            using: nil
        ) { task in
            self.handleBackupTask(task as! BGAppRefreshTask)
        }
        
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: "com.formlyai.native.indexing",
            using: nil
        ) { task in
            self.handleIndexingTask(task as! BGProcessingTask)
        }
    }
    
    private func handleBackupTask(_ task: BGAppRefreshTask) {
        task.expirationHandler = {
            // Cancel ongoing backup
        }
        
        Task {
            do {
                try await BackupService.shared.createBackup()
                task.setTaskCompleted(success: true)
            } catch {
                task.setTaskCompleted(success: false)
            }
        }
    }
    
    private func handleIndexingTask(_ task: BGProcessingTask) {
        task.expirationHandler = {
            // Cancel ongoing indexing
        }
        
        Task {
            do {
                try await RAGService.shared.reindexDocuments()
                task.setTaskCompleted(success: true)
            } catch {
                task.setTaskCompleted(success: false)
            }
        }
    }
}
```

## Security Implementation

### Keychain Integration
```swift
class KeychainService {
    static let shared = KeychainService()
    
    func store(_ data: Data, forKey key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.addFailed(status)
        }
    }
    
    func retrieve(forKey key: String) throws -> Data {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data else {
            throw KeychainError.retrieveFailed(status)
        }
        
        return data
    }
}
```

### Data Protection
```swift
extension StorageService {
    func configureDataProtection() {
        // Set Core Data store protection level
        let coordinator = persistentContainer.persistentStoreCoordinator
        coordinator.persistentStores.forEach { store in
            try? coordinator.setMetadata([
                NSPersistentStoreFileProtectionKey: FileProtectionType.complete
            ], for: store)
        }
    }
    
    func excludeFromBackup(_ url: URL) throws {
        var resourceValues = URLResourceValues()
        resourceValues.isExcludedFromBackup = true
        try url.setResourceValues(resourceValues)
    }
}
```

## Testing Architecture

### Unit Tests
```swift
class ConversationEngineTests: XCTestCase {
    var engine: ConversationEngine!
    var mockAIService: MockAIService!
    var mockStorage: MockStorageService!
    
    override func setUp() {
        super.setUp()
        mockAIService = MockAIService()
        mockStorage = MockStorageService()
        engine = ConversationEngine(
            aiService: mockAIService,
            storageService: mockStorage
        )
    }
    
    func testProcessUserInput_ValidatesField() async throws {
        // Given
        let template = createMockTemplate()
        let session = createMockSession(templateId: template.id)
        
        // When
        let response = try await engine.processUserInput("John Doe")
        
        // Then
        XCTAssertEqual(response.updates.count, 1)
        XCTAssertEqual(response.updates.first?.fieldId, "fullName")
        XCTAssertEqual(response.updates.first?.value as? String, "John Doe")
    }
}
```

### UI Tests
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
        // Navigate to templates
        app.buttons["Templates"].tap()
        app.buttons["DMV License Renewal"].tap()
        
        // Start conversation
        app.buttons["Start"].tap()
        
        // Enter name
        let textField = app.textFields["Name"]
        textField.tap()
        textField.typeText("John Doe")
        app.buttons["Send"].tap()
        
        // Verify AI response
        XCTAssertTrue(app.staticTexts["Hello John Doe"].exists)
    }
}
```

## Performance Considerations

### Memory Management
- Lazy loading of large documents
- Image compression before storage
- Background cleanup of temporary files
- LLM context management

### Battery Optimization
- Efficient background task scheduling
- Minimal network usage (offline-first)
- Optimized OCR processing
- Smart caching strategies

### Storage Optimization
- Compressed embeddings storage
- Efficient Core Data queries
- Regular cleanup of old sessions
- Optimized backup compression

## Deployment Considerations

### App Store Requirements
- Privacy nutrition labels
- App review guidelines compliance
- Accessibility requirements
- Localization support

### Distribution
- TestFlight beta testing
- App Store Connect configuration
- Code signing and provisioning
- Release management

This architecture provides a solid foundation for building a privacy-preserving, offline-first form assistant with on-device AI capabilities.
