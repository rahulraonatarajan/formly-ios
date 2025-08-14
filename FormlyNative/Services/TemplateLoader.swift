import Foundation
import CoreData

class TemplateLoader {
    static let shared = TemplateLoader()
    
    private let storageService = StorageService.shared
    
    private init() {}
    
    func loadInitialTemplates() async throws {
        // Check if templates are already loaded
        let request: NSFetchRequest<FormTemplate> = FormTemplate.fetchRequest()
        let existingTemplates = try storageService.fetch(request)
        
        if existingTemplates.isEmpty {
            try await loadBundledTemplates()
        }
    }
    
    private func loadBundledTemplates() async throws {
        let templates = [
            ("dmv-renewal", "DMV License Renewal"),
            ("ds-160", "DS-160 Visa Application")
        ]
        
        for (filename, name) in templates {
            if let templateData = loadTemplateFromBundle(filename: filename) {
                try await saveTemplateToCoreData(templateData, name: name)
            }
        }
    }
    
    private func loadTemplateFromBundle(filename: String) -> Data? {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json", subdirectory: "templates") else {
            print("Template file not found: \(filename).json")
            return nil
        }
        
        do {
            return try Data(contentsOf: url)
        } catch {
            print("Failed to load template \(filename): \(error)")
            return nil
        }
    }
    
    private func saveTemplateToCoreData(_ templateData: Data, name: String) async throws {
        let context = storageService.viewContext
        
        // Parse template JSON
        let template = try JSONDecoder().decode(TemplateData.self, from: templateData)
        
        // Create FormTemplate entity
        let formTemplate = FormTemplate(context: context)
        formTemplate.id = UUID()
        formTemplate.name = template.metadata.name
        formTemplate.category = template.metadata.category
        formTemplate.description = template.metadata.description
        formTemplate.estimatedTime = Int16(template.metadata.estimatedTime)
        formTemplate.difficulty = template.metadata.difficulty
        formTemplate.jsonSchema = templateData
        formTemplate.version = template.metadata.version
        formTemplate.languageSupport = template.metadata.languageSupport
        formTemplate.createdAt = Date()
        formTemplate.updatedAt = Date()
        
        try storageService.saveContext()
        print("Loaded template: \(name)")
    }
    
    func getTemplate(id: String) throws -> FormTemplate? {
        let request: NSFetchRequest<FormTemplate> = FormTemplate.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[c] %@", id)
        request.fetchLimit = 1
        
        let templates = try storageService.fetch(request)
        return templates.first
    }
    
    func getAllTemplates() throws -> [FormTemplate] {
        let request: NSFetchRequest<FormTemplate> = FormTemplate.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FormTemplate.name, ascending: true)]
        
        return try storageService.fetch(request)
    }
}

// MARK: - Template Data Structure

struct TemplateData: Codable {
    let metadata: TemplateMetadata
    let schema: TemplateSchema
    let conversationFlow: ConversationFlow
    let review: TemplateReview
    let systemPrompt: String?
}

struct TemplateMetadata: Codable {
    let id: String
    let name: String
    let version: String
    let languageSupport: [String]
    let category: String
    let description: String
    let estimatedTime: Int
    let difficulty: String
}

struct TemplateSchema: Codable {
    let sections: [TemplateSection]
}

struct TemplateSection: Codable {
    let id: String
    let title: String
    let description: String
    let fields: [TemplateField]
}

struct TemplateField: Codable {
    let id: String
    let label: String
    let type: String
    let required: Bool
    let options: [String]?
    let validation: FieldValidation?
    let aiPrompt: String?
}

struct FieldValidation: Codable {
    let pattern: String?
    let minLength: Int?
    let maxLength: Int?
    let minAge: Int?
    let maxAge: Int?
    let maxDaysAgo: Int?
    let minDaysFromNow: Int?
    let message: String?
}

struct ConversationFlow: Codable {
    let steps: [ConversationStepData]
}

struct ConversationStepData: Codable {
    let id: String
    let title: String
    let description: String
    let expectedFields: [String]
    let validationRules: [ValidationRule]?
    let conditionalLogic: [ConditionalLogic]?
}

struct ValidationRule: Codable {
    let field: String
    let rule: String
    let value: String?
    let message: String?
}

struct ConditionalLogic: Codable {
    let condition: String
    let action: String
    let message: String?
    let documents: [String]?
}

struct TemplateReview: Codable {
    let checklists: [Checklist]?
    let submissionGuidance: String?
    let feeInfo: FeeInfo?
}

struct Checklist: Codable {
    let id: String
    let title: String
    let items: [String]
}

struct FeeInfo: Codable {
    let standard: FeeDetail?
    let realId: FeeDetail?
    let enhanced: FeeDetail?
    let additionalFees: [AdditionalFee]?
}

struct FeeDetail: Codable {
    let base: Int
    let currency: String
    let description: String
}

struct AdditionalFee: Codable {
    let name: String
    let amount: String
    let description: String
}
