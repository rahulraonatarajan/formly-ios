import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Formly AI")
                }
                .tag(0)
            
            AIAssistantView()
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("AI Assist")
                }
                .tag(1)
            
            ScanFormView()
                .tabItem {
                    Image(systemName: "camera.fill")
                    Text("Scan Form")
                }
                .tag(2)
            
            DocumentsView()
                .tabItem {
                    Image(systemName: "folder.fill")
                    Text("Documents")
                }
                .tag(3)
            
            FormTemplatesView()
                .tabItem {
                    Image(systemName: "doc.text.fill")
                    Text("Form Templates")
                }
                .tag(4)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(5)
        }
        .accentColor(.blue)
    }
}

struct HomeView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header Section with Gradient
                    headerSection
                    
                    // Quick Actions Section
                    quickActionsSection
                    
                    // Recent Forms Section
                    recentFormsSection
                }
                .padding(.horizontal, 20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarHidden(true)
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            // Gradient Background
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 200)
            .overlay(
                VStack(spacing: 12) {
                    Text("Formly AI")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 12) {
                        Image(systemName: "brain.head.profile")
                            .font(.title)
                            .foregroundColor(.white)
                        
                        Text("Welcome to Formly AI")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    
                    Text("Your AI-powered form assistant")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                    
                    // Offline Mode Button
                    HStack(spacing: 8) {
                        Image(systemName: "wifi")
                            .foregroundColor(.green)
                        Text("Offline Mode")
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(20)
                }
                .padding(.horizontal, 20)
            )
            .cornerRadius(16)
        }
    }
    
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            HStack(spacing: 12) {
                // Scan Form Card
                QuickActionCard(
                    icon: "camera.fill",
                    iconColor: .blue,
                    title: "Scan Form",
                    subtitle: "Take a photo of any form...",
                    backgroundColor: .blue.opacity(0.1)
                )
                
                // AI Assistant Card
                QuickActionCard(
                    icon: "message.fill",
                    iconColor: .purple,
                    title: "AI Assistant",
                    subtitle: "Get AI help with forms",
                    backgroundColor: .purple.opacity(0.1)
                )
                
                // Form Templates Card
                QuickActionCard(
                    icon: "doc.text.fill",
                    iconColor: .green,
                    title: "Form Templates",
                    subtitle: "Pre-built form templ...",
                    backgroundColor: .green.opacity(0.1)
                )
            }
        }
    }
    
    private var recentFormsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Forms")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                // Medicaid Application
                RecentFormCard(
                    title: "Medicaid Application",
                    date: "2024-01-15",
                    status: "Completed",
                    statusColor: .green
                )
                
                // SNAP Benefits Form
                RecentFormCard(
                    title: "SNAP Benefits Form",
                    date: "2024-01-10",
                    status: "In Progress",
                    statusColor: .blue
                )
                
                // Additional form (partially visible)
                RecentFormCard(
                    title: "Tax Return Form",
                    date: "2024-01-05",
                    status: "Draft",
                    statusColor: .orange
                )
            }
        }
    }
}

struct QuickActionCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let backgroundColor: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(iconColor)
                .frame(width: 40, height: 40)
                .background(backgroundColor)
                .clipShape(Circle())
            
            VStack(spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct RecentFormCard: View {
    let title: String
    let date: String
    let status: String
    let statusColor: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text(date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(status)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(statusColor)
                .cornerRadius(12)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

// Placeholder Views for other tabs
struct AIAssistantView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "message.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.purple)
                Text("AI Assistant")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Get AI help with your forms")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .navigationTitle("AI Assistant")
        }
    }
}

struct ScanFormView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "camera.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                Text("Scan Form")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Take a photo of any form")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Scan Form")
        }
    }
}

struct DocumentsView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "folder.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.orange)
                Text("Documents")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Manage your documents")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Documents")
        }
    }
}

struct FormTemplatesView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "doc.text.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                Text("Form Templates")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Pre-built form templates")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Form Templates")
        }
    }
}

struct SettingsView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "gear")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
                Text("Settings")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Configure your preferences")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    ContentView()
}
