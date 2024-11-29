import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:wmssimulator/bloc/dock_area/dock_area_bloc.dart';
import 'package:wmssimulator/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:wmssimulator/pages/customs/customs.dart';
import 'package:wmssimulator/pages/customs/expandable_list_view.dart';

class DockAreaDataSheet extends StatefulWidget {
  const DockAreaDataSheet({super.key});

  @override
  State<DockAreaDataSheet> createState() => _DockAreaDataSheetState();
}

class _DockAreaDataSheetState extends State<DockAreaDataSheet> {
  final ScrollController _controller = ScrollController();
  late DockAreaBloc _dockAreaBloc;



late  WarehouseInteractionBloc _warehouseInteractionBloc ;
  @override
  void initState() {
    super.initState();

    _warehouseInteractionBloc = context.read<WarehouseInteractionBloc>();
    _dockAreaBloc = context.read<DockAreaBloc>();
    _dockAreaBloc.add(GetDockAreaData(
        searchText: context.read<WarehouseInteractionBloc>().state.searchText,
        searchArea: context.read<WarehouseInteractionBloc>().state.selectedSearchArea.contains('in') ? "DOCK_IN" : "DOCK_OUT"));

    _controller.addListener(_scrollListener);
  }

  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent && _dockAreaBloc.state.dockAreaItems!.length + 1 > (_dockAreaBloc.state.pageNum! + 1) * 100) {
      _dockAreaBloc.state.pageNum = _dockAreaBloc.state.pageNum! + 1;
      _dockAreaBloc.add(GetDockAreaData(
          searchText: context.read<WarehouseInteractionBloc>().state.searchText,
          searchArea: context.read<WarehouseInteractionBloc>().state.selectedSearchArea.contains('in') ? "DOCK_IN" : "DOCK_OUT"));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Customs.DataSheet(context: context, size: size, title: 'Dock Area', children: [
      BlocBuilder<DockAreaBloc, DockAreaState>(
        builder: (context, state) {
          bool isEnabled = state.getDataState != GetDataState.success;
          return Expanded(
            child: LayoutBuilder(builder: (context, lsize) {
              return (state.getDataState== GetDataState.success &&  state.dockAreaItems!.length==0)?
                      Column(children: [Text(_warehouseInteractionBloc.state.searchText!=null&&_warehouseInteractionBloc.state.searchText !=""?_warehouseInteractionBloc.state.searchText!:"",style: TextStyle(fontWeight: FontWeight.w600,fontSize: lsize.maxWidth*0.048),),Text("Data not found")],)
                     : isEnabled ? Center(child: CircularProgressIndicator(),) : ExpandableListView(data: state.dockAreaItems!, l1StyleData: L1StyleData(height: 60, width: 400, color: Colors.white, dropDownColor: Colors.white), l2StyleData: L2StyleData(height: 60, color: Color.fromRGBO(43, 79, 122, 1), dropDownColor: Color.fromRGBO(43, 79, 122, 1)), l3StyleData: L3StyleData(height: lsize.maxHeight*0.145, color: Color.fromRGBO(127, 161, 202, 1)),);
            }),
          );
        },
      )
    ]);
  }
}


/*
*/