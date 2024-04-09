import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:viral_app/colors/theme_colors.dart';
import 'package:viral_app/constants/my_const.dart';
import 'package:viral_app/screens/play_video/play_video_screen.dart';
import 'package:http/http.dart' as http;

import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

class TrendsScreen extends StatefulWidget {
  const TrendsScreen({super.key});

  @override
  State<TrendsScreen> createState() => _TrendsScreenState();
}

class _TrendsScreenState extends State<TrendsScreen> {
  List<List<dynamic>> csvData = [];

  @override
  void initState() {
    super.initState();
    loadCSV();

    fetchVideos();
  }

  List<String> csvList = [];

  Future<void> loadCSV() async {
    final csvFile = await rootBundle.loadString('assets/data.csv');

    setState(() {
      csvList = csvData.map((row) => row.join(', ')).toList();
    });
    // debugPrint(csvList.toString());
  }

  Future<List<dynamic>> fetchVideos() async {
    final apiKey = MyConst.apiKey;
    final channelId = 'UCv5q-ZDNw-4AZgCkY1vgC1g';
    final url =
        'https://youtube.googleapis.com/youtube/v3/search?part=snippet&channelId=$channelId&maxResults=50&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      var v = data['items'];
      for (var i in v) {
        setState(() {
          // print(i['snippet']['title']);
        });
      }
      return data['items'];
    } else {
      throw Exception('Failed to fetch videos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        // final videoId = _ids[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              //   Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => PlayVideoScreen(videoId: videoId),
              //       ));
            },
            // Video Thumbnail
            child: Container(
              height: 300,
              decoration: const BoxDecoration(color: MyColors.background),
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text("Ok"),
            ),
          ),
        );
      },
    );
  }
}
