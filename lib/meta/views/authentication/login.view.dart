import 'package:flutter/material.dart';
import 'package:quest_server/app/routes/app.routes.dart';
import 'package:quest_server/meta/views/navigation/navigation.view.dart';

import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Login"),
          ),
          body: Container(
            padding: EdgeInsets.only(top: 16),
            child: Column(
              children: [
                SupaEmailAuth(
                  authAction: SupaAuthAction.signIn,
                  onSuccess: (GotrueSessionResponse response) async {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (_) => Navbar(),
                    ));
                  },
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.SignupRoute);
                  },
                  child: Text("Already have an account? Sign Up"),
                )
              ],
            ),
          ),
        ));
  }
}
