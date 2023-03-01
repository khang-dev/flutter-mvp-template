import 'package:mobile_app/features/dashboard/dashboard_screen.dart';

import '../../../core/mvp/base_presenter.dart';
import '../../app/app_view.dart';
import 'splash_screen.dart';

class SplashPresenter extends BasePresenter<SplashUI> {
  SplashPresenter(SplashUI ui) : super(ui);

  // @override
  // void onInitState() {
  //   super.onInitState();
  // }

  @override
  void onViewDidLoad() {
    super.onViewDidLoad();
    Future.delayed(const Duration(milliseconds: 300), () {
      Application.navigator.pushReplacementNamed(DashboardScreen.routeName);
    });
  }

  // @override
  // void onDispose() {
  //   super.onDispose();
  // }
}

class SplashViewData {}
