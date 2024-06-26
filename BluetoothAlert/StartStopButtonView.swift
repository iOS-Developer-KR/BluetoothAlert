//
//  StartStopButtonView.swift
//  BluetoothAlert
//
//  Created by Taewon Yoon on 4/8/24.
//

import SwiftUI

struct StartStopButtonView: View {
    @Environment(TimeManager.self) var timeManager
    
    var body: some View {
        HStack {
            Button(action: {
                timeManager.cancelTimer()
            }, label: {
                Text("취소")
                    .foregroundStyle(.white)
            })
            .buttonStyle(CustomButtonStyle(buttonColor: .gray))
            .padding()
            
            Spacer()
            
            Button(action: {
                    timeManager.pauseOrResumeTimer()
            }, label: {
                Text(timeManager.isStarted ? "중지" : "재시작")
                    .foregroundStyle(.white)
            })
            .buttonStyle(CustomButtonStyle(buttonColor: timeManager.isStarted ? .yellow : .green))
            .padding()
            
        }
    }
}

#Preview {
    StartStopButtonView()
        .environment(TimeManager())
}
