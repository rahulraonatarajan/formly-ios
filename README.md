# Formly iOS Native Recipe

A fully native iOS version of Formly using Swift/SwiftUI with offline-first storage, on-device document processing, an on-device LLM as the recommended baseline for AI, and complete iCloud backup support. Includes DMV Driver License Renewal and DS-160 conversational form flows.

## Table of Contents
- [Project Goals and Scope](#project-goals-and-scope)
- [Architecture Overview](#architecture-overview)
- [Technology Stack](#technology-stack)
- [Project Setup](#project-setup)
- [Data and Storage](#data-and-storage)
- [AI Layer](#ai-layer)
- [Conversation-Driven Form System](#conversation-driven-form-system)
- [DMV License Renewal Flow](#dmv-license-renewal-flow)
- [DS-160 Flow](#ds-160-flow)
- [Document Scanning, OCR, and PDF Handling](#document-scanning-ocr-and-pdf-handling)
- [Accessibility and Localization](#accessibility-and-localization)
- [Security and Privacy](#security-and-privacy)
- [Backups and Restore](#backups-and-restore)
- [Build, Run, and Distribution](#build-run-and-distribution)
- [Testing Strategy](#testing-strategy)

## Project Goals and Scope
- Offline-first form-filling assistant for iOS
- Fully local storage for all user data
- iCloud backup and user-initiated export/restore
- Conversational, step-by-step completion of complex forms
- Support for DMV License Renewal and DS-160 templates
- On-device OCR for documents and photos
- On-device LLM as the default baseline for privacy-preserving AI; graceful fallback to rules + local RAG if device constraints require it

## Architecture Overview
- **UI**: SwiftUI app with MVVM
- **Data**: Core Data for structured entities; Files for binary assets
- **AI**: Pluggable providers with on-device LLM baseline (llama.cpp-metal/MLC) + Embeddings RAG + Rules engine fallback
- **Services**: Modular services (Form, DMV, DS-160, Document, AI, Backup)
- **Background Work**: BackgroundTasks for long-running indexing and backups

## Technology Stack
- **Language**: Swift 5.10+
- **UI**: SwiftUI, Combine/Observation
- **Data**: Core Data (SQLite-backed), FileManager
- **System Frameworks**: Vision, VisionKit, PDFKit, Photos, AVFoundation, BackgroundTasks, Metal
- **iCloud**: iCloud Documents/Drive via UIDocumentPicker and ubiquity containers
- **Notifications**: UserNotifications for reminders
- **Third-Party (recommended)**:
  - llama.cpp (Metal) or MLC LLM for on-device LLM inference
  - KeychainAccess (or own thin wrapper over Keychain)
  - ZIPFoundation (backup archives)
  - GRDB.swift (alternative to Core Data, optional)

## Project Setup

### 1) Create Xcode Project
- App template: iOS App, Swift, SwiftUI
- Bundle Identifier: com.formlyai.native
- Minimum iOS: 16.0+ (for VisionKit DataScanner), or 15.0 if you gate features

### 2) Capabilities and Entitlements
- iCloud: Enable iCloud with iCloud Documents; create ubiquity container (e.g., iCloud.com.formlyai.native)
- Background Modes: Background fetch/processing for indexing and backup
- Keychain Sharing: if needed for shared credentials
- App Sandbox default enabled

### 3) Info.plist Privacy Keys
- NSCameraUsageDescription
- NSPhotoLibraryUsageDescription
- NSMicrophoneUsageDescription (if voice input)
- NSSpeechRecognitionUsageDescription (if voice input)
- NSUserTrackingUsageDescription (not required unless ad frameworks)

### 4) Targets and Schemes
- Main app target "FormlyNative"
- UITests target for conversation flows

## Data and Storage
All data stays local by default. iCloud is used for user-initiated export/restore, and for Apple's automatic device backup of app data. Avoid storing large caches in iCloud by using the appropriate exclude-from-backup attributes.

### Core Data Model (Suggested Entities)
- **FormTemplate**
  - id (UUID), name, category, description, estimatedTime, difficulty
  - jsonSchema (Data) for structured fields/sections/logic
- **FormSession**
  - id (UUID), templateId, createdAt, updatedAt, status
  - progress (Double), state (Data for any dynamic state), answers (Data)
- **Conversation**
  - id (UUID), sessionId (UUID), createdAt, updatedAt
- **Message**
  - id (UUID), conversationId (UUID), role (user/ai/system), content (String), metadata (Data), createdAt
- **Document**
  - id (UUID), sessionId (UUID?), type (pdf/image), fileURL (String), textIndex (Data?), createdAt
- **Embedding**
  - id (UUID), ownerType (document/message), ownerId (UUID), vector (Data), dim (Int), createdAt

### File Storage Layout (in Application Support or Documents)
```
Documents/
  templates/ (bundled templates shipped in app bundle; copied to Documents on first run if needed)
  sessions/<sessionId>/
    documents/<uuid>.pdf|.jpg
    exports/<timestamp>.zip
  backups/
    formly-backup-YYYYMMDD-HHmm.zip
```

### iCloud
- Use UIDocumentPicker to export/import ZIP backups to iCloud Drive
- Optionally, write to ubiquity container for automatic sync of templates/minor preferences
- Exclude caches from backup with NSURLIsExcludedFromBackupKey

### Backup Strategy
- Periodic background backup task: create ZIP of Core Data store + Documents/sessions + templates
- Provide user-facing "Backup Now" and "Restore From Backup" actions
- Validate integrity before restore; support dry-run listing

## AI Layer (On-Device LLM Baseline + RAG)
Goal: Keep user data private while enabling assistive AI. Default to an on-device LLM; degrade gracefully on older devices.

### Providers (priority order)
1. **On-Device LLM (baseline)**:
   - Integrate a compact gguf model (1–3B) via llama.cpp with Metal or MLC LLM.
   - Ship a default model variant optimized for memory (int4/int8) and speed; select per-device at runtime.
   - Guardrails: context strictly limited to template schema, user answers, and retrieved chunks.
2. **Embeddings RAG**:
   - Core ML sentence embeddings; vectors stored as float32 BLOBs.
   - Cosine similarity for retrieval of prior answers and OCR text.
3. **Rules and Validation**:
   - Deterministic validators and conditional logic encoded in templates.

### Prompting Strategy
- Maintain strong system prompts per template to steer the on-device LLM.
- Strict toolformer-style outputs: compact JSON for updates and next step.
- Refuse to answer beyond provided context; ask clarifying questions when needed.

## Conversation-Driven Form System
Represent conversational flows as template artifacts so the engine is generic.

### Template JSON Contract (stored in bundle then copied into Core Data)
```json
{
  "metadata": {
    "id": "string",
    "name": "string",
    "version": "string",
    "languageSupport": ["en", "es", "fr"]
  },
  "schema": {
    "sections": [
      {
        "id": "string",
        "title": "string",
        "description": "string",
        "fields": [
          {
            "id": "string",
            "label": "string",
            "type": "string",
            "required": "boolean",
            "options": ["array"],
            "validation": "object",
            "aiPrompt": "string"
          }
        ]
      }
    ]
  },
  "conversationFlow": {
    "steps": [
      {
        "id": "string",
        "title": "string",
        "description": "string",
        "expectedFields": ["array"],
        "validationRules": ["array"],
        "conditionalLogic": ["array"]
      }
    ]
  },
  "review": {
    "checklists": ["array"],
    "submissionGuidance": "string",
    "feeInfo": "object"
  }
}
```

### Conversation Engine Responsibilities
- Maintain current step, pending fields, and context
- Generate next prompt (from `aiPrompt` and missing fields)
- Validate user answers (rules, regex, special validators like date/state)
- Persist after each user/AI turn
- Provide evidence trail for suggestions (RAG citations)

### UI Patterns
- Chat-style screen with messages (user/assistant/system)
- Progress header: percent complete and step list (optional disclosure)
- Inline validation feedback and quick fixes
- Review screen with final checklist before export

## DMV License Renewal Flow
### Scope
- State selection, identity details, address verification, eligibility (vision, suspensions), fees, and submission checklist

### Key Rules
- State-specific age, residency, REAL ID, eye test recency
- Name/address change triggers document requirements
- Fee estimation with add-ons (organ donor, veteran status)

### Templates
- Fields: fullName, dob, licenseNumber, state, address, organDonor, medicalConditions
- Steps: welcome → state → identity → address → eligibility → fees → review

### Data Sources
- Built-in `dmvStates.json` for per-state rules and URLs

### Outputs
- Completed renewal form PDF (pre-filled), checklist PDF, reminders for appointments

## DS-160 Flow
### Scope
- Personal info, travel, passport, security questions, work/education, family, photo requirements

### Key Rules
- Strict validation for names, dates, passport numbers, and address formats
- Conditional sections (e.g., previous travel history)

### Templates
- Steps: identity → travel → passport → security → employment/education → supporting docs → review

### Outputs
- JSON answers, pre-filled PDF, appointment reminders

## Document Scanning, OCR, and PDF Handling
- **Scanning**: VisionKit DataScannerViewController (iOS 16+) for documents and codes
- **OCR**: Vision VNRecognizeTextRequest; auto-language detection; layout-aware
- **PDFs**: PDFKit for viewing and creating filled forms and checklists
- **Image Processing**: Core Image for crop/contrast; ensure sandbox-friendly

## Accessibility and Localization
- VoiceOver labels and hints for all controls
- Dynamic Type and high-contrast themes
- Haptics for step transitions
- Localization: en + es + fr + de + hi + ar + zh; strings in Localizable.strings; templates tagged with i18n labels

## Security and Privacy
- All data local by default; no network calls required for core flows
- Keychain for small secrets and feature flags
- Exclude caches from iCloud backups where appropriate
- Provide a privacy dashboard: what data is stored and how to wipe/export

## Backups and Restore
- **Backup**: ZIP Core Data store (sqlite, -wal, -shm) + Documents/sessions + templates into Documents/backups
- **Export**: Present UIDocumentPicker to save to iCloud Drive or Files
- **Restore**: Let user pick ZIP; validate manifest; migrate store if schema changed
- **Automatic**: Optional periodic background backup (user-controlled)

## Build, Run, and Distribution
### Local Run
- Select "FormlyNative" scheme → iPhone 16 simulator → Run
- First launch seeds templates into Core Data

### App Icons and Branding
- Asset Catalog with multiples for light/dark

### Distribution
- Sign with Apple Developer account
- TestFlight for beta
- App Store with privacy nutrition labels stating local-only processing

## Testing Strategy
### Unit Tests
- Validators (name, date, passport, address)
- Conversation engine step transitions
- RAG retrieval and cosine similarity

### UI Tests
- DMV and DS-160 happy paths; error handling; resume session
- Backup and restore flows

### Performance
- Embedding generation latencies
- OCR throughput on common devices

## Full System Prompts (for On-Device LLM or Strict Assistant)

### System Prompt: Core Assistant (On-Device LLM)
```
You are Formly, an offline-first form-filling assistant running on-device. Follow these rules:
- Only use the provided schema, user answers, and retrieved context to propose updates.
- When you need to write output, respond as compact JSON with the shape:
  { "updates": [{"fieldId": string, "value": any}], "nextStepId": string, "notes": string[] }
- Validate all values against field types and constraints; if invalid, request a corrected value.
- Never include personal data not explicitly provided by the user.
- Operate entirely on-device. If a capability is unavailable, fall back to rules + RAG and ask concise clarifying questions.
```

### System Prompt: DMV Renewal
```
Context: DMV license renewal. Respect state-specific rules. Only ask for required fields.
Prioritize: accuracy, eligibility checks, and checklist completeness.
Output format: same compact JSON update object as Core Assistant.
```

### System Prompt: DS-160
```
Context: DS-160 nonimmigrant visa application. Follow strict formatting rules for names, addresses, dates, and passport data.
Ask only one focused question at a time, validate, then proceed.
Output format: same compact JSON update object as Core Assistant.
```

### User Prompt Template (runtime)
```
Template: ${template.name}
Step: ${step.title}
Missing fields: ${fieldsToCollect.map(f => f.label).join(", ")}
Known answers: ${shortSummary}
Relevant context: ${citations}
```

### Developer Prompt (tools)
```
If the user references a document, call OCR to extract text and propose field updates.
If ambiguous, ask a clarifying question before updating.
```

## Developer Tasks Checklist (High-Level)
- [ ] Define Core Data model and generate NSManagedObject subclasses
- [ ] Implement StorageService (Core Data CRUD + file management)
- [ ] Implement BackupService (ZIP export/import + iCloud document picker)
- [ ] Implement TemplateLoader (seed DMV + DS-160 templates)
- [ ] Implement ConversationEngine (state machine + validation + persistence)
- [ ] Implement RAGService (embeddings, cosine similarity)
- [ ] Wire OCR/Scan (Vision + VisionKit) and PDF export (PDFKit)
- [ ] Build SwiftUI screens: Home, Templates, Chat, Review, Settings, Backups
- [ ] Add Accessibility + Localization
- [ ] Add Unit and UI tests

---

This recipe serves as a blueprint to build a fully native iOS Formly app with strict local storage, iCloud backup, and privacy-preserving conversational assistance for DMV renewal and DS-160.
