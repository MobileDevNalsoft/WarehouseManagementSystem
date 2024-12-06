import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:wmssimulator/bloc/warehouse/warehouse_interaction_bloc.dart';
import 'package:wmssimulator/models/user_model.dart';
import 'package:wmssimulator/pages/customs/customs.dart';
import 'package:wmssimulator/pages/customs/loginformfield.dart';

class UsersBuilder extends StatefulWidget {
  const UsersBuilder({super.key});

  @override
  State<UsersBuilder> createState() => _UsersBuilderState();
}

class _UsersBuilderState extends State<UsersBuilder> {

  TextEditingController textEditingController = TextEditingController();
  late WarehouseInteractionBloc _warehouseInteractionBloc;

  @override
  void initState() {
    super.initState();
    _warehouseInteractionBloc = context.read<WarehouseInteractionBloc>();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return PointerInterceptor(
      child: IntrinsicHeight(
        child: Container(
          alignment: Alignment.topCenter,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Material(
                color: Colors.transparent,
                child: Container(
                  margin: EdgeInsets.only(top: size.height * 0.035),
                  width: size.width * 0.35,
                  height: size.height * 0.6,
                  decoration: BoxDecoration(color: Color.fromRGBO(192, 208, 230, 1), borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: size.height * 0.05,
                        width: size.width * 0.35,
                        child: LayoutBuilder(builder: (context, constraints) {
                          double aspectRatio;
                          aspectRatio = constraints.maxWidth / constraints.maxHeight;
                          return TextFormField(
                            controller: textEditingController,
                            textAlign: TextAlign.start,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(fontSize: aspectRatio * 1.6, height: constraints.maxHeight * 0.01),
                            cursorColor: Colors.black,
                            cursorHeight: aspectRatio * 2,
                            onChanged: (value) {
                              _warehouseInteractionBloc.add(FilterUsers(searchText: value));
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: aspectRatio * 0.03,
                              ),
                              hintStyle: TextStyle(color: Colors.black26, fontSize: aspectRatio * 1.6),
                              hintText: 'Search',
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(
                                  top: aspectRatio * 0.6,
                                ), // Center icon vertically
                                child: Icon(Icons.search_rounded),
                              ),
                            ),
                          );
                        }),
                      ),
                      Divider(
                        color: Color.fromRGBO(148, 166, 187, 1),
                      ),
                      Expanded(
                        child: BlocBuilder<WarehouseInteractionBloc, WarehouseInteractionState>(
                          builder: (context, state) {
                            return ListView.separated(
                              itemCount: state.filteredUsers!.length,
                              itemBuilder: (context, index) => Container(
                                padding: EdgeInsets.only(
                                  left: size.width * 0.01,
                                  right: size.width*0.008
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(state.filteredUsers![index].username!, style: TextStyle(fontSize: size.aspectRatio*8),),
                                    SizedBox(
                                      height: size.height*0.06,
                                      width: size.width * 0.1,
                                      child: Transform.translate(
                                        offset: Offset(0, size.height*0.005),
                                        child: CustomDropdown<String>.multiSelect(
                                          items: const [
                                            "Dashboards",
                                            "WMS Cloud",
                                            "3D Model",
                                            "Manage Users",
                                          ],
                                          initialItems: state.filteredUsers![index].access,
                                          hintBuilder: (context, hint, enabled) {
                                            return const Text('Configure Access');
                                          },
                                          decoration: CustomDropdownDecoration(
                                            closedBorder: Border.all(),
                                          ),
                                          hideSelectedFieldWhenExpanded: true,
                                          onListChanged: (value) {
                                            state.filteredUsers![index].access = value;
                                            _warehouseInteractionBloc.add(FilterUsers(searchText: textEditingController.text));
                                            _warehouseInteractionBloc.state.updatedUsers!.add(User(username: state.filteredUsers![index].username, access: value));
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              separatorBuilder: (context, index) => Divider(
                                color: Color.fromRGBO(148, 166, 187, 1),
                              ),
                            );
                          }
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: size.height*0.01, horizontal: size.height*0.012),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                _warehouseInteractionBloc.state.filteredUsers = _warehouseInteractionBloc.state.users;
                                Navigator.pop(context);
                              },
                              child: Text('Discard'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                  backgroundColor: Color.fromRGBO(68, 98, 136, 1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                            ),
                            Gap(size.width*0.005),
                            TextButton(
                              onPressed: () {},
                              child: Text('Save'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                  backgroundColor: Color.fromRGBO(68, 98, 136, 1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              ClipPath(
                clipper: DialogTopClipper(),
                child: CircleAvatar(
                  backgroundColor: Color.fromRGBO(192, 208, 230, 1),
                  radius: 35,
                  child: Transform.translate(offset: Offset(0, -size.height * 0.01), child: Icon(Icons.person_outlined)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
