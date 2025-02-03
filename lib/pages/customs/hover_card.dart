import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wmssimulator/bloc/container_management/container_bloc.dart';
import 'package:wmssimulator/models/container_model.dart';

class HoverCard extends StatefulWidget {
  HoverCard({super.key, required this.child, this.topMargin = true, required this.hoveredContainer});

  Widget child;
  bool topMargin;
  ContainerData hoveredContainer;
  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  double x = 0;
  double y = 0;
  late final ContainerBloc _containerBloc;

  @override
  void initState() {
    super.initState();
    _containerBloc = context.read<ContainerBloc>();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: size.height * 0.2,
          width: size.width * 0.05,
          margin: EdgeInsets.only(top: widget.topMargin ? size.height * 0.01 : 0, bottom: !widget.topMargin ? size.height * 0.01 : 0),
          color: Colors.black,
        ),
        Positioned(
          top: x,
          left: y,
          child: MouseRegion(
            onHover: (event) {
              setState(() {
                _containerBloc.add(OnHover(isHovering: true, hoveredContainer: widget.hoveredContainer));
                x = 3;
                y = 3;
              });
            },
            onExit: (event) {
              setState(() {
                _containerBloc.add(OnHover(isHovering: false));
                x = 0;
                y = 0;
              });
            },
            child: widget.child,
          ),
        )
      ],
    );
  }
}
