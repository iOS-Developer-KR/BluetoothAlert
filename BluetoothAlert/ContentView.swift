//
//  ContentView.swift
//  BluetoothAlert
//
//  Created by Taewon Yoon on 4/7/24.
//

import SwiftUI
import BackgroundTasks

struct ContentView: View {
    
    @Environment(Bluetooth.self) var bluetooth
    
    func scheduleAppRefresh() {

        let request = BGAppRefreshTaskRequest(identifier: "BluetoothAlert.BluetoothAlert")
        request.earliestBeginDate = Calendar.current.date(byAdding: .second, value: 5, to: Date())
        do {
            try BGTaskScheduler.shared.submit(request)
            print("Background Task Scheduled!")
        } catch(let error) {
            print("Scheduling Error \(error.localizedDescription)")
        }
        
    }
    
    
    var body: some View {
        Text("블루투스 알람 앱을 만들어보자")
            .padding(50)
        
        Button {
            scheduleAppRefresh()
        } label: {
            Text("백그라운드로 불 켜기")
        }
        .padding(40)
        
        
        Button(action: {
            bluetooth.sendMessageToDevice("o")
        }, label: {
            Text("불켜기")
        })
        
        Button(action: {
            bluetooth.sendMessageToDevice("f")
        }, label: {
            Text("불끄기")
        })
        
        List(bluetooth.peripherals.sorted(by: { $0.name ?? "" < $1.name ?? "" }), id: \.self) { ph in
            Button {
                print("연결")
                bluetooth.centralManager.connect(ph)
            } label: {
                Text(ph.name ?? "Unknown Device")
            }
        }

    }
    
}

#Preview {
    ContentView()
        .environment(Bluetooth())
}


