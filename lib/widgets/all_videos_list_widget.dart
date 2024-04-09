import 'package:flutter/material.dart';

import '../colors/theme_colors.dart';
import '../screens/play_video/play_video_screen.dart';

class AllVideoListWidget extends StatefulWidget {
  bool getSearchOpen;
  var searchList;
  var getVideoDetails;
  var setIsSearchOpen;

  AllVideoListWidget({
    super.key,
    required this.getSearchOpen,
    required this.searchList,
    required this.getVideoDetails,
    required this.setIsSearchOpen,
  });

  @override
  State<AllVideoListWidget> createState() => _AllVideoListWidgetState();
}

class _AllVideoListWidgetState extends State<AllVideoListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.getSearchOpen
          ? widget.searchList.length
          : widget.getVideoDetails.length,
      itemBuilder: (context, index) {
        final videoData = widget.getSearchOpen
            ? widget.searchList[index]
            : widget.getVideoDetails[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
          child: InkWell(
            onTap: () {
              // yt.setIsSearchOpen(false);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlayVideoScreen(
                      videoId: videoData['videoId'],
                      title: videoData['title'],
                    ),
                  ));
            },
            // Video Thumbnail
            child: Container(
              decoration: BoxDecoration(
                color: MyColors.whiteColor,
                borderRadius: BorderRadius.circular(6),
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(0, 2),
                      blurRadius: 40,
                      color: MyColors.secondary)
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
