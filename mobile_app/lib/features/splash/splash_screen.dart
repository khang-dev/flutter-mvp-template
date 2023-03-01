import 'package:flutter/material.dart';

import '../../../core/mvp/base_ui.dart';
import '../../../core/mvp/base_view_state.dart';
import 'splash_presenter.dart';

abstract class SplashUI extends BaseUI {
  void showData(SplashViewData viewData);
}

class SplashScreen extends StatefulWidget {
  static const String routeName = '/SplashScreen';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends BaseViewState<SplashScreen, SplashPresenter> implements SplashUI {
  SplashViewData _viewData = SplashViewData();

  @override
  void initState() {
    super.initState();
  }

  @override
  SplashPresenter buildPresenter() {
    return SplashPresenter(this);
  }

  @override
  Widget buildContent(BuildContext context) {
    return const Scaffold();
  }

  @override
  void showData(SplashViewData viewData) {
    setState(() {
      _viewData = viewData;
    });
  }
}
