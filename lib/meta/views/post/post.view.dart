import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class PostExpand extends StatefulWidget {
  const PostExpand({super.key});

  @override
  State<PostExpand> createState() => _PostExpandState();
}

class _PostExpandState extends State<PostExpand> with TickerProviderStateMixin {
  StateMachineController? controller;
  SMIInput<double>? inputValue;

  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  void _updateValueInDb(double newValue) async {
    await Supabase.instance.client.from('posts').update({'stars': newValue}).eq(
        "video", "A05CEE6A-56C3-404A-91F2-A6B14E3634A2.MOV");
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 15, bottom: 10, left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 100,
                child: InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    inputValue = controller?.findInput("Rating");
                    int? newValue = inputValue?.value.toInt();
                    _updateValueInDb(newValue!.toDouble());
                  },
                  child: RiveAnimation.asset(
                    "assets/ratings.riv",
                    onInit: (art) async {
                      controller = StateMachineController.fromArtboard(
                        art,
                        "State Machine 1",
                      );
                      art.addController(controller!);
                      inputValue = controller?.findInput("Rating");

                      List result = await Supabase.instance.client
                          .from("posts")
                          .select("stars, user_id")
                          .match({
                        'user_id':
                            '96649509-71a7-4ecf-82cf-9e22b6131558' // Later has to be assigned as a widget argument
                      }).eq("video",
                              "A05CEE6A-56C3-404A-91F2-A6B14E3634A2.MOV"); // Later has to be assigned as a widget argument
                      print(result[0]["stars"]);

                      int? value = result[0]["stars"];
                      inputValue?.change(value!.toDouble());
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
