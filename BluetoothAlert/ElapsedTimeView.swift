//
//  ElapsedTimeView.swift
//  BluetoothAlert
//
//  Created by Taewon Yoon on 4/8/24.
//

import SwiftUI

struct ElapsedTimeView: View {
    @Environment(TimeManager.self) var timeManager
    @State var remainingTime = ""
    
    func updateTimeRemaining(time: Int) -> String {
        var time = timeManager.timeRemaining
        let hour = time / 3600
        time = time % 3600
        let minute = time / 60
        time = time % 60
        let second = time
        return "\(hour)시간 \(minute)분 \(second)초"
    }

    var body: some View {
        
        Text("\(updateTimeRemaining(time: timeManager.timeRemaining))")
            .font(Font.system(.largeTitle, design: .monospaced))
            
                
        StartStopButtonView()

        
    }
}

#Preview {
    ElapsedTimeView()
        .environment(TimeManager())
}
