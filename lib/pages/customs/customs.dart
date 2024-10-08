import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:warehouse_3d/inits/init.dart';
import 'package:warehouse_3d/js_interop_service/js_inter.dart';

class Customs {
  
  static Widget DataSheet({required Size size, required String title,required List<Widget> children}) {
    return Container(
      height: size.height,
      width: size.width * 0.22,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
          border: Border(left: BorderSide(), top: BorderSide(), bottom: BorderSide())),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [IconButton(onPressed: () => getIt<JsInteropService>().switchToMainCam(), icon: Icon(Icons.close_rounded))],),
          Container(
            height: size.height * 0.06,
            width: size.width * 0.12,
            margin: EdgeInsets.symmetric(vertical: size.height * 0.005),
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: Color.fromRGBO(92, 63, 182, 1), borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          Gap(size.height * 0.02),
          ...children
        ],
      ),
    );
  }

  static Widget MapInfo({required Size size, required List<String> keys, required List<String> values}) {
    return Row(
      children: [
        Gap(size.width * 0.025),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              keys.length * 2 - 1,
              (index) => index % 2 == 0 ? Text(keys[index ~/ 2]) : Gap(size.height * 0.02),
            )),
        Gap(size.width * 0.01),
        Column(
            children: List.generate(
          keys.length * 2 - 1,
          (index) => index % 2 == 0 ? const Text(':') : Gap(size.height * 0.02),
        )),
        Gap(size.width * 0.01),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              keys.length * 2 - 1,
              (index) => index % 2 == 0 ? Text(values[index ~/ 2]) : Gap(size.height * 0.02),
            ))
      ],
    );
  }
}


// this class is used to add shadow along the clipped path
@immutable
class ClipShadowPath extends StatelessWidget {
  final Shadow shadow;
  final CustomClipper<Path> clipper;
  final Widget child;

  const ClipShadowPath({
    super.key,
    required this.shadow,
    required this.clipper,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ClipShadowShadowPainter(
        clipper: clipper,
        shadow: shadow,
      ),
      child: ClipPath(clipper: clipper, child: child),
    );
  }
}

// this class is used to paint the shadow along the path that is clipped.
class _ClipShadowShadowPainter extends CustomPainter {
  final Shadow shadow;
  final CustomClipper<Path> clipper;

  _ClipShadowShadowPainter({required this.shadow, required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = shadow.toPaint();
    var clipPath = clipper.getClip(size).shift(shadow.offset);
    canvas.drawPath(clipPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}