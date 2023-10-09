
import { useState } from 'react';
import { BsFillBellSlashFill, BsFillBellFill, BsFillCaretRightFill } from 'react-icons/bs';
import {Link} from 'react-router-dom';
import "./ControlButton.css";

function ControlButton() {
  const [isCollisionTTSOn, setIsCollisionTTSOn] = useState(false); // 충돌감지 TTS 상태

  const handleCollisionTTSClick = () => {
    // 충돌감지 TTS 상태 토글
    if (isCollisionTTSOn) {
      alert('알림을 켭니다.');
      //서버로 버튼 값 넘겨서 음소거
    } else {
      alert('알림을 끕니다.');
      //서버로 버튼 값 넘겨서 다시 소리 들리게
    }
    setIsCollisionTTSOn(!isCollisionTTSOn);
  };

  return (
    <div className="App">
      <Link to="/video">
        <button className="play-button">
          {<BsFillCaretRightFill className="icon" />} 영상
        </button>
      </Link>
      <button className={`icon-button ${isCollisionTTSOn ? 'on-button' : 'off-button'}`} onClick={handleCollisionTTSClick}>
        {isCollisionTTSOn ? <BsFillBellSlashFill className="icon" /> : <BsFillBellFill className="icon" />} 알림
      </button>
    </div>
  );
}

export default ControlButton;