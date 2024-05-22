//
//  Timer.swift
//  BluetoothAlert
//
//  Created by Taewon Yoon on 4/8/24.
//

import Foundation
import SwiftUI
import Combine

@Observable 
class TimeManager {
    
    // used for communicate with HM10
    var bluetooth: Bluetooth = Bluetooth()
        
    // Set the initial time to 0 seconds
    var timeRemaining = 0

    // A boolean used to show an alert when the time runs out
    var showAlert = false

    // A boolean used to pause the timer
    var isStarted = false
        
    var initalized = false

    // Publisher from Combine used for the timer
    var timer: AnyCancellable?
    
    // set hour
    var hour: Int = 0
    
    // set minute
    var minute: Int = 0
    
    // set second
    var second: Int = 0
    
    
    func initalize() {
        if hour != 0 || minute != 0 || second != 0 {
            bluetooth.sendMessageToDevice("f")
            timeRemaining = (hour*3600) + (minute*60) + second
            startTimer()
        }
    }
    
    func startTimer() {
        isStarted = true
        initalized = true
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect().sink { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.showAlert = true
                self.isStarted = false
                self.initalized = false
                self.timer?.cancel()
                self.bluetooth.sendMessageToDevice("o")
            }
        }
    }

    func cancelTimer() {
        timer?.cancel()
        isStarted = false
        initalized = false
    }

    func pauseOrResumeTimer() {
        isStarted.toggle()
        if isStarted && timeRemaining > 0 {
            startTimer()
        } else {
            timer?.cancel()
        }
    }
}
