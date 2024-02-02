import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ttteeesssttt/controller/fileController.dart';

import '../model/DetailModel.dart';
import '../model/RandomFeedModel.dart';
import 'LatestImage.dart';

class RandomPhoto extends StatefulWidget {
  const RandomPhoto({super.key});

  @override
  State<RandomPhoto> createState() => _RandomPhotoState();
}

class _RandomPhotoState extends State<RandomPhoto> {
  List<RandomFeedModel> randomFeed = [];
  final fileCtrl = Get.find<FileController>();
  bool isRequested = false;

  PageController pageController = PageController(viewportFraction: 0.9);

  void requestRandomPhotoInfo() async {
    String baseUrl = "https://api.unsplash.com/photos/random/";

    // Define query parameters
    Map<String, String> queryParams = {
      'client_id': 'xISg2GZEw6KH6Cka77LeZfoOxzIv9Bz7lgR2RNS4dbo',
    };

    // Combine base URL and query parameters
    Uri url = Uri.parse(baseUrl).replace(queryParameters: queryParams);

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      randomFeed.add(RandomFeedModel.fromJson(jsonData));
      print(randomFeed.first.id);
      print(randomFeed.length);
      setState(() {});
    } else {
      print("Error: ${response.statusCode}");
    }
  }

  void request10() {
    for (int i = 0; i < 20; i++) {
      requestRandomPhotoInfo();
    }
  }

  @override
  void initState() {
    request10();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 30.0, 0, 40.0),
            child: PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              itemCount: randomFeed.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(6.0, 12, 6.0, 15),
                  child: GestureDetector(
                    onHorizontalDragEnd: (details) {
                      if (details.primaryVelocity! > 0) {
                        pageController.animateToPage(
                          pageController.page!.round() - 1,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut, // 애니메이션 커브 설정
                        );
                      } else if (details.primaryVelocity! < 0) {
                        fileCtrl.saveImageFromUrl(
                            randomFeed[index].imgurl, randomFeed[index].id);
                        pageController.animateToPage(
                            pageController.page!.round() + 1,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.fastOutSlowIn);
                      }
                    },
                    child: photoCard(
                        randomFeed[index].imgurl,
                        randomFeed[index].id,
                        pageController,
                        context,
                        fileCtrl),
                  ),
                );
              },
            )),
      ),
    );
  }
}

Widget photoCard(String imgUrl, String cardId, PageController pageController,
    context, fileCtrl) {
  OverlayEntry? overlayEntry;
  PhotoDetailModel? photoDetailModel;

  void updateOverlayContent() {
    if (overlayEntry != null) {
      overlayEntry!.markNeedsBuild();
    }
  }

  void showOverlay(BuildContext context, bool isBookmarked,
      PhotoDetailModel photoDetailModel) {
    final photoWidth = MediaQuery.of(context).size.width - 24;
    final photoHeight =
        photoWidth / photoDetailModel.width * photoDetailModel.height;
    overlayEntry = OverlayEntry(
      builder: (context) => Material(
        color: Colors.transparent,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
                color: Colors.black.withOpacity(0.9),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                overlayEntry!.remove();
                              },
                              icon: Image.asset('assets/CloseButton.png')),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            photoDetailModel.userName,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const Spacer(),
                          IconButton(
                              onPressed: () {},
                              icon: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Image.asset('assets/download.png'))),
                          IconButton(
                            onPressed: () {
                              isBookmarked = !isBookmarked;
                              updateOverlayContent();
                              if (isBookmarked) {
                                fileCtrl.saveImageFromUrl(
                                    photoDetailModel.imgurl,
                                    photoDetailModel.id);
                                print('saved');
                              } else {
                                final index = fileCtrl.files.indexWhere(
                                    (entry) =>
                                        basenameWithoutExtension(entry.path) ==
                                        photoDetailModel.id);
                                fileCtrl.deleteFile(fileCtrl.files[index]);
                                print('deleted');
                              }
                            },
                            icon: isBookmarked
                                ? Image.asset(
                                    'assets/NavigationButtonWhite.png',
                                    width: 20,
                                    height: 20,
                                  )
                                : Opacity(
                                    opacity: 0.3,
                                    child: Image.asset(
                                      'assets/NavigationButtonWhite.png',
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: SizedBox(
                            width: photoWidth,
                            height: photoHeight,
                            child: CachedNetworkImage(
                              imageUrl: photoDetailModel.imgurl,
                              fit: BoxFit.cover,
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${photoDetailModel.slug}\n',
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${photoDetailModel.description}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            photoDetailModel.tags.map((tag) {
                              return '#$tag ';
                            }).join(),
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );

    Overlay.of(context)!.insert(overlayEntry!);
  }

  Future<void> requestRandomPhotoDetail(id) async {
    String baseUrl = "https://api.unsplash.com/photos/$id/";

    // Define query parameters
    Map<String, String> queryParams = {
      'client_id': 'xISg2GZEw6KH6Cka77LeZfoOxzIv9Bz7lgR2RNS4dbo',
    };

    // Combine base URL and query parameters
    Uri url = Uri.parse(baseUrl).replace(queryParameters: queryParams);

    var response = await http.get(url);

    if (response.statusCode == 200) {
      String jsonString = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonData = json.decode(jsonString);
      photoDetailModel = PhotoDetailModel.fromJson(jsonData);
    } else {
      print("Error: ${response.statusCode}");
    }
  }

  return Container(
    alignment: Alignment.topCenter,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15.0),
      color: const Color(0xffffffff),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.12), // 그림자 색상과 투명도 설정
          spreadRadius: 0, // 그림자 확산 정도
          blurRadius: 25, // 그림자 흐림 정도
          offset: const Offset(0, 4), // 그림자 위치 (가로, 세로)
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(11.0),
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 74),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.black,
              ),
              child: CachedNetworkImage(imageUrl: imgUrl, fit: BoxFit.fitWidth),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset('assets/NotInterestedButton.png'),
                IconButton(
                  onPressed: () {
                    pageController.animateToPage(
                      pageController.page!.round() + 1,
                      // 현재 페이지에서 1을 더한 페이지로 이동
                      duration: const Duration(milliseconds: 500),
                      // 애니메이션 소요 시간 설정
                      curve: Curves.easeInOut, // 애니메이션 커브 설정
                    );
                  },
                  icon: Image.asset('assets/BookmarkButton.png'),
                ),
                IconButton(
                    onPressed: () async {
                      await requestRandomPhotoDetail(cardId);
                      showOverlay(context, false, photoDetailModel!);
                    },
                    icon: Image.asset('assets/InformationButton.png')),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
