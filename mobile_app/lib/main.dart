import 'package:flutter/material.dart';

import 'app/app_env_config.dart';
import 'app/app_view.dart';

void mainWithConfig(AppEnvConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(Application.run(config));
}
