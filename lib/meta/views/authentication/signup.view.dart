import 'package:flutter/material.dart';
import 'package:quest_server/app/notifier/database.notifier.dart';
import 'package:quest_server/app/routes/app.routes.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:provider/provider.dart' as prvdr;

class SignupView extends StatefulWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  @override
  Widget build(BuildContext context) {
    final DatabaseNotifier databaseNotifier =
        prvdr.Provider.of<DatabaseNotifier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 16),
        child: Column(
          children: [
            SupaEmailAuth(
              authAction: SupaAuthAction.signUp,
              onSuccess: (GotrueSessionResponse response) {
                databaseNotifier.addInfo(
                    id: "${response.user!.id}",
                    email: "${response.user!.email}",
                    phone: "${response.user!.phone}");
                Navigator.of(context).pushNamed(AppRoutes.LoginRoute);
              },
              onError: (error) {
                print("Signup failed");
              },
              metadataFields: [
                MetaDataField(
                    label: "Name",
                    key: "name",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    prefixIcon: const Icon(Icons.person)),
                MetaDataField(
                  label: "Phone",
                  key: "phone",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                  prefixIcon: Icon(Icons.phone),
                )
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.LoginRoute);
              },
              child: Text("Already have an account? Login"),
            )
          ],
        ),
      ),
    );
  }
}
