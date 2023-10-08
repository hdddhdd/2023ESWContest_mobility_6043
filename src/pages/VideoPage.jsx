import { useEffect, useState } from 'react';
import { ref, get, child } from 'firebase/database'; // Firebase Realtime Database 관련 import
import {realtimeDbService} from '../utils/firebase';
import VideoPlayer from '../components/VideoPlayer';

export default function VideoPage() {
  const [data, setData] = useState(null); // 데이터를 저장할 상태 변수

  const readOne = () => {
    const dbRef = ref(realtimeDbService);
    get(child(dbRef, '/test'))
      .then(snapshot => {
        if (snapshot.exists()) {
          setData(snapshot.val()); // 데이터를 상태 변수에 저장
        } else {
          console.log('No data available');
        }
      })
      .catch(error => {
        console.error(error);
      });
  };

  useEffect(() => {
    readOne(); // 페이지가 로딩될 때 함수 실행
  }, []);

  return (
    <div>
      {data ? (
        // 데이터가 있는 경우 출력
        <div>
          <VideoPlayer videoUrl = {data.image_url}/>
        </div>
      ) : (
        // 데이터가 없는 경우 출력
        <p>Loading...</p>
      )}
    </div>
  );
}