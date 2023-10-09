import os
import time
import cv2
import datetime
import numpy as np
import firebase_admin
from uuid import uuid4
from pathlib import Path
from PIL import ImageFont, ImageDraw, Image
from firebase_admin import credentials, db, storage
from flask import Flask, render_template, Response
# 센서 모듈 불러오기
from MPU6050 import MPU
from SW420 import Crash_D 
from MP3Player import player


app = Flask(__name__)
capture = cv2.VideoCapture(0)
fourcc = cv2.VideoWriter_fourcc(*'H264')
capture.set(cv2.CAP_PROP_FRAME_WIDTH, 640)
capture.set(cv2.CAP_PROP_FRAME_HEIGHT, 480)
font = ImageFont.truetype('fonts/SCDream6.otf', 20)
# 전역 변수 설정
DB_name = ""
is_record = False
start_record = False
video = None
start_time = "" 
recording_time = 10

def database_init():
    try:
        app = firebase_admin.get_app()
    except ValueError as e:
        cred = credentials.Certificate("whycarno-firebase-firebase-adminsdk-e0i3x-cce4eba255.json")
        firebase_admin.initialize_app(cred, {
            "databaseURL": f"https://{cred.project_id}-default-rtdb.firebaseio.com/",
            "storageBucket": f"{cred.project_id}.appspot.com"
        })

def firebase_process(image_file_path, DB_name):
    folder_path, video_file_name = image_file_path.split('/')[0], image_file_path.split('/')[1]
    bucket = storage.bucket()
    new_token = uuid4()
    metadata = {"firebaseStorageDownloadTokens": new_token}
    blob = bucket.blob(video_file_name)
    blob.content_type = 'video/mov'
    blob.metadata = metadata
    blob.upload_from_filename(image_file_path)
    video_url = f"https://firebasestorage.googleapis.com/v0/b/{bucket.name}/o/{video_file_name}?alt=media&token={new_token}"
    
    update_data = {
        "date_time": datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
        "video_url": video_url  # 비디오 URL로 변경
    }
    idx = datetime.datetime.now().strftime("%H:%M:%S")
    dir = db.reference(f"accident/{DB_name}/{idx}")
    dir.update(update_data)
    ref = db.reference("accident")
    return ref.get()

def gen_frames():  
    database_init()
    global is_record, start_record, video, fourcc, DB_name
    # 현재 작업 디렉토리에 "result" 디렉토리가 없으면 생성
    directory = "result"
    if not os.path.exists(directory):
        os.makedirs(directory)
    video_name = f"{directory}/test.mov"  # 파일 경로로 설정
    # video_name = f"{directory}/accident.mp4"  # 파일 경로로 설정
    # video_name = str(Path(f'{directory}/accident').with_suffix(".mp4"))
    while True:
        now = datetime.datetime.now()
        nowDatetime = now.strftime('%Y-%m-%d %H:%M:%S')
        ref, frame = capture.read()
        if not ref:
            break
        else:
            frame = Image.fromarray(frame)    
            draw = ImageDraw.Draw(frame)
            draw.text(xy=(5, 10), text="웹캠 "+nowDatetime, font=font, fill=(255, 255, 255))
            frame = np.array(frame)
            ref, buffer = cv2.imencode('.jpg', frame)
            frame1 = frame
            frame = buffer.tobytes()
            # 자이로 센서 값 받아오기
            start_record, value = MPU()
            if start_record:
                if is_record == False:     # 녹화 시작
                    if os.path.exists(video_name):
                        os.remove(video_name)
                        print("REMOVED!!!")
                        time.sleep(2)
                    print("//////// Recording Start ////////", value)
                    player(False, "mp3/turn_right.mp3")
                    DB_name = datetime.datetime.now().strftime('%Y-%m-%d')
                    is_record = True
                    start_record = False
                    video = cv2.VideoWriter(video_name, fourcc, 15, (frame1.shape[1], frame1.shape[0]))
                else:      # 녹화 중
                    print("+++++++++ RECORDING!!! ++++++++++++", value)
                    if Crash_D():
                        print("***** CRASH!!!! *****")
                        player(False, "mp3/collision.mp3")
                        is_record = False
                        start_record = False
                        video.release()
                        result = firebase_process(video_name, DB_name)
                        print(result)
                        print("=== Recording Stop and DB upload Success ===")
                        # reuslt 파일 삭제
                        time.sleep(2)
                    else:
                        video.write(frame1)
            else:
                is_record = False
                print(start_record, value)
            yield (b'--frame\r\n' b'Content-Type: image/jpeg\r\n\r\n' + frame + b'\r\n')


@app.route('/')
def index():
    global is_record
    return render_template('index.html', is_record=is_record)

@app.route('/video_feed')
def video_feed():
    return Response(gen_frames(), mimetype='multipart/x-mixed-replace; boundary=frame')

if __name__ == "__main__":
    # app.run(debug=True)
    app.run(host="192.168.0.5", port="8080")
