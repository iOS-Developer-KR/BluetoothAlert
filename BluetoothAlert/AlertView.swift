//
//  AlertView.swift
//  BluetoothAlert
//
//  Created by Taewon Yoon on 4/8/24.
//

import SwiftUI


struct CustomButtonStyle: ButtonStyle {
    
    let buttonColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 55, height: 55)
            .background(buttonColor)
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
        
    }
}

struct AlertView: View {
    @Environment(TimeManager.self) var timeManager
    @State var pressed = false
    
    var body: some View {
        @Bindable var timer = timeManager
        ZStack {
            RadialGradient(gradient: Gradient(colors: [Color.purple, Color.accentColor]), center: .center, startRadius: 5, endRadius: 500)
                .ignoresSafeArea()
            VStack {
                HourMinutePickerView()
                
                if !timeManager.initalized {
                    Button(action: {
                        timeManager.initalize()
                    }, label: {
                        Text("시작")
                    })
                    .buttonStyle(CustomButtonStyle(buttonColor: .green))
                }
                
                if timeManager.initalized && timeManager.timeRemaining > 0 {
                    ElapsedTimeView()
                }
                
            }
        }
        .alert("알람", isPresented: $timer.showAlert) {
            Button("알람끄기") {
                timer.bluetooth.sendMessageToDevice("f")
            }
        }
        

    }
    

    
}

#Preview {
    AlertView()
        .environment(TimeManager())
}
