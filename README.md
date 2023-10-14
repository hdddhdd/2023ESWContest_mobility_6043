# Team whycarno(6043)

### 🗂️ 파일 구조
```
.
├── AI
│   ├── best_100_ver12_s_batch16.pt
│   ├── detect.py
│   ├── export.py
│   ├── input.png
│   ├── models
│   │   ├── common.py
│   │   ├── experimental.py
│   │   └── yolo.py
│   │   └── custom_train.ipynb
│   ├── requirements.txt
│   └── utils
│       ├── IOU.py
│       ├── __init__.py
│       ├── augmentations.py
│       ├── autoanchor.py
│       ├── dataloaders.py
│       ├── downloads.py
│       ├── draw.py
│       ├── general.py
│       ├── metrics.py
│       ├── plots.py
│       └── torch_utils.py
└── README.md
```

### 🔎 cumstom dataset YOLO5 커스텀 학습 (roboflow dataset)
**1. AI/models/custom_train.ipynb 코드를 Colab에서 Open한다.**

**2. 세번째 셀에 자신의 Roboflow api_key를 입력하고, roboflow dataset을 export하여 코드를 복사/붙여넣기한다.**
<img width="650" alt="image" src="https://github.com/hdddhdd/whycarno_6043/assets/71762328/6080b031-62c3-4e57-9f65-438fc4a57803">

**3. 런타임 유형을 GPU로 변경한다.**

1) 학습이 완료되어 best.pt 모델이 완성된 화면
<img width="1084" alt="image" src="https://github.com/hdddhdd/whycarno_6043/assets/71762328/70789ab0-e193-41ff-b6eb-2a06c0ebf25c">


2) 6번째 셀에서 학습된 모델을 실제 이미지에 적용한 결과 (신호등, 차량, 사람 감지)
```
!python detect.py --weights /content/yolov5/runs/train/results/weights/best.pt --img 416 --conf 0.5 --source /content/yolov5/<테스트이미지 파일명>
```
<img width="453" alt="image" src="https://github.com/hdddhdd/whycarno_6043/assets/71762328/f164777f-22f6-4602-a93c-aeb3594f240f">



### 🚀 실행 방법
1. Git 클론 및 브랜치 변경
  ```bash
  git clone https://github.com/hdddhdd/whycarno_6043.git
  cd whycarno_6043
  git checkout AI
  cd AI
  ```

2. 개발 환경 세팅
  ```bash
  pip3 install -r requirements.txt
  ```

3. detect.py 실행
  ```bash
  python3 detect.py
  ```

### 📸 실행화면
**준비중 ...**
