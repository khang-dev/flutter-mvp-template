import 'package:flutter/material.dart';
import 'base_presenter.dart';
import 'base_ui.dart';

abstract class BaseViewState<W extends StatefulWidget, P extends BasePresenter> extends State<W> implements BaseUI {
  late P presenter;

  P buildPresenter();

  Widget buildContent(BuildContext context);

  @override
  void initState() {
    presenter = buildPresenter();
    presenter.onInitState();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      presenter.onViewDidLoad();
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildContent(context);
  }

  @override
  void goBack({dynamic data}) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(data);
    }
  }

  @override
  void dispose() {
    presenter.onDispose();
    super.dispose();
  }
}
