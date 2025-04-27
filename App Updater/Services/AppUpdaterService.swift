//
//  AppUpdaterService.swift
//  App Updater
//
//  Created by Nour Araar on 28/04/2025.
//

import Foundation

class AppUpdaterService {
    
    func updateApp(_ app: InstalledApp) -> Bool {
        switch app.source {
        case .appStore:
            return updateAppStoreApp(app)
        case .homebrew:
            return updateHomebrewApp(app)
        case .manual:
            // Manual update not supported
            return false
        }
    }
    
    private func updateAppStoreApp(_ app: InstalledApp) -> Bool {
        guard let bundleId = app.bundleId else { return false }
        
        print("[Updating] App Store App: \(app.name)")
        
        // mas upgrade <bundleId>
        let output = ShellExecutor.run("mas upgrade \(bundleId)")
        return output.lowercased().contains("upgraded")
    }
    
    private func updateHomebrewApp(_ app: InstalledApp) -> Bool {
        let normalizedName = app.name.lowercased().replacingOccurrences(of: " ", with: "-")
        
        print("[Updating] Homebrew App: \(app.name)")
        
        // brew upgrade --cask <app>
        let output = ShellExecutor.run("brew upgrade --cask \(normalizedName)")
        return output.lowercased().contains("successfully installed")
    }
}
