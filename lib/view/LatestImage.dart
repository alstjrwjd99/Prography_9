import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:ttteeesssttt/controller/fileController.dart';
import 'package:ttteeesssttt/model/DetailModel.dart';

import '../model/FeedModel.dart';
import 'RandomPhoto.dart';

class MainPhoto extends StatefulWidget {
  const MainPhoto({super.key});

  @override
  State<MainPhoto> createState() => _MainPhotoState();
}

class _MainPhotoState extends State<MainPhoto> {
  final fileCtrl = Get.put(FileController());
  OverlayEntry? overlayEntry;
  PhotoDetailModel? photoDetailModel;

  List<FeedInfo> latestFeed = [];
  bool isBring = false;
  ScrollController scrollController = ScrollController();

  void requestPhotoInfo() async {
    String baseUrl = "https://api.unsplash.com/photos/";

    // Define query parameters
    Map<String, String> queryParams = {
      'client_id': 'xISg2GZEw6KH6Cka77LeZfoOxzIv9Bz7lgR2RNS4dbo',
    };

    // Combine base URL and query parameters
    Uri url = Uri.parse(baseUrl).replace(queryParameters: queryParams);

    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));

      // latestFeed.clear();
      for (var item in jsonData) {
        latestFeed.add(FeedInfo.fromJson(item));
      }
      print(latestFeed.length);
      setState(() {
        isBring = false;
      });
    } else {
      print("Error: ${response.statusCode}");
      setState(() {
        isBring = true;
      });
    }
  }

  Future<void> requestPhotoDetail(String id) async {
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
      print(photoDetailModel?.tags);
      print(latestFeed.length);
    } else {
      print("Error: ${response.statusCode}");
    }
  }

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
                                setState(() {});
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
                              setState(() {
                                isBookmarked = !isBookmarked;
                              });
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

  @override
  void initState() {
    scrollController.addListener(_scrollController);
    requestPhotoInfo();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _scrollController() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      requestPhotoInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          fileCtrl.files.isNotEmpty
              ? const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    '북마크',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                )
              : Container(),
          fileCtrl.files.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Container(
                    height: 128,
                    width: double.infinity,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: fileCtrl.files.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: InkWell(
                                onTap: () async {
                                  await requestPhotoDetail(
                                      basenameWithoutExtension(
                                          fileCtrl.files[index].path));
                                  showOverlay(context, true, photoDetailModel!);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(fileCtrl.files[index]),
                                ),
                              ));
                        }),
                  ),
                )
              : Container(),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              '최신 이미지',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Skeletonizer(
                  enabled: isBring,
                  child: MasonryGridView.count(
                      controller: scrollController,
                      itemCount: latestFeed.length,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      itemBuilder: (context, index) {
                        String description = latestFeed[index].description;

                        return InkWell(
                          onTap: () async {
                            await requestPhotoDetail(latestFeed[index].id);
                            showOverlay(context, false, photoDetailModel!);
                          },
                          child: Stack(children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: CachedNetworkImage(
                                imageUrl: latestFeed[index].imgurl,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                                left: 0,
                                bottom: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    description.length > 25
                                        ? '${description.substring(0, 25)}\n${description.substring(25)}'
                                        : description,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ))
                          ]),
                        );
                      }),
                )),
          )
        ],
      ),
    );
  }
}
