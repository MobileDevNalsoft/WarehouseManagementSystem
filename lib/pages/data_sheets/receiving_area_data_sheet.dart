import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:warehouse_3d/bloc/receiving/receiving_bloc.dart';
import 'package:warehouse_3d/bloc/receiving/receiving_event.dart';
import 'package:warehouse_3d/bloc/receiving/receiving_state.dart';
import 'package:warehouse_3d/pages/customs/customs.dart';

class ReceivingAreaDataSheet extends StatefulWidget {
  const ReceivingAreaDataSheet({super.key});

  @override
  State<ReceivingAreaDataSheet> createState() => _ReceivingAreaDataSheetState();
}

class _ReceivingAreaDataSheetState extends State<ReceivingAreaDataSheet> {
  final ScrollController _controller = ScrollController();
  ReceivingBloc? _receivingBloc;

  @override
  void initState() {
    super.initState();
    _receivingBloc = context.read<ReceivingBloc>();

    if (_receivingBloc!.state.receivingStatus == ReceivingAreaStatus.initial) {
      _receivingBloc!.add(const GetReceivingData());
    }

    _controller.addListener(_scrollListener);
  }

  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      _receivingBloc!.state.pageNum = _receivingBloc!.state.pageNum! + 1;
      _receivingBloc!.add(const GetReceivingData());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Customs.DataSheet(
        context: context,
        size: size,
        title: 'Receiving Area',
        children: [
          const Text(
            'Materials',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          Gap(size.height * 0.02),
          BlocBuilder<ReceivingBloc, ReceivingState>(
            builder: (context, state) {
              bool isEnabled =
                  state.receivingStatus != ReceivingAreaStatus.success;
              return Skeletonizer(
                  enabled: isEnabled,
                  enableSwitchAnimation: true,
                  child: SizedBox(
                    height: size.height * 0.6,
                    child: ListView.separated(
                        controller: _controller,
                        itemBuilder: (context, index) =>
                            index < state.receiveList!.length
                                ? Customs.MapInfo(size: size, keys: [
                                    'No',
                                    'POs',
                                    'Vendor',
                                    'Item',
                                    'Quantity'
                                  ], values: [
                                    isEnabled
                                        ? 'No'
                                        : state.receiveList![index].asn!,
                                    isEnabled
                                        ? 'POs'
                                        : state.receiveList![index].poNum!,
                                    isEnabled
                                        ? 'Vendor'
                                        : state.receiveList![index].vendor!,
                                    isEnabled
                                        ? 'Item'
                                        : state.receiveList![index].item!,
                                    isEnabled
                                        ? 'Quantity'
                                        : state.receiveList![index].qty!
                                  ])
                                : Skeletonizer(
                                    child: Customs.MapInfo(size: size, keys: [
                                      'No',
                                      'POs',
                                      'Vendor',
                                      'Item',
                                      'Quantity'
                                    ], values: [
                                      'No',
                                      'POs',
                                      'Vendor',
                                      'Item',
                                      'Quantity'
                                    ]),
                                  ),
                        separatorBuilder: (context, index) =>
                            Gap(size.height * 0.025),
                        itemCount:
                            isEnabled ? 8 : state.receiveList!.length + 1 > (state.pageNum!+1)*100 ? state.receiveList!.length + 1 : state.receiveList!.length),
                  ));
            },
          )
        ]);
  }
}
