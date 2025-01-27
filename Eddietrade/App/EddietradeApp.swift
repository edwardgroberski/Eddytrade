//
//  EddietradeApp.swift
//  Eddietrade
//
//  Created by Edward Groberski on 1/24/25.
//

import SwiftUI
import XCTestDynamicOverlay
import Dependencies

@main
struct EddietradeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Dependency(\.authManager) var authManager
    
    var body: some Scene {
        WindowGroup {
            // Prevent root view from running during tests
            if !_XCTIsTesting {
                if (authManager.isAuthenticated) {
                    WatchlistsView()
                } else {
                    LoginView()
                }
            }
        }
    }
}
