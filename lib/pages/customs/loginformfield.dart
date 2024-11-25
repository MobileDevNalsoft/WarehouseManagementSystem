import 'package:flutter/material.dart';

// ignore: must_be_immutable
// this custom text form field is used in login button for username and password.
class CustomTextFormField extends StatelessWidget {
  TextEditingController? controller;
  String? hintText;
  Icon? prefixIcon;
  IconButton? suffixIcon;
  String? obscureChar;
  bool? obscureText;
  void Function(String)? onFieldSubmitted;

  CustomTextFormField(
      {super.key, required this.hintText, this.prefixIcon, this.suffixIcon, this.controller, this.obscureText, this.obscureChar, this.onFieldSubmitted}) {}

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.06,
      width: size.width * 0.2,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white, boxShadow: const [
        BoxShadow(color: Color.fromARGB(255, 175, 175, 175), offset: Offset(0, 1), blurRadius: 5),
        BoxShadow(
          color: Colors.white70,
        ),
      ]),
      child: LayoutBuilder(builder: (context, constraints) {
        double aspectRatio;
        if (constraints.maxHeight > constraints.maxWidth) {
          aspectRatio = constraints.maxHeight / constraints.maxWidth;
        } else {
          aspectRatio = constraints.maxWidth / constraints.maxHeight;
        }
        return TextFormField(
          textAlign: TextAlign.start,
          textAlignVertical: TextAlignVertical.center,
          controller: controller,
          style: TextStyle(fontSize: aspectRatio * 2.4),
          cursorColor: Colors.black,
          cursorHeight: constraints.maxHeight * 0.5,
          onFieldSubmitted: onFieldSubmitted,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(bottom: size.height*0.018),
            hintStyle: TextStyle(color: Colors.black26, fontSize: aspectRatio * 2.4),
            hintText: hintText,
            prefixIcon: prefixIcon != null
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.01), // Center icon vertically
                    child: prefixIcon,
                  )
                : null,
            suffixIcon: suffixIcon,
          ),
          obscuringCharacter: obscureChar ?? '*',
          obscureText: obscureText ?? false,
        );
      }),
    );
  }
}
