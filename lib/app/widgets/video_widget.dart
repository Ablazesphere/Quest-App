import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:quest_server/app/widgets/shimmer_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  final bool play;
  final String url;

  const VideoWidget({Key? key, required this.url, required this.play})
      : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  double videoContainerRatio = 0.5;

  double getScale() {
    double videoRatio = videoPlayerController.value.aspectRatio;

    if (videoRatio < videoContainerRatio) {
      ///for tall videos, we just return the inverse of the controller aspect ratio
      return videoContainerRatio / videoRatio;
    } else {
      ///for wide videos, divide the video AR by the fixed container AR
      ///so that the video does not over scale

      return videoRatio / videoContainerRatio;
    }
  }

  late VideoPlayerController videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.url);

    _initializeVideoPlayerFuture = videoPlayerController.initialize().then((_) {
      //       Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {
        videoPlayerController.setVolume(0);
      });
    });
  } // This closing tag was missing

  @override
  void dispose() {
    videoPlayerController.dispose();
    //    widget.videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            aspectRatio: 0.67 / 1.19,
            child: Stack(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 0.67 / 1.19,
                  child: Chewie(
                    controller: ChewieController(
                      showControls: false,
                      videoPlayerController: videoPlayerController,
                      aspectRatio: videoPlayerController.value.aspectRatio,
                      // Prepare the video to be played and display the first frame
                      autoInitialize: true,
                      looping: true,
                      autoPlay: true,
                      // Errors can occur for example when trying to play a video
                      // from a non-existent URL
                      errorBuilder: (context, errorMessage) {
                        return Center(
                          child: Text(
                            errorMessage,
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: ShimmerEffect(height: 300, width: 160, rounded: false),
          );
        }
      },
    );
  }
}
