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
            await notification()
        }
    }
    
    func notification() async {
        bluetooth.sendMessageToDevice("o")
        let content = UNMutableNotificationContent()
        content.title = "블루투스 실행 완료"
        content.subtitle = "드가자"
        
        try? await UNUserNotificationCenter.current().add(UNNotificationRequest(identifier: "test", content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)))
    }
}

