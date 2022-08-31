import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:stocker_mobile/app/providers/app.authentication.dart';
import 'package:stocker_mobile/app/providers/app.dbnotifier.dart';

class AppProvider {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => AuthenticationNotifier()),
     ChangeNotifierProvider(create: (_) => DataBaseNotifier())
  ];
}
