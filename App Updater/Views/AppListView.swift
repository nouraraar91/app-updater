//
//  AppListView.swift
//  App Updater
//
//  Created by Nour Araar on 28/04/2025.
//

import SwiftUI

import SwiftUI

struct AppListView: View {
    @StateObject private var viewModel = AppListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }
                
                // Search Bar
                TextField("Search apps...", text: $viewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding([.horizontal, .top])
                    .disabled(viewModel.isLoading)
                
                // Update All Button
                if viewModel.apps.contains(where: { $0.isUpdateAvailable }) && !viewModel.isLoading {
                    Button(action: {
                        viewModel.updateAllOutdatedApps()
                    }) {
                        Text("Update All Outdated Apps")
                            .bold()
                    }
                    .padding(.bottom, 8)
                }
                
                List(viewModel.filteredApps) { app in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(app.name)
                                .font(.headline)
                            Text("Version: \(app.version)")
                                .font(.subheadline)
                            Text("Source: \(app.source.rawValue)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        if app.isUpdateAvailable {
                            Button("Update") {
                                viewModel.updateApp(app)
                            }
                            .buttonStyle(.borderedProminent)
                        } else {
                            Text("Up to date")
                                .foregroundColor(.green)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .listStyle(.plain)
                .disabled(viewModel.isLoading)
            }
            .navigationTitle("Installed Apps")
            .toolbar {
                Button("Refresh") {
                    viewModel.loadApps()
                }
                .disabled(viewModel.isLoading)
            }
            .alert(item: $viewModel.alertMessage) { message in
                Alert(title: Text(message))
            }
            .confirmationDialog(
                "Are you sure you want to update all outdated apps?",
                isPresented: $viewModel.showUpdateAllConfirmation,
                titleVisibility: .visible
            ) {
                Button("Update All", role: .destructive) {
                    viewModel.performUpdateAll()
                }
                Button("Cancel", role: .cancel) {}
            }
        }
        .onAppear {
            viewModel.loadApps()
        }
    }
}

extension String: Identifiable {
    public var id: String { self }
}

#Preview {
    AppListView()
}
