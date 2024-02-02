import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class FileController extends GetxController {
  List<File> files = [];

  void loadFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    final fileList = directory.listSync();

    final filteredFiles = fileList.where((file) {
      if (file is File) {
        final String extension = file.path.split('.').last.toLowerCase();
        return extension == 'jpg' || extension == 'jpeg' || extension == 'png' || extension == 'gif';
      }
      return false;
    }).toList();

    files = filteredFiles.cast<File>().toList();
    update();
  }

  // 파일 삭제 함수
  Future<void> deleteFile(File fileToDelete) async {
    try {
      await fileToDelete.delete();
      files.remove(fileToDelete);
      update();
    } catch (e) {
      print('파일 삭제 중 오류 발생: $e');
    }
  }

  Future<void> saveFile(Uint8List imageBytes, String fileId) async {
    final directory = await getApplicationDocumentsDirectory();
    String filePath = '${directory.path}/$fileId.jpg';

    // Uint8List to File
    final File imageFile = File(filePath);
    await imageFile.writeAsBytes(imageBytes);

    // Save the image file to the list
    files.add(imageFile);
    print('---------file save success');
    update(); // Notify listeners of the change
  }

  void saveImageFromUrl(String imageUrl, String id) async {
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      // Convert the response body (bytes) to Uint8List
      Uint8List imageBytes = Uint8List.fromList(response.bodyBytes);

      // Save the image to the file controller
      await saveFile(imageBytes, id);
    } else {
      print('Failed to download image: ${response.statusCode}');
    }
  }

  @override
  void onInit() {
    loadFiles();
    print('---------load success');
    super.onInit();
  }
}
