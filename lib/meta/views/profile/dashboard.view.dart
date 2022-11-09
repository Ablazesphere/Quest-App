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
  late Future<List?> urls;
  late Future<String?> id;
  @override
  void initState() {
    id = DatabaseService().fetchId();
    urls = DatabaseService().getURLs();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
        ),
        body: SizedBox(
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
                        style: const TextStyle(fontSize: 15),
                      );
                    } else {
                      return const Text('error');
                    }
                  }),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final XFile? image = await ImagePicker()
                      .pickImage(source: ImageSource.gallery, imageQuality: 50);
                  try {
                    await Supabase.instance.client.storage
                        .from("public-image")
                        .upload("${await id}/${image!.name}", File(image.path));
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
                child: const Text("Select photos from gallery"),
              ),
              const SizedBox(height: 16),
              const Divider(
                thickness: 1,
                indent: 10,
                endIndent: 10,
                color: Colors.white,
                height: 5,
              ),
              const SizedBox(height: 16),
              FutureBuilder<List?>(
                  future: urls,
                  builder: (context, snapshot) {
                    if (!snapshot.hasError && snapshot.hasData) {
                      return SizedBox(
                        height: 500,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 5,
                                margin: EdgeInsets.all(10),
                                child: Image.network(
                                  '${snapshot.data![index]}',
                                  fit: BoxFit.fill,
                                ),
                              );
                            }),
                      );
                    } else {
                      return const Text('error');
                    }
                  }),
            ],
          ),
        ));
  }
}
