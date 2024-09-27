// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:model_viewer_plus/model_viewer_plus.dart';
// import 'package:warehouse_3d/bloc/warehouse_interaction_bloc.dart';

// class ThreeDTesting extends StatefulWidget {
//   const ThreeDTesting({super.key});

//   @override
//   State<ThreeDTesting> createState() => _ThreeDTestingState();
// }

// class _ThreeDTestingState extends State<ThreeDTesting> with TickerProviderStateMixin {
//   DraggableScrollableController draggableScrollableController = DraggableScrollableController();

//   late WarehouseInteractionBloc _warehouseInteractionBloc;

//   @override
//   void initState() {
//     super.initState();
//     _warehouseInteractionBloc = context.read<WarehouseInteractionBloc>();
//   }

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
//     Size size = MediaQuery.sizeOf(context);
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         // ensures scrollable widgets doesnt scroll underneath the appbar.
//         scrolledUnderElevation: 0,
//         elevation: 0,
//         toolbarHeight: size.height * 0.08,
//         backgroundColor: Colors.black45,
//         leadingWidth: size.width * 0.14,
//         leading: Container(
//           margin: EdgeInsets.only(left: size.width * 0.025, right: size.width * 0.025),
//           decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.black,
//               boxShadow: [BoxShadow(blurRadius: 10, blurStyle: BlurStyle.outer, spreadRadius: 0, color: Colors.orange.shade200, offset: const Offset(0, 0))]),
//           child: Transform(
//             transform: Matrix4.translationValues(-3, 0, 0),
//             child: IconButton(
//                 onPressed: () {
//                   // pops the current page from the stack
//                 },
//                 icon: Icon(
//                   Icons.arrow_back_rounded,
//                   color: Colors.white,
//                   size: size.height * 0.028,
//                 )),
//           ),
//         ),
//         title: Container(
//             alignment: Alignment.center,
//             height: size.height * 0.05,
//             width: size.width * 0.35,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 color: Colors.black,
//                 boxShadow: [BoxShadow(blurRadius: 10, blurStyle: BlurStyle.outer, spreadRadius: 0, color: Colors.orange.shade200, offset: const Offset(0, 0))]),
//             child: const Text(
//               textAlign: TextAlign.center,
//               '3D Testing',
//               style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 18),
//             )),
//         centerTitle: true,
//       ),
//       body: Container(
//         height: size.height,
//         width: size.width,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//               colors: [Colors.black45, Colors.black26, Colors.black45], begin: Alignment.topCenter, end: Alignment.bottomCenter, stops: [0.1, 0.5, 1]),
//         ),
//         child: Stack(
//           alignment: Alignment.topCenter,
//           children: [
//             SizedBox(
//               height: size.height * 0.4,
//               width: size.width * 0.98,
//               child: Transform.scale(
//                 scale: 1.5,
//                 child: const ModelViewer(
//                   src: 'assets/3d_models/warehouse.glb',
//                   iosSrc: 'assets/3d_models/warehouse.glb',
//                   interactionPrompt: InteractionPrompt.none,
//                   disableZoom: false,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
