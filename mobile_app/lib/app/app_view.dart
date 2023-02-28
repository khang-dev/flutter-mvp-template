import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/mvp/base_view_state.dart';
import '../common/widgets/app/app_life_cycle_listener.dart';
import '../core/mvp/base_ui.dart';
import 'app_env_config.dart';
import 'app_presenter.dart';
import 'app_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

abstract class ApplicationUI extends BaseUI {}

class Application extends StatefulWidget {
  static Application? _instance;
  final navigatorKey = GlobalKey<NavigatorState>();
  final AppEnvConfig appConfig;

  Application._internal(this.appConfig);

  static Application instance() {
    return _instance!;
  }

  static Application run(AppEnvConfig appEnvConfig) {
    _instance ??= Application._internal(appEnvConfig);
    return _instance!;
  }

  static NavigatorState get navigator => Navigator.of(_instance!.navigatorKey.currentContext!);

  static AppEnvConfig get config => _instance!.appConfig;

  @override
  // ignore: no_logic_in_create_state
  ApplicationState createState() => ApplicationState(navigatorKey);
}

class ApplicationState extends BaseViewState<Application, ApplicationPresenter> implements ApplicationUI {
  GlobalKey<NavigatorState> navigatorKey;

  ApplicationState(this.navigatorKey);
  final _appRouter = AppRouter();

  @override
  ApplicationPresenter buildPresenter() {
    return ApplicationPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    presenter.onInitApplicationState();
  }

  @override
  Widget buildContent(BuildContext context) {
    return AppLifeCycleListener(onStateChanged: _handleAppStateChange, child: _buildMaterialApp());
  }

  Widget _buildMaterialApp() {
    return ScreenUtilInit(
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          restorationScopeId: 'app',
          navigatorKey: navigatorKey,
          locale: const Locale('en', ''),
          initialRoute: _appRouter.initialRouteName,
          routes: _appRouter.initialRoute,
          onGenerateRoute: _appRouter.onGenerateRoute,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
          ],
        );
      },
    );
  }

  void _handleAppStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.detached:
        break;
      default:
        break;
    }
  }
}
