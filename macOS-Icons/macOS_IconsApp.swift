//
//  macOS_IconsApp.swift
//  macOS-Icons
//
//  Created by Tim Schuchardt on 15.12.2024.
//

import SwiftUI

@main
struct macOS_IconsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        #if os(macOS)
        Settings {
            SettingsView()
        }
        #endif
    }
}
