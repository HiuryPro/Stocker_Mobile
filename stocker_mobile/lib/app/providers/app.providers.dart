import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:stocker_mobile/app/providers/app.authentication.dart';

class AppProvider {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => AuthenticationNotifier())
  ];
}
