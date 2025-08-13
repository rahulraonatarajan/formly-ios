import Foundation
import CoreData
import Combine

class StorageService: ObservableObject {
    static let shared = StorageService()
    
    private let containerName = "FormlyNative"
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        
        // Configure data protection
        container.persistentStoreDescriptions.forEach { description in
            description.setOption(true as NSNumber, forKey: NSPersistentStoreFileProtectionKey)
        }
        
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private init() {}
    
    func saveContext() throws {
        if viewContext.hasChanges {
            try viewContext.save()
        }
    }
    
    func fetch<T: NSManagedObject>(_ request: NSFetchRequest<T>) throws -> [T] {
        return try viewContext.fetch(request)
    }
    
    func saveDocument(_ data: Data, filename: String, sessionId: UUID?) throws -> URL {
        let documentsDirectory = getDocumentsDirectory()
        let sessionDirectory = sessionId.map { documentsDirectory.appendingPathComponent("sessions/\($0.uuidString)") } ?? documentsDirectory
        let documentsDirectory = sessionDirectory.appendingPathComponent("documents")
        
        try FileManager.default.createDirectory(at: documentsDirectory, withIntermediateDirectories: true)
        
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        try data.write(to: fileURL)
        
        return fileURL
    }
    
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func createBackup() throws -> URL {
        let backupDirectory = getDocumentsDirectory().appendingPathComponent("backups")
        try FileManager.default.createDirectory(at: backupDirectory, withIntermediateDirectories: true)
        
        let timestamp = ISO8601DateFormatter().string(from: Date())
        let backupURL = backupDirectory.appendingPathComponent("formly-backup-\(timestamp).zip")
        
        // Create ZIP backup of Core Data store and documents
        // Implementation would use ZIPFoundation
        return backupURL
    }
    
    func restoreFromBackup(_ url: URL) throws {
        // Implementation would extract ZIP and restore Core Data store
        // This is a placeholder for the actual implementation
    }
    
    func excludeFromBackup(_ url: URL) throws {
        var resourceValues = URLResourceValues()
        resourceValues.isExcludedFromBackup = true
        try url.setResourceValues(resourceValues)
    }
}
