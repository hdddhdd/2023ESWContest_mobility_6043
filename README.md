# Team whycarno(6043)

### 🗂️ 파일 구조
```
├── README.md
└── Sensor
    ├── MPU6050.py    # 자이로 센서(MPU-6050) 실행파일
    ├── Mp3Player.py  # 음성안내 실행파일
    └── SW420.py      # 충격감지 센서(SW-420) 실행파일
```

### 🪫 센서 회로도
    구성요소: Raspberry Pi 4, 자이로 센서(MPU-6050), 충격감지센서(SW-420), BreadBoard
    ![라즈베리파이4_회로도 jpg](https://github.com/hdddhdd/whycarno_6043/assets/131581393/a9123a8e-dd73-4c3a-adcd-fd38dbe30324)
    ![라즈베리파치4_스케메틱 ps](https://github.com/hdddhdd/whycarno_6043/assets/131581393/84999fe5-ddfa-4f05-ae01-c468e4ad5138)
    
### 💻 동작원리
    1. 자이로 센서(MPU-6050)
    ![mpu흐름도](https://github.com/hdddhdd/whycarno_6043/assets/131581393/dd7b2b6d-3b21-4695-b83c-944c2c3acbf3)

    2. 충격감지 센서(SW-420)
    ![SW흐름도 drawio](https://github.com/hdddhdd/whycarno_6043/assets/131581393/e9af15f5-80e0-44be-aba3-64ca354a1d66)
