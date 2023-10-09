import { useEffect, useState } from 'react';
import { ref, get, child } from 'firebase/database';
import { realtimeDbService } from '../utils/firebase';
import VideoPlayer from '../components/VideoPlayer';

export default function VideoPage() {
  const [data, setData] = useState([]); // 데이터를 저장할 상태 변수

  useEffect(() => {
    const dbRef = ref(realtimeDbService);

    get(child(dbRef, 'test'))
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
        <div>
          {data.map((item, index) => (
            <VideoPlayer key={index} videoUrl={item.image_url} />
          ))}
        </div>
      ) : (
        // 데이터가 없는 경우 출력
        <p>Loading...</p>
      )}
    </div>
  );
}
