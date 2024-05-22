# BluetoothAlert

## 기능 설명
타이머를 설정하여 타이머가 완료되면 CoreBluetooth 프레임워크를 이용한 블루투스 통신으로 아두이노의 LED를 키는 코드입니다.

## 준비 과정
아두이노와 HM-10 블루투스 모듈을 준비합니다.


![RPReplay_Final1716390158](https://github.com/iOS-Developer-KR/BluetoothAlert/assets/155956734/7e5fb441-15a5-42c7-b738-bb2d8c659ba8)

## 블루투스 통신
### 블루투스 통신 준비

아두이노에 데이터를 전송할 수 있도록 블루투스 통신을 위한 인스턴스들을 만들어줍니다.
아두이노의 모듈마다 다르지만 HM-10 모듈은 FFE0 서비스 UUID와 FFE1 특성UUID를 갖기 때문에 아래처럼 설정합니다.
```swift

    weak var writeCharacteristic: CBCharacteristic? // 데이터를 주변기기에 보내기 위한 characcteristic을 저장하는 변수

    // 데이터를 주변기기에 보내는 type을 설정한다. withResponse는 데이터를 보내면 이에 대한 답장이 오는 경우, withoutResponse는 데이터를 보내도 답장이 오지 않는 경우
    private var writeType: CBCharacteristicWriteType = .withoutResponse
    
    var centralManager : CBCentralManager! // centralManager 객체 만들기
        
    var connectedPeripheral : CBPeripheral? // 연결된 아두이노 객체
    
    var serviceUUID = CBUUID(string: "FFE0") // 아래에 있는 128비트짜리 uuid를 사용하면 모듈을 못찾는다.
    
    //characteristicUUID는 serviceUUID에 포함되어 있다. 이를 이용하여 데이터를 송수신한다. FFE0 서비스가 갖고있는 FFE1로 설정한다.
    var characteristicUUID = CBUUID(string: "FFE1")
```

### 탐색 중 모듈을 찾았을 때
블루투스 탐색 중 모듈을 찾게 된다면 호출되는 콜백되는 delegate 메서드로 peripherals에 찾은 아두이노를 추가하고 connect 메서드를 이용하여 연결합니다.
```swift
// central manager가 peripheral를 발견할 때마다 delegate 객체의 메서드를 호출 // RSSI: 신호강도
func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    print("발견")
    peripherals.insert(peripheral)
    centralManager.connect(peripheral)
}
```

### 연결 후 데이터 전송
블루투스 연결 후 데이터를 전송하기 위한 코드입니다.
아두이노 코드에서 f 또는 o 를 이용하여 불을 키고 끔을 인식하므로 String.Encoding.utf8 으로 인코딩하여 데이터를 전송합니다.
```swift
func sendMessageToDevice(_ message: String){
    if connectedPeripheral?.state == .connected {
        if let data = message.data(using: String.Encoding.utf8), let charater = writeCharacteristic {
            connectedPeripheral!.writeValue(data, for: charater, type: writeType) // writeCharacteristic은 주변기기에 보내기 위한 특성
        }
    }
}
```

## 타이머
타이머는 Combine을 이용하여 구현하였습니다.

### 초기 설정
처음 타이머를 실행하게 될 때 아두이노의 LED를 꺼줍니다.
```swift
func initalize() {
    if hour != 0 || minute != 0 || second != 0 {
        bluetooth.sendMessageToDevice("f")
        timeRemaining = (hour*3600) + (minute*60) + second
        startTimer()
    }
}
```

### 타이머 시작
타이머가 시작되면 combine을 이용하여 1초마다 시간을 측정합니다.

```swift
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
```

### 타이머 종료
타이머가 종료되면 다음 타이머를 실행하기 위해 변수의 값들도 초기화 시킵니다.
```swift
func cancelTimer() {
    timer?.cancel()
    isStarted = false
    initalized = false
}
```

### 타이머 중지 및 재개
타이머 중지버튼을 누르게 된다면 실행되는 코드로 이미 중지된 상태라면 타이머를 재개합니다.
```swift
    func pauseOrResumeTimer() {
        isStarted.toggle()
        if isStarted && timeRemaining > 0 {
            startTimer()
        } else {
            timer?.cancel()
        }
    }
```
