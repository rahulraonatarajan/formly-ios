import SwiftUI
import CoreData

@main
struct FormlyNativeApp: App {
    // TODO: Add services back once they're properly integrated
    // @StateObject private var storageService = StorageService.shared
    // @StateObject private var aiService = AIService.shared
    // @StateObject private var backupService = BackupService.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                // TODO: Add environment objects back once services are integrated
                // .environment(\.managedObjectContext, storageService.viewContext)
                // .environmentObject(storageService)
                // .environmentObject(aiService)
                // .environmentObject(backupService)
                .onAppear {
                    setupApp()
                }
        }
    }
    
    private func setupApp() {
        // TODO: Add background tasks back once services are integrated
        // BackgroundTaskManager.shared.registerBackgroundTasks()
        // BackgroundTaskManager.shared.scheduleBackgroundTasks()
        
        // TODO: Add template loading back once services are integrated
        // Task {
        //     await loadInitialTemplates()
        // }
    }
    
    private func loadInitialTemplates() async {
        // TODO: Add template loading back once services are integrated
        // do {
        //     try await TemplateLoader.shared.loadInitialTemplates()
        // } catch {
        //     print("Failed to load initial templates: \(error)")
        // }
    }
}

#Preview {
    ContentView()
}
