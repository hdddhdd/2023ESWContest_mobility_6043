import KakaoTraffic from "../components/KakaoTraffic.jsx";
import ControlButton from "../components/ControlButton.jsx";
import DigitalClock from "../components/DigitalClock.jsx";
import "./MainPage.css"; // CSS 파일을 import

export default function MainPage() {
    return (
        <div className="app-container">
            <div className="left-pane">
                <KakaoTraffic />
            </div>
            <div className="right-pane">
                <div className="top-right">
                <DigitalClock />
                </div>
                <div className="bottom-right">
                <ControlButton />
                </div>
            </div>
        </div>
    );
}
