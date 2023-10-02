import matplotlib.pyplot as plt
import matplotlib.patches as patches

def plot_boxes(crosswalk_box, person_boxes):
    # 입력 데이터를 그래프에 그리기
    fig, ax = plt.subplots(1)
    ax.set_aspect('equal')

    # crosswalk 그리기
    crosswalk_rect = patches.Rectangle((crosswalk_box[0], crosswalk_box[1]), crosswalk_box[2], crosswalk_box[3], linewidth=1, edgecolor='r', facecolor='none')
    ax.add_patch(crosswalk_rect)

    # person 그리기
    for person_box in person_boxes:
        person_rect = patches.Rectangle((person_box[0], person_box[1]), person_box[2], person_box[3], linewidth=1, edgecolor='b', facecolor='none')
        ax.add_patch(person_rect)

    # 그래프 표시
    plt.xlim(0, 50)  # x 범위 설정
    plt.ylim(0, 50)  # y 범위 설정
    plt.gca().invert_yaxis()  # y 축을 뒤집어서 상단이 위로 오도록 함
    plt.show()

# 임의의 입력 데이터 생성
input_data = {
    "crossWalk": [85.44, [10, 10, 20, 20]],
    "person": [89.44, [15, 15, 20, 20], 90.44, [30, 30, 15, 15], 85.44, [5, 5, 10, 10]]
}

crosswalk_box = input_data["crossWalk"][1]  # crosswalk의 bounding box 정보
person_boxes = input_data["person"][1::2]  # person들의 bounding box 정보를 리스트로 추출

# 입력 데이터와 계산한 IOU를 그래프로 표시
plot_boxes(crosswalk_box, person_boxes)

# IOU 계산 및 출력은 이전 코드와 동일하게 사용할 수 있습니다.
