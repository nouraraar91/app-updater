//
//  InstalledApp.swift
//  App Updater
//
//  Created by Nour Araar on 28/04/2025.
//

import Foundation

enum AppSource: String, Codable {
    case appStore = "App Store"
    case homebrew = "Homebrew"
    case manual = "Manual"
}

struct InstalledApp: Identifiable, Codable {
    let id: UUID
    let name: String
    let bundleId: String?
    let version: String
    let source: AppSource
    var isUpdateAvailable: Bool
}
