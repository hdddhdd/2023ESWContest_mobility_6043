import { useEffect, useState } from 'react';
import { ref, get, child } from 'firebase/database';
import { realtimeDbService } from '../utils/firebase';
import ReactPlayer from 'react-player';

export default function VideoPage() {
  const [data, setData] = useState([]); // 데이터를 저장할 상태 변수

  useEffect(() => {
    const dbRef = ref(realtimeDbService);

    get(child(dbRef, 'mydata'))
      .then((snapshot) => {
        if (snapshot.exists()) {
          const newData = [];
          snapshot.forEach((childSnapshot) => {
            // 각 데이터 항목을 배열에 추가
            newData.push(childSnapshot.val());
          });
          setData(newData); // 데이터를 상태 변수에 저장
        } else {
          console.log('No data available');
        }
      })
      .catch((error) => {
        console.error(error);
      });
  }, []);

  return (
    <div>
      {data.length > 0 ? (
        // 데이터가 있는 경우 출력
        console.log(JSON.stringify(data, null, 4)),
        <div>
          {data.map((timeData, index) => (
            <div key={index}>
                {Object.keys(timeData).map((time, subIndex) => (
                    <div key={subIndex}>
                      <h3>{time}</h3>
                      <p>Date & Time: {timeData[time].date_time}</p>
                      <ReactPlayer
                        url={timeData[time].video_Url}
                        controls // 동영상 컨트롤러 표시
                        width="700px" // 동영상 너비 조절
                        height="500px" // 동영상 높이 자동 조절
                      />
                    </div>
                ))}
            </div>
          ))}
        </div>
      ) : (
        // 데이터가 없는 경우 출력
        <p>Loading...</p>
      )}
    </div>
  );
}
