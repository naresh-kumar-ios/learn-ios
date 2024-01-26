//
//  ContentView.swift
//  LearniOS
//
//  Created by Naresh on 28/12/23.
//

import SwiftUI
import Combine

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    var body: some View {
        Text("Hello welcome to SwiftUI")
        .onChange(of: scenePhase) { newValue in
            if newValue == .active {
                print("ContentView updated to active state")
            }
            if newValue == .inactive {
                print("ContentView updated to inactive state")
            }
            if newValue == .background {
                print("ContentView updated to background state")
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in
            print("willTerminateNotification notification recived")
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
            print("didEnterBackgroundNotification notification recived")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
