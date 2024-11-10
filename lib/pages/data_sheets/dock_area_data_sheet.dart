import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:warehouse_3d/bloc/dock_area/dock_area_bloc.dart';
import 'package:warehouse_3d/pages/customs/customs.dart';

class DockAreaDataSheet extends StatefulWidget {
  const DockAreaDataSheet({super.key});

  @override
  State<DockAreaDataSheet> createState() => _DockAreaDataSheetState();
}

class _DockAreaDataSheetState extends State<DockAreaDataSheet> {
  final ScrollController _controller = ScrollController();
  late DockAreaBloc _dockAreaBloc;

  @override
  void initState() {
    super.initState();

    _dockAreaBloc = context.read<DockAreaBloc>();
    if (_dockAreaBloc.state.getDataState == GetDataState.initial) {
      _dockAreaBloc.add(const GetDockAreaData());
    }
    _controller.addListener(_scrollListener);
  }

  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      _dockAreaBloc.state.pageNum = _dockAreaBloc.state.pageNum! + 1;
      _dockAreaBloc.add(const GetDockAreaData());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Customs.DataSheet(
      context: context,
      size: size,
      title: 'Dock Area',
      children: [
        const Text(
            'Materials',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          Gap(size.height * 0.02),
          BlocBuilder<DockAreaBloc, DockAreaState>(
            builder: (context, state) {
              bool isEnabled = state.getDataState != GetDataState.success;
              return Skeletonizer(
                  enabled: isEnabled,
                  enableSwitchAnimation: true,
                  child: SizedBox(
                    height: size.height * 0.6,
                    child: ListView.separated(
                        controller: _controller,
                        itemBuilder: (context, index) => index < state.dockAreaItems!.length
                                ? Customs.MapInfo(size: size, keys: [
                              'Dock Type',
                              'Truck No.',
                              'PO No.',
                              'Vendor',
                              'CheckIn TS',
                              'Quantity'
                            ], values: [
                              isEnabled ? 'Dock Type' : state.dockAreaItems![index].dockType!,
                              isEnabled ? 'Truck No.' : state.dockAreaItems![index].truckNum!,
                              isEnabled ? 'PO No.' : state.dockAreaItems![index].poNum!,
                              isEnabled ? 'Vendor' : state.dockAreaItems![index].vendor!,
                              isEnabled ? 'CheckIn TS': state.dockAreaItems![index].checkInTS!,
                              isEnabled ? 'Quantity' : state.dockAreaItems![index].qty!.toString()
                            ]) : Skeletonizer(
                              child: Customs.MapInfo(size: size, keys: [
                                'Dock Type',
                                'Truck No.',
                                'PO No.',
                                'Vendor',
                                'CheckIn TS',
                                'Quantity'
                              ], values: [
                                'Dock Type',
                                'Truck No.',
                                'PO No.',
                                'Vendor',
                                'CheckIn TS',
                                'Quantity'
                              ]),
                            ),
                        separatorBuilder: (context, index) => Gap(size.height * 0.025),
                        itemCount: isEnabled ? 8 : state.dockAreaItems!.length + 1 > (state.pageNum!+1)*100 ? state.dockAreaItems!.length + 1 : state.dockAreaItems!.length),
                  ));
            },
          )
      ]
    );
  }
}
