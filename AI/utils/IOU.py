def calculate_iou(box1, box2):
    # box1, box2: [x, y, w, h] 형태의 bounding box 정보

    # 각 bounding box의 좌표 정보 추출
    x1, y1, w1, h1 = box1
    x2, y2, w2, h2 = box2

    # bounding box의 좌상단과 우하단 좌표 계산
    x1_min, y1_min, x1_max, y1_max = x1, y1, x1 + w1, y1 + h1
    x2_min, y2_min, x2_max, y2_max = x2, y2, x2 + w2, y2 + h2

    # 겹치는 영역의 좌상단과 우하단 좌표 계산
    x_intersection_min = max(x1_min, x2_min)
    y_intersection_min = max(y1_min, y2_min)
    x_intersection_max = min(x1_max, x2_max)
    y_intersection_max = min(y1_max, y2_max)

    # 겹치는 영역의 넓이 계산
    intersection_area = max(0, x_intersection_max - x_intersection_min) * max(0, y_intersection_max - y_intersection_min)

    # 각 bounding box의 넓이 계산
    area1 = w1 * h1
    area2 = w2 * h2

    # IOU 계산
    iou = intersection_area / (area1 + area2 - intersection_area)

    return iou

# 임의의 입력 데이터 생성
input_data = {
    "crossWalk": [85.44, [10, 10, 20, 20]],
    "person": [89.44, [15, 15, 20, 20], 90.44, [30, 30, 15, 15], 85.44, [5, 5, 10, 10]]
}

crosswalk_box = input_data["crossWalk"][1]  # crosswalk의 bounding box 정보
person_boxes = input_data["person"][1::2]  # person들의 bounding box 정보를 리스트로 추출

iou_list = []

# 모든 person과 crosswalk 간의 IOU 계산
for person_box in person_boxes:
    iou = calculate_iou(crosswalk_box, person_box)
    iou_list.append(iou)

print("IOU 리스트:", iou_list)
