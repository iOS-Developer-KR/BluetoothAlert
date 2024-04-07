//
//  Bluetooth.swift
//  BluetoothAlert
//
//  Created by Taewon Yoon on 4/7/24.
//

import CoreBluetooth
import SwiftUI

enum BluetoothError: Error {
    case DecodingError
}

@Observable class Bluetooth: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var peripherals: Set<CBPeripheral> = Set<CBPeripheral>()
    var values: String = .init()
    var connected = false
        
    weak var writeCharacteristic: CBCharacteristic? // 데이터를 주변기기에 보내기 위한 characcteristic을 저장하는 변수
    
    // 데이터를 주변기기에 보내는 type을 설정한다. withResponse는 데이터를 보내면 이에 대한 답장이 오는 경우, withoutResponse는 데이터를 보내도 답장이 오지 않는 경우
    private var writeType: CBCharacteristicWriteType = .withoutResponse
    
    var centralManager : CBCentralManager! // centralManager 객체 만들기
        
    var connectedPeripheral : CBPeripheral? // 연결된 아두이노 객체
    
    var serviceUUID = CBUUID(string: "FFE0") // 아래에 있는 128비트짜리 uuid를 사용하면 모듈을 못찾는다.
    
    //characteristicUUID는 serviceUUID에 포함되어 있다. 이를 이용하여 데이터를 송수신한다. FFE0 서비스가 갖고있는 FFE1로 설정한다.
    var characteristicUUID = CBUUID(string: "FFE1")
    
    public override init() {
        super.init()
        print("초기화")
        self.centralManager = CBCentralManager.init(delegate: self, queue: nil, options: nil) // 1. centralManager 객체를 초기화 시킨다.
    }
    // central manager를 만들때 central manager는 이 메서드를 부른다.
    // centralManagerDidUpdateState 함수는 delegate한테 central manager'의 상태가 변했다고 알려주는데
    // 아래와 같은 경우는 init()에서 centralManager가 CBCentralManager.init(...)을 실행시켜서 초기화 시킴으로 상태가 변했으므로 이 함수를 실행시킨다.
    // 저전력 블루투스가 지원되고 central 기기에서 쓰일수 있도록 반드시 구현해야한다.
    func centralManagerDidUpdateState(_ central: CBCentralManager) { // 1. 그리고 대리자를 세팅시켜라
        print("만들어졌다")
        switch central.state {
        case .unknown:
            print("unknown")
        case .resetting:
            print("resetting")
        case .unsupported:
            print("unsupported")
        case .unauthorized:
            print("unauthorized")
        case .poweredOff:
            print("powered off")
        case .poweredOn:
            print("powered on")
//            self.centralManager.scanForPeripherals(withServices: nil, options: nil)
            self.centralManager.scanForPeripherals(withServices: [serviceUUID])
        @unknown default:
            fatalError()
        }
        connectedPeripheral = nil
    }
    func startScan(){ // 2. 주변기기를 스캔
        guard centralManager.state == .poweredOn else {return}
        // [serviceUUID]만 갖고있는 기기만 검색
        print("주변기기 스캔시작")
        centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
    }
    func stopScan() {
        centralManager.stopScan()
    }
    
    // central manager가 peripheral를 발견할 때마다 delegate 객체의 메서드를 호출 // RSSI: 신호강도
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("발견")
        peripherals.insert(peripheral)
        centralManager.connect(peripheral)
    }
        
    // 기기가 연결되면 호출되는 delegate 메서드다.
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self // 5. 연결되면 주변기기 대리자 만들기
        connectedPeripheral = peripheral
        
        // peripheral의 Service들을 검색한다. 파라미터를 nil으로 설정하면 Peripheral의 모든 service를 검색한다.
        peripheral.discoverServices([serviceUUID])
        if peripheral.name == "YourNewName" {
            connected = true
        }
        print([serviceUUID])
        print("연결 성공")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if peripheral.name == "YourNewName" {
            connected = false
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            peripheral.discoverCharacteristics([characteristicUUID], for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics!{
            if characteristic.uuid == characteristicUUID {
                peripheral.setNotifyValue(true, for: characteristic) // 10. 구독한다.
                
                writeCharacteristic = characteristic // writeCharacteristic:  주변기기에 보내기 위한 특성을 저장하는 변수
                
                writeType = characteristic.properties.contains(.write) ? .withResponse : .withoutResponse // 9.
                
                connected = true
            }
        }
    }
    
    func sendMessageToDevice(_ message: String){ // -> Bool{
        // 만약 블루투스가 연결되지 않았다면 보내면 안된다.
        if connectedPeripheral?.state == .connected {
            if let data = message.data(using: String.Encoding.utf8), let charater = writeCharacteristic {
                connectedPeripheral!.writeValue(data, for: charater, type: writeType) // writeCharacteristic은 주변기기에 보내기 위한 특성
            }
        }
    }
    
}
