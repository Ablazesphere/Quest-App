import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quest_server/app/provider/app.provider..dart';
import 'package:quest_server/app/routes/app.routes.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: "ADD YOUR SUPABASE URL", anonKey: "ADD YOUR SUPABASE ANNON KEY");
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
