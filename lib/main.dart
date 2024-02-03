import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import 'view/LatestImage.dart';
import 'view/bottomNavigator.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await _requestPermissions();

  runApp(const MyApp());
}
Future<void> _requestPermissions() async {
  // 파일 시스템 권한 확인 및 요청
  var storageStatus = await Permission.storage.status;
  if (storageStatus.isDenied) {
    await Permission.storage.request();
  } else if (storageStatus.isPermanentlyDenied) {
    await openAppSettings();
  }}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (BuildContext context, Widget? widget) {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: BottomNavigator(),
        );
      },
    );
  }
}
