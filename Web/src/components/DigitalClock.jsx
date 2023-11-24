import { useState, useEffect } from 'react';
import styled from 'styled-components';

export default function DigitalClock() {
  const [currentTime, setCurrentTime] = useState(new Date().toLocaleTimeString());

  useEffect(() => {
    const timerID = setInterval(() => {
      setCurrentTime(new Date().toLocaleTimeString());
    }, 1000);

    return () => clearInterval(timerID);
  }, []);

  return (
    <>
      <TimeText>{currentTime}</TimeText>
    </>
  );
}

const TimeText = styled.h1`
  margin: 0;
  padding: 0;
  box-sizing: border-box;
  width: 100%;
  text-align: center;
  font-size: 2.5rem;
  font-weight: bold;
  color: #000;
`;