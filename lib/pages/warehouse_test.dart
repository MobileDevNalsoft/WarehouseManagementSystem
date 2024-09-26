// import 'dart:convert';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lottie/lottie.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:warehouse_3d/bloc/warehouse_interaction_bloc.dart';
// import 'package:warehouse_3d/path_builders/xml_parser.dart';
// import 'package:scroll_to_index/scroll_to_index.dart';
// import '../models/warehouse_model.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import '../path_builders/rack_canvas.dart';
// import 'package:gap/gap.dart';

// class WarehouseTest extends StatefulWidget {
//   const WarehouseTest({super.key});

//   @override
//   State<WarehouseTest> createState() => _WarehouseTestState();
// }

// class _WarehouseTestState extends State<WarehouseTest> with TickerProviderStateMixin {
//   DraggableScrollableController draggableScrollableController = DraggableScrollableController();

//   final ScrollController _listController = ScrollController(initialScrollOffset: 0);
//   final AutoScrollController _autoScrollController = AutoScrollController(initialScrollOffset: 0);

//   late WarehouseInteractionBloc _warehouseInteractionBloc;

//   Future<WarehouseData> getWarehouseData() async {
//     return WarehouseData.fromJson(jsonDecode(await rootBundle.loadString("assets/jsons/warehouse.json")));
//   }

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
//         toolbarHeight: size.height * 0.1,
//         backgroundColor: Colors.black45,
//         leadingWidth: size.width * 0.14,
//         leading: Container(
//           margin: EdgeInsets.only(left: size.width * 0.022, right: size.width * 0.022),
//           decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.black,
//               boxShadow: [BoxShadow(blurRadius: 10, blurStyle: BlurStyle.outer, spreadRadius: 0, color: Colors.orange.shade200, offset: const Offset(0, 0))]),
//           child: Transform(
//             transform: Matrix4.translationValues(-3, 0, 0),
//             child: IconButton(
//                 onPressed: () {
//                   // pops the current page from the stack
//                   Navigator.pop(context);
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
//             width: size.width * 0.45,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: Colors.black,
//                 boxShadow: [BoxShadow(blurRadius: 10, blurStyle: BlurStyle.outer, spreadRadius: 0, color: Colors.orange.shade200, offset: const Offset(0, 0))]),
//             child: const Text(
//               textAlign: TextAlign.center,
//               'Rack 2D',
//               style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 16),
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
//         child: FutureBuilder(
//             future: getWarehouseData(),
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 ZoneData zoneData = snapshot.data!.zones!
//                     .where(
//                       (element) => element.zoneID == _warehouseInteractionBloc.state.zoneID,
//                     )
//                     .toList()[0];
//                 return Stack(
//                   alignment: Alignment.topCenter,
//                   children: [
//                     SizedBox(
//                       height: size.height * 0.5,
//                       child: StaggeredGrid.count(
//                         crossAxisCount: 1,
//                         axisDirection: AxisDirection.right,
//                         children: zoneData.racks!.map((e) {
//                           if (e.type == 'R') {
//                             return Column(
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       e.ID!,
//                                       style: TextStyle(fontSize: 25),
//                                     )
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   height: size.height * 0.45,
//                                   width: size.width * 0.22,
//                                   child: GridView.builder(
//                                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisExtent: size.height * 0.12),
//                                     itemBuilder: (context, index) => InkWell(
//                                       onTap: () {
//                                         _warehouseInteractionBloc.add(SelectedRackOfIndex(index: index, rackID: e.ID!));
//                                       },
//                                       child: Container(
//                                         margin: EdgeInsets.all(size.width * 0.002),
//                                         decoration: BoxDecoration(
//                                             color: e.bins![index].totalQuantity! <= 6
//                                                 ? Colors.green
//                                                 : e.bins![index].totalQuantity! > 10 && e.bins![index].totalQuantity! != 20
//                                                     ? Colors.orange
//                                                     : Colors.red,
//                                             borderRadius: BorderRadius.circular(4)),
//                                         height: size.height * 0.05,
//                                         width: size.width * 0.1,
//                                       ),
//                                     ),
//                                     itemCount: (e.bins!.length / 3).toInt(),
//                                   ),
//                                 )
//                               ],
//                             );
//                           } else {
//                             return StaggeredGridTile.extent(
//                                 crossAxisCellCount: 1,
//                                 mainAxisExtent: size.height * 0.15,
//                                 child: Align(
//                                   alignment: Alignment.center,
//                                   child: Text(
//                                     e.ID!,
//                                     style: const TextStyle(fontSize: 25),
//                                   ),
//                                 ));
//                           }
//                         }).toList(),
//                       ),
//                     ),
//                     BlocBuilder<WarehouseInteractionBloc, WarehouseInteractionState>(
//                       builder: (context, state) {
//                         return DraggableScrollableSheet(
//                           controller: draggableScrollableController,
//                           // Bottom sheet sizes
//                           minChildSize: 0.4,
//                           maxChildSize: 1,
//                           initialChildSize: 0.5,
//                           builder: (context, scrollController) {
//                             RackData rack = zoneData.racks!
//                                 .where(
//                                   (element) => element.ID == state.rackID!,
//                                 )
//                                 .toList()[0];
//                             return Container(
//                               alignment: Alignment.center,
//                               height: size.height * 0.2,
//                               width: size.width,
//                               decoration: const BoxDecoration(
//                                   color: Color.fromRGBO(26, 26, 27, 1),
//                                   borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
//                               child: CustomScrollView(
//                                 controller: scrollController,
//                                 slivers: [
//                                   SliverGap(size.height * 0.02),
//                                   SliverToBoxAdapter(
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         Gap(size.width * 0.45),
//                                         Text(
//                                           state.rackID!,
//                                           // ignore: prefer_const_constructors
//                                           style: TextStyle(color: Colors.white, fontSize: 25),
//                                         ),
//                                         const Spacer(),
//                                       ],
//                                     ),
//                                   ),
//                                   SliverToBoxAdapter(
//                                       child: Row(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Container(
//                                         padding: EdgeInsets.only(top: size.height * 0.18),
//                                         height: size.height * 0.8,
//                                         width: size.width * 0.4,
//                                         child: GridView(
//                                           shrinkWrap: true,
//                                           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                                             crossAxisCount: 3,
//                                             childAspectRatio: size.width / size.height,
//                                           ),
//                                           children: ((state.index!) % 2 == 0 ? rack.bins!.sublist(0, 9) : rack.bins!.sublist(9))
//                                               .map(
//                                                 (e) => InkWell(
//                                                   onTap: () {
//                                                     _warehouseInteractionBloc.add(SelectedBinOfIndex(index: rack.bins!.indexOf(e)));
//                                                   },
//                                                   child: Container(
//                                                     alignment: Alignment.center,
//                                                     margin: EdgeInsets.all(size.width * 0.01),
//                                                     decoration: BoxDecoration(
//                                                         color: e.totalQuantity! <= 6
//                                                             ? Colors.green
//                                                             : e.totalQuantity! > 10 && e.totalQuantity! != 20
//                                                                 ? Colors.orange
//                                                                 : Colors.red),
//                                                     child: Text(
//                                                       e.binID!,
//                                                       style: TextStyle(fontSize: 25),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               )
//                                               .toList(),
//                                         ),
//                                       ),
//                                       Container(
//                                         decoration: BoxDecoration(color: Colors.white),
//                                         child: Column(
//                                           children: [
//                                             Padding(
//                                               padding: EdgeInsets.only(left: size.width * 0.28),
//                                               child: Text(
//                                                 rack.bins![state.binIndex!].binID!,
//                                                 style: TextStyle(color: Colors.white, fontSize: 20),
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   ))
//                                 ],
//                               ),
//                             );
//                           },
//                         );
//                       },
//                     ),
//                   ],
//                 );
//               } else {
//                 return const Center(child: CircularProgressIndicator());
//               }
//             }),
//       ),
//     );
//   }
// }
