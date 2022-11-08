import 'package:file_picker/file_picker.dart';
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

  Future<String?> getURL({required String filename}) async {
    final response = await Supabase.instance.client.storage
        .from("public-image")
        .createSignedUrl("${user!.id}/$filename", 120);
    return response;
  }

  Future<List?> getURLs() async {
    final path = await Supabase.instance.client.storage
        .from("public-image")
        .list(path: "${user!.id}");
    return path;
  }
}
