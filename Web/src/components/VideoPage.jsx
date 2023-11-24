import { useEffect, useState } from 'react';
import { ref, get, child } from 'firebase/database';
import { realtimeDbService } from '../utils/firebase';
import styled from 'styled-components';

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
    <>
      {data.length > 0 ? (
        <DBContainer>
          {data.map((timeData, index) => (
            <VideoContainer key={index}>
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
            </VideoContainer>
          ))}
        </DBContainer>
      ) : (
        <p>Loading...</p>
      )}
    </>
  );
}

const DBContainer = styled.div`
  margin-top: 10px;
  width: 90%;
  height: 100%; // 높이를 100%로 변경
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  overflow-y: scroll; // scroll 대신 auto로 변경
  border-radius: 10px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.15);
  border: 10px solid #fff;
`;

const VideoContainer = styled.div`
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  .object-contianer {
    width: 100%;
    height: 100%;
    display: flex;
    flex-direction: column;
    align-items: center;
  }
`;