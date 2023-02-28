import 'package:flutter/material.dart';

class AppLifeCycleListener extends StatefulWidget {
  final VoidCallback? onAppResumed;
  final VoidCallback? onAppBecameInactive;
  final VoidCallback? onAppPaused;
  final VoidCallback? onAppDeatached;
  final Function(AppLifecycleState)? onStateChanged;
  final Widget child;

  const AppLifeCycleListener(
      {Key? key,
      required this.child,
      this.onAppResumed,
      this.onAppBecameInactive,
      this.onStateChanged,
      this.onAppDeatached,
      this.onAppPaused})
      : super(key: key);

  @override
  AppLifeCycleLinsterState createState() => AppLifeCycleLinsterState();
}

class AppLifeCycleLinsterState extends State<AppLifeCycleListener> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    widget.onStateChanged?.call(state);
    if (state == AppLifecycleState.resumed) {
      widget.onAppResumed?.call();
      return;
    }

    if (state == AppLifecycleState.inactive) {
      widget.onAppBecameInactive?.call();
      return;
    }

    if (state == AppLifecycleState.paused) {
      widget.onAppPaused?.call();
      return;
    }

    if (state == AppLifecycleState.detached) {
      widget.onAppDeatached?.call();
      return;
    }

    widget.onAppBecameInactive?.call();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
