#include <SoftwareSerial.h>
#include <ArduinoJson.h>

#define BT_RXD 4
#define BT_TXD 5
#define LED 13
#define BUTTON_PIN 2 // 버튼을 연결한 핀 번호

SoftwareSerial HM10(BT_RXD, BT_TXD);  // RX핀(4번)은 HM10의 TX에 연결
                                      // TX핀(5번)은 HM10의 RX에 연결  


void loop(){
  // Bluetooth 모듈에서 데이터를 읽어옴
  if (HM10.available()){       
    char h = (char)HM10.read();
    Serial.println(h);
    if(h == 'o'){                   // 알파벳 소문자 'o'를 입력하면
      digitalWrite(LED, HIGH);     // LED가 점등됨
    }
    if(h == 'f'){                   // 알파벳 소문자 'f'를 입력하면
      digitalWrite(LED, LOW);       // LED가 소등됨
    }
  }
}