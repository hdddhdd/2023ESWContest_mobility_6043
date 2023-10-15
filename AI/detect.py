import argparse
import os
import platform
import sys
from pathlib import Path
from pprint import pprint
import torch

from MPU6050 import MPU
from utils.IOU import IOU
from utils.MP3Player import player

FILE = Path(__file__).resolve()
ROOT = FILE.parents[0]  # YOLOv5 root directory
if str(ROOT) not in sys.path:
    sys.path.append(str(ROOT))  # add ROOT to PATH
ROOT = Path(os.path.relpath(ROOT, Path.cwd()))  # relative

from ultralytics.utils.plotting import Annotator, colors, save_one_box

from models.common import DetectMultiBackend
from utils.dataloaders import IMG_FORMATS, VID_FORMATS, LoadImages, LoadScreenshots, LoadStreams
from utils.general import (LOGGER, Profile, check_file, check_img_size, check_imshow, cv2, increment_path, non_max_suppression, scale_boxes, xyxy2xywh)
from utils.torch_utils import select_device, smart_inference_mode


@smart_inference_mode()
def run(weights, source, data, imgsz, conf_thres, iou_thres, max_det, device, view_img, nosave, classes, agnostic_nms, augment, visualize, project, name, exist_ok, line_thickness, hide_labels, hide_conf, half, dnn, vid_stride):
    source = str(source)
    save_img = not nosave and not source.endswith('.txt')  # save inference images
    is_file = Path(source).suffix[1:] in (IMG_FORMATS + VID_FORMATS)
    is_url = source.lower().startswith(('rtsp://', 'rtmp://', 'http://', 'https://'))
    webcam = source.isnumeric() or source.endswith('.streams') or (is_url and not is_file)
    if is_url and is_file:
        source = check_file(source)  # download

    # Directories
    save_dir = increment_path(Path(project) / name, exist_ok=exist_ok)  # increment run
    save_dir.mkdir(parents=True, exist_ok=True)  # make dir

    # Load model
    device = select_device(device)
    model = DetectMultiBackend(weights, device=device, dnn=dnn, data=data, fp16=half)
    stride, names, pt = model.stride, model.names, model.pt
    imgsz = check_img_size(imgsz, s=stride)  # check image size

    # Dataloader
    bs = 1  # batch_size
    if webcam:
        view_img = check_imshow(warn=True)
        dataset = LoadStreams(source, img_size=imgsz, stride=stride, auto=pt, vid_stride=vid_stride)
        bs = len(dataset)
    else:
        dataset = LoadImages(source, img_size=imgsz, stride=stride, auto=pt, vid_stride=vid_stride)
    vid_path, vid_writer = [None] * bs, [None] * bs

    # Run inference
    model.warmup(imgsz=(1 if pt or model.triton else bs, 3, *imgsz))  # warmup
    seen, windows, dt = 0, [], (Profile(), Profile(), Profile())
    
    # 우회전 알고리즘 check point
    right_algo = True
    prev_dict = {}
    for path, im, im0s, vid_cap, s in dataset:
        with dt[0]:
            im = torch.from_numpy(im).to(model.device)
            im = im.half() if model.fp16 else im.float()  # uint8 to fp16/32
            im /= 255  # 0 - 255 to 0.0 - 1.0
            if len(im.shape) == 3:
                im = im[None]  # expand for batch dim

        # Inference
        with dt[1]:
            visualize = increment_path(save_dir / Path(path).stem, mkdir=True) if visualize else False
            pred = model(im, augment=augment, visualize=visualize)

        # NMS
        with dt[2]:
            pred = non_max_suppression(pred, conf_thres, iou_thres, classes, agnostic_nms, max_det=max_det)

        # Process predictions
        for i, det in enumerate(pred):  # per image
            pred_dict = {}
            seen += 1
            if webcam:  # batch_size >= 1
                p, im0, frame = path[i], im0s[i].copy(), dataset.count
                s += f'{i}: '
            else:
                p, im0, frame = path, im0s.copy(), getattr(dataset, 'frame', 0)

            p = Path(p)  # to Path
            # 나중에 필요할 수 있어서 일단 주석 처리
            save_path = str(save_dir / p.name)  # im.jpg
            
            s += '%gx%g ' % im.shape[2:]  # print string
            annotator = Annotator(im0, line_width=line_thickness, example=str(names))
            if len(det):
                # Rescale boxes from img_size to im0 size
                det[:, :4] = scale_boxes(im.shape[2:], det[:, :4], im0.shape).round()

                # Print results
                for c in det[:, 5].unique():
                    n = (det[:, 5] == c).sum()  # detections per class
                    s += f"{n} {names[int(c)]}{'s' * (n > 1)}, "  # add to string

                # Write results
                for *xyxy, conf, cls in reversed(det):
                    c = int(cls)  # integer class
                    label = names[c] if hide_conf else f'{names[c]}'
                    confidence = float(conf)
                    box = xyxy2xywh(torch.tensor(xyxy).view(1, 4)).view(-1).tolist()
                    if label not in pred_dict:
                        pred_dict[label] = [[round(confidence*100,2), box]]
                    else:
                        pred_dict[label].append([round(confidence*100,2), box])

                    if save_img or view_img:  # Add bbox to image
                        c = int(cls)  # integer class
                        label = None if hide_labels else (names[c] if hide_conf else f'{names[c]} {conf:.2f}')
                        annotator.box_label(xyxy, label, color=colors(c, True))
            print("********* RESULT *********")
            pprint(pred_dict)
            im0 = annotator.result()
            if view_img:
                if platform.system() == 'Linux' and p not in windows:
                    windows.append(p)
                    cv2.namedWindow(str(p), cv2.WINDOW_NORMAL | cv2.WINDOW_KEEPRATIO)  # allow window resize (Linux)
                    cv2.resizeWindow(str(p), im0.shape[1], im0.shape[0])
                cv2.imshow(str(p), im0)
                cv2.waitKey(1)  # 1 millisecond

            # 자이로 센서가 참일 경우에만 실행
            resultMPU, value = MPU()
            print(resultMPU, value)
            if resultMPU:
                if "c_r" in pred_dict:
                    print("빨간불입니다. 멈추세요.")
                    # TTS("빨간불입니다. 멈추세요.")
                elif "c_g" in pred_dict:
                    print("초록불입니다. 지나가세요.")
                    # TTS("초록불입니다. 지나가세요.")

                # check point 변환
                # 생각해야할 점 - 갑자기 P_G나 P_R이 인식 -> 객체인식 못하다가 인식되는 경우, 잠시 짤렸을 경우
                changed1 = "p_g" in prev_dict and "p_r" in pred_dict
                changed2 = "p_r" in prev_dict and "p_g" in pred_dict
                changed3 = "p_g" not in prev_dict and "p_g" in pred_dict
                changed4 = "p_r" not in prev_dict and "p_r" in pred_dict
                if changed1 or changed2 or changed3 or changed4 or not IOU(pred_dict):
                    right_algo = True
                # 우회전 알고리즘
                if right_algo:
                    # 1,2번 상황은 그냥 IOU값으로만 판단 가능
                    # 1. 사람 유 / 초록불 -> STOP
                    # 2. 사람 무 / 초록불 -> PASS
                    # 3. 사람 무 / 빨간불 -> PASS
                    # IOU가 0이면 사람이 없다는 뜻 -> True반한
                    if IOU(pred_dict) or ("p_r" in pred_dict):
                        print("지나가세요.")
                    else:
                        print("지나가세요.")
                    right_algo = False
            prev_dict = pred_dict.copy()

            # 나중에 필요할 수 있어서 일단 주석 처리
            # Save results (image with detections)
            if save_img:
                if dataset.mode == 'image':
                    cv2.imwrite(save_path, im0)
                else:  # 'video' or 'stream'
                    if vid_path[i] != save_path:  # new video
                        vid_path[i] = save_path
                        if isinstance(vid_writer[i], cv2.VideoWriter):
                            vid_writer[i].release()  # release previous video writer
                        if vid_cap:  # video
                            fps = vid_cap.get(cv2.CAP_PROP_FPS)
                            w = int(vid_cap.get(cv2.CAP_PROP_FRAME_WIDTH))
                            h = int(vid_cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
                        else:  # stream
                            fps, w, h = 30, im0.shape[1], im0.shape[0]
                        save_path = str(Path(save_path).with_suffix('.mp4'))  # force *.mp4 suffix on results videos
                        vid_writer[i] = cv2.VideoWriter(save_path, cv2.VideoWriter_fourcc(*'mp4v'), fps, (w, h))
                    vid_writer[i].write(im0)

def detection(model, input):
    args = argparse.Namespace(
        weights=model,
        source=input,
        data='coco128.yaml',
        # imgsz=(640, 640),
        imgsz=(320, 320),
        conf_thres=0.2,     # confidence threshold
        iou_thres=0.45,     # NMS IOU threshold
        # max_det=1000,
        max_det=50,         # 50개까지만 인식
        device='',
        view_img=False,
        nosave=False,
        classes=None,
        agnostic_nms=False,
        augment=False,
        visualize=False,
        project='runs/detect',
        name='exp',
        exist_ok=False,
        line_thickness=3,
        hide_labels=False,
        hide_conf=False,
        half=False,
        dnn=False,
        vid_stride=1
    )
    run(**vars(args))

if __name__ == '__main__':
    # detection("yolov5n.pt", "http://192.168.0.3:8080/video_feed")
    # detection("yolov5custom.pt", "input.png")
    # detection("best_100_ver12_s_batch16.pt", "http://192.168.0.5:8080/video_feed")
    detection("best_100_ver12_s_batch16.pt", "0")