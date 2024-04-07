//
//  Item.swift
//  BluetoothAlert
//
//  Created by Taewon Yoon on 4/7/24.
//

import Foundation
import SwiftUI
import BackgroundTasks

class BGADelegate: NSObject,  UIApplicationDelegate, ObservableObject {
    let taskIdentifier = "BluetoothAlert.BluetoothAlert"
    @AppStorage("backgroundtask") var tasks: Int = 0
    
    func application(_ applicatiown: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        register()
        scheduleAppRefresh()
        return true
    }

    func register() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: taskIdentifier, using: nil) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
            print("register")
        }
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: taskIdentifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15)
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
        scheduleAppRefresh()
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        DispatchQueue.main.async {
            self.tasks += 1
        }
        // Network request here
        task.setTaskCompleted(success: true)
        print("handle app refresh")
    }
    
}
