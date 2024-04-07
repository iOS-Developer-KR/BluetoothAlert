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
    
    @State var bluetooth: Bluetooth = Bluetooth()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(bluetooth)
        }
        .backgroundTask(.appRefresh("BluetoothAlert.BluetoothAlert")) {
            notification()
        }
    }
    
    func notification() {
        bluetooth.sendMessageToDevice("o")
    }
}

