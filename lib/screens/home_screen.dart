import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:viral_app/constants/my_const.dart';
import 'package:viral_app/screens/recommends/recommends_screen.dart';

import '../colors/theme_colors.dart';
import '../provider/theme_manager.dart';
import '../provider/youtube_data_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Initialize with -1, indicating no category selected to set color
  int selectedCategoryIndex = -1;

  FocusNode searchFocusNode = FocusNode();

  List<Map<String, dynamic>> searchList = [];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Consumer<YoutubeDataProvider>(builder: (context, yt, child) {
        return GestureDetector(
          onTap: () {
            setState(() {
              yt.setIsSearchOpen(false);
            });
          },
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: !yt.getSearchOpen
                    ? Center(child: Text(MyConst.myAppName))
                    : const Text(""),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: yt.getSearchOpen
                        ? Container(
                            margin: const EdgeInsets.only(
                                top: 2, bottom: 2, left: 2),
                            alignment: AlignmentDirectional.centerEnd,
                            width: MediaQuery.of(context).size.width * 0.6,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: TextField(
                                      focusNode: searchFocusNode,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      cursorColor: MyColors.blackColor,
                                      decoration: const InputDecoration(
                                        hintText: "Search Title...",
                                        contentPadding:
                                            EdgeInsets.only(left: 8),
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (query) {
                                        setState(() {
                                          yt.setYoutubeSearch(query);
                                        });

                                        if (yt.getSearchOpen) {
                                          searchList = yt.videoDetails
                                              .where((video) => video['title']
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(
                                                      query.toLowerCase()))
                                              .map((video) => video)
                                              .toList();
                                        }
                                        if (searchList.isEmpty) {
                                          searchList =
                                              List.from(yt.getVideoDetails);
                                        }
                                        // print(searchList);
                                      },
                                      onSubmitted: (query) {
                                        setState(() {
                                          yt.setIsSearchOpen(false);
                                          yt.setYoutubeSearch('');
                                          searchList.clear();
                                        });
                                      }),
                                ),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(Icons.close,
                                      color: MyColors.blackColor),
                                  onPressed: () {
                                    setState(() {
                                      yt.setIsSearchOpen(false);
                                      yt.setYoutubeSearch('');
                                      searchList.clear();
                                    });

                                    searchFocusNode.unfocus();
                                  },
                                ),
                              ],
                            ),
                          )
                        : IconButton(
                            // padding: EdgeInsets.zero,
                            icon: Icon(
                                yt.getSearchOpen ? Icons.close : Icons.search),
                            onPressed: () => setState(() {
                              yt.setIsSearchOpen(!yt.getSearchOpen);
                              searchList = List.from(yt.getVideoDetails);

                              // Request focus when opening the search bar
                              searchFocusNode.requestFocus();
                            }),
                          ),
                  ),
                ],
                leading: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: const Icon(Icons.menu),
                      // icon: Image.asset(
                      //     "assets/nav/menu.png"),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                        yt.setIsSearchOpen(false);
                        // yt.clearAllTemporaryVideos();
                      },
                    );
                  },
                ),
              ),
              drawer: Drawer(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.zero)),
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  children: [
                    DrawerHeader(
                      decoration: const BoxDecoration(
                        color: MyColors.background,
                      ),
                      child: Stack(children: [
                        Positioned(
                          bottom: 2,
                          child: Text(MyConst.myAppName),
                        )
                      ]),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: selectedCategoryIndex == -1
                            ? MyColors.highlight
                            : null,
                      ),
                      child: ListTile(
                        title: const Text("Home"),
                        onTap: () {
                          Navigator.pop(context);
                          // yt.setCategoryOpen(true);
                          setState(() {
                            yt.setCategoryOpen(false);
                            selectedCategoryIndex = -1;
                          });
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Dark Mode",
                            style: TextStyle(
                                color: MyColors.whiteColor, fontSize: 16),
                          ),
                          Consumer<ThemeManager>(
                            builder: (context, themeManager, child) => Switch(
                              activeColor: MyColors.whiteColor,
                              activeTrackColor: MyColors.primary,
                              inactiveThumbColor: MyColors.whiteColor,
                              inactiveTrackColor: MyColors.secondary,
                              // activeThumbImage:
                              //     const AssetImage("assets/nav/night-mode.png"),
                              // inactiveThumbImage:
                              //     const AssetImage("assets/nav/light-mode.png"),
                              value: themeManager.isDarkMode,
                              onChanged: (value) => themeManager.toggleTheme(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      padding: const EdgeInsets.all(0),
                      shrinkWrap: true,
                      itemCount: yt.uniqueCategoriesList.length,
                      itemBuilder: (BuildContext context, int index) {
                        String myCategory = yt.uniqueCategoriesList[index];

                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: index == selectedCategoryIndex
                                ? MyColors.highlight
                                : null,
                          ),
                          child: ListTile(
                            title: Text(myCategory),
                            onTap: () {
                              Navigator.pop(context);

                              List<Map<String, dynamic>> temporaryVideos = yt
                                  .videoDetails
                                  .where((video) => video['category']
                                      .toString()
                                      .toLowerCase()
                                      .contains(myCategory.toLowerCase()))
                                  .toList();

                              yt.setTemporaryVideosForCategory(temporaryVideos);

                              print(temporaryVideos.length);

                              yt.setCategoryOpen(true);

                              // Update the selected category index and change color
                              setState(() {
                                selectedCategoryIndex = index;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              // extendBodyBehindAppBar: true,
              body: RecommendsScreen(searchList: searchList),
              // body: const Center(child: Text("Home")),
            ),
          ),
        );
      }),
    );
  }
}
