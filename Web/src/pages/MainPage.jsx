import KakaoTraffic from "../components/KakaoTraffic.jsx";
import ControlButton from "../components/ControlButton.jsx";
import DigitalClock from "../components/DigitalClock.jsx";
import VideoPage from "../components/VideoPage.jsx";
import styled from "styled-components";

export default function MainPage() {
    return (
        <Container>
            <MapContainer>
                <KakaoTraffic />
            </MapContainer>
            <LeftContainer>
                <InfoContainer>
                    <DigitalClock />
                    <ControlButton />
                </InfoContainer>
                <VideoPage />
            </LeftContainer>
        </Container>
    );
}

const Container = styled.div`
    padding: 10px;
    margin: 0;
    box-sizing: border-box;
    width: 100%;
    height: 98vh;
    display: flex;
    align-items: center;
    justify-content: center;
    position: relative;
    overflow: hidden;
`;

const MapContainer = styled.div`
    padding: 0;
    margin: 0;
    box-sizing: border-box;
    width: 50%;
    height: 95%;
    padding: 10px;
    position: relative;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.15);
    border-radius: 10px;
    overflow: hidden;
`;

const LeftContainer = styled.div`
    padding: 0;
    margin: 0;
    box-sizing: border-box;
    width: 50%;
    height: 95%;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    align-items: center;
`;

const InfoContainer = styled.div`
    padding: 0;
    margin: 0;
    box-sizing: border-box;
    width: 100%;
    display: flex;
    align-items: center;
    justify-content: space-around;
    align-items: center;
    padding: 0px 20px;
`;