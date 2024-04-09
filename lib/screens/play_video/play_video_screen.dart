import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:viral_app/colors/theme_colors.dart';
import 'package:viral_app/screens/home_screen.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../provider/youtube_data_provider.dart';

class PlayVideoScreen extends StatefulWidget {
  final String videoId;
  final String title;

  const PlayVideoScreen({Key? key, required this.videoId, required this.title})
      : super(key: key);

  @override
  _PlayVideoScreenState createState() => _PlayVideoScreenState();
}

class _PlayVideoScreenState extends State<PlayVideoScreen> {
  late YoutubePlayerController _youtubeController;
  bool isFullScreen = false;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _youtubeController = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        hideControls: false,
        controlsVisibleAtStart: true,
        autoPlay: true,
        mute: false,
        isLive: false,
        hideThumbnail: false,
        disableDragSeek: false,
        enableCaption: false,
        loop: true,
        forceHD: false,
        startAt: 0,
      ),
    )..addListener(_videoPlayerListener);
  }

  void _videoPlayerListener() {
    if (_isPlayerReady) {
      setState(() {
        _youtubeController.value.playerState;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to the next page.
    _youtubeController.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: isFullScreen
            ? null
            : AppBar(
                title: Text(widget.title),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: IconButton(
                        onPressed: () {
                          final youtubeDataProvider =
                              Provider.of<YoutubeDataProvider>(context,
                                  listen: false);
                          youtubeDataProvider.setCategoryOpen(false);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const HomeScreen();
                              },
                              // Add this line to enable back button behavior:
                              fullscreenDialog: true,
                            ),
                          );
                        },
                        icon: const Icon(CupertinoIcons.home)),
                  ),
                ],
              ),
        body: OrientationBuilder(
          builder: (context, orientation) {
            return _buildPortraitBody();
          },
        ),
      ),
    );
  }

  YoutubePlayerBuilder _buildVideoPlayer() {
    return YoutubePlayerBuilder(
      onEnterFullScreen: () {
        setState(() {
          isFullScreen = true;
        });
      },
      onExitFullScreen: () {
        setState(() {
          isFullScreen = false;
        });
      },
      player: YoutubePlayer(
        aspectRatio: 16 / 9,
        controller: _youtubeController,
        showVideoProgressIndicator: true,
        onReady: () {
          _isPlayerReady = true;
        },
        onEnded: (data) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(data.title.toString())));
        },
        progressColors: const ProgressBarColors(
          playedColor: MyColors.primary,
          handleColor: MyColors.secondary,
        ),
      ),
      builder: (context, player) {
        return player;
      },
    );
  }

  Widget _buildPortraitBody() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: MyColors.primary.withOpacity(0.7),
                spreadRadius: 5,
                blurRadius: 10,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          padding: isFullScreen
              ? const EdgeInsets.all(0)
              : const EdgeInsets.only(bottom: 10),
          child: _buildVideoPlayer(),
        ),
        isFullScreen
            ? Container()
            : Expanded(
                child: Consumer<YoutubeDataProvider>(
                  builder: (context, yt, child) {
                    return yt.isLoaded
                        ? _buildVideoSuggestions(yt)
                        : const Center(
                            child: SleekCircularSlider(
                              appearance: CircularSliderAppearance(
                                spinnerMode: true,
                                size: 40,
                              ),
                            ),
                          );
                  },
                ),
              ),
      ],
    );
  }

  Widget _buildVideoSuggestions(YoutubeDataProvider yt) {
    return ListView.builder(
      itemCount: yt.videoDetails.length,
      itemBuilder: (context, index) {
        // Check if the current videoId matches widget.videoId
        if (yt.getVideoDetails[index]['videoId'] == widget.videoId) {
          // Skip this iteration if there's a match
          return Container();
        }

        // Assign videoData for the non-matching video
        var videoData = yt.getVideoDetails[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlayVideoScreen(
                    videoId: videoData['videoId'],
                    title: videoData['title'],
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: MyColors.whiteColor,
                borderRadius: BorderRadius.circular(6),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 2),
                    blurRadius: 40,
                    color: MyColors.secondary,
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      "https://i.ytimg.com/vi/${videoData['videoId']}/hqdefault.jpg",
                      fit: BoxFit.contain,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(videoData['title']),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
