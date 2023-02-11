import 'dart:io';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quest_server/app/widgets/add_todo_button.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:video_compress/video_compress.dart';

import '../../../app/widgets/video_widget.dart';
import '../../../core/service/database.service.dart';
import '../post/post.view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Future<String?> id;
  late Future<List?> urls;

  void initState() {
    id = DatabaseService().fetchId();
    urls = DatabaseService().feedgetURLs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
              padding: const EdgeInsets.only(right: 20),
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
              )),
          // Container(
          //     padding: const EdgeInsets.only(right: 20), child: AddTodoButton())
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          fit: StackFit.expand,
          children: [
            FutureBuilder<List?>(
              future: urls,
              builder: (context, snapshot) {
                if (!snapshot.hasError && snapshot.hasData) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      final imageResults = DatabaseService().feedgetURLs();
                      setState(() {
                        urls = Future.value(imageResults);
                      });
                    },
                    child: ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return OpenContainer(
                            transitionDuration:
                                const Duration(milliseconds: 600),
                            closedElevation: 0,
                            closedColor: Colors.grey[850]!,
                            closedShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            transitionType: ContainerTransitionType.fadeThrough,
                            closedBuilder: ((context, action) {
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.35,
                                child: Card(
                                  color: Colors.blueGrey,
                                  semanticContainer: true,
                                  clipBehavior: Clip.antiAlias,
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
                                            width: 200,
                                            padding:
                                                const EdgeInsets.only(top: 15),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              //Convert this to widget later
                                              children: [
                                                SizedBox(
                                                  height: 100,
                                                  child: FutureBuilder(
                                                      future: Supabase
                                                          .instance.client
                                                          .from("posts")
                                                          .select("title")
                                                          .eq("video",
                                                              "${snapshot.data![index].path}"),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<dynamic>
                                                              snapshot) {
                                                        if (!snapshot
                                                                .hasError &&
                                                            snapshot.hasData) {
                                                          return ListView
                                                              .builder(
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            shrinkWrap: true,
                                                            itemCount: snapshot
                                                                .data.length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return Text(
                                                                '${snapshot.data![index]}',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        22,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              );
                                                            },
                                                          );
                                                        } else {
                                                          return const Text("");
                                                        }
                                                      }),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                  child: FutureBuilder(
                                                      future: Supabase
                                                          .instance.client
                                                          .from("posts")
                                                          .select("description")
                                                          .eq("video",
                                                              "${snapshot.data![index].path}"),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<dynamic>
                                                              snapshot) {
                                                        if (!snapshot
                                                                .hasError &&
                                                            snapshot.hasData) {
                                                          return ListView
                                                              .builder(
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            shrinkWrap: true,
                                                            itemCount: snapshot
                                                                .data.length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return Text(
                                                                '${snapshot.data![index]}',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                              );
                                                            },
                                                          );
                                                        } else {
                                                          return const Text(
                                                              "bye");
                                                        }
                                                      }),
                                                ),
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
                            openBuilder: ((context, action) {
                              return const PostExpand();
                            }),
                          );
                        }),
                  );
                } else {
                  return const Text("");
                }
              },
            ),
            Container(
              alignment: Alignment.bottomRight,
              child: const AddTodoButton(),
            ),
          ],
        ),
      ),
    );
  }
}
