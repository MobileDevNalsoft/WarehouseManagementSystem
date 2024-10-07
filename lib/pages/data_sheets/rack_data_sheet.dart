import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:warehouse_3d/bloc/warehouse_interaction_bloc.dart';
import 'package:warehouse_3d/inits/init.dart';
import 'package:warehouse_3d/js_interop_service/js_inter.dart';
import 'package:warehouse_3d/pages/customs/customs.dart';

class RackDataSheet extends StatefulWidget {
  const RackDataSheet({super.key});

  @override
  State<RackDataSheet> createState() => _RackDataSheetState();
}

class _RackDataSheetState extends State<RackDataSheet> {
  late WarehouseInteractionBloc _warehouseInteractionBloc;

  @override
  void initState() {
    super.initState();

    _warehouseInteractionBloc = context.read<WarehouseInteractionBloc>();
    if (_warehouseInteractionBloc.state.getRacksDataState == GetRacksDataState.initial) {
      _warehouseInteractionBloc.add(GetRacksData());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Customs.SheetBody(
      size: size,
      child: Column(
        children: [
          Customs.SheetAppBar(
            size: size,
            title: 'Storage Rack',
          ),
          Gap(size.height * 0.02),
          BlocConsumer<WarehouseInteractionBloc, WarehouseInteractionState>(
            listenWhen: (previous, current) => previous.getRacksDataState != current.getRacksDataState,
            listener: (context, state) {
              if (state.getRacksDataState == GetRacksDataState.success) {
                _warehouseInteractionBloc.add(SelectedRack(rackID: state.dataFromJS!['rack']));
              }
            },
            builder: (context, state) {
              bool isEnabled = state.getRacksDataState != GetRacksDataState.success;
              return Skeletonizer(
                  enabled: isEnabled,
                  enableSwitchAnimation: true,
                  child: Column(
                    children: [
                      Text(
                        isEnabled ? 'Rack ID' : state.selectedRack!.rackID!,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      Gap(size.height * 0.02),
                      Customs.MapInfo(
                          size: size,
                          keys: ['Category', 'Number of Bins'],
                          values: [isEnabled ? 'Category' : state.selectedRack!.category!, isEnabled ? '50' : state.selectedRack!.bins!.length.toString()])
                    ],
                  ));
            },
          )
        ],
      ),
    );
  }
}
