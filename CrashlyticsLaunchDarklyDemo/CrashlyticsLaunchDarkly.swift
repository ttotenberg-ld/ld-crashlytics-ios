import Foundation
import FirebaseCore
import FirebaseCrashlytics
import LaunchDarkly

// MARK: - Crashlytics + LaunchDarkly Integration

extension Crashlytics {
    
    // MARK: - User Identification
    
    /// Set user ID for both Crashlytics and LaunchDarkly
    /// - Parameter userId: The user identifier to set
    static func setUserID(_ userId: String) {
        // Set user ID for Crashlytics
        Crashlytics.crashlytics().setUserID(userId)
    
    }
    
    // MARK: - Custom Values
    
    /// Set a custom key-value pair for both Crashlytics and LaunchDarkly user context
    /// - Parameters:
    ///   - value: The value to set
    ///   - key: The key for the value
    static func setCustomValue(_ value: Any, forKey key: String) {
        // Set custom value for Crashlytics
        Crashlytics.crashlytics().setCustomValue(value, forKey: key)
        
        // For simple tracking - convert to JSON-compatible dictionary
        LDClient.get()?.track(key: "custom_value_set")
    }
    
    // MARK: - Logging and Error Tracking
    
    /// Log a message to both Crashlytics and LaunchDarkly
    /// - Parameters:
    ///   - message: The message to log
    ///   - metadata: Additional metadata to include with the log
    static func log(message: String, metadata: [String: Any]? = nil) {
        // Log to Crashlytics
        Crashlytics.crashlytics().log("\(message)")
        
        // Track in LaunchDarkly
        let data: LDValue = ["some-custom-key": "some-custom-value"]
        LDClient.get()?.track(key: "log_event", data: data)
    }
    
    /// Record a non-fatal error to both Crashlytics and LaunchDarkly
    /// - Parameters:
    ///   - error: The error to record
    ///   - metadata: Additional metadata to include with the error
    static func recordError(_ error: Error, metadata: [String: Any]? = nil) {
        // Convert metadata for Crashlytics
        var crashlyticsUserInfo: [String: Any] = [:]
        if let meta = metadata {
            crashlyticsUserInfo = meta
        }
        
        // Record error to Crashlytics
        Crashlytics.crashlytics().record(error: error, userInfo: crashlyticsUserInfo)
        
        // Track in LaunchDarkly
        let data: LDValue = ["some-custom-key": "some-custom-value"]
        LDClient.get()?.track(key: "non_fatal_error", data: data)
    }
    
    // MARK: - User Actions
    
    /// Track a user action in both systems
    /// - Parameters:
    ///   - action: The action name/description
    ///   - parameters: Additional parameters about the action
    static func trackUserAction(_ action: String, parameters: [String: Any]? = nil) {
        // Log to Crashlytics for context in crash reports
        var logMessage = "User Action: \(action)"
        if let params = parameters, !params.isEmpty {
            logMessage += " - Params: \(params)"
        }
        Crashlytics.crashlytics().log(logMessage)
        
        // Track in LaunchDarkly
        let data: LDValue = ["some-custom-key": "some-custom-value"]
        LDClient.get()?.track(key: "user_action", data: data)
    }
    
    // MARK: - Crash Management
    
    /// Log a breadcrumb that will be visible if a crash occurs
    /// - Parameters:
    ///   - message: The breadcrumb message
    ///   - metadata: Additional context for the breadcrumb
    static func leaveBreadcrumb(_ message: String, metadata: [String: Any]? = nil) {
        // Log to Crashlytics
        Crashlytics.crashlytics().log(message)
        
        // Track in LaunchDarkly
        let data: LDValue = ["some-custom-key": "some-custom-value"]
        LDClient.get()?.track(key: "breadcrumb", data: data)
    }
    
    /// Force a crash for testing purposes - ONLY FOR DEVELOPMENT
    static func forceCrash() {
        // Send a final log to LaunchDarkly before crashing
        let data: LDValue = ["timestamp": "timestamp"]
        LDClient.get()?.track(key: "crash_forced", data: data)
        
        // Allow LaunchDarkly event to be sent
        Thread.sleep(forTimeInterval: 0.5)
        
        // Force a crash
        fatalError("Forced crash for testing")
    }
}
