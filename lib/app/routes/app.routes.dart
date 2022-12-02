import 'package:quest_server/meta/views/authentication/login.view.dart';
import 'package:quest_server/meta/views/authentication/signup.view.dart';
import 'package:quest_server/meta/views/navigation/navigation.view.dart';
import 'package:quest_server/meta/views/profile/dashboard.view.dart';
import 'package:quest_server/meta/views/tasks/task.view.dart';

class AppRoutes {
  static const String LoginRoute = "/login";
  static const String SignupRoute = "/signup";
  static const String ProfileRoute = "/profile";
  static const String NavRoute = "/navigation";
  static const String TaskRoute = "/tasks";

  static final routes = {
    LoginRoute: (context) => LoginView(),
    SignupRoute: (context) => SignupView(),
    ProfileRoute: (context) => ProfileView(),
    NavRoute: (context) => Navbar(),
    TaskRoute: (context) => TaskView(),
  };
}
