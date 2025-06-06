import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

Future<void> uploadImageWithMetaData({
  required XFile imageFile,
  required String clubId,
  required String caption,
  required int rating,
  required List<String> taggedUserIds,
  required String uploaderId,
}) async {
  final now = DateTime.now();
  final dateKey = DateFormat('yyyy-MM-dd').format(now);
  final timestamp = Timestamp.fromDate(now);
  final uniqueId = const Uuid()
      .v4(); // generates a unique ID like '550e8400-e29b-41d4-a716-446655440000'

  final fileName = "${dateKey}_$uniqueId";
  final storageRef = FirebaseStorage.instance
      .ref()
      .child('user_images/$uploaderId/mood_images/$fileName.webp');

  // Step 1: Compress to temp .webp
  final tempDir = await getTemporaryDirectory();
  final tempPath = '${tempDir.path}/$fileName.webp';

  final XFile? compressedXFile = await FlutterImageCompress.compressAndGetFile(
    imageFile.path,
    tempPath,
    format: CompressFormat.webp,
    quality: 80,
  );

  if (compressedXFile == null) {
    throw Exception("Image compression failed");
  }
//   if (compressedXFile == null) { // TODO
//   Navigator.of(context).pop(); // Dismiss loading indicator
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       content: Text('Image compression failed. Please try again.'),
//       backgroundColor: Colors.red,
//     ),
//   );
//   return;
// }

  final File tempFile = File(compressedXFile.path);

  // Step 2: Upload to Firebase
  final uploadTask = await storageRef.putFile(tempFile);
  final downloadUrl = await uploadTask.ref.getDownloadURL();

  // Step 3: Move to permanent app directory // Todo when fetching
  final appDir = await getApplicationDocumentsDirectory();
  final savedFile = await tempFile.copy('${appDir.path}/$fileName.webp');

  // Step 4: Save metadata to Firestore
  await FirebaseFirestore.instance.collection('mood_images').add({
    'club_id': clubId,
    'caption': caption,
    'date_key': dateKey,
    'rating': rating,
    'tagged_users': taggedUserIds,
    'timestamp': timestamp,
    'uploaded_by': uploaderId,
    'url': downloadUrl,
  });

  print('📁 Saved permanent file: ${savedFile.path}');
}
