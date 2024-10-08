import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:warehouse_3d/bloc/warehouse_interaction_bloc.dart';
import 'package:warehouse_3d/inits/init.dart';
import 'package:warehouse_3d/js_interop_service/js_inter.dart';

class Customs {
  
  static Widget DataSheet({required Size size, required String title,required List<Widget> children,controller,required BuildContext context}) {
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
