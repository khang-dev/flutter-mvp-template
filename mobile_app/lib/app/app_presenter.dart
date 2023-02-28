import '../core/mvp/base_presenter.dart';
import 'app_view.dart';

class ApplicationPresenter extends BasePresenter<ApplicationUI> {
  ApplicationPresenter(ApplicationUI uiExecutor) : super(uiExecutor);

  void onInitApplicationState() {}

  // @override
  // void onDispose() {
  //   super.onDispose();
  // }

  // @override
  // void onInitState() {
  //   super.onInitState();
  // }
}
