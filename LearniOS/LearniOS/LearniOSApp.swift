//
//  LearniOSApp.swift
//  LearniOS
//
//  Created by Naresh on 28/12/23.
//

import SwiftUI

@main
struct LearniOSApp: App {
    @Environment(\.scenePhase) private var scenePhase
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: scenePhase) { newValue in
            if newValue == .active {
                print("WindowGroup updated to active state")
            }
            if newValue == .inactive {
                print("WindowGroup updated to inactive state")
            }
            if newValue == .background {
                print("WindowGroup updated to background state")
            }
        }
    }
}
