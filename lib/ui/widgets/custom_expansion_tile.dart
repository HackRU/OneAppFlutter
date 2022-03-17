import 'package:flutter/material.dart';

/// Reference: https://github.com/flutter/flutter/blob/2d2a1ffec9/packages/flutter/lib/src/material/expansion_tile.dart#L30

const Duration _kExpand = Duration(milliseconds: 200);

class CustomExpansionTile extends StatefulWidget {
  const CustomExpansionTile({
    Key? key,
    this.leading,
    this.title,
    this.backgroundColor,
    this.onExpansionChanged,
    this.children = const <Widget>[],
    this.trailing,
    this.initiallyExpanded = false,
  })  : assert(initiallyExpanded != null),
        super(key: key);

  final Widget? leading;
  final Widget? title;
  final ValueChanged<bool>? onExpansionChanged;
  final List<Widget>? children;
  final Color? backgroundColor;
  final Widget? trailing;
  final bool? initiallyExpanded;

  @override
  CustomExpansionTileState createState() => CustomExpansionTileState();
}

class CustomExpansionTileState extends State<CustomExpansionTile>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  CurvedAnimation? _easeOutAnimation;
  CurvedAnimation? _easeInAnimation;
  ColorTween? _borderColor;
  ColorTween? _headerColor;
  ColorTween? _iconColor;
  ColorTween? _backgroundColor;
  Animation<double>? _iconTurns;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _easeOutAnimation =
        CurvedAnimation(parent: _controller!, curve: Curves.easeOut);
    _easeInAnimation =
        CurvedAnimation(parent: _controller!, curve: Curves.easeIn);
    _borderColor = ColorTween();
    _headerColor = ColorTween();
    _iconColor = ColorTween();
    _iconTurns = Tween<double>(begin: 0.0, end: 0.5).animate(_easeInAnimation!);
    _backgroundColor = ColorTween();

    _isExpanded =
        PageStorage.of(context)?.readState(context) ?? widget.initiallyExpanded;
    if (_isExpanded) _controller?.value = 1.0;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void expand() {
    _setExpanded(true);
  }

  void collapse() {
    _setExpanded(false);
  }

  void toggle() {
    _setExpanded(!_isExpanded);
  }

  void _setExpanded(bool isExpanded) {
    if (_isExpanded != isExpanded) {
      setState(() {
        _isExpanded = isExpanded;
        if (_isExpanded) {
          _controller?.forward();
        } else {
          _controller?.reverse().then<void>((void value) {
            if (!mounted) return;
            setState(() {
              // Rebuild without widget.children.
            });
          });
        }
        PageStorage.of(context)?.writeState(context, _isExpanded);
      });
      if (widget.onExpansionChanged != null) {
        widget.onExpansionChanged!(_isExpanded);
      }
    }
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    final borderSideColor =
        _borderColor?.evaluate(_easeOutAnimation!) ?? Colors.transparent;
    final titleColor = _headerColor?.evaluate(_easeInAnimation!);

    return Container(
      decoration: BoxDecoration(
          color: _backgroundColor?.evaluate(_easeOutAnimation!) ??
              Colors.transparent,
          border: Border(
            top: BorderSide(color: borderSideColor),
            bottom: BorderSide(color: borderSideColor),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconTheme.merge(
            data: IconThemeData(color: _iconColor?.evaluate(_easeInAnimation!)),
            child: ListTile(
              onTap: toggle,
              leading: widget.leading,
              title: DefaultTextStyle(
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: titleColor),
                child: widget.title!,
              ),
              trailing: widget.trailing,
            ),
          ),
          ClipRect(
            child: Align(
              heightFactor: _easeInAnimation?.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    _borderColor?.end = theme.dividerColor;
    _headerColor?.begin = theme.textTheme.subtitle1?.color;
    // ?.end = theme.accentColor;
    _iconColor?.begin = theme.unselectedWidgetColor;
    // ..end = theme.accentColor;
    _backgroundColor?.end = widget.backgroundColor;

    final closed = !_isExpanded && _controller!.isDismissed;
    return AnimatedBuilder(
      animation: _controller!.view,
      builder: _buildChildren,
      child: closed ? null : Column(children: widget.children!),
    );
  }
}
