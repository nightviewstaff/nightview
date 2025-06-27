import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nightview/screens/clubs/club_more_info_screen.dart';

import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/models/clubs/club_data.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ClubBarCardScreen extends StatefulWidget {
  static const id = 'club_bar_card';

  final ClubData club;

  const ClubBarCardScreen({Key? key, required this.club}) : super(key: key);

  @override
  State<ClubBarCardScreen> createState() => _ClubBarCardScreenState();
}

class _ClubBarCardScreenState extends State<ClubBarCardScreen> {
  String? filePath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      final ref = FirebaseStorage.instance
          .ref('club_images/${widget.club.id}/barcard.pdf');
      final url = await ref.getDownloadURL();

      final httpClient = HttpClient();
      final request = await httpClient.getUrl(Uri.parse(url));
      final response = await request.close();

      final bytes = await consolidateHttpClientResponseBytes(response);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/barcard_${widget.club.id}.pdf');
      await file.writeAsBytes(bytes);

      setState(() {
        filePath = file.path;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading PDF: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: white),
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: white, fontSize: 18),
              children: [
                const TextSpan(text: 'Bar Card For '),
                TextSpan(
                  text: widget.club.name,
                  style: const TextStyle(color: primaryColor),
                ),
              ],
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SfPdfViewer.file(
              File(filePath!),
              canShowScrollStatus: false,
              pageLayoutMode: PdfPageLayoutMode.continuous,
              // backgroundColor: black,
              canShowScrollHead: false,
              controller: PdfViewerController(),
              enableTextSelection: false,
              interactionMode: PdfInteractionMode.pan,
            ),
    );
  }
}
