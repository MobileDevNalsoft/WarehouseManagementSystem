import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:warehouse_3d/bloc/inspection_area/inspection_area_bloc.dart';
import 'package:warehouse_3d/pages/customs/customs.dart';

class InspectionAreaDataSheet extends StatefulWidget {
  const InspectionAreaDataSheet({super.key});

  @override
  State<InspectionAreaDataSheet> createState() => _InspectionAreaDataSheetState();
}

class _InspectionAreaDataSheetState extends State<InspectionAreaDataSheet> {
  late InspectionAreaBloc _inspectionAreaBloc;

  @override
  void initState() {
    super.initState();

    _inspectionAreaBloc = context.read<InspectionAreaBloc>();
    if (_inspectionAreaBloc.state.getDataState == GetDataState.initial) {
      _inspectionAreaBloc.add(const GetInspectionAreaData());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Customs.DataSheet(
      context: context,
      size: size,
      title: 'Inspection Area',
      children: [
        const Text(
            'Materials',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          Gap(size.height * 0.02),
          BlocBuilder<InspectionAreaBloc, InspectionAreaState>(
            builder: (context, state) {
              bool isEnabled = state.getDataState != GetDataState.success;
              return Skeletonizer(
                  enabled: isEnabled,
                  enableSwitchAnimation: true,
                  child: SizedBox(
                    height: size.height * 0.6,
                    child: ListView.separated(
                        itemBuilder: (context, index) => Customs.MapInfo(size: size, keys: [
                              'ASN',
                              'PO',
                              'Vendor',
                              'LPN',
                              'Item',
                              'Quantity'
                            ], values: [
                              isEnabled ? 'ASN' : state.inspectionAreaItems![index].asn!,
                              isEnabled ? 'PO' : state.inspectionAreaItems![index].poNum!,
                              isEnabled ? 'Vendor' : state.inspectionAreaItems![index].vendor!,
                              isEnabled ? 'LPN' : state.inspectionAreaItems![index].lpnNum!.toString(),
                              isEnabled ? 'Item' : state.inspectionAreaItems![index].item!,
                              isEnabled ? 'Quantity' : state.inspectionAreaItems![index].qty!.toString()
                            ]),
                        separatorBuilder: (context, index) => Gap(size.height * 0.025),
                        itemCount: isEnabled ? 8 : state.inspectionAreaItems!.length),
                  ));
            },
          )
      ]
    );
  }
}
