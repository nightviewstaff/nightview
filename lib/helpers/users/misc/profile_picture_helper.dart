import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/generated/l10n.dart';
import 'package:nightview/main.dart';

class ProfilePictureHelper {
  static final ImagePicker _picker = ImagePicker();

  static Future<bool> _uploadProfilePicture(File image) async {
    final storage = FirebaseStorage.instance;
    final auth = FirebaseAuth.instance;

    if (auth.currentUser == null) {
      return false;
    }

    try {
      await storage.ref('pb/${auth.currentUser!.uid}.jpg').putFile(image);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<File?> _pickImage() async {
    final XFile? newPb = await _picker.pickImage(source: ImageSource.gallery);
    return newPb == null ? null : File(newPb.path);
  }

  static Future<File?> _cropImage(File original) async {
    CroppedFile? cropped = await ImageCropper().cropImage(
      sourcePath: original.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
// Removed cropStyle. Is it needed?
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: S.of(ourNavigatorKey.currentContext!).select_image,
          toolbarColor: black,
          toolbarWidgetColor: white,
          hideBottomControls: true,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: S.of(ourNavigatorKey.currentContext!).select_image,
          doneButtonTitle: S.of(ourNavigatorKey.currentContext!).continues,
          cancelButtonTitle: S.of(ourNavigatorKey.currentContext!).back,
          aspectRatioPickerButtonHidden: true,
          resetButtonHidden: true,
          rotateButtonsHidden: true,
          aspectRatioLockEnabled: true,
        ),
      ],
    );

    return cropped == null ? null : File(cropped.path);
  }

  static Future<File?> _compressImage(File original) async {
    XFile? compressed = await FlutterImageCompress.compressAndGetFile(
      original.absolute.path,
      "${original.absolute.path}_compressed.jpg",
      quality: 88, // 0-100, lower value means higher compression
      format: CompressFormat.jpeg,
    );

    return compressed == null ? null : File(compressed.path);
  }

  static File _resizeImage(File file, int width, int height) {
    final img.Image originalImage = img.decodeImage(file.readAsBytesSync())!;
    final img.Image resizedImage =
        img.copyResize(originalImage, width: width, height: height);

    // Save the resized image to a file
    file.writeAsBytesSync(img.encodeJpg(resizedImage));

    return file;
  }

  static Future<bool> pickCropResizeCompressAndUploadPb() async {
    File? picked = await _pickImage();

    if (picked == null) {
      return false;
    }

    File? cropped = await _cropImage(picked);

    if (cropped == null) {
      return false;
    }

    File resized = _resizeImage(cropped, 256, 256);

    File? compressed = await _compressImage(resized);

    if (compressed == null) {
      return false;
    }

    return _uploadProfilePicture(compressed);
  }

  static Future<String?> getProfilePicture(String userId) async {
    try {
      Reference ref = FirebaseStorage.instance.ref('pb/$userId.jpg');
      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print("Failed to get the download URL: $e");
      return null;
    }
  }
}
