import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants/my_const.dart';

class YoutubeDataProvider extends ChangeNotifier {
  String _youtubeSearch = "";
  bool _isSearchOpen = false;

  get getYoutubeSearch => _youtubeSearch;
  void setYoutubeSearch(search) {
    _youtubeSearch = search;
    notifyListeners();
  }

  get getSearchOpen => _isSearchOpen;
  void setIsSearchOpen(bool search) {
    _isSearchOpen = search;
    notifyListeners();
  }

  // to store videos temporarily for categories
  bool categoryOpen = false;
  get getCategoryOpen => categoryOpen;
  void setCategoryOpen(bool search) {
    categoryOpen = search;
    notifyListeners();
  }

  List<Map<String, dynamic>> temporaryVideosByCategory = [];

  void setTemporaryVideosForCategory(List<Map<String, dynamic>> video) {
    temporaryVideosByCategory = List.from(video);
    notifyListeners();
  }

  get getTemporaryVideosForCategory => temporaryVideosByCategory;

  void clearAllTemporaryVideos() {
    notifyListeners();
    temporaryVideosByCategory.clear();
  }

  // to fetch all youtube data
  List<Map<String, dynamic>> videoDetails = [];
  List<String> uniqueCategoriesList = [];
  bool isLoaded = false;

  get getVideoDetails => videoDetails;
  get getUniqueCategoriesList => uniqueCategoriesList;

  Future fetchVideos() async {
    List<Map<String, dynamic>> items = [];
    Set<String> uniqueCategoriesSet = Set<String>();

    try {
      final response = await http.get(Uri.parse('${MyConst.baseUrl}/get'),
          headers: {'x-api-key': MyConst.apiKey});

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        items = List<Map<String, dynamic>>.from(responseData['data']);
      } else {
        print('Error - Status Code: ${response.statusCode}');
        print('Error - Response Body: ${response.body}');
        return;
      }
    } catch (error) {
      print('Error: $error');
      return;
    }

    // Extract unique categories
    for (var video in items) {
      String category = video['category'];
      List<String> categoriesList = category.split(',');

      // Remove leading and trailing spaces from inner words
      categoriesList =
          categoriesList.map((category) => category.trim()).toList();

      // Add categories to the Set to ensure uniqueness
      uniqueCategoriesSet.addAll(categoriesList);
    }

    // Convert the Set back to a List
    uniqueCategoriesList = uniqueCategoriesSet.toList();

    videoDetails = items;

    isLoaded = true;
    notifyListeners();
  }
}
