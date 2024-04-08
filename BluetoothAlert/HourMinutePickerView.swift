//
//  HourMinutePickerView.swift
//  BluetoothAlert
//
//  Created by Taewon Yoon on 4/8/24.
//

import SwiftUI

struct HourMinutePickerView: View {
    @Environment(TimeManager.self) private var timeManager
    
    var body: some View {
        @Bindable var manager = timeManager
        HStack {
            VStack {
                
                Picker("시간",selection: $manager.hour) {
                    ForEach(0..<25) { value in
                        Text("\(value)시간")
                            .tag(value)
                    }
                }
                .pickerStyle(WheelPickerStyle())
            }
            VStack {
                Picker("시간",selection: $manager.minute) {
                    ForEach(0..<61) { value in
                        Text("\(value)분")
                            .tag(value)
                    }
                }
                .pickerStyle(WheelPickerStyle())
            }
            VStack {
                Picker("시간",selection: $manager.second) {
                    ForEach(0..<61) { value in
                        Text("\(value)초")
                            .tag(value)
                    }
                }
                .pickerStyle(WheelPickerStyle())
            }
        }
    }
}

#Preview {
    HourMinutePickerView()
        .environment(TimeManager())
}
