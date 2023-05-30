import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Animation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Center(
          child: StringAnimator(
            'AM I WORTHY?',
            containerHeight: 50.0,
            fontSize: 30.0,
          ),
        ),
      ),
    );
  }
}

class Character {
  String? value;
  Character(String value) {
    this.value = value;
  }
  static Character get(String char) {
    return Character(char);
  }
}

class StringAnimator extends StatefulWidget {
  final String text;
  final double? containerHeight;
  final double? fontSize;
  StringAnimator(
    this.text, {
    this.containerHeight,
    this.fontSize,
  });
  @override
  _StringAnimatorState createState() => _StringAnimatorState();
}

class _StringAnimatorState extends State<StringAnimator> {
  bool animate = false;
  List<Character> textArray = [];
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.text.length; i++) {
      textArray
          .add(Character.get(widget.text.characters.characterAt(i).toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (value) {
        setState(() {
          animate = true;
        });
      },
      onExit: (value) {
        setState(() {
          animate = false;
        });
      },
      child: Container(
        height: widget.containerHeight ?? 50.0,
        width: 600.0,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: textArray
              .map(
                (e) => AnimatedText(
                  delay: Duration(milliseconds: textArray.indexOf(e) * 50),
                  animate: animate,
                  text: e.value!,
                  containerHeight: widget.containerHeight,
                  fontSize: widget.fontSize,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class AnimatedText extends StatefulWidget {
  final Duration delay;
  final bool animate;
  final String text;
  final double? containerHeight;
  final double? fontSize;
  AnimatedText(
      {required this.delay,
      required this.animate,
      required this.text,
      this.containerHeight,
      this.fontSize});
  @override
  _AnimatedTextState createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with TickerProviderStateMixin {
  late AnimationController controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 350),
  );
  Animation<double>? forwardAnimation;
  Animation<double>? reverseAnimation;
  @override
  void initState() {
    super.initState();
    forwardAnimation =
        Tween<double>(begin: 0.0, end: -10.5).animate(controller);
    reverseAnimation = Tween<double>(begin: 10.5, end: 0.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOutQuint));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animate) {
      if (controller.isDismissed) {
        Future.delayed(widget.delay, () {
          controller.forward();
        });
      }
    } else {
      if (controller.isCompleted) {
        Future.delayed(widget.delay, () {
          controller.reverse();
        });
      }
    }
    return Container(
      height: widget.containerHeight ?? 50.0,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Center(
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: forwardAnimation!,
              builder: (context, child) {
                return Align(
                  alignment: Alignment(0.0, forwardAnimation!.value),
                  child: child,
                );
              },
              child: Text(
                widget.text,
                style: GoogleFonts.montserrat(
                  fontSize: widget.fontSize ?? 30.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
            ),
            AnimatedBuilder(
              animation: reverseAnimation!,
              builder: (context, child) {
                return Align(
                  alignment: Alignment(0.0, reverseAnimation!.value),
                  child: child,
                );
              },
              child: Text(
                widget.text,
                style: GoogleFonts.montserrat(
                  fontSize: widget.fontSize ?? 30.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
