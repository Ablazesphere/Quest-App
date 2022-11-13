import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quest_server/app/widgets/re_usable_select_photo_button.dart';
import 'package:quest_server/core/service/database.service.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import '../../../core/service/app.service.dart';

class SelectPhotoOptionsScreen extends StatelessWidget {
  const SelectPhotoOptionsScreen({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.grey.shade300,
      padding: const EdgeInsets.all(20),
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -35,
            child: Container(
              width: 50,
              height: 6,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.5),
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Column(children: [
            SelectPhoto(
              onTap: () async {
                final id = await DatabaseService()
                    .fetchId(); // try removing the await if it works
                final File image =
                    await AppService().pickImage(ImageSource.gallery) as File;
                try {
                  await Supabase.instance.client.storage
                      .from("avatar")
                      .upload("$id/$id.jpg", File(image.path));
                  var snackBarSucess = const SnackBar(
                    content: Text(
                      "Uploaded",
                    ),
                    backgroundColor: Colors.green,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBarSucess);
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
              icon: Icons.image,
              textLabel: 'Browse Gallery',
            ),
            const SizedBox(
              height: 10,
            ),
            const Center(
              child: Text(
                'OR',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SelectPhoto(
              onTap: () async {
                final id = await DatabaseService()
                    .fetchId(); // try removing the await if it works
                final File image =
                    await AppService().pickImage(ImageSource.gallery) as File;
                try {
                  await Supabase.instance.client.storage
                      .from("avatar")
                      .upload("$id/$id.jpg", File(image.path));
                  var snackBarSucess = const SnackBar(
                    content: Text(
                      "Uploaded",
                    ),
                    backgroundColor: Colors.green,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBarSucess);
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
              icon: Icons.camera_alt_outlined,
              textLabel: 'Use a Camera',
            ),
          ])
        ],
      ),
    );
  }
}
