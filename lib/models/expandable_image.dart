import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class ExpandableImage extends StatefulWidget {
  ExpandableImage(this.image, {Key key}) : super(key: key);
  final Image image;

  @override
  _ExpandableImageState createState() => new _ExpandableImageState();
}

class _ExpandableImageState extends State<ExpandableImage> {
  _ExpandableImageState();

  double _scale = 1.0;
  double _previousScale;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onScaleStart: (ScaleStartDetails details) {
        _previousScale = _scale;
      },
      onScaleUpdate: (ScaleUpdateDetails details) {
        setState(() => _scale = _previousScale * details.scale);
      },
      onScaleEnd: (ScaleEndDetails details) {
        _previousScale = null;
      },
      child: new Transform(
        transform: new Matrix4.diagonal3(new Vector3(_scale, _scale, _scale)),
        alignment: FractionalOffset.center,
        child: widget.image,
      ),
    );
  }
}