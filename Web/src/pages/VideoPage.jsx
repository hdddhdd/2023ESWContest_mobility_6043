import { useEffect, useState } from 'react';
import { ref, get, child } from 'firebase/database';
import { realtimeDbService } from '../utils/firebase';
import { BsMap }from 'react-icons/bs';
import { Link } from 'react-router-dom';
import './VideoPage.css'; // CSS 모듈 가져오기

export default function VideoPage() {
  const [data, setData] = useState([]);

  useEffect(() => {
    const dbRef = ref(realtimeDbService);

    get(child(dbRef, 'accident'))
      .then((snapshot) => {
        if (snapshot.exists()) {
          const newData = [];
          // console.log(JSON.stringify(snapshot, null, 2));
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
                  {/* {console.log(typeof(timeData[time].video_url))} */}
                  {/* <ReactPlayer url={[timeData[time].date_time]} playing controls/> */}
                  <video 
                    controls 
                    autoPlay
                    src={timeData[time].video_url} />
                </div>
              ))}
            </div>
          ))}
          <Link to="/">
            <button className="homeButton">
              {<BsMap className="icon" />} 홈
            </button>
          </Link>
        </div>
      ) : (
        <p>Loading...</p>
      )}
    </div>
  );
}
