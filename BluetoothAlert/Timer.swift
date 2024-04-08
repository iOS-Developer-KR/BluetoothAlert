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
    
    // Set the initial time to 60 seconds
    var timeRemaining = 60

    // A boolean used to show an alert when the time runs out
    var showAlert = false

    // A boolean used to pause the timer
    var isStarted = false
    
    var isPaused = false
    
    var initalized = false

    // Publisher from Combine used for the timer
    var timer: AnyCancellable?

    // An integer bounded to our picker
    var selectedDuration = 60

    // An array of integers allowing the timer to be set from 20-100 seconds
    let durationRange = Array(20...100)
    
    var currentState = "시작"
    
    var hour: Int = 0
    
    var minute: Int = 0
    
    var second: Int = 0
    
    var textTimeRemaining = ""
    
    func initalize() {
        timeRemaining = (hour*3600) + (minute*60) + second
        initalized = true
        isStarted = true
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect().sink { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.showAlert = true
                self.isStarted = false
                self.timer?.cancel()
            }
        }
    }
    
    // 1.
    func startTimer() {
        initalized = true
        isStarted = true
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect().sink { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.showAlert = true
                self.isStarted = false
                self.timer?.cancel()
            }
        }
    }

    // 2.
    func cancelTimer() {
        timer?.cancel()
        isStarted = false
        timeRemaining = selectedDuration
    }

    // 3.
    func pauseOrResumeTimer() {
        isStarted.toggle()
        if isStarted && timeRemaining > 0 {
            startTimer()
        } else {
            timer?.cancel()
        }
    }

    // 4.
    func resetTimer() {
        timeRemaining = selectedDuration
        isStarted = false
    }
}


let dateformat: DateFormatter = {
      let formatter = DateFormatter()
       formatter.dateFormat = "HH:mm:ss"
       return formatter
}()
