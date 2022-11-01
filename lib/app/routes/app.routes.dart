import 'package:quest_server/meta/views/authentication/login.view.dart';
import 'package:quest_server/meta/views/authentication/signup.view.dart';
import 'package:quest_server/meta/views/profile/dashboard.view.dart';

class AppRoutes {
  static const String LoginRoute = "/login";
  static const String SignupRoute = "/signup";
  static const String ProfileRoute = "/profile";

  static final routes = {
    LoginRoute: (context) => LoginView(),
    SignupRoute: (context) => SignupView(),
    ProfileRoute: (context) => ProfileView(),
  };
}
