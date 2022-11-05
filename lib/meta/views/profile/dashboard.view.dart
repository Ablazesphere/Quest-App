import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quest_server/core/service/database.service.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class ProfileView extends StatefulWidget {
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _uploadState = false;
  late Future<String?> id;
  @override
  void initState() {
    id = DatabaseService().fetchId();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder<String?>(
                  future: id,
                  builder: (context, snapshot) {
                    if (!snapshot.hasError && snapshot.hasData) {
                      return Text(
                        "UID : ${snapshot.data!}",
                        style: TextStyle(fontSize: 15),
                      );
                    } else {
                      return Text('error');
                    }
                  }),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final XFile? image = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  await Supabase.instance.client.storage
                      .from("public-image")
                      .upload("${await id}/${image!.name}", File(image.path))
                      .then((value) {
                    setState(() {
                      _uploadState = true;
                    });
                    var snackBarSucess = const SnackBar(
                      content: Text(
                        "Uploaded",
                      ),
                      backgroundColor: Colors.green,
                    );
                    var snackBarFail = const SnackBar(
                      content: Text(
                        "Uploaded",
                      ),
                      backgroundColor: Colors.green,
                    );
                    if (_uploadState = true) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(snackBarSucess);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(snackBarFail);
                    }
                  });
                },
                child: const Text("Select photos"),
              ),
            ],
          ),
        ));
  }
}
