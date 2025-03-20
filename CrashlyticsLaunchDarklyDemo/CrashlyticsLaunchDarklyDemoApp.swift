//
//  CrashlyticsLaunchDarklyDemoApp.swift
//  CrashlyticsLaunchDarklyDemo
//
//  Created by Tom Totenberg on 3/19/25.
//

import SwiftUI
import FirebaseCore
import FirebaseCrashlytics
import LaunchDarkly

@main
struct CrashlyticsLaunchDarklyDemoApp: App {
    @StateObject private var appState = AppState()
    
    init() {
        // Configure Firebase
        FirebaseApp.configure()
        
        // Configure LaunchDarkly
        let config = LDConfig(mobileKey: "mob-1af9289b-ae34-4fa4-9738-ef9ea58093be", autoEnvAttributes: .enabled)
        
        // Set up initial user
        let userKey = UIDevice.current.identifierForVendor?.uuidString ?? "unknown-user"
        let contextBuilder = LDContextBuilder(key: userKey)
        guard case .success(let context) = contextBuilder.build()
        else { return }
        
        // Initialize LaunchDarkly
        LDClient.start(config: config, context: context, startWaitSeconds: 5)

        
        // Synchronize user ID with Crashlytics
        Crashlytics.setUserID(userKey)
        
        // Set some initial custom values
        Crashlytics.setCustomValue("iOS Demo App", forKey: "app_type")
        Crashlytics.setCustomValue(UIDevice.current.systemVersion, forKey: "ios_version")
        
        // Log initialization
        Crashlytics.log(message: "App initialized", metadata: ["timestamp": Date().timeIntervalSince1970])
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}

// App state to share across views
class AppState: ObservableObject {
    @Published var lastAction: String = "None"
    @Published var errorCount: Int = 0
    
    func trackAction(_ action: String) {
        lastAction = action
        Crashlytics.trackUserAction(action)
    }
    
    func recordError() {
        errorCount += 1
        
        let error = NSError(
            domain: "com.example.CrashlyticsLaunchDarklyDemo",
            code: 100 + errorCount,
            userInfo: [
                NSLocalizedDescriptionKey: "Demo error #\(errorCount)",
                "error_source": "demo_button"
            ]
        )
        
        Crashlytics.recordError(error, metadata: [
            "count": errorCount,
            "timestamp": Date().timeIntervalSince1970
        ])
    }
}
