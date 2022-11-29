import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quest_server/app/routes/app.routes.dart';
import 'package:quest_server/app/widgets/shimmer_widget.dart';
import 'package:quest_server/app/widgets/video_widget.dart';
import 'package:quest_server/meta/views/authentication/login.view.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:video_player/video_player.dart';

import '../../../core/service/app.service.dart';
import '../../../core/service/database.service.dart';

class ProfileView extends StatefulWidget {
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late VideoPlayerController controller;
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
          actions: [
            Container(
                padding: EdgeInsets.only(right: 20),
                child: GestureDetector(
                  onTap: () async {
                    Navigator.of(context, rootNavigator: true).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => LoginView(),
                      ),
                    );

                    await Supabase.instance.client.auth.signOut();
                  },
                  child: const Icon(
                    Icons.logout_rounded,
                    size: 30,
                  ),
                ))
          ],
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
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
                          return Lottie.asset(
                            "assets/add-profile-picture.json",
                            frameRate: FrameRate(120),
                            repeat: false,
                          );
                          // const Center(
                          //     child: Icon(
                          //   Icons.account_circle,
                          //   size: 150,
                          //   color: Colors.lightBlue,
                          // ));
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
                      return const ShimmerEffect(
                        height: 20,
                        width: 350,
                        rounded: true,
                      );
                    } else {
                      return const Text("Check your internet connection.");
                    }
                  }),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              const Divider(
                thickness: 1,
                indent: 10,
                endIndent: 10,
                color: Colors.white,
                height: 5,
              ),
              Container(
                padding: const EdgeInsets.all(15),
                child: const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Posts",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              FutureBuilder<List?>(
                  future: urls,
                  builder: (context, snapshot) {
                    if (!snapshot.hasError && snapshot.hasData) {
                      return Expanded(
                          child: RefreshIndicator(
                        onRefresh: () async {
                          final avatarResults = DatabaseService().getAvatar();
                          final imageResults = DatabaseService().getURLs();
                          setState(() {
                            avatar = Future.value(avatarResults);
                            urls = Future.value(imageResults);
                          });
                        },
                        color: Colors.blue,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return SizedBox(
                                height: 300,
                                child: Card(
                                  color: Colors.blueGrey,
                                  semanticContainer: true,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 5,
                                  margin: const EdgeInsets.all(10),
                                  child:
                                      // CachedNetworkImage(
                                      //   imageUrl:
                                      //       'https://zomfoszsstzqszqfyoie.supabase.co/storage/v1${snapshot.data![index].signedUrl}',
                                      //   fit: BoxFit.fill,
                                      // ),

                                      Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      VideoWidget(
                                          url:
                                              'https://zomfoszsstzqszqfyoie.supabase.co/storage/v1${snapshot.data![index].signedUrl}',
                                          play: true),
                                      Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(15),
                                            alignment: Alignment.topLeft,
                                            child: Column(
                                              //Convert this to widget later
                                              children: const [
                                                ShimmerEffect(
                                                    height: 20,
                                                    width: 180,
                                                    rounded: true),
                                                SizedBox(height: 10),
                                                ShimmerEffect(
                                                  height: 20,
                                                  width: 180,
                                                  rounded: true,
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ));
                    } else {
                      return const Text("");
                    }
                  }),
            ],
          ),
        ));
  }
}
