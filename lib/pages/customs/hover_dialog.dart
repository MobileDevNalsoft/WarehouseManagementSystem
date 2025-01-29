import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wmssimulator/bloc/container_management/container_bloc.dart';

class HoverOverlay extends StatefulWidget {
  HoverOverlay({required this.child});
  Widget child;
  @override
  _HoverOverlayState createState() => _HoverOverlayState();
}

class _HoverOverlayState extends State<HoverOverlay> {
  Offset hoverPosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContainerBloc, ContainerState>(builder: (context, state) {
      return Stack(
        children: [
          MouseRegion(
              onHover: (PointerEvent details) {
                setState(() {
                  hoverPosition = details.localPosition;
                });
              },
              child: widget.child),
          if (state.isHovering ?? false)
            Positioned(
              left: hoverPosition.dx - 100,
              top: hoverPosition.dy + 20,
              child: Material(
                child: Container(
                  padding: EdgeInsets.all(8),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Container Nbr : ${state.hoveredContainer!.containerNbr}'),
                      Text('Customer : ${state.hoveredContainer!.customer}'),
                      Text('Arrival Date : ${state.hoveredContainer!.arrivalDate.toString().split(' ')[0]}'),
                      if (DateTime.now().difference(state.hoveredContainer!.arrivalDate!).inDays > 3)
                        Text('Detention Days : ${DateTime.now().difference(state.hoveredContainer!.arrivalDate!).inDays - 3}'),
                      if (DateTime.now().difference(state.hoveredContainer!.arrivalDate!).inDays > 3)
                        Text('Detention Cost : ${(DateTime.now().difference(state.hoveredContainer!.arrivalDate!).inDays - 3) * 500}Rs'),
                    ],
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}
