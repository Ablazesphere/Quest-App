import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class DatabaseService {
  final user = Supabase.instance.client.auth.currentUser;

  Future<String?> fetchId() async {
    var response = await Supabase.instance.client
        .from("Users")
        .select("id")
        .eq("email", user!.email)
        .execute();
    return response.data![0]["id"];
  }

  Future<PostgrestResponse?> addInfo(
      {required String id,
      required String email,
      required String phone}) async {
    PostgrestResponse? response =
        await Supabase.instance.client.from("Users").insert(
      {
        "id": id,
        "email": email,
        "phone": phone,
      },
    );
  }

  Future<PostgrestResponse?> addPost(
      {required String title, required String description}) async {
    PostgrestResponse? response =
        await Supabase.instance.client.from("posts").insert(
      {
        "user_id": user?.id,
        "title": title,
        "description": description,
        "video": "007BD52B-0BAD-4ED1-BF8B-103AB727D01F.MOV"
      },
    );
  }

  Future<String?> getAvatar() async {
    final String avatar = await Supabase.instance.client.storage
        .from("avatar")
        .createSignedUrl("${user!.id}/${user!.id}.jpg", 120);
    print(avatar);
    return avatar;
  }

  Future<List> getURLs() async {
    final List<FileObject> path = await Supabase.instance.client.storage
        .from("public-image")
        .list(path: user!.id);
    final List<String> fpath =
        path.map((e) => '${user!.id}/${e.name}').toList();
    final signedUrls = await Supabase.instance.client.storage
        .from("public-image")
        .createSignedUrls(fpath, 120);
    return signedUrls;
  }

  Future<List> feedgetURLs() async {
    final List<FileObject> path =
        await Supabase.instance.client.storage.from("main-feed").list();
    final List<String> fpath = path.map((e) => e.name).toList();
    final signedUrls = await Supabase.instance.client.storage
        .from("main-feed")
        .createSignedUrls(fpath, 120);
    print(signedUrls);
    return signedUrls;
  }
}
