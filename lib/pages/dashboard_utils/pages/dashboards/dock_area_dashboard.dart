import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wmssimulator/bloc/dashboards/dashboard_bloc.dart';
import 'package:wmssimulator/bloc/receiving/receiving_bloc.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:wmssimulator/pages/customs/customs.dart';
import 'package:intl/intl.dart';

class DockAreaDashboard extends StatefulWidget {
  DockAreaDashboard({super.key});

  @override
  State<DockAreaDashboard> createState() => _DockAreaDashboardState();
}

class _DockAreaDashboardState extends State<DockAreaDashboard> {
  List<BarData>? dockINDayWiseDataSource;

  List<BarData>? dockOUTDayWiseDataSource;

  final List<TimeData> chartData1 = [
    TimeData('David', 81, const Color.fromARGB(255, 151, 174, 206)),
    TimeData('sd', 19, Colors.transparent),
  ];

  final List<TimeData> chartData2 = [
    TimeData('David', 81, const Color.fromARGB(255, 176, 211, 141)),
    TimeData('sd', 19, Colors.transparent),
  ];

  final List<TimeData> chartData3 = [
    TimeData('David', 81, const Color.fromARGB(255, 196, 141, 204)),
    TimeData('sd', 19, Colors.transparent),
  ];

  List<PieData>? dockINDataSource;

  List<PieData>? dockOUTDataSource;

  late DashboardsBloc _dashboardsBloc;

  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();

    _dashboardsBloc = context.read<DashboardsBloc>();
    _dashboardsBloc.state.appointmentsDate = DateTime.parse('2024-09-13');
    _dashboardsBloc.add(GetDockAppointments(date: DateFormat('yyyy-MM-dd').format(DateTime.parse('2024-09-13'))));
    _dashboardsBloc.add(GetDockDashboardData(facilityID: 243));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double aspectRatio = size.width / size.height;
    return Row(
      children: [
        ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SingleChildScrollView(
              child: BlocBuilder<DashboardsBloc, DashboardsState>( builder: (context, state) {
            bool isEnabled = state.getDockDashboardState != DockDashboardState.success;
            return Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.all(aspectRatio * 8),
                      height: size.height * 0.45,
                      width: size.width * 0.3,
                      decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                      padding: EdgeInsets.only(left: size.height * 0.035, top: size.height * 0.035, bottom: size.height * 0.035),
                      alignment: Alignment.center,
                      child: LayoutBuilder(builder: (context, lsize) {
                        return isEnabled
                            ? Customs.DashboardLoader(lsize: lsize)
                            : Stack(
                                children: [
                                  Customs.WMSCartesianChart(
                                    title: "Daywise Utilization",
                                    yAxisTitle: 'Number of Vehicles',
                                    barCount: 2,
                                    barColors: [Colors.teal, Colors.greenAccent],
                                    dataSources: [
                                      state.dockDashboardData!.daywiseDockInUtilization!
                                          .map((e) => BarData(xLabel: e.status!, yValue: e.count!, abbreviation: e.status!))
                                          .toList(),
                                      state.dockDashboardData!.daywiseDockOutUtilization!
                                          .map((e) => BarData(xLabel: e.status!, yValue: e.count!, abbreviation: e.status!))
                                          .toList()
                                    ],
                                  ),
                                  Positioned(
                                    right: lsize.maxWidth * 0.08,
                                    child: InkWell(onTap: () {}, child: Icon(Icons.calendar_month_rounded)),
                                  )
                                ],
                              );
                      }),
                    ),
                    Container(
                      margin: EdgeInsets.all(aspectRatio * 8),
                      height: size.height * 0.45,
                      width: size.width * 0.3,
                      decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                      padding: EdgeInsets.only(left: size.height * 0.035, top: size.height * 0.035, bottom: size.height * 0.035),
                      alignment: Alignment.center,
                      child: LayoutBuilder(
                        builder: (context, lsize) {
                          return isEnabled
                                ? Customs.DashboardLoader(lsize: lsize)
                                : SfCircularChart(
                            title: ChartTitle(
                              text: 'Dock-IN Utilization',
                              textStyle: TextStyle(fontSize: aspectRatio * 6.8, fontWeight: FontWeight.bold),
                            ),
                            legend: const Legend(isVisible: true, alignment: ChartAlignment.far),
                            series: <CircularSeries>[
                              // Renders radial bar chart
                              DoughnutSeries<PieData, String>(
                                dataSource: state.dockDashboardData!.dockInUtilization!.map((e) => PieData(xData: e.status!, yData: e.count!, color: const Color.fromARGB(255, 102, 82, 156))).toList(),
                                dataLabelSettings: const DataLabelSettings(
                                    // Renders the data label
                                    isVisible: true,
                                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                                    alignment: ChartAlignment.center),
                                pointColorMapper: (datum, index) {
                                  if(index == 1){
                                    return const Color.fromARGB(255, 102, 82, 156);
                                  }else{
                                    return Color.fromARGB(255, 178, 166, 209);
                                  }
                                },
                                xValueMapper: (PieData data, _) => data.xData,
                                yValueMapper: (PieData data, _) => data.yData,
                              )
                            ],
                          );
                        }
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.all(aspectRatio * 8),
                      height: size.height * 0.45,
                      width: size.width * 0.3,
                      decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                      padding: EdgeInsets.only(left: size.height * 0.035, top: size.height * 0.035, bottom: size.height * 0.035),
                      alignment: Alignment.center,
                      child: LayoutBuilder(
                        builder: (context, lsize) {
                          return isEnabled
                            ? Customs.DashboardLoader(lsize: lsize)
                            : SfCircularChart(
                            title: ChartTitle(
                              text: 'Dock-OUT Utilization',
                              textStyle: TextStyle(fontSize: aspectRatio * 6.8, fontWeight: FontWeight.bold),
                            ),
                            legend: const Legend(isVisible: true, alignment: ChartAlignment.far),
                            series: <CircularSeries>[
                              // Renders radial bar chart
                              DoughnutSeries<PieData, String>(
                                dataSource: state.dockDashboardData!.dockOutUtilization!.map((e) => PieData(xData: e.status!, yData: e.count!, color: const Color.fromARGB(255, 102, 82, 156))).toList(),
                                dataLabelSettings: const DataLabelSettings(
                                    // Renders the data label
                                    isVisible: true,
                                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                                    alignment: ChartAlignment.center),
                                pointColorMapper: (datum, index) {
                                  if(index == 1){
                                    return const Color.fromARGB(255, 52, 132, 136);
                                  }else{
                                    return const Color.fromARGB(255, 154, 197, 200);
                                  }
                                },
                                xValueMapper: (PieData data, _) => data.xData,
                                yValueMapper: (PieData data, _) => data.yData,
                              )
                            ],
                          );
                        }
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.all(aspectRatio * 8),
                        height: size.height * 0.45,
                        width: size.width * 0.3,
                        decoration: BoxDecoration(
                            color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                        padding: EdgeInsets.all(size.height * 0.035),
                        alignment: Alignment.center,
                        child: LayoutBuilder(
                          builder: (context, lsize) {
                            return isEnabled
                                ? Customs.DashboardLoader(lsize: lsize)
                                : SfCircularChart(
                              title: ChartTitle(text: "Avg Loading Time", textStyle: TextStyle(fontSize: aspectRatio * 6.8, fontWeight: FontWeight.bold)),
                              annotations: <CircularChartAnnotation>[
                                CircularChartAnnotation(
                                  verticalAlignment: ChartAlignment.center,
                                  widget: Container(
                                      height: size.height * 0.12,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blueGrey.shade100,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade900,
                                            blurRadius: 10, // Adjust to set shadow direction
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        state.dockDashboardData!.avgLoadingTime!,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: size.height * 0.02,
                                        ),
                                      )),
                                ),
                              ],
                              series: <CircularSeries>[
                                DoughnutSeries<TimeData, String>(
                                  dataSource: chartData1,
                                  xValueMapper: (TimeData data, _) => data.x,
                                  yValueMapper: (TimeData data, _) => data.y,
                                  radius: '60%', // Adjust the radius as needed
                                  innerRadius: '40%', // Optional: adjust for a thinner ring
                                  pointColorMapper: (TimeData data, _) => data.color,
                                )
                              ],
                            );
                          }
                        )),
                  ],
                ),
                Row(
                  children: [
                    Container(
                        margin: EdgeInsets.all(aspectRatio * 8),
                        height: size.height * 0.45,
                        width: size.width * 0.3,
                        decoration: BoxDecoration(
                            color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                        padding: EdgeInsets.all(size.height * 0.035),
                        alignment: Alignment.center,
                        child: LayoutBuilder(
                          builder: (context, lsize) {
                            return isEnabled
                            ? Customs.DashboardLoader(lsize: lsize)
                            : SfCircularChart(
                              title: ChartTitle(text: "Avg Unloading Time", textStyle: TextStyle(fontSize: aspectRatio * 6.8, fontWeight: FontWeight.bold)),
                              annotations: <CircularChartAnnotation>[
                                CircularChartAnnotation(
                                  verticalAlignment: ChartAlignment.center,
                                  widget: Container(
                                      height: size.height * 0.12,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blueGrey.shade100,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade900,
                                            blurRadius: 10, // Adjust to set shadow direction
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        state.dockDashboardData!.avgUnloadingTime!,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: size.height * 0.02,
                                        ),
                                      )),
                                ),
                              ],
                              series: <CircularSeries>[
                                DoughnutSeries<TimeData, String>(
                                  dataSource: chartData2,
                                  xValueMapper: (TimeData data, _) => data.x,
                                  yValueMapper: (TimeData data, _) => data.y,
                                  radius: '60%', // Adjust the radius as needed
                                  innerRadius: '40%', // Optional: adjust for a thinner ring
                                  pointColorMapper: (TimeData data, _) => data.color,
                                )
                              ],
                            );
                          }
                        )),
                    Container(
                        margin: EdgeInsets.all(aspectRatio * 8),
                        height: size.height * 0.45,
                        width: size.width * 0.3,
                        decoration: BoxDecoration(
                            color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                        padding: EdgeInsets.all(size.height * 0.035),
                        alignment: Alignment.center,
                        child: LayoutBuilder(
                          builder: (context, lsize) {
                            return isEnabled
                            ? Customs.DashboardLoader(lsize: lsize)
                            : SfCircularChart(
                              title: ChartTitle(text: "Avg Dock TAT", textStyle: TextStyle(fontSize: aspectRatio * 6.8, fontWeight: FontWeight.bold)),
                              annotations: <CircularChartAnnotation>[
                                CircularChartAnnotation(
                                  verticalAlignment: ChartAlignment.center,
                                  widget: Container(
                                      height: size.height * 0.12,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blueGrey.shade100,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade900,
                                            blurRadius: 10, // Adjust to set shadow direction
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        state.dockDashboardData!.avgDockTAT!,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: size.height * 0.02,
                                        ),
                                      )),
                                ),
                              ],
                              series: <CircularSeries>[
                                DoughnutSeries<TimeData, String>(
                                  dataSource: chartData3,
                                  xValueMapper: (TimeData data, _) => data.x,
                                  yValueMapper: (TimeData data, _) => data.y,
                                  radius: '60%', // Adjust the radius as needed
                                  innerRadius: '40%', // Optional: adjust for a thinner ring
                                  pointColorMapper: (TimeData data, _) => data.color,
                                )
                              ],
                            );
                          }
                        )),
                  ],
                )
              ],
            );
          })),
        ),
        Expanded(
          child: LayoutBuilder(builder: (context, lsize) {
            return BlocBuilder<DashboardsBloc, DashboardsState>(builder: (context, state) {
              bool isEnabled = state.getAppointmentsState == AppointmentsState.loading;

              return Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height: lsize.maxHeight * 0.125,
                          width: lsize.maxWidth,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(12, 46, 87, 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: EdgeInsets.only(top: lsize.maxHeight * 0.018),
                          padding: EdgeInsets.all(lsize.maxWidth * 0.045),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Appointments',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: lsize.maxHeight * 0.025),
                              ),
                              Gap(lsize.maxHeight * 0.01),
                              Row(
                                children: [
                                  SizedBox(
                                      width: lsize.maxWidth * 0.32,
                                      child: Text(
                                          '${DateFormat('E').format(state.appointmentsDate!)}, ${DateFormat('MMM').format(state.appointmentsDate!)} ${state.appointmentsDate!.day}',
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: lsize.maxHeight * 0.02))),
                                  Spacer(),
                                  Container(
                                    alignment: Alignment.center,
                                    height: lsize.maxHeight * 0.03,
                                    width: lsize.maxWidth * 0.22,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(192, 208, 230, 1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: EdgeInsets.all(lsize.maxHeight * 0.002),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (state.appointmentsDate!.isAfter(now)) {
                                              _dashboardsBloc.add(UpdateDate(date: state.appointmentsDate!.subtract(Duration(days: 1))));
                                              _dashboardsBloc.add(ToggleCalendar(toggleCalendar: false));
                                            }
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: lsize.maxHeight * 0.03,
                                            width: lsize.maxWidth * 0.1,
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(12, 46, 87, 1),
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                                            ),
                                            child: Transform.translate(
                                              offset: Offset(0, -lsize.maxHeight*0.002),
                                              child: Icon(
                                                Icons.arrow_left_outlined,
                                                color: Colors.white,
                                                size: lsize.maxHeight*0.03,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Gap(lsize.maxWidth * 0.005),
                                        InkWell(
                                          onTap: () {
                                            _dashboardsBloc.add(UpdateDate(date: state.appointmentsDate!.add(Duration(days: 1))));
                                            _dashboardsBloc.add(ToggleCalendar(toggleCalendar: false));
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: lsize.maxHeight * 0.03,
                                            width: lsize.maxWidth * 0.1,
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(12, 46, 87, 1),
                                              borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                                            ),
                                            child: Transform.translate(offset: Offset(0, -lsize.maxHeight*0.002),child: Icon(Icons.arrow_right_outlined, color: Colors.white, size: lsize.maxHeight*0.03,)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Gap(lsize.maxWidth * 0.04),
                                  InkWell(
                                    onTap: () {
                                      _dashboardsBloc.add(ToggleCalendar(toggleCalendar: !state.toggleCalendar!));
                                    },
                                    child: Icon(
                                      Icons.calendar_month_rounded,
                                      size: lsize.maxWidth * 0.065,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              )
                            ],
                          )),
                      Expanded(
                        child: Container(
                          width: lsize.maxWidth,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(12, 46, 87, 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: EdgeInsets.only(top: size.height * 0.01),
                          padding: EdgeInsets.symmetric(vertical: lsize.maxHeight * 0.02, horizontal: lsize.maxWidth * 0.03),
                          child: isEnabled
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: ListView.builder(
                                    itemCount: isEnabled ? 10 : state.appointments!.length,
                                    itemBuilder: (context, index) => Container(
                                      height: lsize.maxHeight * 0.1,
                                      width: lsize.maxWidth,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      margin: EdgeInsets.only(bottom: lsize.maxHeight * 0.01),
                                      padding: EdgeInsets.all(lsize.maxHeight * 0.02),
                                      child: Row(
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Skeletonizer(
                                                  enabled: isEnabled,
                                                  enableSwitchAnimation: true,
                                                  child: Text(
                                                    isEnabled ? '9:00 AM' : state.appointments![index].startTime!,
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(12, 46, 87, 1), fontSize: lsize.maxWidth * 0.045, fontWeight: FontWeight.bold),
                                                  )),
                                              Gap(lsize.maxHeight * 0.008),
                                              Skeletonizer(
                                                  enabled: isEnabled,
                                                  enableSwitchAnimation: true,
                                                  child: Text(isEnabled ? '10:00 AM' : state.appointments![index].endTime!,
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(95, 116, 143, 1),
                                                          fontSize: lsize.maxWidth * 0.035,
                                                          fontWeight: FontWeight.bold)))
                                            ],
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(horizontal: lsize.maxWidth * 0.05),
                                            decoration: BoxDecoration(color: Color.fromRGBO(12, 46, 87, 1), borderRadius: BorderRadius.circular(500)),
                                            width: lsize.maxHeight * 0.003,
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Skeletonizer(
                                                  enabled: isEnabled,
                                                  enableSwitchAnimation: true,
                                                  child: Text(
                                                    isEnabled ? 'APDEMODEMO' : state.appointments![index].apptNbr!,
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(12, 46, 87, 1), fontSize: lsize.maxWidth * 0.04, fontWeight: FontWeight.bold),
                                                  )),
                                              Gap(lsize.maxHeight * 0.008),
                                              Skeletonizer(
                                                  enabled: isEnabled,
                                                  enableSwitchAnimation: true,
                                                  child: Text(isEnabled ? 'DOCK-IN-01' : state.appointments![index].dockNbr!,
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(95, 116, 143, 1),
                                                          fontSize: lsize.maxWidth * 0.035,
                                                          fontWeight: FontWeight.bold)))
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : state.appointments!.length == 0
                                  ? Center(
                                      child: Text(
                                        'Looks like you have no Appointments',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: ListView.builder(
                                        itemCount: isEnabled ? 10 : state.appointments!.length,
                                        itemBuilder: (context, index) => Container(
                                          height: lsize.maxHeight * 0.1,
                                          width: lsize.maxWidth,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          margin: EdgeInsets.only(bottom: lsize.maxHeight * 0.01),
                                          padding: EdgeInsets.all(lsize.maxHeight * 0.02),
                                          child: Row(
                                            children: [
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Skeletonizer(
                                                      enabled: isEnabled,
                                                      enableSwitchAnimation: true,
                                                      child: Text(
                                                        isEnabled ? '9:00 AM' : state.appointments![index].startTime!,
                                                        style: TextStyle(
                                                            color: Color.fromRGBO(12, 46, 87, 1),
                                                            fontSize: lsize.maxWidth * 0.045,
                                                            fontWeight: FontWeight.bold),
                                                      )),
                                                  Gap(lsize.maxHeight * 0.008),
                                                  Skeletonizer(
                                                      enabled: isEnabled,
                                                      enableSwitchAnimation: true,
                                                      child: Text(isEnabled ? '10:00 AM' : state.appointments![index].endTime!,
                                                          style: TextStyle(
                                                              color: Color.fromRGBO(95, 116, 143, 1),
                                                              fontSize: lsize.maxWidth * 0.035,
                                                              fontWeight: FontWeight.bold)))
                                                ],
                                              ),
                                              Container(
                                                margin: EdgeInsets.symmetric(horizontal: lsize.maxWidth * 0.05),
                                                decoration: BoxDecoration(color: Color.fromRGBO(12, 46, 87, 1), borderRadius: BorderRadius.circular(500)),
                                                width: lsize.maxHeight * 0.003,
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Skeletonizer(
                                                      enabled: isEnabled,
                                                      enableSwitchAnimation: true,
                                                      child: Text(
                                                        isEnabled ? 'APDEMODEMO' : state.appointments![index].apptNbr!,
                                                        style: TextStyle(
                                                            color: Color.fromRGBO(12, 46, 87, 1),
                                                            fontSize: lsize.maxWidth * 0.037,
                                                            fontWeight: FontWeight.bold),
                                                      )),
                                                  Gap(lsize.maxHeight * 0.008),
                                                  Skeletonizer(
                                                      enabled: isEnabled,
                                                      enableSwitchAnimation: true,
                                                      child: Text(isEnabled ? 'DOCK-IN-01' : state.appointments![index].dockNbr!,
                                                          style: TextStyle(
                                                              color: Color.fromRGBO(95, 116, 143, 1),
                                                              fontSize: lsize.maxWidth * 0.035,
                                                              fontWeight: FontWeight.bold)))
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                        ),
                      )
                    ],
                  ),
                  if (state.toggleCalendar!)
                    Positioned(
                      top: lsize.maxHeight * 0.13,
                      left: lsize.maxWidth * 0.1,
                      right: 0,
                      bottom: lsize.maxHeight * 0.5,
                      child: SizedBox(
                        width: size.width * 1,
                        height: size.height * 0.45,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: SfDateRangePicker(
                            initialDisplayDate: state.appointmentsDate,
                            initialSelectedDate: state.appointmentsDate,
                            selectionMode: DateRangePickerSelectionMode.single,
                            backgroundColor: Color.fromRGBO(174, 204, 240, 1),
                            headerStyle: DateRangePickerHeaderStyle(
                              backgroundColor: Color.fromRGBO(12, 46, 87, 1),
                              textStyle: TextStyle(color: Colors.white),
                            ),
                            headerHeight: lsize.maxHeight * 0.05,
                            minDate: DateTime(now.year, 1, 1, 0, 0, 0, 0, 0),
                            maxDate: DateTime(now.year, 12, 31, 23, 59, 0, 0, 0),
                            selectionColor: Color.fromRGBO(12, 46, 87, 1),
                            allowViewNavigation: false,
                            showNavigationArrow: true,
                            selectionShape: DateRangePickerSelectionShape.circle,
                            selectableDayPredicate: (date) {
                              return true;
                              // date.isAfter(now.subtract(
                              //         const Duration(days: 1))) &&
                              //     ![
                              //       DateTime.saturday,
                              //       DateTime.sunday
                              //     ].contains(date.weekday);
                            },
                            cellBuilder: (BuildContext context, DateRangePickerCellDetails details) {
                              Color circleColor;

                              circleColor =
                                  details.date.toString().substring(0, 10) == now.toString().substring(0, 10) ? Color.fromRGBO(12, 46, 87, 1) : Colors.white;

                              return Padding(
                                padding: const EdgeInsets.all(4),
                                child: Container(
                                  width: details.bounds.width / 2,
                                  height: details.bounds.width / 2,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: circleColor,
                                  ),
                                  child: Center(
                                      child: Text(details.date.day.toString(),
                                          style: TextStyle(
                                            color: details.date.toString().substring(0, 10) == now.toString().substring(0, 10) ? Colors.white : Colors.black,
                                          ))),
                                ),
                              );
                            },
                            onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                              _dashboardsBloc.add(UpdateDate(date: dateRangePickerSelectionChangedArgs.value));
                              _dashboardsBloc.add(ToggleCalendar(toggleCalendar: false));
                            },
                          ),
                        ),
                      ),
                    )
                ],
              );
            });
          }),
        )
      ],
    );
  }
}
