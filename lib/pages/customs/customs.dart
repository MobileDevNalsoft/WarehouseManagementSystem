import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Customs {
  static Widget SheetBody({required Size size, Widget? child}) {
    return Container(
      height: size.height,
      width: size.width * 0.26,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
          border: Border(left: BorderSide(), top: BorderSide(), bottom: BorderSide())),
      child: child,
    );
  }

  static Widget SheetAppBar({required Size size, required String title}) {
    return Container(
      height: size.height * 0.08,
      width: size.width * 0.18,
      margin: EdgeInsets.symmetric(vertical: size.height * 0.005),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Color.fromRGBO(92, 63, 182, 1), borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }

  static Widget MapInfo({required Size size, required List<String> keys, required List<String> values}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
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
          (index) => index % 2 == 0 ? Text(':') : Gap(size.height * 0.02),
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
