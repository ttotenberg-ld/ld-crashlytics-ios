//
//  ContentView.swift
//  CrashlyticsLaunchDarklyDemo
//
//  Created by Tom Totenberg on 3/19/25.
//

import SwiftUI
import FirebaseCrashlytics
import LaunchDarkly

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var customPropertyName = ""
    @State private var customPropertyValue = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Demo Actions")) {
                    // Basic logging button
                    Button(action: {
                        Crashlytics.log(message: "User tapped log button")
                        appState.trackAction("Log Button Tap")
                        showAlert(message: "Event logged to both systems")
                    }) {
                        HStack {
                            Image(systemName: "text.badge.checkmark")
                            Text("Log Event")
                        }
                    }
                    
                    // Non-fatal error button
                    Button(action: {
                        appState.recordError()
                        appState.trackAction("Record Error")
                        showAlert(message: "Non-fatal error recorded (#\(appState.errorCount))")
                    }) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle")
                            Text("Record Non-Fatal Error")
                        }
                    }
                    
                    // Breadcrumb button
                    Button(action: {
                        let timestamp = Date().timeIntervalSince1970
                        Crashlytics.leaveBreadcrumb("User left breadcrumb", metadata: ["timestamp": timestamp])
                        appState.trackAction("Leave Breadcrumb")
                        showAlert(message: "Breadcrumb recorded")
                    }) {
                        HStack {
                            Image(systemName: "arrow.triangle.branch")
                            Text("Leave Breadcrumb")
                        }
                    }
                    
                    // Crash button
                    Button(action: {
                        appState.trackAction("Force Crash")
                        // Small delay to ensure tracking completes
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            Crashlytics.forceCrash()
                        }
                    }) {
                        HStack {
                            Image(systemName: "burst")
                                .foregroundColor(.red)
                            Text("Force Crash")
                                .foregroundColor(.red)
                        }
                    }
                }
                
                Section(header: Text("Custom Properties")) {
                    TextField("Property Name", text: $customPropertyName)
                    TextField("Property Value", text: $customPropertyValue)
                    
                    Button(action: {
                        guard !customPropertyName.isEmpty, !customPropertyValue.isEmpty else {
                            showAlert(message: "Please enter both property name and value")
                            return
                        }
                        
                        Crashlytics.setCustomValue(customPropertyValue, forKey: customPropertyName)
                        appState.trackAction("Set Custom Property")
                        showAlert(message: "Custom property set: \(customPropertyName) = \(customPropertyValue)")
                        
                        // Clear fields
                        customPropertyName = ""
                        customPropertyValue = ""
                    }) {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text("Set Custom Property")
                        }
                    }
                }
                
                Section(header: Text("Status")) {
                    HStack {
                        Text("Last Action:")
                        Spacer()
                        Text(appState.lastAction)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Error Count:")
                        Spacer()
                        Text("\(appState.errorCount)")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Crashlytics + LaunchDarkly")
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Info"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
