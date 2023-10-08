import ReactPlayer from 'react-player';

const VideoPlayer = (videoUrl) => {
  return (
    console.log(videoUrl),
    <div>
      <ReactPlayer
        url={videoUrl}
        controls // 동영상 컨트롤러 표시
        width="100%" // 동영상 너비 조절
        height="auto" // 동영상 높이 자동 조절
      />
    </div>
  );
};

export default VideoPlayer;