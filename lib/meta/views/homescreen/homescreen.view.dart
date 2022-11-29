import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:video_compress/video_compress.dart';

import '../../../core/service/database.service.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Future<String?> id;

  void initState() {
    id = DatabaseService().fetchId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
              padding: EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () async {
                  final XFile? image = await ImagePicker().pickVideo(
                    source: ImageSource.gallery,
                    // maxHeight: 250,
                    // maxWidth: 250,
                  );
                  MediaInfo? mediaInfo = await VideoCompress.compressVideo(
                    image!.path,
                    quality: VideoQuality.DefaultQuality,
                    deleteOrigin: false,
                  );
                  try {
                    await Supabase.instance.client.storage
                        .from("public-image")
                        .upload("${await id}/${image.name.substring(5)}",
                            File(mediaInfo!.path.toString()));
                    var snackBarSucess = const SnackBar(
                      content: Text(
                        "Uploaded",
                      ),
                      backgroundColor: Colors.green,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBarSucess);
                    await VideoCompress.deleteAllCache();
                  } catch (e) {
                    print(e);
                    var snackBarFail = const SnackBar(
                      content: Text(
                        "Upload failed",
                      ),
                      backgroundColor: Colors.red,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBarFail);
                  }
                },
                child: const Icon(
                  Icons.add_photo_alternate_rounded,
                  size: 30,
                ),
              ))
        ],
      ),
      body: Container(),
    );
  }
}
