
import { useState } from 'react';
import { BsFillBellSlashFill, BsFillBellFill } from 'react-icons/bs';
import "./ControlButton.css";

function ControlButton() {
  const [isCollisionTTSOn, setIsCollisionTTSOn] = useState(false); // 충돌감지 TTS 상태

  const handleCollisionTTSClick = () => {
    // 충돌감지 TTS 상태 토글
    if (isCollisionTTSOn) {
      alert('알림을 켭니다.');
      //서버로 버튼 값 넘겨서 음소거
      console.log("fetch");
      fetch("http://127.0.0.1:8080/player").then(
        // response 객체의 json() 이용하여 json 데이터를 객체로 변화
        res => res.json()
      ).then(
        // 데이터를 콘솔에 출력
        data => console.log(data)
      )
      console.log("fetch end");
    } else {
      alert('알림을 끕니다.');
      //서버로 버튼 값 넘겨서 다시 소리 들리게
      //서버로 버튼 값 넘겨서 음소거
      console.log("fetch");
      fetch("http://127.0.0.1:8080/player").then(
        // response 객체의 json() 이용하여 json 데이터를 객체로 변화
        res => res.json()
      ).then(
        // 데이터를 콘솔에 출력
        data => console.log(data)
      )
      console.log("fetch end");
    }
    setIsCollisionTTSOn(!isCollisionTTSOn);
  };

  return (
    <div className="App">
      <button className={`icon-button ${isCollisionTTSOn ? 'on-button' : 'off-button'}`} onClick={handleCollisionTTSClick}>
        {isCollisionTTSOn ? <BsFillBellSlashFill className="icon" /> : <BsFillBellFill className="icon" />} 알림
      </button>
    </div>
  );
}

export default ControlButton;