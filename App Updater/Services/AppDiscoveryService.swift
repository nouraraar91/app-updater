//
//  AppDiscoveryService.swift
//  App Updater
//
//  Created by Nour Araar on 28/04/2025.
//

import Foundation

class AppDiscoveryService {
    
    func discoverApps() -> [InstalledApp] {
        var apps: [InstalledApp] = []
        
        if ShellExecutor.isCommandAvailable("mas") {
            apps += discoverAppStoreApps()
        } else {
            print("[Warning] `mas` is not installed. App Store apps won't be listed.")
        }
        
        if ShellExecutor.isCommandAvailable("brew") {
            apps += discoverHomebrewApps()
        } else {
            print("[Warning] `brew` is not installed. Homebrew apps won't be listed.")
        }
        
        apps += discoverManualApps()
        
        return apps
    }
    
    private func discoverAppStoreApps() -> [InstalledApp] {
        let output = ShellExecutor.run("mas list")
        let lines = output.split(separator: "\n")
        var apps: [InstalledApp] = []
        
        for line in lines {
            // Example line: 497799835 Xcode (15.2)
            let components = line.split(separator: " ")
            guard components.count >= 3 else { continue }
            
            let appId = String(components[0])
            let nameAndVersion = components.dropFirst().joined(separator: " ")
            
            if let nameStart = nameAndVersion.firstIndex(of: "("),
               let nameEnd = nameAndVersion.firstIndex(of: ")") {
                let name = String(nameAndVersion[..<nameStart]).trimmingCharacters(in: .whitespaces)
                let version = String(nameAndVersion[nameStart...].dropFirst().dropLast())
                
                let app = InstalledApp(
                    id: UUID(),
                    name: name,
                    bundleId: appId,
                    version: version,
                    source: .appStore,
                    isUpdateAvailable: false
                )
                apps.append(app)
            }
        }
        
        return apps
    }
    
    private func discoverHomebrewApps() -> [InstalledApp] {
        let output = ShellExecutor.run("brew list --cask --versions")
        let lines = output.split(separator: "\n")
        var apps: [InstalledApp] = []
        
        for line in lines {
            // Example line: google-chrome 124.0.6367.91
            let components = line.split(separator: " ")
            guard components.count >= 2 else { continue }
            
            let name = components[0].replacingOccurrences(of: "-", with: " ").capitalized
            let version = String(components[1])
            
            let app = InstalledApp(
                id: UUID(),
                name: name,
                bundleId: nil,
                version: version,
                source: .homebrew,
                isUpdateAvailable: false
            )
            apps.append(app)
        }
        
        return apps
    }
    
    private func discoverManualApps() -> [InstalledApp] {
        let output = ShellExecutor.run("system_profiler SPApplicationsDataType -detailLevel mini")
        let apps = parseSystemProfilerOutput(output)
        return apps
    }
    
    private func parseSystemProfilerOutput(_ output: String) -> [InstalledApp] {
        var apps: [InstalledApp] = []
        
        let lines = output.split(separator: "\n")
        var currentAppName: String?
        var currentAppVersion: String?
        
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if trimmed.hasSuffix(":") {
                currentAppName = String(trimmed.dropLast())
            } else if trimmed.starts(with: "Version:") {
                currentAppVersion = trimmed.replacingOccurrences(of: "Version:", with: "").trimmingCharacters(in: .whitespaces)
            }
            
            if let name = currentAppName, let version = currentAppVersion {
                let app = InstalledApp(
                    id: UUID(),
                    name: name,
                    bundleId: nil,
                    version: version,
                    source: .manual,
                    isUpdateAvailable: false
                )
                apps.append(app)
                
                // Reset for next app
                currentAppName = nil
                currentAppVersion = nil
            }
        }
        
        return apps
    }
}
