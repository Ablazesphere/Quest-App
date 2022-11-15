import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import '../../../core/service/app.service.dart';
import '../../../core/service/database.service.dart';

class ProfileView extends StatefulWidget {
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late Future<List?> urls;
  late Future<String?> id;
  late Future<String?> avatar;

  @override
  void initState() {
    id = DatabaseService().fetchId();
    urls = DatabaseService().getURLs();
    avatar = DatabaseService().getAvatar();
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
              AvatarGlow(
                glowColor: Colors.grey,
                endRadius: 100,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    AppService().showSelectPhotoOptions(context);
                  },
                  child: Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    height: 150.0,
                    width: 150.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: FutureBuilder<String?>(
                      future: avatar,
                      builder: (context, snapshot) {
                        if (!snapshot.hasError && snapshot.hasData) {
                          return Center(
                            child: CachedNetworkImage(
                              imageUrl: "${snapshot.data}",
                              fit: BoxFit.cover,
                              height: 150,
                              width: 150,
                            ),
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else {
                          return const Center(
                              child: Icon(
                            Icons.account_circle,
                            size: 150,
                            color: Colors.lightBlue,
                          ));
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 23),
              FutureBuilder<String?>(
                  future: id,
                  builder: (context, snapshot) {
                    if (!snapshot.hasError && snapshot.hasData) {
                      return Text(
                        "UID : ${snapshot.data!}",
                        style: const TextStyle(fontSize: 15),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else {
                      return const Text("Check your internet connection.");
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
                child: const Text("Upload Photos"),
              ),
              const SizedBox(height: 16),
              const Divider(
                thickness: 1,
                indent: 10,
                endIndent: 10,
                color: Colors.white,
                height: 5,
              ),
              FutureBuilder<List?>(
                  future: urls,
                  builder: (context, snapshot) {
                    if (!snapshot.hasError && snapshot.hasData) {
                      return Expanded(
                          child: RefreshIndicator(
                        onRefresh: () async {
                          final avatar_results = DatabaseService().getAvatar();
                          final image_results = DatabaseService().getURLs();
                          setState(() {
                            avatar = Future.value(avatar_results);
                            urls = Future.value(image_results);
                          });
                        },
                        color: Colors.blue,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                height: 300,
                                child: Card(
                                  semanticContainer: true,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 5,
                                  margin: EdgeInsets.all(10),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        'https://zomfoszsstzqszqfyoie.supabase.co/storage/v1${snapshot.data![index].signedUrl}',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              );
                            }),
                      ));
                    } else {
                      return Text("");
                    }
                  }),
            ],
          ),
        ));
  }
}
