import Foundation
import BackgroundTasks

class BackgroundTaskManager {
    static let shared = BackgroundTaskManager()
    
    private let backupTaskIdentifier = "com.formlyai.native.backup"
    private let indexingTaskIdentifier = "com.formlyai.native.indexing"
    
    private init() {}
    
    func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: backupTaskIdentifier,
            using: nil
        ) { task in
            self.handleBackupTask(task as! BGAppRefreshTask)
        }
        
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: indexingTaskIdentifier,
            using: nil
        ) { task in
            self.handleIndexingTask(task as! BGProcessingTask)
        }
    }
    
    func scheduleBackgroundTasks() {
        scheduleBackupTask()
        scheduleIndexingTask()
    }
    
    private func scheduleBackupTask() {
        let request = BGAppRefreshTaskRequest(identifier: backupTaskIdentifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 24 * 60 * 60) // 24 hours from now
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("Background backup task scheduled")
        } catch {
            print("Failed to schedule background backup task: \(error)")
        }
    }
    
    private func scheduleIndexingTask() {
        let request = BGProcessingTaskRequest(identifier: indexingTaskIdentifier)
        request.requiresNetworkConnectivity = false
        request.requiresExternalPower = false
        request.earliestBeginDate = Date(timeIntervalSinceNow: 60 * 60) // 1 hour from now
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("Background indexing task scheduled")
        } catch {
            print("Failed to schedule background indexing task: \(error)")
        }
    }
    
    private func handleBackupTask(_ task: BGAppRefreshTask) {
        task.expirationHandler = {
            // Cancel ongoing backup
            print("Background backup task expired")
        }
        
        Task {
            do {
                try await BackupService.shared.createBackup()
                task.setTaskCompleted(success: true)
                print("Background backup completed successfully")
            } catch {
                task.setTaskCompleted(success: false)
                print("Background backup failed: \(error)")
            }
            
            // Schedule next backup
            scheduleBackupTask()
        }
    }
    
    private func handleIndexingTask(_ task: BGProcessingTask) {
        task.expirationHandler = {
            // Cancel ongoing indexing
            print("Background indexing task expired")
        }
        
        Task {
            do {
                try await performIndexing()
                task.setTaskCompleted(success: true)
                print("Background indexing completed successfully")
            } catch {
                task.setTaskCompleted(success: false)
                print("Background indexing failed: \(error)")
            }
            
            // Schedule next indexing
            scheduleIndexingTask()
        }
    }
    
    private func performIndexing() async throws {
        // Index documents for RAG
        // This would process documents and generate embeddings
        print("Performing background indexing...")
        
        // Simulate indexing work
        try await Task.sleep(nanoseconds: 5_000_000_000) // 5 seconds
    }
}
