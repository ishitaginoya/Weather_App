//
//  Weather_AppApp.swift
//  Weather App
//
//  Created by Ishita Ginoya on 14/12/24.
//

import SwiftUI

@main
struct Weather_AppApp: App {
    @State private var networkMonitor = NetworkMonitor()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(networkMonitor)
        }
    }
}
