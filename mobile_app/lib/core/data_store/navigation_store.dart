class NavigationStore {
  static final Map<Type, dynamic> _cachedParams = {};

  bindNavigationParam(Type destinationPresenter, dynamic data) {
    _cachedParams.addAll({destinationPresenter: data});
  }

  loadNavigationParam({bool clearAfterLoading = true}) {
    dynamic data = _cachedParams[runtimeType];
    if (clearAfterLoading) {
      _cachedParams.remove(runtimeType);
    }
    return data;
  }
}
