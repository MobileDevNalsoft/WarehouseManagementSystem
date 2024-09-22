// import 'dart:html' as html;
// import 'dart:ui_web';
// import 'package:flutter/material.dart';


// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     print('started building');
    
//     return MaterialApp(
//       title: 'Flutter Web with Three.js',
//       home: Scaffold(
//         appBar: AppBar(title: Text('3D Model Viewer')),
//         body: MyHtmlWidget(),
//       ),
//     );
//   }
// }

// class MyHtmlWidget extends StatefulWidget {
//   @override
//   _MyHtmlWidgetState createState() => _MyHtmlWidgetState();
// }

// class _MyHtmlWidgetState extends State<MyHtmlWidget> {
//   @override
//   void initState() {
//     super.initState();
//     print('in init state');
//     registerElementFactory();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return HtmlElementView(
//       viewType: 'my-html-view',
//     );
//   }

//   void registerElementFactory() {
//     // Register the view factory for HtmlElementView.
//     print('started execution');
//     platformViewRegistry.registerViewFactory(
//       'my-html-view',
//       (int viewId) => html.DivElement()
//         ..id = 'my-html-view'
//         ..innerHtml = '''
//           <!DOCTYPE html>
//           <html lang="en">
//           <head>
//               <meta charset="UTF-8">
//               <meta name="viewport" content="width=device-width, initial-scale=1.0">
//               <title>Flutter Web with Three.js</title>
//               <style>
//                   body { margin: 0; }
//                   canvas { display: block; }
//               </style>
//               <script type="application/javascript" src="/assets/packages/flutter_inappwebview/assets/web/web_support.js" defer></script>
//           </head>
//           <body>
//               <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
//               <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/examples/js/loaders/GLTFLoader.js"></script>
//               <script>
//                   let scene, camera, renderer;

//                   function init() {
//                       scene = new THREE.Scene();
//                       camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
//                       renderer = new THREE.WebGLRenderer();
//                       renderer.setSize(window.innerWidth, window.innerHeight);
//                       document.body.appendChild(renderer.domElement);

//                       const loader = new THREE.GLTFLoader();
//                       loader.load('path/to/your_model.glb', function(gltf) {
//                           scene.add(gltf.scene);
//                           animate();
//                       });

//                       camera.position.z = 5;
//                       window.addEventListener('resize', onWindowResize);
//                   }

//                   function animate() {
//                       requestAnimationFrame(animate);
//                       renderer.render(scene, camera);
//                   }

//                   function onWindowResize() {
//                       camera.aspect = window.innerWidth / window.innerHeight;
//                       camera.updateProjectionMatrix();
//                       renderer.setSize(window.innerWidth, window.innerHeight);
//                   }

//                   init();
//               </script>
//           </body>
//           </html>
//         ''',
//     );
//   }
// }