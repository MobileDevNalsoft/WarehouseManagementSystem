import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:warehouse_3d/bloc/warehouse_interaction_bloc.dart';
import 'package:warehouse_3d/path_builders/xml_parser.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import '../models/warehouse_model.dart';
import '../path_builders/rack_canvas.dart';
import 'package:gap/gap.dart';

class WarehouseTest extends StatefulWidget {
  const WarehouseTest({super.key});

  @override
  State<WarehouseTest> createState() => _WarehouseTestState();
}

class _WarehouseTestState extends State<WarehouseTest>
    with TickerProviderStateMixin {
  DraggableScrollableController draggableScrollableController =
      DraggableScrollableController();

  final ScrollController _listController =
      ScrollController(initialScrollOffset: 0);
      
  final AutoScrollController _autoScrollController =
      AutoScrollController(initialScrollOffset: 0);

  late WarehouseInteractionBloc _warehouseInteractionBloc;

  Future<WarehouseData> getWarehouseData() async {
    return WarehouseData.fromJson(jsonDecode(
        await rootBundle.loadString("assets/jsons/warehouse_data.json")));
  }

  @override
  void initState() {
    super.initState();
    _warehouseInteractionBloc = context.read<WarehouseInteractionBloc>();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // ensures scrollable widgets doesnt scroll underneath the appbar.
        scrolledUnderElevation: 0,
        elevation: 0,
        toolbarHeight: size.height * 0.08,
        backgroundColor: Colors.black45,
        leadingWidth: size.width * 0.14,
        leading: Container(
          margin: EdgeInsets.only(
              left: size.width * 0.022, right: size.width * 0.022),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                    blurRadius: 10,
                    blurStyle: BlurStyle.outer,
                    spreadRadius: 0,
                    color: Colors.orange.shade200,
                    offset: const Offset(0, 0))
              ]),
          child: Transform(
            transform: Matrix4.translationValues(-3, 0, 0),
            child: IconButton(
                onPressed: () {
                  // pops the current page from the stack
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: size.height * 0.028,
                )),
          ),
        ),
        title: Container(
            alignment: Alignment.center,
            height: size.height * 0.05,
            width: size.width * 0.45,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 10,
                      blurStyle: BlurStyle.outer,
                      spreadRadius: 0,
                      color: Colors.orange.shade200,
                      offset: const Offset(0, 0))
                ]),
            child: const Text(
              textAlign: TextAlign.center,
              'Rack 2D',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 16),
            )),
        centerTitle: true,
      ),
      body: Container(
        height: size.height,
        width: size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.black45, Colors.black26, Colors.black45],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.5, 1]),
        ),
        child: FutureBuilder(
          future: getWarehouseData(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return Stack(
              children: [
                Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: size.height * 0.3,
                                child: GridView.builder(
                                  scrollDirection: Axis.horizontal,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          mainAxisExtent: size.height * 0.2,
                                          crossAxisSpacing: size.height * 0.02,
                                          mainAxisSpacing: size.width * 0.03),
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                        onTap: () {
                                          _warehouseInteractionBloc.add(
                                              SelectedRackOfIndex(index: index));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: snapshot.data!.racks![index].totalQuantity! <= 5 ? Colors.lightGreen : snapshot.data!.racks![index].totalQuantity! > 5 && snapshot.data!.racks![index].totalQuantity! != 10 ? Colors.orange : Colors.red),
                                        ));
                                  },
                                  itemCount: snapshot.data!.racks!.length,
                                ),
                              ),
                            ),
                          ],
                        )
                      ,
                BlocBuilder<WarehouseInteractionBloc, WarehouseInteractionState>(
                  builder: (context, state) {
                    return DraggableScrollableSheet(
                      controller: draggableScrollableController,
                      // Bottom sheet sizes
                      minChildSize: 0.15,
                      maxChildSize: 1,
                      initialChildSize: 0.5,
                      builder: (context, scrollController) {
                        print(snapshot.data!.racks![state.index!].totalQuantity);
                        return Container(
                          alignment: Alignment.center,
                          height: size.height * 0.2,
                          width: size.width,
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(26, 26, 27, 1),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(24),
                                  topRight: Radius.circular(24))),
                          child: CustomScrollView(
                            controller: scrollController,
                            slivers: [
                              SliverGap(size.height*0.02),
                              SliverToBoxAdapter(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Gap(size.width * 0.43),
                                    Text(
                                      'Rack ${snapshot.data!.racks![state.index!].rackId}',
                                      // ignore: prefer_const_constructors
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: Column(
                                  children: [
                                    Gap(size.height * 0.02),
                                    Text(
                                      snapshot.data!.racks![state.index!].categoryName!,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                    Gap(size.height * 0.02),
                                    ...snapshot.data!.racks![state.index!].items!.map((e) => Container(
                                      margin: EdgeInsets.symmetric(vertical: size.height*0.01),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15)
                                      ),
                                      height: size.height*0.06,
                                      width: size.width*0.9,
                                      child: Row(
                                        children: [
                                          Gap(size.width*0.05),
                                          Text(e.itemName!),
                                          Spacer(),
                                          Text('Q ${e.quantity}'),
                                          Gap(size.width*0.05),
                                        ],
                                      ),
                                    ))
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            );
            }else{
              return const CircularProgressIndicator();
            }
          }
        ),
      ),
    );
  }
}
