import 'dart:async';
import 'package:fitween1/global/global.dart';
import 'package:fitween1/presenter/page/splash.dart';
import 'package:fitween1/view/widget/image.dart';
import 'package:flutter/material.dart';

// 스플래시 페이지
class SplashPage extends StatefulWidget {
  const SplashPage({Key? key, this.theme = FWTheme.dark}) : super(key: key);

  final FWTheme theme;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(
      SplashPresenter.duration,
      SplashPresenter.toRoute,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: widget.theme.color,
              child: const FWLogo(),
            ),
          ),
        ],
      ),
    );
  }
}
