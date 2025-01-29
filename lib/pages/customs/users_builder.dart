import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:wmssimulator/bloc/warehouse/warehouse_interaction_bloc.dart';

class UsersBuilder extends StatefulWidget {
  const UsersBuilder({super.key});

  @override
  State<UsersBuilder> createState() => _UsersBuilderState();
}

class _UsersBuilderState extends State<UsersBuilder> {
  TextEditingController textEditingController = TextEditingController();
  late WarehouseInteractionBloc _warehouseInteractionBloc;
  MultiSelectController multiSelectController = MultiSelectController([
    "Dashboard",
    "Workflow",
    "WMS Cloud",
    "Warehouse",
    "Manage Users",
  ]);

  @override
  void initState() {
    super.initState();
    _warehouseInteractionBloc = context.read<WarehouseInteractionBloc>();
    _warehouseInteractionBloc.add(FilterUsers(searchText: ''));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return PointerInterceptor(
      child: Container(
        height: size.height * 0.8,
        margin: EdgeInsets.only(top: size.height * 0.15),
        alignment: Alignment.topCenter,
        child: LayoutBuilder(builder: (context, lsize) {
          return Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.only(top: lsize.maxHeight * 0.06),
              padding: EdgeInsets.all(lsize.maxHeight * 0.035),
              width: lsize.maxWidth * 0.4,
              height: lsize.maxHeight * 0.8,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        " All Users   ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(_warehouseInteractionBloc.state.users!.length.toString()),
                      Spacer(),
                      SizedBox(
                        height: size.height * 0.05,
                        width: size.width * 0.2,
                        child: LayoutBuilder(builder: (context, constraints) {
                          return TextFormField(
                            controller: textEditingController,
                            textAlign: TextAlign.start,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(fontSize: 15, height: constraints.maxHeight * 0.01),
                            cursorColor: Colors.black,
                            cursorHeight: size.height * 0.025,
                            onChanged: (value) {
                              _warehouseInteractionBloc.add(FilterUsers(searchText: value));
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(top: lsize.maxHeight * 0.01),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  borderSide: BorderSide(color: Colors.black38)),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.black38)),
                              hintStyle: const TextStyle(color: Colors.black38, fontSize: 15),
                              hintText: 'Search',
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                size: lsize.maxHeight * 0.035,
                                color: Colors.black38,
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                  Container(
                    height: lsize.maxHeight * 0.05,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: lsize.maxHeight * 0.02),
                    decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: lsize.maxWidth * 0.01, right: lsize.maxWidth * 0.196),
                          child: Text(
                            'Username',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                        Text(
                          'Access',
                          style: TextStyle(color: Colors.black54),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<WarehouseInteractionBloc, WarehouseInteractionState>(builder: (context, state) {
                      return ListView.separated(
                        itemCount: state.filteredUsers!.length,
                        itemBuilder: (context, index) => Container(
                          padding: EdgeInsets.only(left: size.width * 0.01, right: size.width * 0.008),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                state.filteredUsers![index].username!,
                                style: const TextStyle(fontSize: 15),
                              ),
                              SizedBox(
                                height: size.height * 0.05,
                                width: size.width * 0.12,
                                child: Transform.translate(
                                  offset: Offset(0, -lsize.maxHeight * 0.01),
                                  child: CustomDropdown<String>.multiSelect(
                                    items: const [
                                      "Dashboard",
                                      "Workflow",
                                      "WMS Cloud",
                                      "Warehouse",
                                      "Manage Users",
                                    ],
                                    initialItems: state.filteredUsers![index].access!,
                                    closedHeaderPadding: EdgeInsets.all(lsize.maxHeight * 0.01),
                                    hintBuilder: (context, hint, enabled) {
                                      return const Text('Configure Access');
                                    },
                                    decoration: CustomDropdownDecoration(
                                        listItemDecoration: ListItemDecoration(selectedIconColor: const Color.fromRGBO(68, 98, 136, 1)),
                                        hintStyle: TextStyle(fontSize: 12),
                                        expandedBorder: Border.all(color: Colors.black38),
                                        expandedShadow: [BoxShadow(blurRadius: 5, color: Colors.grey.shade500)]),
                                    hideSelectedFieldWhenExpanded: true,
                                    onListChanged: (value) {
                                      if (value.isEmpty) {
                                        value.add('Dashboard');
                                      }
                                      state.filteredUsers![index].access = value;
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        separatorBuilder: (context, index) => Divider(
                          indent: size.width * 0.01,
                          endIndent: size.width * 0.01,
                          color: Colors.grey.shade300,
                        ),
                      );
                    }),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.01, horizontal: size.height * 0.012),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            _warehouseInteractionBloc.add(FilterUsers(searchText: ''));
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color.fromRGBO(68, 98, 136, 1),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                          child: Text('Discard'),
                        ),
                        Gap(size.width * 0.005),
                        TextButton(
                          onPressed: () {
                            _warehouseInteractionBloc.state.filteredUsers!.removeWhere((e) =>
                                e.access.toString() ==
                                _warehouseInteractionBloc.state.users![_warehouseInteractionBloc.state.filteredUsers!.indexOf(e)].access.toString());
                            for (var e in _warehouseInteractionBloc.state.filteredUsers!) {
                              _warehouseInteractionBloc.state.users!.where((i) => i.username == e.username).first.access = e.access;
                            }
                            _warehouseInteractionBloc.add(UpdateUserAccess(updatedUsers: _warehouseInteractionBloc.state.filteredUsers!));
                            print(_warehouseInteractionBloc.state.filteredUsers!.length);
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color.fromRGBO(68, 98, 136, 1),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                          child: Text('Save'),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
