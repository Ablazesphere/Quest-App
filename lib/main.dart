import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quest_server/app/provider/app.provider..dart';
import 'package:quest_server/app/routes/app.routes.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: "https://zomfoszsstzqszqfyoie.supabase.co",
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpvbWZvc3pzc3R6cXN6cWZ5b2llIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NjU1OTU1OTksImV4cCI6MTk4MTE3MTU5OX0.f3qigEYXYgo8hawS3cGNa0KA8Gxb3iVliAR16rvuBII");
  runApp(
    MultiProvider(
      providers: AppProviders.providers,
      child: const Core(),
    ),
  );
}

class Core extends StatelessWidget {
  const Core({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Lava();
  }
}

class Lava extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AppRoutes.LoginRoute,
      routes: AppRoutes.routes,
      theme: ThemeData.dark(),
    );
  }
}
