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
        
        ZStack {
            RadialGradient(gradient: Gradient(colors: [Color.purple, Color.accentColor]), center: .center, startRadius: 5, endRadius: 500)
                .ignoresSafeArea()
            VStack {
                HourMinutePickerView()
                
                Button(action: {
                    timeManager.initalize()
                }, label: {
                    Text("시작")
                })
                .buttonStyle(CustomButtonStyle(buttonColor: .green))
                
                if timeManager.initalized && timeManager.timeRemaining > 0 {
                    ElapsedTimeView()
                }
                
            }

        }

    }
    

    
}

#Preview {
    AlertView()
        .environment(TimeManager())
}
