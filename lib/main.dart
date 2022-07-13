import 'dart:math' as math;
import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:intl/intl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setPortrait();

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({Key? key}) : super(key: key);

  final game = MyGame();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepPurple,
      ),
      home: GameWidget(
        game: game,
        overlayBuilderMap: {
          'MainMenu': (context, MyGame game) => MainMenu(game: game),
        },
      ),
    );
  }
}

/// This example simply adds a rotating white square on the screen.
/// If you press on a square, it will be removed.
/// If you press anywhere else, another square will be added.
class MyGame extends FlameGame with HasTappables  {
  var bn;

  @override
  Future<void> onLoad() async {
    bn=SpriteButtonComponent(position:Vector2(300,200),
        button: await  Sprite.load('PauseButton.png'),
        buttonDown: await Sprite.load('PauseButtonInvert.png'),
        onPressed: BnAcc
    );
    add(bn);

  }
  void BnAcc(){
    if (!overlays.isActive('MainMenu')) {
      overlays.add('MainMenu');
    }
    else {
      overlays.remove('MainMenu');
    }
  }

}
class MainMenu extends StatefulWidget {
  const MainMenu({Key? key, required this.game}) : super(key: key);

  /// The reference to the game.
  final MyGame game;

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> with TickerProviderStateMixin {
  static Duration duration = const Duration(milliseconds: 250);
  late AnimationController _controller;

  final _fbKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration)
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.dismissed) {
          widget.game.overlays.remove('MainMenu');
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    //_controller.reverse(from: 1.0);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, _) {
        double animationVal = _controller.value;
        double translateVal = (animationVal - 1.0) * 320.0;
        return Transform.translate(
          offset: Offset(translateVal, 0.0),
          child: Drawer(
            child:FormBuilder(
              key: _fbKey,
              child: Column(
                children: <Widget>[
                  FormBuilderTextField(
                    name: 'age',
                    keyboardType: TextInputType.text,

                  ),

                ]
              )


            ),
          ),
        );
      },
    );
  }
}
















