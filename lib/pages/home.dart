import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:warehouse_3d/pages/customs/customs.dart';

import '../inits/init.dart';
import '../navigations/navigator_service.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Service to handle navigation within the app
  final NavigatorService navigator = getIt<NavigatorService>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blue.shade100, Colors.white], begin: Alignment.centerLeft, end: Alignment.centerRight, stops: [0.5, 1])
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: ClipShadowPath(
                shadow: BoxShadow(blurRadius: 20, blurStyle: BlurStyle.outer, spreadRadius: 25, color: Colors.black, offset: const Offset(0, 0)),
                clipper: BackGroundClipper(),
                child: Container(
                  height: size.height*0.93,
                  width: size.width*0.45,
                  decoration: BoxDecoration(color: Colors.blue.shade900),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gap(size.height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Gap(size.width*0.015),
                    Image.asset('assets/images/nalsoft_logo.png', scale: 4, isAntiAlias: true,),
                    MaxGap(size.width),
                    TextButton(
                      onPressed: () {
                        
                      },
                      style: TextButton.styleFrom(
                          side: BorderSide(
                            color: Colors.blue.shade900,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          minimumSize: Size(size.width * 0.05, size.height * 0.05)),
                      child: Text(
                        'Log in',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ),
                    Gap(size.width * 0.005),
                    TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.blue.shade900,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: Size(size.width * 0.05, size.height * 0.05)),
                        child: Text(
                          'Sign up',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        )),
                    Gap(size.width * 0.02)
                  ],
                ),
                Divider(indent: size.width*0.02, endIndent: size.width*0.02, color: Colors.blue.shade900,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: size.width * 0.03, top: size.height * 0.2),
                          child: Text(
                            'WMS\nWarehouse Simulator ',
                            style: TextStyle(fontSize: 80, color: Colors.blue.shade900, fontWeight: FontWeight.w900),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: size.width * 0.25, top: size.height * 0.01),
                          child: Row(
                            children: [
                              Text(
                                'Unlock your warehouse ',
                                style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w900),
                              ),
                              InkWell(
                                onTap: () {
                                  navigator.push('/warehouse');
                                },
                                child: Text(
                                'POTENTIAL',
                                style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w900, decoration: TextDecoration.underline),
                                
                              ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Gap(size.height*0.18),
                        Padding(
                          padding: EdgeInsets.only(right: size.width*0.03),
                          child: LottieBuilder.asset(
                            'assets/lottie/home_warehouse.json',
                            height: size.height * 0.5,
                            width: size.width * 0.4,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class BackGroundClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(size.width*0.7, size.height*0.2);
    path.lineTo(size.width*0.96, size.height*0.2);
    path.lineTo(size.width*0.96, size.height*0.75);
    path.lineTo(size.width*0.23, size.height*0.75);
    path.lineTo(0, size.height*0.87);
    path.lineTo(size.width*0.3, size.height);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => oldClipper != this;
}