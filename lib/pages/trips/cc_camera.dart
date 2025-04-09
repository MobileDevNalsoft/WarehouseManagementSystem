import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class CCTVScreen extends StatefulWidget {
  @override
  _CCTVScreenState createState() => _CCTVScreenState();
}

class _CCTVScreenState extends State<CCTVScreen> with SingleTickerProviderStateMixin {
  late InAppWebViewController webViewController;
  late AnimationController _animationController;

  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(192, 208, 230, 1),
      body: Center(
        child: Wrap(
          children: List.generate(
            10,
            (index) {
              return InkWell(
                onTap: () {
                  showGeneralDialog(
                    context: context,
                    barrierColor: Colors.black45,
                    transitionBuilder: (context, animation, secondaryAnimation, child) {
                      final curvedValue = Curves.bounceInOut.transform(animation.value);
                      return Transform.scale(
                        scale: curvedValue,
                        child: Opacity(
                          opacity: animation.value,
                          child: child,
                        ),
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 300),
                    barrierDismissible: true,
                    barrierLabel: '',
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return StatefulBuilder(builder: (context, setState) {
                        return Center(
                          child: Container(
                            height: size.height * 0.72,
                            width: size.width * 0.46,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: Colors.transparent,
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), spreadRadius: 1, blurRadius: 5)],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: InAppWebView(
                                initialFile: "assets/camera/stream.html",
                                initialSettings: InAppWebViewSettings(
                                  allowsInlineMediaPlayback: true,
                                  mediaPlaybackRequiresUserGesture: false,
                                  javaScriptEnabled: true,
                                ),
                                onWebViewCreated: (controller) {
                                  webViewController = controller;
                                },
                              ),
                            ),
                          ),
                        );
                      });
                    },
                  );
                },
                child: Container(
                  alignment: Alignment.bottomLeft,
                  width: size.width * 0.2,
                  height: size.height * 0.26,
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          'http://localhost:3000/snapshot',
                          fit: BoxFit.cover,
                          width: size.width * 0.2,
                          height: size.height * 0.26,
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                      : null,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 2,
                        left:2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 5.0,
                              sigmaY: 5.0,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              margin: EdgeInsets.all(16),
                              // height: parent.maxHeight * 0.18,
                              child: Text("Cam ${index + 1}", style: TextStyle(color: Colors.white, fontSize: 16)),
                            ),
                          ),
                        ),
                      ),
                       Positioned(
                        top: 8,
                        right: 8,
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _animationController.value,
                              child: child,
                            );
                          },
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
