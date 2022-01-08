// ignore_for_file:invalid_use_of_protected_member

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:material_switcher/src/material_switcher.dart';

enum _Position { reverse, idle, forward }
enum _Direction { incoming, outgoing }

/// Item builder for [MaterialView] children.
typedef MaterialViewItemBuilder = Widget Function(BuildContext contex, int index);

/// Page view with material transition animations, instead of linear swipe animation.
/// Similar to how pages transition in the google play app.
class MaterialView extends StatelessWidget {
  /// Creates material fade variant of [MaterialView].
  const MaterialView.fade({
    Key? key,
    required this.itemBuilder,
    required this.itemCount,
    this.fillColor = Colors.transparent,
    this.swipeDirection = Axis.horizontal,
    this.controller,
    this.addRepaintBoundaries = true,
    this.clipBehavior = Clip.hardEdge,
    this.onPageChanged,
    this.physics = const AlwaysScrollableScrollPhysics(),
    this.allowImplicitScrolling = false,
    this.inherit = false,
    this.paintInheritedAnimations = false,
    this.wrapInheritBoundary = false,
    this.enableScroll = true,
  })  : _type = MaterialSwitcherType.fade,
        super(key: key);

  /// Creates material shared axis vertical variant of [MaterialView].
  const MaterialView.vertical({
    Key? key,
    required this.itemBuilder,
    required this.itemCount,
    this.fillColor = Colors.transparent,
    this.controller,
    this.addRepaintBoundaries = true,
    this.clipBehavior = Clip.hardEdge,
    this.onPageChanged,
    this.physics = const AlwaysScrollableScrollPhysics(),
    this.allowImplicitScrolling = false,
    this.inherit = false,
    this.paintInheritedAnimations = false,
    this.wrapInheritBoundary = false,
    this.enableScroll = true,
  })  : _type = MaterialSwitcherType.axisVertical,
        swipeDirection = Axis.vertical,
        super(key: key);

  /// Creates material shared axis horizontal variant of [MaterialView].
  const MaterialView.horizontal({
    Key? key,
    required this.itemBuilder,
    required this.itemCount,
    this.fillColor = Colors.transparent,
    this.controller,
    this.addRepaintBoundaries = true,
    this.clipBehavior = Clip.hardEdge,
    this.onPageChanged,
    this.physics = const AlwaysScrollableScrollPhysics(),
    this.allowImplicitScrolling = false,
    this.inherit = false,
    this.paintInheritedAnimations = false,
    this.wrapInheritBoundary = false,
    this.enableScroll = true,
  })  : _type = MaterialSwitcherType.axisHorizontal,
        swipeDirection = Axis.horizontal,
        super(key: key);

  /// Creates material shared axis scaled variant of [MaterialView].
  const MaterialView.scaled({
    Key? key,
    required this.itemBuilder,
    required this.itemCount,
    this.fillColor = Colors.transparent,
    this.swipeDirection = Axis.horizontal,
    this.controller,
    this.addRepaintBoundaries = true,
    this.clipBehavior = Clip.hardEdge,
    this.onPageChanged,
    this.physics = const AlwaysScrollableScrollPhysics(),
    this.allowImplicitScrolling = false,
    this.inherit = false,
    this.paintInheritedAnimations = false,
    this.wrapInheritBoundary = false,
    this.enableScroll = true,
  })  : _type = MaterialSwitcherType.scaled,
        super(key: key);

  /// Child builder.
  final MaterialViewItemBuilder itemBuilder;

  /// Child widget count.
  final int itemCount;

  /// Type of the material transition animation.
  final MaterialSwitcherType _type;

  /// Fill color built into some transitions. Setting this makes the animation look more materialy, I guess…
  ///
  /// Should usually either be transparent or match the background of the switchers container.
  final Color fillColor;

  /// Swipe direction of this [MaterialView].
  final Axis swipeDirection;

  /// Page controller of the inner [PageView].
  final PageController? controller;

  /// Whether to wrap child widget in repaint boundaries.
  final bool addRepaintBoundaries;

  /// Clip behavior of the [PageView].
  final Clip clipBehavior;

  /// Called when the page changes.
  final ValueChanged<int>? onPageChanged;

  /// [ScrollPhysics] of the inner [PageView].
  final ScrollPhysics physics;

  /// Allow implicit scrolling on iOS. While this is enabled, the cache extent is set
  /// to 1 viewport, which means other the surrounding pages will get prebuilt.
  final bool allowImplicitScrolling;

  /// Whether to defer the animations to [InheritedAnimationCoordinator].
  ///
  /// If this is toggled, you are responsible for building [InheritedAnimation]
  /// somewhere down the widget tree.
  final bool inherit;

  /// Whether to paint any deferred animations before the child.
  final bool paintInheritedAnimations;

  /// Whether to add an [InheritedAnimationCoordinator.boundary] to avoid inheriting parent animations.
  final bool wrapInheritBoundary;

  /// When disabled, scroll physics will fallback to [NeverScrollableScrollPhysics].
  final bool enableScroll;

  Widget _transition(
    Widget child,
    Animation<double> primaryAnimation,
    Animation<double> secondaryAnimation,
  ) {
    switch (_type) {
      case MaterialSwitcherType.fade:
        return FadeThroughTransition(
          child: child,
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          fillColor: fillColor,
          inherit: inherit,
          paintInheritedAnimations: paintInheritedAnimations,
        );
      case MaterialSwitcherType.axisVertical:
        return SharedAxisTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.vertical,
          child: child,
          fillColor: fillColor,
          inherit: inherit,
          paintInheritedAnimations: paintInheritedAnimations,
        );
      case MaterialSwitcherType.axisHorizontal:
        return SharedAxisTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
          child: child,
          fillColor: fillColor,
          inherit: inherit,
          paintInheritedAnimations: paintInheritedAnimations,
        );
      case MaterialSwitcherType.scaled:
        return SharedAxisTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.scaled,
          child: child,
          fillColor: fillColor,
          inherit: inherit,
          paintInheritedAnimations: paintInheritedAnimations,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget view = _MaterialPageView(
      controller: controller,
      itemBuilder: itemBuilder,
      itemCount: itemCount,
      swipeDirection: swipeDirection,
      transitionBuilder: _transition,
      addRepaintBoundaries: addRepaintBoundaries,
      fillColor: fillColor,
      clipBehavior: clipBehavior,
      onPageChanged: onPageChanged,
      physics: physics,
      allowImplicitScrolling: allowImplicitScrolling,
      enableScroll: enableScroll,
    );

    if (wrapInheritBoundary) {
      view = InheritedAnimationCoordinator.boundary(child: view);
    }

    return view;
  }
}

class _MaterialPageView extends StatefulWidget {
  const _MaterialPageView({
    Key? key,
    required this.itemBuilder,
    required this.itemCount,
    required this.transitionBuilder,
    this.swipeDirection = Axis.horizontal,
    this.fillColor = Colors.transparent,
    this.controller,
    this.addRepaintBoundaries = true,
    this.clipBehavior = Clip.hardEdge,
    this.onPageChanged,
    this.physics = const AlwaysScrollableScrollPhysics(),
    this.allowImplicitScrolling = true,
    this.scrollBehavior,
    this.reverse = false,
    this.pageSnapping = true,
    this.enableScroll = true,
  }) : super(key: key);

  final MaterialViewItemBuilder itemBuilder;
  final int itemCount;
  final Axis swipeDirection;
  final PageTransitionSwitcherTransitionBuilder transitionBuilder;
  final Color fillColor;
  final PageController? controller;
  final bool addRepaintBoundaries;
  final Clip clipBehavior;
  final ValueChanged<int>? onPageChanged;
  final ScrollPhysics physics;
  final bool allowImplicitScrolling;
  final ScrollBehavior? scrollBehavior;
  final bool reverse;
  final bool pageSnapping;
  final bool enableScroll;

  @override
  __MaterialPageViewState createState() => __MaterialPageViewState();
}

class __MaterialPageViewState extends State<_MaterialPageView> {
  final _goingReverse = ValueNotifier<bool?>(null);

  late PageController _controller;
  bool _disposeController = false;
  int _lastReportedPage = 0;
  double _lastValue = 0.0;

  void _handleChange({double? value}) {
    final _value = value ?? (_controller.positions.isNotEmpty ? _controller.page : _controller.initialPage.toDouble());

    if (_lastValue != _value) {
      final isStopped = _value?.toInt() == _value;
      if (isStopped) {
        _goingReverse.value = null;
      } else {
        _goingReverse.value ??= (_value ?? 0.0) < _lastValue;
      }
      _lastValue = _value ?? 0.0;
      // markNeedsBuild();
    }

    // Report page change.
    final currentPage = _value?.round() ?? _controller.initialPage;
    if (currentPage != _lastReportedPage) {
      _lastReportedPage = currentPage;
      widget.onPageChanged?.call(currentPage);
    }
  }

  @override
  void initState() {
    _disposeController = widget.controller == null;
    _controller = widget.controller ?? PageController();
    _controller.addListener(_handleChange);
    _lastValue = _controller.initialPage.toDouble();
    _handleChange(value: _controller.initialPage.toDouble());
    super.initState();
  }

  @override
  void dispose() {
    if (_disposeController) {
      _controller.dispose();
    } else {
      _controller.removeListener(_handleChange);
    }

    super.dispose();
  }

  Widget _buildItem(BuildContext context, int i) => _MaterialViewTransformedChildBuilder(
        index: i,
        controller: _controller,
        reverse: _goingReverse,
        axis: widget.swipeDirection,
        builder: widget.transitionBuilder,
        child: widget.itemBuilder(context, i),
      );

  @override
  Widget build(BuildContext context) => PageView.custom(
        controller: _controller,
        scrollDirection: widget.swipeDirection,
        clipBehavior: widget.clipBehavior,
        physics: !widget.enableScroll ? const NeverScrollableScrollPhysics() : null,
        scrollBehavior: widget.scrollBehavior,
        childrenDelegate: SliverChildBuilderDelegate(
          _buildItem,
          childCount: widget.itemCount,
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: widget.addRepaintBoundaries,
        ),
      );
}

/// Widget that builds the children for [MaterialView].
///
/// It handles syncing of primary & secondary material transition animations
/// to the [PageController] in the [MaterialView].
class _MaterialViewTransformedChildBuilder extends StatefulWidget {
  /// Creates [_MaterialViewTransformedChildBuilder].
  const _MaterialViewTransformedChildBuilder({
    Key? key,
    required this.controller,
    required this.builder,
    required this.index,
    required this.child,
    required this.reverse,
    this.axis = Axis.horizontal,
    this.debug = false,
  }) : super(key: key);

  /// [PageController] that's gonna drive the primary and secondary animation
  /// of the children switcher animations.
  final PageController controller;

  /// Child widget that's wrapped in a material transition.
  final Widget child;

  /// Index of this child, for syncing the animation value, relative to the page
  /// in the [PageController].
  final int index;

  /// Whether the [MaterialView] is being reversed in reverse.
  final ValueNotifier<bool?> reverse;

  /// The scroll direction.
  final Axis axis;

  /// Builder of the material transition.
  final PageTransitionSwitcherTransitionBuilder builder;

  /// Whether to overlay animation debug info over the children.
  final bool debug;

  @override
  _MaterialViewTransformedChildBuilderState createState() => _MaterialViewTransformedChildBuilderState();
}

class _MaterialViewTransformedChildBuilderState extends State<_MaterialViewTransformedChildBuilder>
    with TickerProviderStateMixin<_MaterialViewTransformedChildBuilder> {
  late final AnimationController _primaryController;
  late final AnimationController _secondaryController;

  final _relativeValue = ValueNotifier(0.0);

  _Position get _position {
    if (widget.reverse.value == true) {
      return _Position.reverse;
    } else if (widget.reverse.value == false) {
      return _Position.forward;
    }

    if (_relativeValue.value < 0.0) {
      return _Position.reverse;
    } else if (_relativeValue.value > 0.0) {
      return _Position.forward;
    } else {
      return _Position.idle;
    }
  }

  _Direction get _direction {
    if (_relativeValue.value < 0.0) {
      return widget.reverse.value == true ? _Direction.outgoing : _Direction.incoming;
    } else {
      return widget.reverse.value != true ? _Direction.outgoing : _Direction.incoming;
    }
  }

  void _handleValueChange() {
    switch (_position) {
      case _Position.idle:
        _primaryController.value = 1.0;
        _secondaryController.value = 0.0;
        break;
      case _Position.forward:
        switch (_direction) {
          case _Direction.incoming:
            _primaryController.value = 1.0 - _relativeValue.value.abs();
            _secondaryController.value = 0.0;
            break;
          case _Direction.outgoing:
            _primaryController.value = 1.0;
            _secondaryController.value = _relativeValue.value.abs();
            break;
        }
        break;
      case _Position.reverse:
        switch (_direction) {
          case _Direction.incoming:
            _secondaryController.value = _relativeValue.value.abs();
            _primaryController.value = 1.0;
            break;
          case _Direction.outgoing:
            _primaryController.value = 1.0 - _relativeValue.value.abs();
            _secondaryController.value = 0.0;
            break;
        }
        break;
    }
  }

  void _handlePageController({double? value}) {
    final relativeValue = (value ??
                (widget.controller.positions.isNotEmpty
                    ? widget.controller.page ?? widget.controller.initialPage.toDouble()
                    : widget.controller.initialPage.toDouble()))
            .clamp(widget.index - 1, widget.index + 1)
            .toDouble() -
        widget.index;

    if (_relativeValue.value != relativeValue) {
      _relativeValue.value = relativeValue;
      _handleValueChange();
    }
  }

  @override
  void initState() {
    _primaryController = AnimationController(vsync: this);
    _secondaryController = AnimationController(vsync: this);
    widget.reverse.addListener(_handlePageController);
    widget.controller.addListener(_handlePageController);
    _handlePageController(value: widget.controller.initialPage.toDouble());
    _handleValueChange();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _MaterialViewTransformedChildBuilder oldWidget) {
    assert(oldWidget.controller == widget.controller);
    if (oldWidget.reverse != widget.reverse) _handlePageController();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.reverse.removeListener(_handlePageController);
    widget.controller.removeListener(_handlePageController);
    _primaryController.dispose();
    _secondaryController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<double>(
        valueListenable: _relativeValue,
        child: widget.builder(widget.child, _primaryController, _secondaryController),
        builder: (_, relativeValue, child) {
          Offset offset = Offset.zero;

          switch (widget.axis) {
            case Axis.horizontal:
              offset = Offset(relativeValue, 0);
              break;
            case Axis.vertical:
              offset = Offset(0, relativeValue);
              break;
          }

          return FractionalTranslation(translation: offset, child: child);
        },
      );
}
