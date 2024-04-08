//
//  BluetoothAlertApp.swift
//  BluetoothAlert
//
//  Created by Taewon Yoon on 4/7/24.
//

import SwiftUI
import BackgroundTasks

@main
struct BluetoothAlertApp: App {
    
    @State var timeManager: TimeManager = TimeManager()
    
    var body: some Scene {
        WindowGroup {
            AlertView()
                .environment(timeManager)
        }
    }
}

