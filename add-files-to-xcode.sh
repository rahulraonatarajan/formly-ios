#!/bin/bash

# Script to add missing files to Xcode project
echo "Adding missing files to Xcode project..."

# Add service files to the project
echo "Adding service files..."
xcodebuild -project FormlyNative.xcodeproj -target FormlyNative -add-file FormlyNative/Services/StorageService.swift
xcodebuild -project FormlyNative.xcodeproj -target FormlyNative -add-file FormlyNative/Services/AIService.swift
xcodebuild -project FormlyNative.xcodeproj -target FormlyNative -add-file FormlyNative/Services/BackupService.swift
xcodebuild -project FormlyNative.xcodeproj -target FormlyNative -add-file FormlyNative/Services/TemplateLoader.swift
xcodebuild -project FormlyNative.xcodeproj -target FormlyNative -add-file FormlyNative/Services/BackgroundTaskManager.swift

# Add template files to the project
echo "Adding template files..."
xcodebuild -project FormlyNative.xcodeproj -target FormlyNative -add-file FormlyNative/Resources/templates/dmv-renewal.json
xcodebuild -project FormlyNative.xcodeproj -target FormlyNative -add-file FormlyNative/Resources/templates/ds-160.json

echo "Files added successfully!"
echo "Now try building again in Xcode."
