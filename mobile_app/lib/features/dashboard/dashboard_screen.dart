import 'package:flutter/material.dart';

import '../../../core/mvp/base_ui.dart';
import '../../../core/mvp/base_view_state.dart';
import 'dashboard_presenter.dart';

abstract class DashboardUI extends BaseUI {
  void showData(DashboardViewData viewData);
}

class DashboardScreen extends StatefulWidget {
  static const String routeName = '/DashboardScreen';

  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DashboardScreenState();
}

class DashboardScreenState extends BaseViewState<DashboardScreen, DashboardPresenter> implements DashboardUI {
  DashboardViewData _viewData = DashboardViewData();

  @override
  void initState() {
    super.initState();
  }

  @override
  DashboardPresenter buildPresenter() {
    return DashboardPresenter(this);
  }

  @override
  Widget buildContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
    );
  }

  @override
  void showData(DashboardViewData viewData) {
    setState(() {
      _viewData = viewData;
    });
  }
}
