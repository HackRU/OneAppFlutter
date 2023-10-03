import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:hackru/weather/bg/weather_bg.dart';
import 'package:hackru/weather/utils/print_utils.dart';

import '../utils/weather_type.dart';

//// 晴晚&流星层
class WeatherNightStarBg extends StatefulWidget {
  final WeatherType weatherType;

  WeatherNightStarBg({Key? key, required this.weatherType}) : super(key: key);

  @override
  _WeatherNightStarBgState createState() => _WeatherNightStarBgState();
}

class _WeatherNightStarBgState extends State<WeatherNightStarBg>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  List<_StarParam> _starParams = [];
  List<_MeteorParam> _meteorParams = [];
  WeatherDataState _state = WeatherDataState.init;
  late double width;
  late double height;
  late double widthToHeight;
  late Timer dimUpdateTimer;

  void fetchData(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    widthToHeight = (height!) / width!;
    _state = WeatherDataState.loading;
    initStarParams();
    setState(() {
      _controller!.repeat();
    });
    _state = WeatherDataState.finish;
  }

  /// 初始化星星参数
  void initStarParams() {
    for (int i = 0; i < 45; i++) {
      var index = Random().nextInt(2);
      _StarParam _starParam = _StarParam(index);
      _starParam.init(width, height, widthToHeight);
      _starParams.add(_starParam);
    }

    for (int i = 0; i < 2; i++) {
      _MeteorParam param = _MeteorParam();
      param.init(width, height);
      _meteorParams.add(param);
    }
  }

  @override
  void initState() {
    dimUpdateTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        width = MediaQuery.of(context).size.width;
        height = MediaQuery.of(context).size.height;
      });
    });

    _controller = AnimationController(
        duration: Duration(milliseconds: 5000), vsync: this);
    _controller!.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    dimUpdateTimer.cancel();
    _controller!.dispose();
    super.dispose();
  }

  Widget _buildWidget() {
    if (_starParams.isNotEmpty &&
        widget.weatherType == WeatherType.sunnyNight) {
      return Container(
          height: height,
          width: width,
          child: CustomPaint(
            painter: _StarPainter(
                _starParams, _meteorParams, width, height, widthToHeight),
          ));
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_state == WeatherDataState.init) {
      fetchData(context);
    } else if (_state == WeatherDataState.finish) {
      return _buildWidget();
    }
    return Container();
  }
}

class _StarPainter extends CustomPainter {
  final _paint = Paint();
  final _meteorPaint = Paint();
  final List<_StarParam> _starParams;

  final width;
  final height;
  final widthToHeight;

  /// 配置星星数据信息
  final List<_MeteorParam> _meteorParams;

  /// 流星参数信息
  final double _meteorWidth = 200;

  /// 流星的长度
  final double _meteorHeight = 2;

  /// 流星的圆角半径
  _StarPainter(this._starParams, this._meteorParams, this.width, this.height,
      this.widthToHeight) {
    _paint.maskFilter = MaskFilter.blur(BlurStyle.normal, 0.5);
    _paint.color = Colors.white;
    _paint.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_starParams.isNotEmpty) {
      for (var param in _starParams) {
        drawStar(param, canvas, size);
      }
    }
    if (_meteorParams.isNotEmpty) {
      for (var param in _meteorParams) {
        drawMeteor(param, canvas, size);
      }
    }
  }

  /// 绘制流星
  void drawMeteor(_MeteorParam param, Canvas canvas, Size size) {
    canvas.save();
    var gradient = ui.Gradient.linear(
      const Offset(0, 0),
      Offset(_meteorWidth, 0),
      <Color>[
        const Color(0xFFFFFFFF).withOpacity(0),
        const Color(0xFFFFFFFF).withOpacity(0.2)
      ],
    );
    _meteorPaint.shader = gradient;
    canvas.rotate(param.radians!);
    canvas.translate(param.translateX!, param.translateY!);
    canvas.drawRRect(
        RRect.fromLTRBAndCorners(0, 0, _meteorWidth, _meteorHeight,
            topLeft: Radius.circular(10),
            topRight: Radius.zero,
            bottomRight: Radius.zero,
            bottomLeft: Radius.circular(10)),
        _meteorPaint);
    param.move();
    canvas.restore();
  }

  /// 绘制星星
  void drawStar(_StarParam param, Canvas canvas, Size size) {
    canvas.save();
    var identity = ColorFilter.matrix(<double>[
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      param.alpha,
      0,
    ]);
    _paint.colorFilter = identity;
    canvas.drawCircle(Offset(param.x! * size.width, param.y! * size.height),
        param.scale!, _paint);
    canvas.restore();
    param.move();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class _MeteorParam {
  double? translateX;
  double? translateY;
  double? radians;

  double? width, height;

  /// 初始化数据
  void init(width, height) {
    this.width = width;
    this.height = height;
    reset();
  }

  /// 重置数据
  void reset() {
    translateX = -1000 + Random().nextDouble() * 700;
    radians = (pi / 16) + Random().nextDouble() * pi / 8;
    translateY = Random().nextDouble() * height! * 0.66;
  }

  /// 移动
  void move() {
    if (translateX! > width! * 4) {
      reset();
      return;
    }
    translateX = translateX! + 10;
  }
}

class _StarParam {
  double? x;
  double? y;

  double alpha = 0.0;
  double? scale;
  bool reverse = false;
  int index;

  _StarParam(this.index);

  void reset() {
    alpha = 0;
    double baseScale = index == 0 ? 0.7 : 0.5;
    x = Random().nextDouble();
    y = Random().nextDouble();
    reverse = false;
  }

  void init(width, height, widthToHeight) {
    alpha = Random().nextDouble();
    double baseScale = index == 0 ? 1 : 1.8;
    scale = (Random().nextDouble() * 0.3 + baseScale);
    x = Random().nextDouble();
    y = Random().nextDouble();

    reverse = false;
  }

  void move() {
    if (reverse == true) {
      alpha -= 0.01;
      if (alpha < 0) {
        reset();
      }
    } else {
      alpha += 0.01;
      if (alpha > 1.2) {
        reverse = true;
      }
    }
  }
}
