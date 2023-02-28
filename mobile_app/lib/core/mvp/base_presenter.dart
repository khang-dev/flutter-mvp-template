import 'base_ui.dart';

abstract class BasePresenter<U extends BaseUI> {
  U? ui;
  BasePresenter(this.ui);

  void onInitState() {}

  void onDispose() {
    ui = null;
  }

  void onViewDidLoad() {
    // UI is ready
  }
}
