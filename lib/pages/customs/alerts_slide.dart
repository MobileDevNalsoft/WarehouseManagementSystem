import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:wmssimulator/bloc/warehouse/warehouse_interaction_bloc.dart';

class AlertsSlide extends StatefulWidget {
  AlertsSlide({super.key, required this.sliderAnimationController});
  AnimationController sliderAnimationController;

  @override
  State<AlertsSlide> createState() => _AlertsSlideState();
}

class _AlertsSlideState extends State<AlertsSlide> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.98,
      width: size.width * 0.22,
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01, horizontal: size.width * 0.006),
      decoration: BoxDecoration(color: Color.fromRGBO(12, 46, 87, 1), borderRadius: BorderRadius.circular(20), boxShadow: [
        BoxShadow(
          color: Colors.white,
          blurRadius: 8,
        )
      ]),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                child: Text(
                  'Notifications',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: size.aspectRatio * 13, color: Colors.white),
                ),
              ),
              InkWell(
                onTap: () {
                  widget.sliderAnimationController.reverse();
                },
                child: Icon(Icons.cancel, color: Color.fromRGBO(76, 109, 150, 1),),
              ),
            ],
          ),
          Divider(
            color: Color.fromRGBO(76, 109, 150, 1),
          ),
          Gap(size.height * 0.01),
          BlocBuilder<WarehouseInteractionBloc, WarehouseInteractionState>(builder: (context, state) {
            bool isEnabled = state.getAlertsStatus != AlertsStatus.success;
            return Expanded(
              child: Skeletonizer(
                enabled: isEnabled,
                enableSwitchAnimation: true,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: ListView.builder(
                    itemCount: isEnabled ? 15 : state.alerts!.length,
                    itemBuilder: (context, index) => Container(
                      margin: EdgeInsets.only(bottom: size.height * 0.01),
                      padding: EdgeInsets.symmetric(vertical: size.height * 0.01, horizontal: size.width * 0.008),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEnabled ? 'Subject' : state.alerts![index].subject!,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: size.aspectRatio * 8),
                          ),
                          Text(isEnabled ? 'Body body body body body body body body\n body body body' : state.alerts![index].body!),
                          Gap(size.height * 0.01),
                          Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                isEnabled ? 'Time' : state.alerts![index].time!,
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: size.aspectRatio * 7),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}
