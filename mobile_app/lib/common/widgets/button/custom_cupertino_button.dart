import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

const EdgeInsets _kButtonPadding = EdgeInsets.all(16.0);
const EdgeInsets _kBackgroundButtonPadding = EdgeInsets.symmetric(
  vertical: 14.0,
  horizontal: 64.0,
);

class CustomCupertinoButton extends StatefulWidget {
  /// Creates an iOS-style button.
  const CustomCupertinoButton({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.disabledColor = CupertinoColors.quaternarySystemFill,
    this.minSize = kMinInteractiveDimensionCupertino,
    this.pressedOpacity = 0.4,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.alignment = Alignment.center,
    this.onLongPressed,
    Duration fadeInEffectDuration = const Duration(milliseconds: 20),
    Duration fadeOutEffectDuration = const Duration(milliseconds: 20),
    required this.onPressed,
  })  : assert(pressedOpacity == null || (pressedOpacity >= 0.0 && pressedOpacity <= 1.0)),
        _fadeInEffectDuration = fadeInEffectDuration,
        _fadeOutEffectDuration = fadeOutEffectDuration,
        _filled = false;

  /// Creates an iOS-style button with a filled background.
  ///
  /// The background color is derived from the [CupertinoTheme]'s `primaryColor`.
  ///
  /// To specify a custom background color, use the [color] argument of the
  /// default constructor.
  const CustomCupertinoButton.filled({
    super.key,
    required this.child,
    this.padding,
    this.disabledColor = CupertinoColors.quaternarySystemFill,
    this.minSize = kMinInteractiveDimensionCupertino,
    this.pressedOpacity = 0.4,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.alignment = Alignment.center,
    this.onLongPressed,
    required this.onPressed,
  })  : assert(pressedOpacity == null || (pressedOpacity >= 0.0 && pressedOpacity <= 1.0)),
        color = null,
        _filled = true,
        _fadeInEffectDuration = const Duration(milliseconds: 20),
        _fadeOutEffectDuration = const Duration(milliseconds: 20);

  /// The widget below this widget in the tree.
  ///
  /// Typically a [Text] widget.
  final Widget child;

  /// The amount of space to surround the child inside the bounds of the button.
  ///
  /// Defaults to 16.0 pixels.
  final EdgeInsetsGeometry? padding;

  /// The color of the button's background.
  ///
  /// Defaults to null which produces a button with no background or border.
  ///
  /// Defaults to the [CupertinoTheme]'s `primaryColor` when the
  /// [CustomCupertinoButton.filled] constructor is used.
  final Color? color;

  /// The color of the button's background when the button is disabled.
  ///
  /// Ignored if the [CustomCupertinoButton] doesn't also have a [color].
  ///
  /// Defaults to [CupertinoColors.quaternarySystemFill] when [color] is
  /// specified. Must not be null.
  final Color disabledColor;

  /// The callback that is called when the button is tapped or otherwise activated.
  ///
  /// If this is set to null, the button will be disabled.
  final VoidCallback? onPressed;

  final VoidCallback? onLongPressed;

  /// Minimum size of the button.
  ///
  /// Defaults to kMinInteractiveDimensionCupertino which the iOS Human
  /// Interface Guidelines recommends as the minimum tappable area.
  final double? minSize;

  /// The opacity that the button will fade to when it is pressed.
  /// The button will have an opacity of 1.0 when it is not pressed.
  ///
  /// This defaults to 0.4. If null, opacity will not change on pressed if using
  /// your own custom effects is desired.
  final double? pressedOpacity;

  /// The radius of the button's corners when it has a background color.
  ///
  /// Defaults to round corners of 8 logical pixels.
  final BorderRadius? borderRadius;

  /// The alignment of the button's [child].
  ///
  /// Typically buttons are sized to be just big enough to contain the child and its
  /// [padding]. If the button's size is constrained to a fixed size, for example by
  /// enclosing it with a [SizedBox], this property defines how the child is aligned
  /// within the available space.
  ///
  /// Always defaults to [Alignment.center].
  final AlignmentGeometry alignment;

  final bool _filled;

  /// Whether the button is enabled or disabled. Buttons are disabled by default. To
  /// enable a button, set its [onPressed] property to a non-null value.
  bool get enabled => onPressed != null;

  /// The fade in duration of the button's tap opacity effect.
  ///
  /// Defaults is 20 miliseconds.
  final Duration _fadeInEffectDuration;

  /// The fade out duration of the button's tap opacity effect.
  ///
  /// Defaults is 20 miliseconds.
  final Duration _fadeOutEffectDuration;

  @override
  State<CustomCupertinoButton> createState() => _CustomCupertinoButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(FlagProperty('enabled', value: enabled, ifFalse: 'disabled'));
  }
}

class _CustomCupertinoButtonState extends State<CustomCupertinoButton> with SingleTickerProviderStateMixin {
  Duration _fadeOutDuration = const Duration(milliseconds: 20);
  Duration _fadeInDuration = const Duration(milliseconds: 20);
  final _animControllerDuration = const Duration(milliseconds: 50);
  final Tween<double> _opacityTween = Tween<double>(begin: 1.0);

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _fadeInDuration = widget._fadeInEffectDuration;
    _fadeOutDuration = widget._fadeOutEffectDuration;
    _animationController = AnimationController(
      duration: _animControllerDuration,
      value: 0.0,
      vsync: this,
    );
    _opacityAnimation = _animationController.drive(CurveTween(curve: Curves.decelerate)).drive(_opacityTween);
    _setTween();
  }

  @override
  void didUpdateWidget(CustomCupertinoButton old) {
    super.didUpdateWidget(old);
    _setTween();
  }

  void _setTween() {
    _opacityTween.end = widget.pressedOpacity ?? 1.0;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  int longPressCoolDownMs = 600;

  void _checkLongPressed() {
    if (widget.onLongPressed == null) {
      return;
    }
    Future.delayed(Duration(milliseconds: longPressCoolDownMs), () {
      if (!mounted) {
        return;
      }
      if (_buttonHeldDown) {
        widget.onLongPressed?.call();
        _buttonHeldDown = false;
        _animate();
      }
    });
  }

  bool _buttonHeldDown = false;

  void _handleTapDown(TapDownDetails event) {
    if (!_buttonHeldDown) {
      _buttonHeldDown = true;
      _animate();
      _checkLongPressed();
    }
  }

  void _handleTapUp(TapUpDetails event) {
    if (widget.onPressed == null) {
      return;
    }

    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
      widget.onPressed?.call();
    }
  }

  void _handleTapCancel() {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _animate() {
    if (_animationController.isAnimating) {
      return;
    }
    final bool wasHeldDown = _buttonHeldDown;
    final TickerFuture ticker = _buttonHeldDown
        ? _animationController.animateTo(1.0, duration: _fadeOutDuration, curve: Curves.decelerate)
        : _animationController.animateTo(0.0, duration: _fadeInDuration, curve: Curves.decelerate);
    ticker.then<void>((void value) {
      if (mounted && wasHeldDown != _buttonHeldDown) {
        _animate();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool enabled = widget.enabled;
    final CupertinoThemeData themeData = CupertinoTheme.of(context);
    final Color primaryColor = themeData.primaryColor;
    final Color? backgroundColor = widget.color == null
        ? (widget._filled ? primaryColor : null)
        : CupertinoDynamicColor.maybeResolve(widget.color, context);

    final Color foregroundColor = backgroundColor != null
        ? themeData.primaryContrastingColor
        : enabled
            ? primaryColor
            : CupertinoDynamicColor.resolve(CupertinoColors.placeholderText, context);

    final TextStyle textStyle = themeData.textTheme.textStyle.copyWith(color: foregroundColor);

    return MouseRegion(
      cursor: enabled && kIsWeb ? SystemMouseCursors.click : MouseCursor.defer,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: enabled ? _handleTapDown : null,
        onTapUp: enabled ? _handleTapUp : null,
        onTapCancel: enabled ? _handleTapCancel : null,
        // onTap: widget.onPressed,
        child: Semantics(
          button: true,
          child: ConstrainedBox(
            constraints: widget.minSize == null
                ? const BoxConstraints()
                : BoxConstraints(
                    minWidth: widget.minSize!,
                    minHeight: widget.minSize!,
                  ),
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: widget.borderRadius,
                  color: backgroundColor != null && !enabled
                      ? CupertinoDynamicColor.resolve(widget.disabledColor, context)
                      : backgroundColor,
                ),
                child: Padding(
                  padding: widget.padding ?? (backgroundColor != null ? _kBackgroundButtonPadding : _kButtonPadding),
                  child: Align(
                    alignment: widget.alignment,
                    widthFactor: 1.0,
                    heightFactor: 1.0,
                    child: DefaultTextStyle(
                      style: textStyle,
                      child: IconTheme(
                        data: IconThemeData(color: foregroundColor),
                        child: widget.child,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
