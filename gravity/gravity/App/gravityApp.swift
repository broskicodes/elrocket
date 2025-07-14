//
//  gravityApp.swift
//  gravity
//
//  Created by Braeden Hall on 2025-07-10.
//

import SwiftUI

@main
struct gravityApp: App {
    @StateObject private var bleManager = BLEManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bleManager)
        }
    }
}
