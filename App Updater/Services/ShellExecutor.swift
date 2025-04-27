//
//  ShellExecutor.swift
//  App Updater
//
//  Created by Nour Araar on 28/04/2025.
//

import Foundation

class ShellExecutor {
    @discardableResult
    static func run(_ command: String) -> String {
        let process = Process()
        let pipe = Pipe()
        
        process.standardOutput = pipe
        process.standardError = pipe
        process.arguments = ["-c", command]
        process.executableURL = URL(fileURLWithPath: "/bin/zsh") // use zsh
        
        do {
            try process.run()
        } catch {
            print("Failed to run command: \(command)")
            return ""
        }
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8) ?? ""
    }
}


extension ShellExecutor {
    static func isCommandAvailable(_ command: String) -> Bool {
        let whichOutput = run("which \(command)")
        return !whichOutput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
