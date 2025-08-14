import SwiftUI
import CoreData

@main
struct FormlyNativeApp: App {
    @StateObject private var storageService = StorageService.shared
    @StateObject private var aiService = AIService.shared
    @StateObject private var backupService = BackupService.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, storageService.viewContext)
                .environmentObject(storageService)
                .environmentObject(aiService)
                .environmentObject(backupService)
                .onAppear {
                    setupApp()
                }
        }
    }
    
    private func setupApp() {
        // Register background tasks
        BackgroundTaskManager.shared.registerBackgroundTasks()
        
        // Schedule background tasks
        BackgroundTaskManager.shared.scheduleBackgroundTasks()
        
        // Load initial templates if needed
        Task {
            await loadInitialTemplates()
        }
    }
    
    private func loadInitialTemplates() async {
        do {
            try await TemplateLoader.shared.loadInitialTemplates()
        } catch {
            print("Failed to load initial templates: \(error)")
        }
    }
}

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TemplatesView()
                .tabItem {
                    Image(systemName: "doc.text")
                    Text("Templates")
                }
                .tag(0)
            
            SessionsView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Sessions")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(2)
        }
        .accentColor(.blue)
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, StorageService.shared.viewContext)
}
