import 'dart:async';
import 'package:event_bus/event_bus.dart';
import 'package:rxdart/rxdart.dart';

mixin GlobalStore {
  static final Map<Type, EventBus> _eventBuses = {};
  static final Map<Type, dynamic> _cachedState = <Type, dynamic>{};

  clearGlobalStore() {
    for (EventBus eventBus in _eventBuses.values) {
      eventBus.destroy();
    }
    _eventBuses.clear();
    _cachedState.clear();
  }

  StreamSubscription<E> subscribeGlobalStateChange<E>(Function(E) onDataChange) {
    EventBus eventBus = _getEventBusByType(E);
    return eventBus.on<E>().listen(onDataChange);
  }

  updateGlobalState(dynamic newState) {
    EventBus eventBus = _getEventBusByType(newState.runtimeType);
    _cachedState.addAll({newState.runtimeType: newState});
    eventBus.fire(newState);
  }

  EventBus _getEventBusByType(Type type) {
    if (_eventBuses[type] == null) {
      _eventBuses[type] = EventBus.customController(BehaviorSubject());
    }
    return _eventBuses[type]!;
  }

  E? globalStateOf<E>() {
    return _cachedState[E];
  }
}
