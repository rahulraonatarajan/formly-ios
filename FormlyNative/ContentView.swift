import SwiftUI

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

struct TemplatesView: View {
    var body: some View {
        NavigationView {
            List {
                Section("Government Forms") {
                    NavigationLink("DMV License Renewal") {
                        DMVRenewalView()
                    }
                    NavigationLink("DS-160 Visa Application") {
                        DS160View()
                    }
                }
                
                Section("Business Forms") {
                    Text("Coming Soon...")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Form Templates")
        }
    }
}

struct SessionsView: View {
    var body: some View {
        NavigationView {
            List {
                Text("No active sessions")
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Active Sessions")
        }
    }
}

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                Section("Backup & Restore") {
                    Button("Create Backup") {
                        // TODO: Implement backup
                    }
                    Button("Restore from Backup") {
                        // TODO: Implement restore
                    }
                }
                
                Section("Privacy") {
                    Button("Export All Data") {
                        // TODO: Implement export
                    }
                    Button("Delete All Data") {
                        // TODO: Implement delete
                    }
                }
                
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct DMVRenewalView: View {
    @State private var isConversationActive = false
    
    var body: some View {
        VStack {
            if isConversationActive {
                ConversationView(templateId: "dmv-license-renewal")
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "car.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("DMV License Renewal")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Complete your driver's license renewal with conversational assistance. This process typically takes about 15 minutes.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    Button("Start Renewal") {
                        isConversationActive = true
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
                .padding()
            }
        }
        .navigationTitle("DMV Renewal")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DS160View: View {
    @State private var isConversationActive = false
    
    var body: some View {
        VStack {
            if isConversationActive {
                ConversationView(templateId: "ds-160")
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "airplane")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("DS-160 Visa Application")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Complete your nonimmigrant visa application with step-by-step guidance. This process typically takes about 45 minutes.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    Button("Start Application") {
                        isConversationActive = true
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
                .padding()
            }
        }
        .navigationTitle("DS-160 Application")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ConversationView: View {
    let templateId: String
    @State private var messages: [Message] = []
    @State private var inputText = ""
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            // Messages list
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(messages) { message in
                            MessageBubble(message: message)
                        }
                        
                        if isLoading {
                            HStack {
                                ProgressView()
                                    .scaleEffect(0.8)
                                Text("Processing...")
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                        }
                    }
                    .padding()
                }
                .onChange(of: messages.count) { _ in
                    withAnimation {
                        proxy.scrollTo(messages.last?.id, anchor: .bottom)
                    }
                }
            }
            
            // Input area
            HStack {
                TextField("Type your message...", text: $inputText)
                    .textFieldStyle(.roundedBorder)
                    .disabled(isLoading)
                
                Button("Send") {
                    sendMessage()
                }
                .disabled(inputText.isEmpty || isLoading)
            }
            .padding()
        }
        .navigationTitle("Form Assistant")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            startConversation()
        }
    }
    
    private func startConversation() {
        let welcomeMessage = Message(
            id: UUID(),
            role: .assistant,
            content: "Hello! I'm here to help you complete your form. Let's get started.",
            createdAt: Date()
        )
        messages.append(welcomeMessage)
    }
    
    private func sendMessage() {
        guard !inputText.isEmpty else { return }
        
        let userMessage = Message(
            id: UUID(),
            role: .user,
            content: inputText,
            createdAt: Date()
        )
        messages.append(userMessage)
        
        let userInput = inputText
        inputText = ""
        isLoading = true
        
        // Simulate AI response
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let aiResponse = Message(
                id: UUID(),
                role: .assistant,
                content: "I understand you said: '\(userInput)'. Let me help you with that.",
                createdAt: Date()
            )
            messages.append(aiResponse)
            isLoading = false
        }
    }
}

struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.role == .user {
                Spacer()
            }
            
            Text(message.content)
                .padding()
                .background(message.role == .user ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(message.role == .user ? .white : .primary)
                .cornerRadius(16)
            
            if message.role == .assistant {
                Spacer()
            }
        }
    }
}

struct Message: Identifiable {
    let id: UUID
    let role: MessageRole
    let content: String
    let createdAt: Date
}

enum MessageRole {
    case user
    case assistant
    case system
}

#Preview {
    ContentView()
}
