import Foundation
import Combine

class AIService: ObservableObject {
    static let shared = AIService()
    
    @Published var currentProvider: AIProvider = .rulesOnly
    
    private var llmProvider: LLMProvider?
    private var embeddingService: EmbeddingService?
    
    private init() {
        setupAIProviders()
    }
    
    private func setupAIProviders() {
        // Try to initialize on-device LLM
        if let llmProvider = createLLMProvider() {
            self.llmProvider = llmProvider
            self.currentProvider = .onDeviceLLM
        } else {
            // Fallback to RAG only
            self.embeddingService = EmbeddingService()
            self.currentProvider = .ragOnly
        }
    }
    
    private func createLLMProvider() -> LLMProvider? {
        // Try to create llama.cpp provider
        // This would check if model file exists and device has enough memory
        return nil // Placeholder
    }
    
    func generateResponse(
        template: FormTemplate,
        step: ConversationStep,
        context: ConversationContext
    ) async throws -> AIResponse {
        switch currentProvider {
        case .onDeviceLLM:
            return try await generateLLMResponse(template: template, step: step, context: context)
        case .ragOnly:
            return try await generateRAGResponse(template: template, step: step, context: context)
        case .rulesOnly:
            return try await generateRulesResponse(template: template, step: step, context: context)
        }
    }
    
    func generateEmbeddings(_ text: String) async throws -> [Float] {
        guard let embeddingService = embeddingService else {
            throw AIError.embeddingServiceNotAvailable
        }
        return try await embeddingService.generateEmbeddings(text)
    }
    
    func findSimilarContent(_ query: String, limit: Int = 5) async throws -> [RetrievedContent] {
        guard let embeddingService = embeddingService else {
            throw AIError.embeddingServiceNotAvailable
        }
        return try await embeddingService.findSimilarContent(query, limit: limit)
    }
    
    private func generateLLMResponse(
        template: FormTemplate,
        step: ConversationStep,
        context: ConversationContext
    ) async throws -> AIResponse {
        guard let llmProvider = llmProvider else {
            throw AIError.llmProviderNotAvailable
        }
        
        let systemPrompt = template.systemPrompt ?? getDefaultSystemPrompt()
        let userPrompt = createUserPrompt(template: template, step: step, context: context)
        
        let response = try await llmProvider.generateResponse(
            systemPrompt: systemPrompt,
            userPrompt: userPrompt,
            context: context.retrievedContent.map { $0.text }
        )
        
        return try parseAIResponse(response)
    }
    
    private func generateRAGResponse(
        template: FormTemplate,
        step: ConversationStep,
        context: ConversationContext
    ) async throws -> AIResponse {
        // Use RAG to find relevant content and generate response
        let similarContent = try await findSimilarContent(context.currentInput, limit: 3)
        
        // Generate response based on retrieved content and rules
        return try await generateRulesResponse(template: template, step: step, context: context)
    }
    
    private func generateRulesResponse(
        template: FormTemplate,
        step: ConversationStep,
        context: ConversationContext
    ) async throws -> AIResponse {
        // Implement rule-based response generation
        // This would use the template's conversation flow and validation rules
        
        let updates: [FieldUpdate] = []
        let nextStepId = step.id
        let notes: [String] = []
        
        return AIResponse(updates: updates, nextStepId: nextStepId, notes: notes)
    }
    
    private func createUserPrompt(
        template: FormTemplate,
        step: ConversationStep,
        context: ConversationContext
    ) -> String {
        let missingFields = step.expectedFields.joined(separator: ", ")
        let knownAnswers = context.answers.map { "\($0.key): \($0.value)" }.joined(separator: ", ")
        let citations = context.retrievedContent.map { $0.text }.joined(separator: " ")
        
        return """
        Template: \(template.name)
        Step: \(step.title)
        Missing fields: \(missingFields)
        Known answers: \(knownAnswers)
        Relevant context: \(citations)
        """
    }
    
    private func parseAIResponse(_ response: String) throws -> AIResponse {
        // Parse JSON response from LLM
        guard let data = response.data(using: .utf8) else {
            throw AIError.invalidResponseFormat
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(AIResponse.self, from: data)
    }
    
    private func getDefaultSystemPrompt() -> String {
        return """
        You are Formly, an offline-first form-filling assistant running on-device. Follow these rules:
        - Only use the provided schema, user answers, and retrieved context to propose updates.
        - When you need to write output, respond as compact JSON with the shape:
          { "updates": [{"fieldId": string, "value": any}], "nextStepId": string, "notes": string[] }
        - Validate all values against field types and constraints; if invalid, request a corrected value.
        - Never include personal data not explicitly provided by the user.
        - Operate entirely on-device. If a capability is unavailable, fall back to rules + RAG and ask concise clarifying questions.
        """
    }
}

// MARK: - Supporting Types

enum AIProvider {
    case onDeviceLLM
    case ragOnly
    case rulesOnly
}

struct AIResponse: Codable {
    let updates: [FieldUpdate]
    let nextStepId: String
    let notes: [String]
}

struct FieldUpdate: Codable {
    let fieldId: String
    let value: String
}

struct ConversationContext {
    let currentInput: String
    let answers: [String: String]
    let retrievedContent: [RetrievedContent]
}

struct RetrievedContent {
    let text: String
    let source: String
    let similarity: Float
}

struct ConversationStep {
    let id: String
    let title: String
    let description: String
    let expectedFields: [String]
}

enum AIError: Error {
    case llmProviderNotAvailable
    case embeddingServiceNotAvailable
    case invalidResponseFormat
}

// MARK: - Protocol Definitions

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

class EmbeddingService {
    func generateEmbeddings(_ text: String) async throws -> [Float] {
        // Placeholder implementation
        // Would use Core ML sentence transformer
        return Array(repeating: 0.0, count: 384)
    }
    
    func findSimilarContent(_ query: String, limit: Int) async throws -> [RetrievedContent] {
        // Placeholder implementation
        // Would search through stored embeddings
        return []
    }
}
