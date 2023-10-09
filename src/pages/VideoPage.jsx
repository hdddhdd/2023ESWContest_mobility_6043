import { useEffect, useState } from 'react';
import { ref, get, child } from 'firebase/database';
import { realtimeDbService } from '../utils/firebase';
import ReactPlayer from 'react-player';
import './VideoPage.css'; // CSS 모듈 가져오기

export default function VideoPage() {
  const [data, setData] = useState([]);

  useEffect(() => {
    const dbRef = ref(realtimeDbService);

    get(child(dbRef, 'mydata'))
      .then((snapshot) => {
        if (snapshot.exists()) {
          const newData = [];
          snapshot.forEach((childSnapshot) => {
            newData.push(childSnapshot.val());
          });
          setData(newData);
        } else {
          console.log('No data available');
        }
      })
      .catch((error) => {
        console.error(error);
      });
  }, []);

  return (
    <div className='DB-container'>
      {data.length > 0 ? (
        <div>
          {data.map((timeData, index) => (
            <div key={index} className='video-container'>
              {Object.keys(timeData).map((time, subIndex) => (
                <div key={subIndex} className='object-contianer'>
                  <p>Date : {timeData[time].date_time}</p>
                  <ReactPlayer
                    url={timeData[time].video_Url}
                    controls
                    className="video"
                  />
                </div>
              ))}
            </div>
          ))}
        </div>
      ) : (
        <p>Loading...</p>
      )}
    </div>
  );
}
