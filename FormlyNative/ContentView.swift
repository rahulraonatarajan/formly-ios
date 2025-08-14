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
            
            MoreView()
                .tabItem {
                    Image(systemName: "ellipsis")
                    Text("More")
                }
                .tag(4)
        }
        .accentColor(.blue)
        .preferredColorScheme(.dark) // Force dark mode to match screenshot
    }
}

struct HomeView: View {
    @State private var showingFormTemplates = false
    @State private var showingAIAssistant = false
    @State private var showingScanForm = false
    
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
            .background(Color.black)
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingFormTemplates) {
            FormTemplatesView()
        }
        .sheet(isPresented: $showingAIAssistant) {
            AIAssistantView()
        }
        .sheet(isPresented: $showingScanForm) {
            ScanFormView()
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
                .foregroundColor(.white)
            
            HStack(spacing: 12) {
                // Scan Form Card
                QuickActionCard(
                    icon: "camera.fill",
                    iconColor: .blue,
                    title: "Scan Form",
                    subtitle: "Take a photo of any form...",
                    backgroundColor: .blue.opacity(0.1),
                    action: { showingScanForm = true }
                )
                
                // AI Assistant Card
                QuickActionCard(
                    icon: "message.fill",
                    iconColor: .purple,
                    title: "AI Assistant",
                    subtitle: "Get AI help with forms",
                    backgroundColor: .purple.opacity(0.1),
                    action: { showingAIAssistant = true }
                )
                
                // Form Templates Card
                QuickActionCard(
                    icon: "doc.text.fill",
                    iconColor: .green,
                    title: "Form Templates",
                    subtitle: "Pre-built form templ...",
                    backgroundColor: .green.opacity(0.1),
                    action: { showingFormTemplates = true }
                )
            }
        }
    }
    
    private var recentFormsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Forms")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                // Medicaid Application
                RecentFormCard(
                    title: "Medicaid Application",
                    date: "2024-01-15",
                    status: "Completed",
                    statusColor: .green,
                    action: { showingFormTemplates = true }
                )
                
                // SNAP Benefits Form
                RecentFormCard(
                    title: "SNAP Benefits Form",
                    date: "2024-01-10",
                    status: "In Progress",
                    statusColor: .blue,
                    action: { showingFormTemplates = true }
                )
                
                // Additional form (partially visible)
                RecentFormCard(
                    title: "Tax Return Form",
                    date: "2024-01-05",
                    status: "Draft",
                    statusColor: .orange,
                    action: { showingFormTemplates = true }
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
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
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
                        .foregroundColor(.black)
                    
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
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct RecentFormCard: View {
    let title: String
    let date: String
    let status: String
    let statusColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    
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
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Placeholder Views for other tabs
struct AIAssistantView: View {
    @State private var messages: [FormMessage] = []
    @State private var inputText = ""
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Messages area
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(messages) { message in
                                FormMessageBubble(message: message)
                            }
                            
                            if isLoading {
                                HStack {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                    Text("AI is thinking...")
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
                HStack(spacing: 12) {
                    TextField("Ask me anything about forms...", text: $inputText)
                        .textFieldStyle(.roundedBorder)
                        .disabled(isLoading)
                    
                    Button("Send") {
                        sendMessage()
                    }
                    .disabled(inputText.isEmpty || isLoading)
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .background(Color(.systemGroupedBackground))
            }
            .navigationTitle("AI Assistant")
            .onAppear {
                startConversation()
            }
        }
    }
    
    private func startConversation() {
        let welcomeMessage = FormMessage(
            id: UUID(),
            role: .assistant,
            content: "Hello! I'm your AI form assistant. I can help you with:\n\n• Understanding form requirements\n• Filling out complex forms\n• Explaining legal terms\n• Providing step-by-step guidance\n\nWhat would you like help with today?",
            timestamp: Date()
        )
        messages.append(welcomeMessage)
    }
    
    private func sendMessage() {
        guard !inputText.isEmpty else { return }
        
        let userMessage = FormMessage(
            id: UUID(),
            role: .user,
            content: inputText,
            timestamp: Date()
        )
        messages.append(userMessage)
        
        let userInput = inputText
        inputText = ""
        isLoading = true
        
        // Simulate AI response
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let aiResponse = generateAIResponse(to: userInput)
            let responseMessage = FormMessage(
                id: UUID(),
                role: .assistant,
                content: aiResponse,
                timestamp: Date()
            )
            messages.append(responseMessage)
            isLoading = false
        }
    }
    
    private func generateAIResponse(to userInput: String) -> String {
        let lowercased = userInput.lowercased()
        
        if lowercased.contains("dmv") || lowercased.contains("license") || lowercased.contains("driver") {
            return "For DMV license renewal, you'll typically need:\n\n• Current driver's license\n• Proof of identity (passport, birth certificate)\n• Proof of residency (utility bill, lease)\n• Payment method\n\nMost states allow online renewal if your license isn't expired for more than 1 year. Would you like me to help you with a specific state's requirements?"
        } else if lowercased.contains("visa") || lowercased.contains("ds-160") || lowercased.contains("travel") {
            return "The DS-160 is a comprehensive visa application form. Key requirements include:\n\n• Valid passport\n• Travel itinerary\n• Employment/education history\n• Financial information\n• Previous travel history\n\nThe form takes about 90 minutes to complete. Would you like me to walk you through a specific section?"
        } else if lowercased.contains("medicaid") || lowercased.contains("health") {
            return "Medicaid eligibility depends on:\n\n• Income level (varies by state)\n• Household size\n• Age and disability status\n• Citizenship status\n\nYou'll need documents like pay stubs, tax returns, and proof of citizenship. Would you like me to help you check eligibility for your state?"
        } else if lowercased.contains("snap") || lowercased.contains("food") || lowercased.contains("benefits") {
            return "SNAP (food stamps) benefits are based on:\n\n• Household income (must be below 130% of poverty level)\n• Household size\n• Monthly expenses\n• Assets\n\nYou'll need proof of income, expenses, and household composition. Would you like me to help you calculate potential benefits?"
        } else if lowercased.contains("tax") || lowercased.contains("irs") {
            return "For tax returns, you'll need:\n\n• W-2 forms from employers\n• 1099 forms for other income\n• Receipts for deductions\n• Previous year's tax return\n• Social Security numbers for all dependents\n\nWould you like me to help you understand specific deductions or credits you might qualify for?"
        } else {
            return "I can help you with various forms including DMV license renewal, DS-160 visa applications, Medicaid, SNAP benefits, and tax returns. What specific form are you working on? I can provide detailed guidance and help you understand the requirements."
        }
    }
}

struct ScanFormView: View {
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var scannedImage: UIImage?
    @State private var extractedText = ""
    @State private var isProcessing = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let scannedImage = scannedImage {
                    // Show scanned image and extracted text
                    VStack(spacing: 16) {
                        Image(uiImage: scannedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 300)
                            .cornerRadius(12)
                        
                        if isProcessing {
                            ProgressView("Processing image...")
                                .padding()
                        } else if !extractedText.isEmpty {
                            ScrollView {
                                Text(extractedText)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }
                            .frame(maxHeight: 200)
                        }
                        
                        HStack(spacing: 16) {
                            Button("Scan New") {
                                showingCamera = true
                            }
                            .buttonStyle(.bordered)
                            
                            Button("Use Text") {
                                // TODO: Use extracted text to fill form
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(extractedText.isEmpty)
                        }
                    }
                } else {
                    // Show scan options
                    VStack(spacing: 24) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.blue)
                        
                        Text("Scan Form")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Take a photo of any form to extract text and auto-fill information")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            Button(action: {
                                showingCamera = true
                            }) {
                                HStack {
                                    Image(systemName: "camera.fill")
                                    Text("Take Photo")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                            
                            Button(action: {
                                showingImagePicker = true
                            }) {
                                HStack {
                                    Image(systemName: "photo.fill")
                                    Text("Choose from Library")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Scan Form")
            .sheet(isPresented: $showingCamera) {
                CameraView(image: $scannedImage)
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $scannedImage)
            }
            .onChange(of: scannedImage) { _ in
                if scannedImage != nil {
                    processImage()
                }
            }
        }
    }
    
    private func processImage() {
        guard let image = scannedImage else { return }
        
        isProcessing = true
        extractedText = ""
        
        // Simulate OCR processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // In a real app, this would use Vision framework for OCR
            extractedText = "Sample extracted text from form:\n\nName: John Doe\nDate of Birth: 01/15/1985\nAddress: 123 Main Street\nCity: Anytown, ST 12345\n\nThis is a sample of text that would be extracted from the scanned form using OCR technology."
            isProcessing = false
        }
    }
}

struct CameraView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

struct DocumentsView: View {
    @State private var documents: [Document] = [
        Document(name: "DMV License Renewal", type: "Form", date: "2024-01-15", status: "Completed"),
        Document(name: "SNAP Benefits Application", type: "Form", date: "2024-01-10", status: "In Progress"),
        Document(name: "Tax Return 2023", type: "Form", date: "2024-01-05", status: "Draft"),
        Document(name: "Passport Scan", type: "Document", date: "2024-01-03", status: "Uploaded"),
        Document(name: "Utility Bill", type: "Document", date: "2024-01-02", status: "Uploaded")
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(documents) { document in
                    DocumentRow(document: document)
                }
                .onDelete(perform: deleteDocuments)
            }
            .navigationTitle("Documents")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        // TODO: Add document functionality
                    }
                }
            }
        }
    }
    
    private func deleteDocuments(offsets: IndexSet) {
        documents.remove(atOffsets: offsets)
    }
}

struct Document: Identifiable {
    let id = UUID()
    let name: String
    let type: String
    let date: String
    let status: String
}

struct DocumentRow: View {
    let document: Document
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: document.type == "Form" ? "doc.text.fill" : "doc.fill")
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 40, height: 40)
                .background(Color.blue.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(document.name)
                    .font(.headline)
                    .fontWeight(.medium)
                
                Text(document.type)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(document.date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(document.status)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(statusColor)
                .cornerRadius(8)
        }
        .padding(.vertical, 4)
    }
    
    private var statusColor: Color {
        switch document.status {
        case "Completed":
            return .green
        case "In Progress":
            return .blue
        case "Draft":
            return .orange
        case "Uploaded":
            return .purple
        default:
            return .gray
        }
    }
}

struct FormTemplatesView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTemplate: FormTemplate?
    
    let templates = [
        FormTemplate(
            id: "dmv-renewal",
            name: "DMV License Renewal",
            description: "Complete your driver's license renewal with conversational assistance",
            icon: "car.fill",
            color: .blue,
            estimatedTime: "15 minutes"
        ),
        FormTemplate(
            id: "ds-160",
            name: "DS-160 Visa Application",
            description: "Complete your nonimmigrant visa application with step-by-step guidance",
            icon: "airplane",
            color: .purple,
            estimatedTime: "45 minutes"
        ),
        FormTemplate(
            id: "medicaid",
            name: "Medicaid Application",
            description: "Apply for Medicaid health coverage assistance",
            icon: "heart.fill",
            color: .green,
            estimatedTime: "20 minutes"
        ),
        FormTemplate(
            id: "snap",
            name: "SNAP Benefits Form",
            description: "Apply for Supplemental Nutrition Assistance Program",
            icon: "cart.fill",
            color: .orange,
            estimatedTime: "25 minutes"
        ),
        FormTemplate(
            id: "tax-return",
            name: "Tax Return Form",
            description: "Complete your annual tax return with AI assistance",
            icon: "dollarsign.circle.fill",
            color: .red,
            estimatedTime: "30 minutes"
        )
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(templates) { template in
                    FormTemplateRow(template: template) {
                        selectedTemplate = template
                    }
                }
            }
            .navigationTitle("Form Templates")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(item: $selectedTemplate) { template in
            FormFillingView(template: template)
        }
    }
}

struct FormTemplate: Identifiable {
    let id: String
    let name: String
    let description: String
    let icon: String
    let color: Color
    let estimatedTime: String
}

struct FormTemplateRow: View {
    let template: FormTemplate
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: template.icon)
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(template.color)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(template.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(template.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
                    HStack {
                        Image(systemName: "clock")
                            .font(.caption)
                        Text(template.estimatedTime)
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FormFillingView: View {
    let template: FormTemplate
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep = 0
    @State private var formData: [String: String] = [:]
    @State private var messages: [FormMessage] = []
    @State private var inputText = ""
    @State private var isLoading = false
    @State private var showingFormPreview = false
    @State private var entryMode: EntryMode = .structured
    @State private var showingMiniChat = false
    
    enum EntryMode {
        case conversational
        case structured
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Progress header
                progressHeader
                
                // Entry mode selector
                entryModeSelector
                
                if entryMode == .conversational {
                    // Messages area
                    messagesArea
                    
                    // Input area
                    inputArea
                } else {
                    // Structured form view
                    structuredFormView
                }
            }
            .navigationTitle(template.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button("Preview") {
                            showingFormPreview = true
                        }
                        .disabled(formData.isEmpty)
                        
                        Button("Save") {
                            saveForm()
                        }
                        .disabled(formData.isEmpty)
                    }
                }
            }
        }
        .sheet(isPresented: $showingFormPreview) {
            FormPreviewView(template: template, formData: formData)
        }
        .onAppear {
            startForm()
        }
        .onChange(of: formData) { _ in
            if entryMode == .structured {
                updateCurrentStep()
            }
        }
    }
    
    private var progressHeader: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Step \(currentStep + 1) of \(getTotalSteps())")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(Int((Double(currentStep + 1) / Double(getTotalSteps())) * 100))%")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }
            
            ProgressView(value: Double(currentStep + 1), total: Double(getTotalSteps()))
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
        }
        .padding(.horizontal)
        .padding(.top, 8)
        .background(Color(.systemGroupedBackground))
    }
    
    private var entryModeSelector: some View {
        HStack(spacing: 0) {
            Button(action: {
                entryMode = .conversational
            }) {
                HStack {
                    Image(systemName: "message.fill")
                    Text("Chat")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(entryMode == .conversational ? Color.blue : Color(.systemGray5))
                .foregroundColor(entryMode == .conversational ? .white : .primary)
            }
            
            Button(action: {
                entryMode = .structured
            }) {
                HStack {
                    Image(systemName: "doc.text.fill")
                    Text("Form")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(entryMode == .structured ? Color.blue : Color(.systemGray5))
                .foregroundColor(entryMode == .structured ? .white : .primary)
            }
        }
        .background(Color(.systemGray5))
        .cornerRadius(8)
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    private var messagesArea: some View {
        ZStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(messages) { message in
                            FormMessageBubble(message: message)
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
                    .padding(.bottom, 80) // Add padding for floating form button
                }
                .onChange(of: messages.count) { _ in
                    withAnimation {
                        proxy.scrollTo(messages.last?.id, anchor: .bottom)
                    }
                }
            }
            
            // Floating form button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    FloatingFormButton {
                        entryMode = .structured
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                }
            }
        }
    }
    
    private var inputArea: some View {
        HStack(spacing: 12) {
            TextField("Type your answer...", text: $inputText)
                .textFieldStyle(.roundedBorder)
                .disabled(isLoading)
            
            Button("Send") {
                sendMessage()
            }
            .disabled(inputText.isEmpty || isLoading)
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color(.systemGroupedBackground))
    }
    
    private var structuredFormView: some View {
        ZStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(Array(getQuestionsForTemplate().enumerated()), id: \.offset) { index, question in
                        StructuredFormField(
                            question: question,
                            value: Binding(
                                get: { formData[question.field] ?? "" },
                                set: { formData[question.field] = $0 }
                            ),
                            isCompleted: !(formData[question.field] ?? "").isEmpty,
                            isCurrentStep: index == currentStep
                        )
                    }
                }
                .padding()
                .padding(.bottom, 80) // Add padding for floating chat bubble
            }
            .background(Color(.systemGroupedBackground))
            
            // Floating chat bubble
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    FloatingChatBubble {
                        showingMiniChat = true
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                }
            }
            
            // Mini chat overlay
            if showingMiniChat {
                MiniChatOverlay(
                    template: template,
                    formData: $formData,
                    isVisible: $showingMiniChat,
                    currentStep: currentStep,
                    questions: getQuestionsForTemplate()
                )
            }
        }
    }
    
    private func startForm() {
        let welcomeMessage = FormMessage(
            id: UUID(),
            role: .assistant,
            content: "Hello! I'm here to help you complete your \(template.name.lowercased()). Let's get started with the first question.",
            timestamp: Date()
        )
        messages.append(welcomeMessage)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            askNextQuestion()
        }
    }
    
    private func askNextQuestion() {
        let questions = getQuestionsForTemplate()
        guard currentStep < questions.count else {
            completeForm()
            return
        }
        
        let question = questions[currentStep]
        let questionMessage = FormMessage(
            id: UUID(),
            role: .assistant,
            content: question.text,
            timestamp: Date()
        )
        messages.append(questionMessage)
    }
    
    private func sendMessage() {
        guard !inputText.isEmpty else { return }
        
        let userMessage = FormMessage(
            id: UUID(),
            role: .user,
            content: inputText,
            timestamp: Date()
        )
        messages.append(userMessage)
        
        let userInput = inputText
        inputText = ""
        isLoading = true
        
        // Store the answer
        let questions = getQuestionsForTemplate()
        if currentStep < questions.count {
            formData[questions[currentStep].field] = userInput
        }
        
        // Simulate AI processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            currentStep += 1
            
            if currentStep < questions.count {
                askNextQuestion()
            } else {
                completeForm()
            }
        }
    }
    
    private func updateCurrentStep() {
        let questions = getQuestionsForTemplate()
        let completedCount = questions.enumerated().filter { index, question in
            !(formData[question.field] ?? "").isEmpty
        }.count
        
        currentStep = min(completedCount, questions.count - 1)
    }
    
    private func completeForm() {
        let completionMessage = FormMessage(
            id: UUID(),
            role: .assistant,
            content: "Great! I've collected all the information for your \(template.name.lowercased()). Your form is now complete and ready to submit.",
            timestamp: Date()
        )
        messages.append(completionMessage)
    }
    
    private func saveForm() {
        // In a real app, this would save to Core Data
        print("Saving form data: \(formData)")
        dismiss()
    }
    
    private func getTotalSteps() -> Int {
        return getQuestionsForTemplate().count
    }
    
    private func getQuestionsForTemplate() -> [FormQuestion] {
        switch template.id {
        case "dmv-renewal":
            return [
                FormQuestion(field: "fullName", text: "What is your full legal name as it appears on your current license?"),
                FormQuestion(field: "dateOfBirth", text: "What is your date of birth?"),
                FormQuestion(field: "licenseNumber", text: "What is your current driver's license number?"),
                FormQuestion(field: "address", text: "What is your current residential address?"),
                FormQuestion(field: "state", text: "Which state are you renewing your license in?")
            ]
        case "ds-160":
            return [
                FormQuestion(field: "fullName", text: "What is your full name as it appears on your passport?"),
                FormQuestion(field: "dateOfBirth", text: "What is your date of birth?"),
                FormQuestion(field: "passportNumber", text: "What is your passport number?"),
                FormQuestion(field: "purpose", text: "What is the primary purpose of your visit to the United States?"),
                FormQuestion(field: "duration", text: "How long do you plan to stay in the United States?")
            ]
        case "medicaid":
            return [
                FormQuestion(field: "fullName", text: "What is your full legal name?"),
                FormQuestion(field: "dateOfBirth", text: "What is your date of birth?"),
                FormQuestion(field: "income", text: "What is your monthly household income?"),
                FormQuestion(field: "householdSize", text: "How many people are in your household?"),
                FormQuestion(field: "address", text: "What is your current address?")
            ]
        case "snap":
            return [
                FormQuestion(field: "fullName", text: "What is your full legal name?"),
                FormQuestion(field: "dateOfBirth", text: "What is your date of birth?"),
                FormQuestion(field: "income", text: "What is your monthly household income?"),
                FormQuestion(field: "expenses", text: "What are your monthly housing expenses?"),
                FormQuestion(field: "address", text: "What is your current address?")
            ]
        case "tax-return":
            return [
                FormQuestion(field: "fullName", text: "What is your full legal name?"),
                FormQuestion(field: "ssn", text: "What is your Social Security Number?"),
                FormQuestion(field: "income", text: "What was your total income for the tax year?"),
                FormQuestion(field: "deductions", text: "What were your total deductions?"),
                FormQuestion(field: "filingStatus", text: "What is your filing status?")
            ]
        default:
            return []
        }
    }
}

struct FormQuestion {
    let field: String
    let text: String
}

struct FormMessage: Identifiable {
    let id: UUID
    let role: MessageRole
    let content: String
    let timestamp: Date
}

enum MessageRole {
    case user
    case assistant
}

struct FormMessageBubble: View {
    let message: FormMessage
    
    var body: some View {
        HStack {
            if message.role == .user {
                Spacer()
            }
            
            VStack(alignment: message.role == .user ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .padding()
                    .background(message.role == .user ? Color.blue : Color(.systemGray5))
                    .foregroundColor(message.role == .user ? .white : .primary)
                    .cornerRadius(16)
                
                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            if message.role == .assistant {
                Spacer()
            }
        }
    }
}

struct FormPreviewView: View {
    let template: FormTemplate
    let formData: [String: String]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Form header
                    formHeader
                    
                    // Form content
                    formContent
                    
                    // Completion status
                    completionStatus
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Form Preview")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var formHeader: some View {
        VStack(spacing: 12) {
            Image(systemName: template.icon)
                .font(.system(size: 40))
                .foregroundColor(template.color)
            
            Text(template.name)
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Preview of your completed form")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private var formContent: some View {
        VStack(spacing: 16) {
            ForEach(Array(formData.keys.sorted()), id: \.self) { key in
                if let value = formData[key], !value.isEmpty {
                    FormPreviewField(
                        label: getFieldLabel(for: key),
                        value: value
                    )
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private var completionStatus: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Completion")
                    .font(.headline)
                Spacer()
                Text("\(Int((Double(formData.values.filter { !$0.isEmpty }.count) / Double(getTotalFields())) * 100))%")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            
            ProgressView(value: Double(formData.values.filter { !$0.isEmpty }.count), total: Double(getTotalFields()))
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private func getFieldLabel(for key: String) -> String {
        switch key {
        case "fullName": return "Full Legal Name"
        case "dateOfBirth": return "Date of Birth"
        case "licenseNumber": return "License Number"
        case "address": return "Address"
        case "state": return "State"
        case "passportNumber": return "Passport Number"
        case "purpose": return "Purpose of Visit"
        case "duration": return "Duration of Stay"
        case "income": return "Monthly Income"
        case "householdSize": return "Household Size"
        case "expenses": return "Monthly Expenses"
        case "ssn": return "Social Security Number"
        case "deductions": return "Total Deductions"
        case "filingStatus": return "Filing Status"
        default: return key.capitalized
        }
    }
    
    private func getTotalFields() -> Int {
        switch template.id {
        case "dmv-renewal": return 5
        case "ds-160": return 5
        case "medicaid": return 5
        case "snap": return 5
        case "tax-return": return 5
        default: return 5
        }
    }
}

struct FormPreviewField: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            
            Text(value)
                .font(.body)
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

struct StructuredFormField: View {
    let question: FormQuestion
    @Binding var value: String
    let isCompleted: Bool
    let isCurrentStep: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(question.text)
                    .font(.headline)
                    .fontWeight(.medium)
                
                Spacer()
                
                if isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                } else if isCurrentStep {
                    Image(systemName: "arrow.right.circle.fill")
                        .foregroundColor(.blue)
                }
            }
            
            TextField("Enter your answer...", text: $value)
                .textFieldStyle(.roundedBorder)
                .background(isCurrentStep ? Color.blue.opacity(0.1) : Color.clear)
                .cornerRadius(8)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isCurrentStep ? Color.blue : Color.clear, lineWidth: 2)
        )
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct FloatingChatBubble: View {
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "message.fill")
                    .font(.system(size: 16, weight: .medium))
                
                Text("Need help?")
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

struct FloatingFormButton: View {
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "doc.text.fill")
                    .font(.system(size: 16, weight: .medium))
                
                Text("Fill form")
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.green, Color.blue]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

struct MoreView: View {
    var body: some View {
        NavigationView {
            List {
                Section("Form Templates") {
                    NavigationLink("All Templates") {
                        FormTemplatesView()
                    }
                }
                
                Section("Settings") {
                    NavigationLink("Preferences") {
                        SettingsView()
                    }
                    NavigationLink("Privacy") {
                        Text("Privacy Settings")
                            .navigationTitle("Privacy")
                    }
                    NavigationLink("About") {
                        Text("About Formly AI")
                            .navigationTitle("About")
                    }
                }
            }
            .navigationTitle("More")
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

struct MiniChatOverlay: View {
    let template: FormTemplate
    @Binding var formData: [String: String]
    @Binding var isVisible: Bool
    let currentStep: Int
    let questions: [FormQuestion]
    
    @State private var messages: [FormMessage] = []
    @State private var inputText = ""
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isVisible = false
                    }
                }
            
            // Chat overlay
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("AI Assistant")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isVisible = false
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                
                // Messages area
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            if messages.isEmpty {
                                VStack(spacing: 16) {
                                    Image(systemName: "message.circle.fill")
                                        .font(.system(size: 48))
                                        .foregroundColor(.blue)
                                    
                                    Text("How can I help you fill out this form?")
                                        .font(.headline)
                                        .multilineTextAlignment(.center)
                                    
                                    Text("Ask me anything about the form or let me help you fill specific sections.")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                }
                                .padding(.top, 40)
                            }
                            
                            ForEach(messages) { message in
                                MiniChatBubble(message: message)
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
                .frame(maxHeight: 250) // Reduced height to show more form
                
                // Input area
                HStack(spacing: 12) {
                    TextField("Ask a question...", text: $inputText)
                        .textFieldStyle(.roundedBorder)
                        .disabled(isLoading)
                    
                    Button("Send") {
                        sendMessage()
                    }
                    .disabled(inputText.isEmpty || isLoading)
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .background(Color(.systemGroupedBackground))
            }
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
            .padding(.horizontal, 20)
            .padding(.top, 60) // Reduced top padding to show more form
            .padding(.bottom, 20) // Reduced bottom padding
        }
        .onAppear {
            if messages.isEmpty {
                let currentQuestion = currentStep < questions.count ? questions[currentStep] : nil
                let welcomeMessage = FormMessage(
                    id: UUID(),
                    role: .assistant,
                    content: generateContextualWelcomeMessage(currentQuestion: currentQuestion),
                    timestamp: Date()
                )
                messages.append(welcomeMessage)
            }
        }
    }
    
    private func sendMessage() {
        guard !inputText.isEmpty else { return }
        
        let userMessage = FormMessage(
            id: UUID(),
            role: .user,
            content: inputText,
            timestamp: Date()
        )
        messages.append(userMessage)
        
        let userInput = inputText
        inputText = ""
        isLoading = true
        
        // Simulate AI processing and auto-fill
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            
            // Analyze user input and auto-fill relevant fields
            let response = generateAIResponse(for: userInput)
            let aiMessage = FormMessage(
                id: UUID(),
                role: .assistant,
                content: response.message,
                timestamp: Date()
            )
            messages.append(aiMessage)
            
            // Auto-fill fields if detected
            for (field, value) in response.autoFilledFields {
                formData[field] = value
            }
        }
    }
    
    private func generateContextualWelcomeMessage(currentQuestion: FormQuestion?) -> String {
        if let question = currentQuestion {
            return "Hi! I can help you with the current field: '\(question.text)'. I can also help you with other form fields, gather required documents, or answer any questions about the \(template.name.lowercased()). What would you like assistance with?"
        } else {
            return "Hi! I can help you fill out your \(template.name.lowercased()). I can assist with form fields, gather required documents, or answer any questions. What would you like to know?"
        }
    }
    
    private func generateAIResponse(for input: String) -> (message: String, autoFilledFields: [String: String]) {
        let lowercasedInput = input.lowercased()
        var autoFilledFields: [String: String] = [:]
        var response = ""
        
        // Get current question context
        let currentQuestion = currentStep < questions.count ? questions[currentStep] : nil
        
        // Check if user is asking about current field
        if let question = currentQuestion {
            if lowercasedInput.contains("help") || lowercasedInput.contains("what") || lowercasedInput.contains("how") {
                response = generateFieldHelpMessage(for: question)
                return (response, autoFilledFields)
            }
        }
        
        // Check for document requirements
        if lowercasedInput.contains("document") || lowercasedInput.contains("required") || lowercasedInput.contains("need") {
            response = generateDocumentRequirementsMessage()
            return (response, autoFilledFields)
        }
        
        // Check for form completion status
        if lowercasedInput.contains("progress") || lowercasedInput.contains("complete") || lowercasedInput.contains("done") {
            response = generateProgressMessage()
            return (response, autoFilledFields)
        }
        
        // Simple keyword-based auto-fill logic
        if lowercasedInput.contains("name") || lowercasedInput.contains("full name") {
            if template.name.contains("DMV") {
                autoFilledFields["fullName"] = "John Doe"
                response = "I've filled in your name as 'John Doe'. You can edit it if needed."
            } else if template.name.contains("DS-160") {
                autoFilledFields["fullName"] = "John Doe"
                response = "I've filled in your full name as 'John Doe'. Please verify this is correct."
            }
        } else if lowercasedInput.contains("address") || lowercasedInput.contains("street") {
            autoFilledFields["address"] = "123 Main Street"
            autoFilledFields["city"] = "New York"
            autoFilledFields["state"] = "NY"
            autoFilledFields["zipCode"] = "10001"
            response = "I've filled in a sample address. Please update it with your actual address."
        } else if lowercasedInput.contains("phone") || lowercasedInput.contains("number") {
            autoFilledFields["phoneNumber"] = "(555) 123-4567"
            response = "I've filled in a sample phone number. Please replace it with your actual number."
        } else if lowercasedInput.contains("email") {
            autoFilledFields["email"] = "john.doe@example.com"
            response = "I've filled in a sample email address. Please update it with your actual email."
        } else if lowercasedInput.contains("date of birth") || lowercasedInput.contains("birthday") {
            autoFilledFields["dateOfBirth"] = "01/15/1990"
            response = "I've filled in a sample date of birth. Please update it with your actual date of birth."
        } else if lowercasedInput.contains("license") || lowercasedInput.contains("driver") {
            if template.name.contains("DMV") {
                autoFilledFields["licenseNumber"] = "DL123456789"
                response = "I've filled in a sample driver's license number. Please replace it with your actual license number."
            }
        } else if lowercasedInput.contains("passport") {
            if template.name.contains("DS-160") {
                autoFilledFields["passportNumber"] = "P123456789"
                response = "I've filled in a sample passport number. Please replace it with your actual passport number."
            }
        } else {
            response = "I can help you with the current field, fill out other form fields, gather required documents, or answer questions about the form. What would you like assistance with?"
        }
        
        return (response, autoFilledFields)
    }
    
    private func generateFieldHelpMessage(for question: FormQuestion) -> String {
        let fieldName = question.field.lowercased()
        
        if fieldName.contains("name") {
            return "For the name field, please provide your full legal name as it appears on your government-issued ID. Make sure to include your first, middle (if applicable), and last name."
        } else if fieldName.contains("address") {
            return "For the address field, please provide your current residential address. Include the street number, street name, apartment/unit number (if applicable), city, state, and ZIP code."
        } else if fieldName.contains("phone") {
            return "For the phone number field, please provide your primary contact number. Include the area code and ensure it's a number where you can be reached during business hours."
        } else if fieldName.contains("email") {
            return "For the email field, please provide a valid email address that you check regularly. This will be used for important communications about your application."
        } else if fieldName.contains("date") || fieldName.contains("birth") {
            return "For the date of birth field, please provide your birth date in MM/DD/YYYY format. Make sure this matches your government-issued identification."
        } else if fieldName.contains("license") {
            return "For the driver's license number field, please provide your current driver's license number exactly as it appears on your license card."
        } else if fieldName.contains("passport") {
            return "For the passport number field, please provide your passport number exactly as it appears on your passport. This is typically a 9-digit number."
        } else {
            return "For this field, please provide accurate and complete information. If you're unsure about any details, I can help you gather the required information or documents."
        }
    }
    
    private func generateDocumentRequirementsMessage() -> String {
        if template.name.contains("DMV") {
            return "For DMV License Renewal, you'll need:\n• Current driver's license\n• Proof of identity (birth certificate, passport)\n• Proof of residency (utility bill, lease agreement)\n• Payment method (credit card, check, or cash)\n• Vision test results (if required)\n• Medical certificate (if applicable)"
        } else if template.name.contains("DS-160") {
            return "For DS-160 Visa Application, you'll need:\n• Valid passport\n• Recent passport photo\n• Travel itinerary\n• Previous visa information (if applicable)\n• Employment/education history\n• Family information\n• Financial support documentation"
        } else {
            return "Required documents typically include:\n• Government-issued photo ID\n• Proof of address\n• Supporting documentation for specific fields\n• Payment method\n\nWould you like me to help you gather any specific documents?"
        }
    }
    
    private func generateProgressMessage() -> String {
        let totalQuestions = questions.count
        let completedQuestions = questions.enumerated().filter { index, question in
            !(formData[question.field] ?? "").isEmpty
        }.count
        let progressPercentage = totalQuestions > 0 ? Int((Double(completedQuestions) / Double(totalQuestions)) * 100) : 0
        
        return "You've completed \(completedQuestions) out of \(totalQuestions) fields (\(progressPercentage)%). You're currently on field \(currentStep + 1): '\(currentStep < questions.count ? questions[currentStep].text : "Unknown")'. Keep going!"
    }
}

struct MiniChatBubble: View {
    let message: FormMessage
    
    var body: some View {
        HStack {
            if message.role == .user {
                Spacer()
                Text(message.content)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            } else {
                Text(message.content)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray5))
                    .foregroundColor(.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}
