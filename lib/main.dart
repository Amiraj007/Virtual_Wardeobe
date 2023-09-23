
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart' hide ImageProvider;

import 'package:wardrobe_app/theme/app_styles.dart';
import 'package:wardrobe_app/imageDetailScreen.dart';
import 'package:wardrobe_app/photo_select_screen.dart';
import 'package:wardrobe_app/theme/size_config.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'imageDataProvider.dart';


void main() {
  runApp(
    const  MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ImageProvider()..loadImages(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: const HomeScreen(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              height: 64,
              child: CustomNavigationBar(
                isFloating: true,
                borderRadius: const Radius.circular(40),
                selectedColor: kWhite,
                unSelectedColor: kGrey,
                backgroundColor: kBrown,
                strokeColor: Colors.transparent,
                scaleFactor: 0.1,
                iconSize: 40,
                items: [
                  CustomNavigationBarItem(
                    icon: _currentIndex == 0
                        ? SvgPicture.asset('assets/home_icon_selected.svg')
                        : SvgPicture.asset('assets/home_icon_unselected.svg'),
                  ),
                  CustomNavigationBarItem(
                    icon: _currentIndex == 1
                        ? SvgPicture.asset('assets/cart_icon_selected.svg')
                        : SvgPicture.asset('assets/cart_icon_unselected.svg'),
                  ),
                  CustomNavigationBarItem(
                    icon: _currentIndex == 2
                        ? SvgPicture.asset('assets/favorite_icon_selected.svg')
                        : SvgPicture.asset(
                            'assets/favorite_icon_unselected.svg'),
                  ),
                  CustomNavigationBarItem(
                    icon: _currentIndex == 3
                        ? SvgPicture.asset('assets/account_icon_selected.svg')
                        : SvgPicture.asset(
                            'assets/account_icon_unselected.svg'),
                  ),
                ],
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
          ),
        ));
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';
  List<String> categories = [
    "All Items",
    "Shirts",
    "T-shirts",
    "Pants",
  ];

  List<String> icons = [
    'all_items_icon',
    'shirt',
    'tshirt',
    'pants',
  ];
  int current = 0;

  final picker = ImagePicker();
  bool isSelected = false;

  void addImage(ImageProvider imageProvider) async {
    final pickedImage = await picker.pickMultiImage();
    if (pickedImage.isNotEmpty) {
       selectedCategory = (await _showCategorySelectionDialog(context))!;
      for (final pickedImage in pickedImage) {
        final imagePath = pickedImage.path;
        imageProvider.addImageWithCategory(imagePath,selectedCategory);
      }
    }
  }

  Future<String?> _showCategorySelectionDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop('T-shirt');
                },
                child: Text('T-shirt'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop('Shirt');
                },
                child: Text('Shirt'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop('Pants');
                },
                child: Text('Pants'),
              ),
            ],
          ),
        );
      },
    );
  }
  void clickImage(ImageProvider imageProvider) async {
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    final imagePath = pickedImage!.path;
    imageProvider.addImageWithCategory(imagePath,selectedCategory);
  }

  void viewImage(BuildContext context, String imagePath, int index) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ImageDetailPage(imagePath, index),
      // builder: (context) => ImageScreen(imagePath, index),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImageProvider>(context);
    final tShirtImages = imageProvider.images.where((image) => image.category == 'T-shirt').toList();
    final shirtImages = imageProvider.images.where((image) => image.category == 'Shirt').toList();
    final pantImages = imageProvider.images.where((image) => image.category == 'Pants').toList();
    final images = imageProvider.images;
    int temp = 0;
    SizeConfig().init(context);

    return SafeArea(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPaddingHorizontal),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hello, Welcome 👋',
                      style: kEncodeSansRagular.copyWith(
                        color: kDarkBrown,
                        fontSize: SizeConfig.blockSizeHorizontal! * 3.5,
                      ),
                    ),
                    Text(
                      'Amiraj Bhnaderi',
                      style: kEncodeSansBold.copyWith(
                        color: kDarkBrown,
                        fontSize: SizeConfig.blockSizeHorizontal! * 4,
                      ),
                    ),
                  ],
                ),
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: kGrey,
                  backgroundImage: NetworkImage(
                      'https://img.freepik.com/premium-vector/account-icon-user-icon-vector-graphics_292645-552.jpg'),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kPaddingHorizontal,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: kEncodeSansRagular.copyWith(
                      color: kDarkGrey,
                      fontSize: SizeConfig.blockSizeHorizontal! * 3.5,
                    ),
                    controller: TextEditingController(),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 13,
                      ),
                      prefixIcon: const IconTheme(
                        data: IconThemeData(
                          color: kDarkGrey,
                        ),
                        child: Icon(Icons.search),
                      ),
                      hintText: 'Sarch clothes...',
                      border: kInputBorder,
                      errorBorder: kInputBorder,
                      disabledBorder: kInputBorder,
                      focusedBorder: kInputBorder,
                      focusedErrorBorder: kInputBorder,
                      enabledBorder: kInputBorder,
                      hintStyle: kEncodeSansRagular.copyWith(
                        color: kDarkGrey,
                        fontSize: SizeConfig.blockSizeHorizontal! * 3.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 6,
                ),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(showDragHandle: true,
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                      ),
                      builder: (context) => _buildBottomSheetContent(context,imageProvider),
                    );
                    isSelected = false;
                    setState(() {});
                  },
                  icon: isSelected
                      ? SvgPicture.asset(
                          'assets/add-square-selected.svg',
                          height: 70,
                        )
                      : SvgPicture.asset(
                          'assets/add-square-svgrepo-com.svg',height: 50),splashRadius: 1,padding: const EdgeInsets.all( 0.0),tooltip: 'Add Images',
                )
              ],
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          SizedBox(
            width: double.infinity,
            height: 36,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: categories.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    temp = index;
                    current = index;
                    print(temp);
                    setState(() {
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      left: index == 0 ? kPaddingHorizontal : 15,
                      right: index == categories.length - 1
                          ? kPaddingHorizontal
                          : 0,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    height: 36,
                    decoration: BoxDecoration(
                      color: current == index ? kBrown : kWhite,
                      borderRadius: BorderRadius.circular(8),
                      border: current == index
                          ? null
                          : Border.all(
                              color: kLightGrey,
                              width: 1,
                            ),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                            current == index
                                ? 'assets/${icons[index]}_selected.svg'
                                : 'assets/${icons[index]}_unselected.svg',
                            height: 20,
                            width: 20),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          categories[index],
                          style: kEncodeSansMedium.copyWith(
                            color: current == index ? kWhite : kDarkBrown,
                            fontSize: SizeConfig.blockSizeHorizontal! * 3,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          MasonryGridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 23,
            itemCount: images.length,
            padding: const EdgeInsets.symmetric(
              horizontal: kPaddingHorizontal,
            ),
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Positioned(
                        child: temp == 0 ? ClipRRect(
                          borderRadius: BorderRadius.circular(kBorderRadius),
                          child: GestureDetector(
                            onTap: () => viewImage(
                                context, images[index].imagePath, index),
                            child: Image.file(
                              File(images[index].imagePath),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ):temp == 1? ClipRRect(
                          borderRadius: BorderRadius.circular(kBorderRadius),
                          child: GestureDetector(
                            onTap: () => viewImage(
                                context, tShirtImages[index].imagePath, index),
                            child: Image.file(
                              File(tShirtImages[index].imagePath),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ):ClipRRect(
                          borderRadius: BorderRadius.circular(kBorderRadius),
                          child: GestureDetector(
                            onTap: () => viewImage(
                                context, tShirtImages[index].imagePath, index),
                            child: Image.file(
                              File(tShirtImages[index].imagePath),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 12,
                        top: 12,
                        child: GestureDetector(
                          onTap: () {},
                          child: SvgPicture.asset(
                            'assets/favorite_cloth_icon_unselected.svg',
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              );
            },
          ),
          SizedBox(height: SizeConfig.screenHeight! * 0.120,)
        ],
      ),
    );
  }

  Widget _buildBottomSheetContent(BuildContext context,ImageProvider imageProvider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20,30,20,50),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
        //   IconButton(onPressed: () {
        //   Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => PhotoSelectScreen(),
        //   ));
        // }, icon: Icon(Icons.add)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Stack(alignment: Alignment.center,
                    children:[
                      Image.asset('assets/images/line.png',width: 120,height: 120,),
                      IconButton(
                        onPressed: () {
                          clickImage(imageProvider);
                          Navigator.pop(context);
                        },
                        icon: SvgPicture.asset('assets/option_camera.svg'),
                        iconSize: 60,
                      ),
                    ]
                  ),
                  Text(
                      "Camera",
                      style: kEncodeSansMedium.copyWith(
                        color: kDarkBrown,
                        fontSize: SizeConfig.blockSizeHorizontal! * 4,
                      )),
                ],
              ),

              Column(
                children: [
                  Stack(alignment: Alignment.center,
                      children:[
                        Image.asset('assets/images/line.png',width: 120,height: 120,),
                        IconButton(
                          onPressed: () {
                            addImage(imageProvider);
                            Navigator.pop(context);
                          },
                          icon: SvgPicture.asset('assets/option_gallery.svg'),
                          iconSize: 60,
                        ),
                      ]
                  ),
                  Text(
                      "Gallery",
                      style: kEncodeSansMedium.copyWith(
                        color: kDarkBrown,
                        fontSize: SizeConfig.blockSizeHorizontal! * 4,
                      )),
                ],
              ),

            ],
          ),
        ],
      ),
    );
  }
}
