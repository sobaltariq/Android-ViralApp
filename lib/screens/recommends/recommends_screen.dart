import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:viral_app/provider/youtube_data_provider.dart';

import '../../colors/theme_colors.dart';
import '../../widgets/all_videos_list_widget.dart';

class RecommendsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> searchList;

  RecommendsScreen({Key? key, required this.searchList}) : super(key: key);

  @override
  State<RecommendsScreen> createState() => _RecommendsScreenState();
}

class _RecommendsScreenState extends State<RecommendsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final youtubeDataProvider =
          Provider.of<YoutubeDataProvider>(context, listen: false);

      if (youtubeDataProvider.getSearchOpen) {
        youtubeDataProvider.setIsSearchOpen(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<YoutubeDataProvider>(
      builder: (context, yt, child) {
        return RefreshIndicator(
          color: MyColors.highlight,
          onRefresh: () async {
            await yt.fetchVideos();
          },
          child: _buildContent(yt),
        );
      },
    );
  }

  Widget _buildContent(YoutubeDataProvider yt) {
    if (widget.searchList.isEmpty && yt.getSearchOpen) {
      return const Center(
        child: Text("Search Not Found"),
      );
    } else if (yt.isLoaded) {
      return AllVideoListWidget(
        getSearchOpen: yt.getSearchOpen,
        searchList: widget.searchList,
        getVideoDetails: yt.categoryOpen
            ? yt.getTemporaryVideosForCategory
            : yt.getVideoDetails,
        setIsSearchOpen: yt.setIsSearchOpen,
      );
    } else {
      return const Center(
        child: SleekCircularSlider(
          appearance: CircularSliderAppearance(
            spinnerMode: true,
            size: 40,
          ),
        ),
      );
    }
  }
}
