import os
import cv2
import datetime
import numpy as np
import firebase_admin
from uuid import uuid4
from PIL import ImageFont, ImageDraw, Image
from firebase_admin import credentials, db, storage
from flask import Flask, render_template, Response, url_for, redirect

app = Flask(__name__)
capture = cv2.VideoCapture(0)
fourcc = cv2.VideoWriter_fourcc(*'mp4v')
capture.set(cv2.CAP_PROP_FRAME_WIDTH, 640)
capture.set(cv2.CAP_PROP_FRAME_HEIGHT, 480)
font = ImageFont.truetype('fonts/SCDream6.otf', 20)
# 전역 변수 설정
is_record = False
start_record = False
video = None
start_time = ""
recording_time = 10

def database_init():
    try:
        app = firebase_admin.get_app()
    except ValueError as e:
        cred = credentials.Certificate("privateKey.json")
        firebase_admin.initialize_app(cred, {
            "databaseURL": f"https://{cred.project_id}-default-rtdb.firebaseio.com/",
            "storageBucket": f"{cred.project_id}.appspot.com"
        })

def firebase_process(image_file_path):
    folder_path, image_file_name = image_file_path.split('/')[0], image_file_path.split('/')[1]
    bucket = storage.bucket()
    new_token = uuid4()
    metadata = {"firebaseStorageDownloadTokens": new_token}
    blob = bucket.blob(image_file_path)
    blob.content_type = 'video/mp4'
    blob.metadata = metadata
    blob.upload_from_filename(image_file_path)
    update_data = {
        "date_time": datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
        "image_url": f"https://firebasestorage.googleapis.com/v0/b/{bucket.name}/o/{folder_path}%2F{image_file_name}?alt=media&token={new_token}"
    }
    dir = db.reference("test")
    dir.update(update_data)
    ref = db.reference("test")
    return ref.get()

def gen_frames():  
    database_init()
    global is_record, start_record, video
    # 현재 작업 디렉토리에 "result" 디렉토리가 없으면 생성
    directory = "result"
    if not os.path.exists(directory):
        os.makedirs(directory)

    video_name = f"{directory}/accident.mp4"  # 파일 경로로 설정
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
            if start_record == True and is_record == False:
                is_record = True
                start_record = False
                fourcc = cv2.VideoWriter_fourcc(*'mp4v')
                video = cv2.VideoWriter(video_name, fourcc, 15, (frame1.shape[1], frame1.shape[0]))
            elif start_record and is_record == True:
                is_record = False
                start_record = False
                # result = firebase_process(video_name)
                # print(result)
                video.release()
            if is_record == True:
                nowDatetime = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
                if nowDatetime[-2:] == str(int(start_time[-2:]) + recording_time):
                    print(f"***** {recording_time}초 지났습니다. *****")
                    print(start_time)
                    print(nowDatetime)
                    start_record = True
                video.write(frame1)
            yield (b'--frame\r\n' b'Content-Type: image/jpeg\r\n\r\n' + frame + b'\r\n')


@app.route('/')
def index():
    global is_record
    return render_template('index.html', is_record=is_record)

@app.route('/video_feed')
def video_feed():
    return Response(gen_frames(), mimetype='multipart/x-mixed-replace; boundary=frame')

@app.route('/push_record')
def push_record():
    global start_record
    start_record = not start_record
    global start_time
    start_time = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    return redirect(url_for('index'))

if __name__ == "__main__":
    app.run(debug=True)
    # app.run(host="192.168.0.19", port="8080")