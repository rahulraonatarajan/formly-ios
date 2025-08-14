import Foundation
import Combine

class BackupService: ObservableObject {
    static let shared = BackupService()
    
    @Published var isBackingUp = false
    @Published var isRestoring = false
    
    private let storageService = StorageService.shared
    
    private init() {}
    
    func createBackup() async throws -> URL {
        await MainActor.run {
            isBackingUp = true
        }
        
        defer {
            Task { @MainActor in
                isBackingUp = false
            }
        }
        
        return try await performBackup()
    }
    
    func restoreFromBackup(_ url: URL) async throws {
        await MainActor.run {
            isRestoring = true
        }
        
        defer {
            Task { @MainActor in
                isRestoring = false
            }
        }
        
        try await performRestore(from: url)
    }
    
    func exportToiCloud() async throws {
        let backupURL = try await createBackup()
        
        // Use UIDocumentPicker to save to iCloud Drive
        // This would be implemented in the UI layer
        print("Backup created at: \(backupURL)")
    }
    
    func importFromiCloud() async throws -> URL {
        // Use UIDocumentPicker to select from iCloud Drive
        // This would be implemented in the UI layer
        throw BackupError.notImplemented
    }
    
    private func performBackup() async throws -> URL {
        let backupURL = try storageService.createBackup()
        
        // Create backup manifest
        let manifest = BackupManifest(
            version: "1.0",
            createdAt: Date(),
            deviceInfo: getDeviceInfo(),
            appVersion: getAppVersion(),
            dataSize: try getDataSize()
        )
        
        // Save manifest to backup
        let manifestData = try JSONEncoder().encode(manifest)
        let manifestURL = backupURL.deletingPathExtension().appendingPathExtension("manifest")
        try manifestData.write(to: manifestURL)
        
        return backupURL
    }
    
    private func performRestore(from url: URL) async throws {
        // Validate backup integrity
        let manifestURL = url.deletingPathExtension().appendingPathExtension("manifest")
        let manifestData = try Data(contentsOf: manifestURL)
        let manifest = try JSONDecoder().decode(BackupManifest.self, from: manifestData)
        
        // Validate manifest
        try validateManifest(manifest)
        
        // Perform restore
        try storageService.restoreFromBackup(url)
    }
    
    private func validateManifest(_ manifest: BackupManifest) throws {
        // Check version compatibility
        guard manifest.version == "1.0" else {
            throw BackupError.incompatibleVersion(manifest.version)
        }
        
        // Check if backup is not too old
        let maxAge: TimeInterval = 365 * 24 * 60 * 60 // 1 year
        if Date().timeIntervalSince(manifest.createdAt) > maxAge {
            throw BackupError.backupTooOld
        }
    }
    
    private func getDeviceInfo() -> DeviceInfo {
        return DeviceInfo(
            model: UIDevice.current.model,
            systemVersion: UIDevice.current.systemVersion,
            identifier: UIDevice.current.identifierForVendor?.uuidString ?? "unknown"
        )
    }
    
    private func getAppVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
    
    private func getDataSize() throws -> Int64 {
        let documentsURL = storageService.getDocumentsDirectory()
        let enumerator = FileManager.default.enumerator(at: documentsURL, includingPropertiesForKeys: [.fileSizeKey])
        
        var totalSize: Int64 = 0
        while let fileURL = enumerator?.nextObject() as? URL {
            let resourceValues = try fileURL.resourceValues(forKeys: [.fileSizeKey])
            totalSize += Int64(resourceValues.fileSize ?? 0)
        }
        
        return totalSize
    }
}

// MARK: - Supporting Types

struct BackupManifest: Codable {
    let version: String
    let createdAt: Date
    let deviceInfo: DeviceInfo
    let appVersion: String
    let dataSize: Int64
}

struct DeviceInfo: Codable {
    let model: String
    let systemVersion: String
    let identifier: String
}

enum BackupError: Error, LocalizedError {
    case notImplemented
    case incompatibleVersion(String)
    case backupTooOld
    case invalidBackup
    case restoreFailed
    
    var errorDescription: String? {
        switch self {
        case .notImplemented:
            return "This feature is not yet implemented"
        case .incompatibleVersion(let version):
            return "Backup version \(version) is not compatible with this app version"
        case .backupTooOld:
            return "Backup is too old and cannot be restored"
        case .invalidBackup:
            return "Backup file is invalid or corrupted"
        case .restoreFailed:
            return "Failed to restore from backup"
        }
    }
}
