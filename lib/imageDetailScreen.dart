import 'package:wardrobe_app/theme/app_styles.dart';
import 'package:wardrobe_app/theme/size_config.dart';
import 'package:flutter_svg/svg.dart';

import 'dart:io';
import 'package:before_after/before_after.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide ImageProvider;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'api.dart';
import 'imageDataProvider.dart';
import 'package:screenshot/screenshot.dart';

class ImageDetailPage extends StatefulWidget {
  final String imagePath;
  final int index;

  const ImageDetailPage(this.imagePath, this.index, {super.key});

  @override
  State<ImageDetailPage> createState() => _ImageDetailPageState();
}

class _ImageDetailPageState extends State<ImageDetailPage> {
  String selectedCategory = 'All';
  Uint8List? image;
  bool removedbg = true;
  late bool isloading = false;
  double value = 0.5;
  bool isnull = false;
  bool save = false;
  ScreenshotController screenshotController = ScreenshotController();

  void onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  Future<void> saveImage(BuildContext context, int index) async {
    var perm = await Permission.storage.request();
    final directory = (await getApplicationDocumentsDirectory()).path;
    String fileName = "${DateTime.now().microsecondsSinceEpoch}.png";
    String imagePath = "$directory/$fileName";

    await screenshotController.captureAndSave(directory,
        pixelRatio: 1.0,
        delay: const Duration(milliseconds: 100),
        fileName: fileName);
    final imageProvider = Provider.of<ImageProvider>(context, listen: false);
    imageProvider.addImage(ImageData(imagePath,selectedCategory));
    imageProvider.removeImage(index);
    Navigator.of(context).pop();
  }

  void deleteImage(BuildContext context, int index) {
    final imageProvider = Provider.of<ImageProvider>(context, listen: false);
    imageProvider.removeImage(index);
    Navigator.of(context).pop(); // Return to previous screen
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Row(
          children: [
             GestureDetector(
                    onTap: () async {
                      save
                          ? saveImage(context, widget.index)
                          : setState(() {
                              isloading = true;
                            });
                      image = await Api.removebg(widget.imagePath);
                      removedbg = false;
                      isloading = false;
                      if (image == null) {
                        isnull = true;
                      } else {
                        save = true;
                      }
                      setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      height: 60,
                      width: kPaddingHorizontal * 10,
                      // double.infinity,
                      margin: const EdgeInsets.only(
                          left: kPaddingHorizontal,
                          right: kPaddingHorizontal * 0.5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: kDarkBrown,
                      ),
                      child: isloading
                          ? const CircularProgressIndicator()
                          :save
                          ? Text('Save!', style: kEncodeSansMedium.copyWith(color: kGrey))
                          : Text('Remove Background',
                              style: kEncodeSansMedium.copyWith(color: kGrey)),
                    ),
                  ),
            GestureDetector(
                child: IconButton(
              onPressed: () => deleteImage(context, widget.index),
              icon: Icon(Icons.delete_forever),color: kDarkBrown,
              iconSize: 50,
            )),
          ],
        ),
        body: Column(
          children: [
            SizedBox(
              height: SizeConfig.blockSizeVertical! * 75,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: removedbg
                        ? PhotoView.customChild(
                            backgroundDecoration:
                                const BoxDecoration(color: Colors.transparent),
                            tightMode: true,
                            enablePanAlways: false,
                            child: Image.file(
                              File(widget.imagePath),
                              height: SizeConfig.blockSizeVertical! * 75,
                              width: double.infinity,
                              fit: BoxFit.contain,
                            ),
                          )
                        : isnull
                            ? const Center(
                                child: Text("Please try another image"))
                            : BeforeAfter(
                                height: SizeConfig.blockSizeVertical! * 80,
                                width: double.infinity,
                                value: value,
                                onValueChanged: (value) {
                                  setState(() => this.value = value);
                                },
                                before: Screenshot(
                                  controller: screenshotController,
                                  child: Image.memory(
                                    image!,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                after: Image.file(
                                  File(widget.imagePath),
                                  fit: BoxFit.contain,
                                ),
                              ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Divider(
              height: 1,
              color: kLightGrey,
            ),
            // Row(
            //   children: [
            //     CategoryButton('T-shirt', selectedCategory, onCategorySelected),
            //     CategoryButton('Shirt', selectedCategory, onCategorySelected),
            //     CategoryButton('Pants', selectedCategory, onCategorySelected),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
//
// class CategoryButton extends StatelessWidget {
//   final String category;
//   final String selectedCategory;
//   final Function(String) onPressed;
//
//   CategoryButton(this.category, this.selectedCategory, this.onPressed);
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () => onPressed(category),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: category == selectedCategory ? Colors.blue : null,
//       ),
//       child: Text(category),
//     );
//   }
// }

