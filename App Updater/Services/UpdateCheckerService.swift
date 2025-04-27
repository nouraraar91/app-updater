//
//  UpdateCheckerService.swift
//  App Updater
//
//  Created by Nour Araar on 28/04/2025.
//

import Foundation

class UpdateCheckerService {
    
    func getAppsWithUpdates() -> (appStoreAppIds: [String], brewAppNames: [String]) {
        var appStoreAppIds: [String] = []
        var brewAppNames: [String] = []
        
        if ShellExecutor.isCommandAvailable("mas") {
            let masOutput = ShellExecutor.run("mas outdated")
            let masLines = masOutput.split(separator: "\n")
            for line in masLines {
                let components = line.split(separator: " ")
                if let appId = components.first {
                    appStoreAppIds.append(String(appId))
                }
            }
        }
        
        if ShellExecutor.isCommandAvailable("brew") {
            let brewOutput = ShellExecutor.run("brew outdated --cask")
            let brewLines = brewOutput.split(separator: "\n")
            for line in brewLines {
                let appName = line.trimmingCharacters(in: .whitespacesAndNewlines)
                if !appName.isEmpty {
                    brewAppNames.append(appName)
                }
            }
        }
        
        return (appStoreAppIds, brewAppNames)
    }
}
