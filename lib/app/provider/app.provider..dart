import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:quest_server/app/notifier/database.notifier.dart';

class AppProviders {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(
      create: (context) => DatabaseNotifier(),
    )
  ];
}
