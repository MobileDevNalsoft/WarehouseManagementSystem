import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:wmssimulator/bloc/container_management/container_bloc.dart';
import 'package:wmssimulator/bloc/workflow/workflow_bloc.dart';
import 'package:wmssimulator/models/container_model.dart';
import 'package:wmssimulator/pages/customs/customs.dart';
import 'package:wmssimulator/pages/customs/hover_card.dart';
import 'package:wmssimulator/pages/customs/hover_dialog.dart';

class ContainerLayout extends StatefulWidget {
  const ContainerLayout({super.key});

  @override
  State<ContainerLayout> createState() => _ContainerLayoutState();
}

class _ContainerLayoutState extends State<ContainerLayout> {
  late final ContainerBloc _containerBloc;
  DateTime now = DateTime(2025, 1, 31)
      // DateTime.now()
      ;
  List<Status> statuses = [
    Status(status: 'Empty', color: const Color.fromRGBO(192, 208, 230, 1)),
    Status(status: 'Loaded', color: Colors.lightBlueAccent.shade200),
    Status(status: 'Unloading', text: 'U', color: const Color.fromRGBO(192, 208, 230, 1)),
    Status(status: 'Loading', text: 'L', color: Colors.lightBlueAccent.shade200),
    Status(status: 'Damaged', text: 'D', color: Colors.red),
    Status(status: 'Detention', color: Colors.red),
  ];
  List<Type> types = [
    Type(type: 'Product', text: 'FP', color: const Color.fromARGB(255, 209, 188, 0)),
    Type(type: 'Raw Material', text: 'RM', color: const Color.fromARGB(255, 209, 188, 0)),
    Type(type: 'Packaging', text: 'PK', color: const Color.fromARGB(255, 209, 188, 0))
  ];

  @override
  void initState() {
    super.initState();
    _containerBloc = context.read<ContainerBloc>();
    _containerBloc.add(GetContainers(facility: 243));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<ContainerBloc, ContainerState>(builder: (context, state) {
      bool isEnabled = state.getContainerStatus != ContainerStatus.success;
      return Column(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.all(size.height * 0.01),
                padding: EdgeInsets.only(left: size.width * 0.02, top: size.height * 0.013),
                decoration: BoxDecoration(
                    color: Colors.black, borderRadius: BorderRadius.circular(25), boxShadow: [const BoxShadow(blurRadius: 5, color: Colors.white)]),
                child: Row(
                  children: [
                    Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    height: size.height * 0.025,
                                    margin: EdgeInsets.only(left: size.width * 0.01, right: size.width * 0.01, top: size.height * 0.008),
                                    decoration: BoxDecoration(color: Colors.amberAccent.shade100, borderRadius: BorderRadius.circular(10)),
                                  ),
                                  Gap(size.height * 0.01),
                                  const Expanded(
                                      child: Text(
                                    'Priority',
                                    style: TextStyle(color: Colors.white, fontSize: 10),
                                  ))
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    height: size.height * 0.025,
                                    margin: EdgeInsets.only(left: size.width * 0.01, right: size.width * 0.01, top: size.height * 0.008),
                                    decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(10)),
                                  ),
                                  Gap(size.height * 0.01),
                                  const Expanded(
                                      child: Text(
                                    'Detention Alert',
                                    style: TextStyle(color: Colors.white, fontSize: 10),
                                  ))
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    height: size.height * 0.025,
                                    margin: EdgeInsets.only(left: size.width * 0.01, right: size.width * 0.01, top: size.height * 0.008),
                                    decoration: BoxDecoration(color: Colors.orangeAccent, borderRadius: BorderRadius.circular(10)),
                                  ),
                                  Gap(size.height * 0.01),
                                  const Expanded(
                                      child: Text(
                                    'Out Bound',
                                    style: TextStyle(color: Colors.white, fontSize: 10),
                                  ))
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    height: size.height * 0.025,
                                    margin: EdgeInsets.only(left: size.width * 0.01, right: size.width * 0.01, top: size.height * 0.008),
                                    decoration: BoxDecoration(color: Colors.greenAccent, borderRadius: BorderRadius.circular(10)),
                                  ),
                                  Gap(size.height * 0.01),
                                  const Expanded(
                                      child: Text(
                                    'In Bound',
                                    style: TextStyle(color: Colors.white, fontSize: 10),
                                  ))
                                ],
                              ),
                            )
                          ],
                        )),
                    Gap(size.width * 0.05),
                    Expanded(
                        flex: 8,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    height: size.height * 0.045,
                                    margin: EdgeInsets.only(left: size.width * 0.01, right: size.width * 0.01),
                                    decoration: BoxDecoration(color: statuses[0].color, borderRadius: BorderRadius.circular(10)),
                                  ),
                                  Gap(size.height * 0.01),
                                  Expanded(
                                      child: Text(
                                    statuses[0].status,
                                    style: const TextStyle(color: Colors.white, fontSize: 10),
                                  ))
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    height: size.height * 0.045,
                                    margin: EdgeInsets.only(left: size.width * 0.01, right: size.width * 0.01),
                                    decoration: BoxDecoration(color: statuses[1].color, borderRadius: BorderRadius.circular(10)),
                                  ),
                                  Gap(size.height * 0.01),
                                  Expanded(child: Text(statuses[1].status, style: const TextStyle(color: Colors.white, fontSize: 10)))
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    height: size.height * 0.045,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(left: size.width * 0.01, right: size.width * 0.01),
                                    decoration: BoxDecoration(color: statuses[2].color, borderRadius: BorderRadius.circular(10)),
                                    child: Text(
                                      statuses[2].text!,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Gap(size.height * 0.01),
                                  Expanded(child: Text(statuses[2].status, style: const TextStyle(color: Colors.white, fontSize: 10)))
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    height: size.height * 0.045,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(left: size.width * 0.01, right: size.width * 0.01),
                                    decoration: BoxDecoration(color: statuses[3].color, borderRadius: BorderRadius.circular(10)),
                                    child: Text(
                                      statuses[3].text!,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Gap(size.height * 0.01),
                                  Expanded(child: Text(statuses[3].status, style: const TextStyle(color: Colors.white, fontSize: 10)))
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    height: size.height * 0.045,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(left: size.width * 0.01, right: size.width * 0.01),
                                    decoration: BoxDecoration(color: statuses[4].color, borderRadius: BorderRadius.circular(10)),
                                    child: Text(
                                      statuses[4].text!,
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Gap(size.height * 0.01),
                                  Expanded(child: Text(statuses[4].status, style: const TextStyle(color: Colors.white, fontSize: 10)))
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    height: size.height * 0.045,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(left: size.width * 0.01, right: size.width * 0.01),
                                    decoration: BoxDecoration(color: statuses[5].color, borderRadius: BorderRadius.circular(10)),
                                    child: Text(
                                      statuses[5].text!,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Gap(size.height * 0.01),
                                  Expanded(child: Text(statuses[5].status, style: const TextStyle(color: Colors.white, fontSize: 10)))
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    height: size.height * 0.045,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(left: size.width * 0.01, right: size.width * 0.01),
                                    decoration: BoxDecoration(color: types[0].color, borderRadius: BorderRadius.circular(10)),
                                    child: Text(
                                      types[0].text,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Gap(size.height * 0.01),
                                  Expanded(child: Text(types[0].type, style: const TextStyle(color: Colors.white, fontSize: 10)))
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    height: size.height * 0.045,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(left: size.width * 0.01, right: size.width * 0.01),
                                    decoration: BoxDecoration(color: types[1].color, borderRadius: BorderRadius.circular(10)),
                                    child: Text(
                                      types[1].text,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Gap(size.height * 0.01),
                                  Expanded(child: Text(types[1].type, style: const TextStyle(color: Colors.white, fontSize: 10)))
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    height: size.height * 0.045,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(left: size.width * 0.01, right: size.width * 0.01),
                                    decoration: BoxDecoration(color: types[0].color, borderRadius: BorderRadius.circular(10)),
                                    child: Text(
                                      types[2].text,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Gap(size.height * 0.01),
                                  Expanded(child: Text(types[2].type, style: const TextStyle(color: Colors.white, fontSize: 10)))
                                ],
                              ),
                            ),
                            Gap(size.width * 0.02)
                          ],
                        )),
                    Transform.translate(
                      offset: Offset(-size.width * 0.01, -size.height * 0.008),
                      child: TextButton(
                          onPressed: () {
                            state.containerNbr = '';
                            state.toLocation = '';
                            Customs.LocateContainerDialog(context: context);
                          },
                          style: TextButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
                          child: Text(
                            'Locate',
                          )),
                    )
                  ],
                ),
              )),
          Expanded(
            flex: 7,
            child: Container(
                margin: EdgeInsets.all(size.height * 0.01),
                padding: EdgeInsets.only(left: size.width * 0.02),
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(67, 82, 103, 1),
                    border: Border.all(color: Colors.white, width: 3),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), bottomLeft: Radius.circular(25)),
                    boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey.shade500)]),
                child: isEnabled
                    ? const CircularProgressIndicator()
                    : SingleChildScrollView(
                        child: SizedBox(
                          height: size.height * 1.3,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: List.generate(12, (index) {
                                      bool isOccupied = state.containers!.where((e) => e.lotNbr == index + 1).isNotEmpty;
                                      ContainerData? container = isOccupied ? state.containers!.where((e) => e.lotNbr == index + 1).first : null;
                                      bool inDetention = container != null ? now.difference(container.arrivalDate!).inDays > 3 : false;
                                      bool isPriorOrDetention = container != null ? container.priority! || inDetention : false;
                                      return Column(
                                        children: [
                                          Container(
                                            height: size.height * 0.03,
                                            width: size.width * 0.06,
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                                border: Border(
                                                    left: BorderSide(color: Colors.white),
                                                    right: BorderSide(color: Colors.white),
                                                    top: BorderSide(color: Colors.white))),
                                            child: Text(
                                              (index + 1).toString(),
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                          ),
                                          Stack(
                                            alignment: Alignment.topCenter,
                                            children: [
                                              Container(
                                                height: size.height * 0.2,
                                                width: size.width * 0.06,
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        left: BorderSide(width: index == 0 ? 4 : 2, color: Colors.white),
                                                        right: BorderSide(width: index == 11 ? 4 : 2, color: Colors.white),
                                                        top: const BorderSide(width: 2, color: Colors.white))),
                                              ),
                                              if (container != null)
                                                HoverCard(
                                                  hoveredContainer: container,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        height: size.height * 0.12,
                                                        width: size.width * 0.05,
                                                        alignment: Alignment.center,
                                                        margin: EdgeInsets.only(top: size.height * 0.01),
                                                        decoration: BoxDecoration(
                                                            color: inDetention ? statuses.last.color : statuses[container.status!].color,
                                                            border: Border.all(width: 2)),
                                                        child: Text(
                                                          inDetention ? statuses.last.text! : statuses[container.status!].text!,
                                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: size.height * 0.015,
                                                        width: size.width * 0.05,
                                                        margin: EdgeInsets.only(top: size.height * 0.001),
                                                        decoration: BoxDecoration(
                                                            color: container.bound! == "IN" ? Colors.greenAccent : Colors.orangeAccent,
                                                            border: Border.all(width: 2)),
                                                      ),
                                                      Container(
                                                        height: size.height * 0.065,
                                                        width: size.width * 0.05,
                                                        margin: EdgeInsets.only(top: size.height * 0.001),
                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(color: types[container.type!].color, border: Border.all(width: 2)),
                                                        child: Text(
                                                          types[container.type!].text,
                                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                      if (isPriorOrDetention)
                                                        Container(
                                                          height: size.height * 0.015,
                                                          width: size.width * 0.05,
                                                          margin: EdgeInsets.only(top: size.height * 0.001),
                                                          decoration: BoxDecoration(
                                                              color: container.priority! ? Colors.amberAccent.shade100 : Colors.red,
                                                              border: Border.all(width: 2)),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                                  Gap(size.height * 0.12),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: List.generate(12, (index) {
                                      index = index + 13;
                                      bool isOccupied = state.containers!.where((e) => e.lotNbr == index).isNotEmpty;
                                      ContainerData? container = isOccupied ? state.containers!.where((e) => e.lotNbr == index).first : null;
                                      bool inDetention = container != null ? now.difference(container.arrivalDate!).inDays > 3 : false;
                                      bool isPriorOrDetention = container != null ? container.priority! || inDetention : false;
                                      return Column(
                                        children: [
                                          Stack(
                                            alignment: Alignment.bottomCenter,
                                            children: [
                                              Container(
                                                height: size.height * 0.2,
                                                width: size.width * 0.06,
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        left: BorderSide(width: index == 0 ? 4 : 2, color: Colors.white),
                                                        right: BorderSide(width: index == 11 ? 4 : 2, color: Colors.white),
                                                        bottom: const BorderSide(width: 2, color: Colors.white))),
                                              ),
                                              if (container != null)
                                                Transform.translate(
                                                  offset: Offset(0, -size.height * (isPriorOrDetention ? 0.018 : 0.003)),
                                                  child: HoverCard(
                                                    topMargin: false,
                                                    hoveredContainer: container,
                                                    child: Column(
                                                      children: [
                                                        if (isPriorOrDetention)
                                                          Container(
                                                            height: size.height * 0.015,
                                                            width: size.width * 0.05,
                                                            decoration: BoxDecoration(
                                                                color: container.priority! ? Colors.amberAccent.shade100 : Colors.red,
                                                                border: Border.all(width: 2)),
                                                          ),
                                                        Container(
                                                          height: size.height * 0.065,
                                                          width: size.width * 0.05,
                                                          margin: EdgeInsets.only(top: size.height * 0.001),
                                                          alignment: Alignment.center,
                                                          decoration: BoxDecoration(color: types[container.type!].color, border: Border.all(width: 2)),
                                                          child: Text(
                                                            types[container.type!].text,
                                                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: size.height * 0.015,
                                                          width: size.width * 0.05,
                                                          margin: EdgeInsets.only(top: size.height * 0.001),
                                                          decoration: BoxDecoration(
                                                              color: container.bound! == "IN" ? Colors.greenAccent : Colors.orangeAccent,
                                                              border: Border.all(width: 2)),
                                                        ),
                                                        Container(
                                                          height: size.height * 0.12,
                                                          width: size.width * 0.05,
                                                          alignment: Alignment.center,
                                                          margin: EdgeInsets.only(top: size.height * 0.001, bottom: size.height * 0.01),
                                                          decoration: BoxDecoration(
                                                              color: inDetention ? statuses.last.color : statuses[container.status!].color,
                                                              border: Border.all(width: 2)),
                                                          child: Text(
                                                            inDetention ? statuses.last.text! : statuses[container.status!].text!,
                                                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          Container(
                                            height: size.height * 0.03,
                                            width: size.width * 0.06,
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                                border: Border(
                                                    left: BorderSide(color: Colors.white),
                                                    right: BorderSide(color: Colors.white),
                                                    bottom: BorderSide(color: Colors.white))),
                                            child: Text(
                                              index.toString(),
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                                  Container(
                                    height: size.height * 0.02,
                                    width: size.width * 0.72,
                                    color: const Color.fromARGB(255, 132, 209, 53),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: List.generate(12, (index) {
                                      index = index + 25;
                                      bool isOccupied = state.containers!.where((e) => e.lotNbr == index).isNotEmpty;
                                      ContainerData? container = isOccupied ? state.containers!.where((e) => e.lotNbr == index).first : null;
                                      bool inDetention = container != null ? now.difference(container.arrivalDate!).inDays > 3 : false;
                                      bool isPriorOrDetention = container != null ? container.priority! || inDetention : false;
                                      return Column(
                                        children: [
                                          Container(
                                            height: size.height * 0.03,
                                            width: size.width * 0.06,
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                                border: Border(
                                                    left: BorderSide(color: Colors.white),
                                                    right: BorderSide(color: Colors.white),
                                                    top: BorderSide(color: Colors.white))),
                                            child: Text(
                                              index.toString(),
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                          ),
                                          Stack(
                                            alignment: Alignment.topCenter,
                                            children: [
                                              Container(
                                                height: size.height * 0.2,
                                                width: size.width * 0.06,
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        left: BorderSide(width: index == 0 ? 4 : 2, color: Colors.white),
                                                        right: BorderSide(width: index == 11 ? 4 : 2, color: Colors.white),
                                                        top: const BorderSide(width: 2, color: Colors.white))),
                                              ),
                                              if (container != null)
                                                HoverCard(
                                                  hoveredContainer: container,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        height: size.height * 0.12,
                                                        width: size.width * 0.05,
                                                        alignment: Alignment.center,
                                                        margin: EdgeInsets.only(top: size.height * 0.01),
                                                        decoration: BoxDecoration(
                                                            color: inDetention ? statuses.last.color : statuses[container.status!].color,
                                                            border: Border.all(width: 2)),
                                                        child: Text(
                                                          inDetention ? statuses.last.text! : statuses[container.status!].text!,
                                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: size.height * 0.015,
                                                        width: size.width * 0.05,
                                                        margin: EdgeInsets.only(top: size.height * 0.001),
                                                        decoration: BoxDecoration(
                                                            color: container.bound! == "IN" ? Colors.greenAccent : Colors.orangeAccent,
                                                            border: Border.all(width: 2)),
                                                      ),
                                                      Container(
                                                        height: size.height * 0.065,
                                                        width: size.width * 0.05,
                                                        margin: EdgeInsets.only(top: size.height * 0.001),
                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(color: types[container.type!].color, border: Border.all(width: 2)),
                                                        child: Text(
                                                          types[container.type!].text,
                                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                      if (isPriorOrDetention)
                                                        Container(
                                                          height: size.height * 0.015,
                                                          width: size.width * 0.05,
                                                          margin: EdgeInsets.only(top: size.height * 0.001),
                                                          decoration: BoxDecoration(
                                                              color: container.priority! ? Colors.amberAccent.shade100 : Colors.red,
                                                              border: Border.all(width: 2)),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                                  Gap(size.height * 0.12),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: List.generate(12, (index) {
                                      index = index + 37;
                                      bool isOccupied = state.containers!.where((e) => e.lotNbr == index).isNotEmpty;
                                      ContainerData? container = isOccupied ? state.containers!.where((e) => e.lotNbr == index).first : null;
                                      bool inDetention = container != null ? now.difference(container.arrivalDate!).inDays > 3 : false;
                                      bool isPriorOrDetention = container != null ? container.priority! || inDetention : false;
                                      return Column(
                                        children: [
                                          Stack(
                                            alignment: Alignment.bottomCenter,
                                            children: [
                                              Container(
                                                height: size.height * 0.2,
                                                width: size.width * 0.06,
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        left: BorderSide(width: index == 0 ? 4 : 2, color: Colors.white),
                                                        right: BorderSide(width: index == 11 ? 4 : 2, color: Colors.white),
                                                        bottom: const BorderSide(width: 2, color: Colors.white))),
                                              ),
                                              if (container != null)
                                                Transform.translate(
                                                  offset: Offset(0, -size.height * (isPriorOrDetention ? 0.018 : 0.003)),
                                                  child: HoverCard(
                                                    topMargin: false,
                                                    hoveredContainer: container,
                                                    child: Column(
                                                      children: [
                                                        if (isPriorOrDetention)
                                                          Container(
                                                            height: size.height * 0.015,
                                                            width: size.width * 0.05,
                                                            decoration: BoxDecoration(
                                                                color: container.priority! ? Colors.amberAccent.shade100 : Colors.red,
                                                                border: Border.all(width: 2)),
                                                          ),
                                                        Container(
                                                          height: size.height * 0.065,
                                                          width: size.width * 0.05,
                                                          margin: EdgeInsets.only(top: size.height * 0.001),
                                                          alignment: Alignment.center,
                                                          decoration: BoxDecoration(color: types[container.type!].color, border: Border.all(width: 2)),
                                                          child: Text(
                                                            types[container.type!].text,
                                                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: size.height * 0.015,
                                                          width: size.width * 0.05,
                                                          margin: EdgeInsets.only(top: size.height * 0.001),
                                                          decoration: BoxDecoration(
                                                              color: container.bound! == "IN" ? Colors.greenAccent : Colors.orangeAccent,
                                                              border: Border.all(width: 2)),
                                                        ),
                                                        Container(
                                                          height: size.height * 0.12,
                                                          width: size.width * 0.05,
                                                          alignment: Alignment.center,
                                                          margin: EdgeInsets.only(top: size.height * 0.001, bottom: size.height * 0.01),
                                                          decoration: BoxDecoration(
                                                              color: inDetention ? statuses.last.color : statuses[container.status!].color,
                                                              border: Border.all(width: 2)),
                                                          child: Text(
                                                            inDetention ? statuses.last.text! : statuses[container.status!].text!,
                                                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          Container(
                                            height: size.height * 0.03,
                                            width: size.width * 0.06,
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                                border: Border(
                                                    left: BorderSide(color: Colors.white),
                                                    right: BorderSide(color: Colors.white),
                                                    bottom: BorderSide(color: Colors.white))),
                                            child: Text(
                                              index.toString(),
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                  )
                                ],
                              ),
                              const Spacer(),
                              Container(
                                height: double.infinity,
                                width: size.width * 0.06,
                                alignment: Alignment.centerRight,
                                decoration:
                                    const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/parking_entry_exit.jpg'), fit: BoxFit.fill)),
                              )
                            ],
                          ),
                        ),
                      )),
          ),
        ],
      );
    });
  }
}

class Status {
  String status;
  String? text;
  Color color;
  Status({required this.status, this.text = '', required this.color});
}

class Type {
  String type;
  String text;
  Color color;
  Type({required this.type, required this.text, required this.color});
}
