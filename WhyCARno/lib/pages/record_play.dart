import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class RecordPlayPage extends StatefulWidget {
  final String videoUrl;

  const RecordPlayPage({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _RecordPlayPageState createState() => _RecordPlayPageState();
}

class _RecordPlayPageState extends State<RecordPlayPage> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);

    //영상 상태가 변경되는거 감지하기!
    _controller.addListener(() {
      setState(() {
        _showControls =
            !_controller.value.isPlaying || _controller.value.isBuffering;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "녹화된 영상 확인",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black), // 뒤로가기 버튼 색상 설정

      ),
      body: GestureDetector(
        onTap: () {
          //화면이 터치되면 영상 다시 재생 + 아이콘 띄우기
          if (_controller.value.isPlaying) {
            _controller.pause();
          } else {
            _controller.play();
          }
        },
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: Duration(milliseconds: 500),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (_controller.value.isPlaying) {
                        _controller.pause();
                      } else {
                        _controller.play();
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(), backgroundColor: Colors.transparent,
                    padding: EdgeInsets.all(16), 
                    minimumSize: Size(64, 64), 
                  ),
                  child: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
