//
//  AppListViewModel.swift
//  App Updater
//
//  Created by Nour Araar on 28/04/2025.
//

import Foundation
import Combine

class AppListViewModel: ObservableObject {
    @Published var apps: [InstalledApp] = []
    @Published var alertMessage: String? = nil
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var showUpdateAllConfirmation: Bool = false
    
    private let discoveryService = AppDiscoveryService()
    private let updateCheckerService = UpdateCheckerService()
    private let updaterService = AppUpdaterService()
    
    var filteredApps: [InstalledApp] {
        if searchText.isEmpty {
            return apps
        } else {
            return apps.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    func loadApps() {
        isLoading = true
        DispatchQueue.global(qos: .userInitiated).async {
            let discoveredApps = self.discoveryService.discoverApps()
            DispatchQueue.main.async {
                self.apps = discoveredApps
                self.updateAppsWithUpdateStatus()
                self.isLoading = false
            }
        }
    }
    
    private func updateAppsWithUpdateStatus() {
        let updates = updateCheckerService.getAppsWithUpdates()
        
        for index in apps.indices {
            let app = apps[index]
            switch app.source {
            case .appStore:
                if let bundleId = app.bundleId, updates.appStoreAppIds.contains(bundleId) {
                    apps[index].isUpdateAvailable = true
                }
            case .homebrew:
                let normalizedName = app.name.lowercased().replacingOccurrences(of: " ", with: "-")
                if updates.brewAppNames.contains(normalizedName) {
                    apps[index].isUpdateAvailable = true
                }
            case .manual:
                break
            }
        }
    }
    
    func updateApp(_ app: InstalledApp) {
        isLoading = true
        DispatchQueue.global(qos: .userInitiated).async {
            let success = self.updaterService.updateApp(app)
            DispatchQueue.main.async {
                self.isLoading = false
                if success {
                    self.alertMessage = "✅ Successfully updated \(app.name)"
                } else {
                    self.alertMessage = "❌ Failed to update \(app.name)"
                }
                self.loadApps()
            }
        }
    }
    
    func updateAllOutdatedApps() {
        showUpdateAllConfirmation = true
    }
    
    func performUpdateAll() {
        isLoading = true
        DispatchQueue.global(qos: .userInitiated).async {
            let outdatedApps = self.apps.filter { $0.isUpdateAvailable }
            guard !outdatedApps.isEmpty else {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.alertMessage = "✅ All apps are already up to date!"
                }
                return
            }
            
            for app in outdatedApps {
                _ = self.updaterService.updateApp(app)
            }
            
            DispatchQueue.main.async {
                self.isLoading = false
                self.alertMessage = "✅ Updated \(outdatedApps.count) app(s)!"
                self.loadApps()
            }
        }
    }
}
