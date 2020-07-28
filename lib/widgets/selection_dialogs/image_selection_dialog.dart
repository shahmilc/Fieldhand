import 'dart:io';
import 'package:fieldhand/computation/general_functions.dart';
import 'package:fieldhand/screen_sizing.dart';
import 'package:fieldhand/widgets/elements.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fieldhand/extentions/string_extensions.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:i18n_extension/default.i18n.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ImageSelectionDialog extends StatefulWidget {
  final String headerTitle;
  final List<String> imgList;
  final String objectSerial;
  final String currentImage;

  ImageSelectionDialog(
      {@required this.headerTitle,
      @required this.imgList,
      @required this.objectSerial,
      @required this.currentImage});

  @override
  State<StatefulWidget> createState() => _ImageSelectionDialogState();
}

class _ImageSelectionDialogState extends State<ImageSelectionDialog> {

  List<Widget> imageSliders;
  String _selected;
  List<String> displayImgList = List<String>();

  PickedFile _pickedImageFile;
  File _croppedImageFile;
  dynamic _pickImageError;
  String _retrieveDataError;
  final ImagePicker _picker = ImagePicker();


  @override
  void initState() {
    displayImgList.addAll(widget.imgList);
    setInitialImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    imageSliders = _returnImages();
    return SimpleDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(displayWidth(context) * 0.07))),
      titlePadding: const EdgeInsets.all(0),
      contentPadding: EdgeInsets.only(bottom: 0),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          verticalSpace(context, 0.02),
          cardHeader(context: context, text: widget.headerTitle),
          verticalSpace(context, 0.02),
        ],
      ),
      children: [
        SizedBox(
          height: displayHeight(context) * 0.32,
          child: ClipRRect(
            borderRadius:
                BorderRadius.all(Radius.circular(displayWidth(context) * 0.07)),
            child: Container(
              child: CarouselSlider(
                options: CarouselOptions(
                  autoPlay: false,
                  aspectRatio: 1.0,
                  enlargeCenterPage: true,
                  viewportFraction: 0.7,
                  onPageChanged: (selectionIndex, reason) {
                    _selected = displayImgList[selectionIndex];
                  }
                ),
                items: imageSliders,
              ),
            ),
          ),
        ),
        _optionTile(text: 'Take Photo'.i18n, icon: Icons.camera_alt),
        _optionTile(text: 'Upload'.i18n, icon: Icons.file_upload),
        verticalSpace(context, 0.02),
        _buttonRow()
      ],
    );
  }

  void _onImageButtonPressed({ImageSource source, BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(source: source, maxHeight: 1080, maxWidth: 1920);
      _pickedImageFile = pickedFile;
      _croppedImageFile = (_pickedImageFile != null)
          ? await ImageCropper.cropImage(
              sourcePath: _pickedImageFile.path,
              aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
              compressQuality: 50,
              androidUiSettings: AndroidUiSettings(
                  toolbarTitle: 'Crop Image',
                  toolbarColor: primaryRed(),
                  toolbarWidgetColor: Colors.white,
                  hideBottomControls: true,
                  initAspectRatio: CropAspectRatioPreset.square,
                  lockAspectRatio: true),
              iosUiSettings: IOSUiSettings(
                minimumAspectRatio: 1.0,
              ))
          : null;
        if (_croppedImageFile != null) {
          setState(() {
            displayImgList.insert(displayImgList.indexOf(_selected), _croppedImageFile.path);
            _selected = _croppedImageFile.path;
          });
        }
    } catch (e) {
      _pickImageError = e;
      print(e);
    }
  }

  Future<void> retrieveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _pickedImageFile = response.file;
      });
    } else {
      _retrieveDataError = response.exception.code;
    }
  }

  void setInitialImage() {
    if (displayImgList.contains(widget.currentImage)) displayImgList.remove(widget.currentImage);
    displayImgList.insert(0, widget.currentImage);
    _selected = widget.currentImage;
  }

  void wipeImageCache() async {
    if (_croppedImageFile != null) await Directory(path.dirname(_croppedImageFile.path)).delete(recursive: true);
    if (_pickedImageFile != null) await Directory(path.dirname(_pickedImageFile.path))?.delete(recursive: true);
    imageCache.clear();
  }

  Future<String> saveImage() async {
    String finalImagePath;
    if (!widget.imgList.contains(_selected) && widget.currentImage != _selected) {
      final String appDirectoryPath = (await getApplicationDocumentsDirectory()).path;
      final String subDirectoryPath = 'customImages/custom${(widget.imgList[1].split('/')[3]).capitalize()}'; // i.e. customImages/customAnimals
      final String fileName = '${widget.objectSerial}.jpg';
      final Directory saveDirectory = Directory('$appDirectoryPath/$subDirectoryPath');
      if (! await saveDirectory.exists()) saveDirectory.createSync(recursive: true);
      await File(_selected).copy('${saveDirectory.path}/$fileName').then((value) {
        print(value.path);
        finalImagePath = value.path;
      });
    } else {
      finalImagePath = _selected;
    }
    return finalImagePath;
  }

  Widget _buttonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        MaterialButton(
          child: Text(
            "Cancel",
            style: GoogleFonts.notoSans(
                color: Colors.grey,
                //fontWeight: FontWeight.bold,
                fontSize: displayWidth(context) * 0.04),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        MaterialButton(
          child: Text(
            "Select",
            style: GoogleFonts.notoSans(
                color: (_selected == null || _selected.trim() == '')
                    ? primaryFaded()
                    : primaryRed(),
                fontWeight: FontWeight.bold,
                fontSize: displayWidth(context) * 0.04),
          ),
          onPressed: (_selected == null || _selected.trim() == '')
              ? null :
              () {
                  saveImage().then((value) {print('Popped val: $value'); Navigator.pop(context, value);});
                },
        ),
      ],
    );
  }

  Widget _optionTile({@required String text, @required IconData icon}) {
    return MaterialButton(
      height: displayHeight(context) * 0.07,
      color: Colors.white,
      elevation: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, color: primaryRed(), size: displayWidth(context) * 0.07),
          horizontalSpace(context, 0.03),
          Text(text,
              style: GoogleFonts.notoSans(
                  color: Colors.black54,
                  fontWeight: FontWeight.normal,
                  fontSize: displayWidth(context) * 0.05)),
        ],
      ),
      onPressed: () {
        _onImageButtonPressed(context: context, source: ImageSource.camera);
      },
    );
  }

  List<Widget> _returnImages() {
    return displayImgList
        .map((item) => Container(
              child: Container(
                alignment: Alignment.topCenter,
                child: ClipRRect(
                    borderRadius: BorderRadius.all(
                        Radius.circular(displayWidth(context) * 0.5 * 0.2)),
                    child: Stack(
                      children: <Widget>[
                        getImageFile(item),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(200, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: displayHeight(context) * 0.02,
                                horizontal: displayWidth(context) * 0.07),
                            child: Text(
                              getImageName(item),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: displayWidth(context) * 0.05,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ))
        .toList();
  }

  getImageFile(item) {
    if (item.split('/')[0] == 'assets') {
      return Image.asset(
        item,
        fit: BoxFit.cover,
        height: displayWidth(context) * 0.55,
        width: displayWidth(context) * 0.55,
      );
    } else {
      return Image.file(
        File(item),
        fit: BoxFit.cover,
        height: displayWidth(context) * 0.55,
        width: displayWidth(context) * 0.55,
      );
    }
  }

}
