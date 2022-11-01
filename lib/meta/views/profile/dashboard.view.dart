import 'package:flutter/material.dart';
import 'package:quest_server/app/notifier/database.notifier.dart';
import 'package:quest_server/core/service/database.service.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class ProfileView extends StatefulWidget {
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late Future<String?> id;
  @override
  void initState() {
    id = DatabaseService().fetchId();
    // email = DatabaseService().fetchEmail();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Hello."),
        ),
        body: FutureBuilder<String?>(
            future: id,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const CircularProgressIndicator();
              } else if (!snapshot.hasError && snapshot.hasData) {
                return Text(snapshot.data!);
              } else {
                return Text('error');
              }
            }));
  }
}
