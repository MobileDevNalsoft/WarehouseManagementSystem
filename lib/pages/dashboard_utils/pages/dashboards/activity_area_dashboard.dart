import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gap/gap.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:warehouse_3d/pages/dashboard_utils/shared/constants/defaults.dart';

class ActivityAreaDashboard extends StatefulWidget {
  ActivityAreaDashboard({super.key});

  @override
  State<ActivityAreaDashboard> createState() => _ActivityAreaDashboardState();
}

class _ActivityAreaDashboardState extends State<ActivityAreaDashboard> {
  SuggestionsController suggestionsController = SuggestionsController();


    static Widget WMSCartesianChart({String title = "title", int barCount = 1, List<List<BarData>>? dataSources, String yAxisTitle = "title" ,Color? primaryColor,Color? secondaryColor,List<String>? legendText,bool? isLegendVisible,int? spacing}){
    return SfCartesianChart(
                    title: ChartTitle(text: title,textStyle: const TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    )),
                    
                    legend: isLegendVisible!=null? Legend(alignment: ChartAlignment.near,isVisible: isLegendVisible?? false,isResponsive: true,position: LegendPosition.bottom):Legend(),
                    onLegendItemRender: (legendRenderArgs) {
                      if(legendText!=null){
                      legendRenderArgs.text = legendText[legendRenderArgs.seriesIndex!];}
                    },
                    primaryXAxis: const CategoryAxis(
                      labelStyle: TextStyle(color: Colors.black, fontSize: 16),
                      majorGridLines: MajorGridLines(
                        width: 0,
                      ),
                      majorTickLines: MajorTickLines(width: 0),
                      axisLine: AxisLine(width: 0),
                    ),
                    primaryYAxis: NumericAxis(
                      title: AxisTitle(text: yAxisTitle),
                    ),
                    plotAreaBorderWidth: 0,
                    // tooltipBehavior: TooltipBehavior(
                    //   enable: true,
                    //   color: Colors.black,
                    //   textStyle: const TextStyle(color: Colors.black),
                    //   textAlignment: ChartAlignment.center,
                    //   animationDuration: 100,
                    //   duration: 2000,
                    //   shadowColor: Colors.black,
                    //   builder: (data, point, series, pointIndex, seriesIndex) => IntrinsicWidth(
                    //     child: Container(
                    //         height: size.height * 0.01,
                    //         margin: EdgeInsets.only(
                    //             left: size.width * 0.03, right: size.width * 0.03,),
                    //         child: Text((data as BarData).abbreviation, style: TextStyle(color: Colors.white),)),
                    //   ),
                    // ),
                    borderWidth: 0,
                    series: List.generate(barCount, (index) => ColumnSeries<BarData, String>(
                        dataSource: dataSources![index],
                        xValueMapper: (BarData data, _) => data.xLabel,
                        yValueMapper: (BarData data, _) => data.yValue,
                        borderRadius: BorderRadius.circular(10),
                        spacing: 0.1,
                        color: (primaryColor==null && secondaryColor==null)?Colors.blueAccent: (secondaryColor==null)?primaryColor: index==0?primaryColor:secondaryColor,
                        dataLabelMapper: (datum, index) => datum.yValue.toString(),
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          useSeriesColor: true,
                          builder: (data, point, series, pointIndex, seriesIndex) {
                            return Text(
                            (data as BarData).yValue.toString(),
                            style: const TextStyle(color: Colors.black, fontSize: 14),
                          );}
                        ),
                        width: 0.6,
                      ),)
                    );
  }

  static Widget WMSPieChart({String title = "title", List<PieData>? dataSource, Color? Function(PieData, int)? pointColorMapper}) {
    return SfCircularChart(
        title: ChartTitle(
            text: title,
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            )),
        tooltipBehavior: TooltipBehavior(
          enable: true,
        ),
        legend: const Legend(
          isVisible: true,
          alignment: ChartAlignment.near,
        ),
        series: <PieSeries<PieData, String>>[
          PieSeries<PieData, String>(
              explode: true,
              explodeIndex: 0,
              
              dataSource: dataSource,
              pointColorMapper: pointColorMapper,
              
              xValueMapper: (PieData data, _) => data.xData,
              yValueMapper: (PieData data, _) => data.yData,
              dataLabelMapper: (PieData data, _) => data.text,
              enableTooltip: true,
              dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  labelPosition: ChartDataLabelPosition.outside,
                  textStyle: TextStyle(fontSize: 24),
                  labelAlignment: ChartDataLabelAlignment.top),
      
                  
                  ),
        ]);
  }



  static Widget WMSSfCircularChart({required List<AnalogChartData> chartData,String? title,String? contentText,required Size size,double? height,double? width,String? radius,Color? textColor}){
                    return SfCircularChart(
                                  title: ChartTitle(text: title??"title"),
                                
                                  annotations: <CircularChartAnnotation>[
                                    
                                    CircularChartAnnotation(
                                      
                                      widget: Container(
                                        width: width??100,
                                        height: height??160,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,

                                          color: const Color.fromARGB(255, 232, 229, 229),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.3),
                                              blurRadius: 10,
                                              offset: Offset(0, 4), // Adjust to set shadow direction
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    CircularChartAnnotation(
                                      widget: Container(
                                        child:  Text(
                                          contentText??"chart",
                                          style: TextStyle(
                                            color: textColor??Color.fromARGB(255, 101, 10, 10),
                                            fontSize: 25,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  series: <CircularSeries>[
                                    DoughnutSeries<AnalogChartData, String>(
                                      dataSource: chartData,
                                      xValueMapper: (AnalogChartData data, _) => data.x,
                                      yValueMapper: (AnalogChartData data, _) => data.y,
                                      radius: radius??'50%', // Adjust the radius as needed
                                      innerRadius: '20%', // Optional: adjust for a thinner ring
                                      pointColorMapper: (AnalogChartData data, _) => data.color,
                                    )
                                  ],
                                );
  }

  static void AnimatedDialog({
    required BuildContext context,
    required Widget header,
    required List<Widget> content,
  }) {
    Size size = MediaQuery.of(context).size;
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedValue = Curves.bounceInOut.transform(animation.value);
        return Transform.scale(
          scale: curvedValue,
          child: Opacity(
            opacity: animation.value,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, animation, secondaryAnimation) {
        return IntrinsicHeight(
          child: Container(
            margin: EdgeInsets.only(top: size.height * 0.4),
            alignment: Alignment.topCenter,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Material(
                  color: Colors.transparent,
                  child: IntrinsicHeight(
                    child: Container(
                      margin: EdgeInsets.only(top: size.height * 0.035),
                      padding: EdgeInsets.only(
                        bottom: size.height * 0.02,
                      ),
                      width: size.width * 0.16,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: InkWell(
                                  onTap: () => Navigator.pop(context),
                                  child: const Icon(
                                    Icons.close,
                                    size: 20,
                                    weight: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Gap(size.height * 0.01),
                          ...content
                        ],
                      ),
                    ),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 35,
                  child: header,
                )
              ],
            ),
          ),
        );
      },
    );
  }
















  late TextEditingController typeAheadController;

  late FocusNode typeAheadFocusNode;
  List<String> selectedEmployees = [];
  // Define lists for job card statuses and their corresponding values (replace with actual data)
  List<BarData> taskdata = [
    BarData(xLabel: 'Mon', yValue: 10, abbreviation: 'Monday'),
    BarData(xLabel: 'Tue', yValue: 4, abbreviation: 'Tuesday'),
    BarData(xLabel: 'Wed', yValue: 6, abbreviation: 'Wednesday'),
    BarData(xLabel: 'Thu', yValue: 8, abbreviation: 'Thursday'),
    BarData(xLabel: 'Fri', yValue: 5, abbreviation: 'Friday'),
    BarData(xLabel: 'Sat', yValue: 2, abbreviation: 'Saturday'),
    BarData(xLabel: 'Sun', yValue: 2, abbreviation: 'Sunday')
  ];

  List<BarData> empTaskdata = [];

  // Define lists for job card statuses and their corresponding values (replace with actual data)
  List<BarData> inBoundData = [
    BarData(xLabel: 'Mon', yValue: 4, abbreviation: 'Monday'),
    BarData(xLabel: 'Tue', yValue: 6, abbreviation: 'Tuesday'),
    BarData(xLabel: 'Wed', yValue: 9, abbreviation: 'Wednesday'),
    BarData(xLabel: 'Thu', yValue: 5, abbreviation: 'Thursday'),
    BarData(xLabel: 'Fri', yValue: 18, abbreviation: 'Friday'),
    BarData(xLabel: 'Sat', yValue: 12, abbreviation: 'Saturday'),
    BarData(xLabel: 'Sun', yValue: 9, abbreviation: 'Sunday')
  ];

  // Define lists for job card statuses and their corresponding values (replace with actual data)
  List<BarData> outBoundData = [
    BarData(xLabel: 'Mon', yValue: 6, abbreviation: 'Monday'),
    BarData(xLabel: 'Tue', yValue: 8, abbreviation: 'Tuesday'),
    BarData(xLabel: 'Wed', yValue: 15, abbreviation: 'Wednesday'),
    BarData(xLabel: 'Thu', yValue: 7, abbreviation: 'Thursday'),
    BarData(xLabel: 'Fri', yValue: 20, abbreviation: 'Friday'),
    BarData(xLabel: 'Sat', yValue: 10, abbreviation: 'Saturday'),
    BarData(xLabel: 'Sun', yValue: 2, abbreviation: 'Sunday')
  ];

  final List<AnalogChartData> avgTaskExecutionTime = [
    AnalogChartData('Execution time', 60, Color.fromRGBO(147, 0, 119, 1)),
    AnalogChartData('rest', 40, Colors.transparent),
    // AnalogChartData('rest', 75, Color.fromRGBO(9, 0, 136, 1))
    // AnalogChartData('Jack', 34, Color.fromRGBO(228,0,124,1)),
    // AnalogChartData('Others', 52, Color.fromRGBO(255,189,57,1))
  ];

  final List<AnalogChartData> avgPickTime = [
    AnalogChartData('Execution time', 40, Color.fromRGBO(9, 0, 136, 1)),
    AnalogChartData('rest', 60, Colors.transparent),
  ];
  late Map<String, List<String>> employeeSuggestionRange;
  var random = Random();
  late bool rangeSelection;
  String selectedEmployeeRange = "";
  late List<String> employeeSuggestions;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rangeSelection = true;
    employeeSuggestionRange = {
      "101-110": [
        "101",
        "102",
        "103",
        "104",
        "105",
        "106",
        "107",
        "108",
        "109",
        "110",
      ],
      "111-120": ["111", "112", "113", "114", "115", "116", "117", "118", "119", "120"],
      "121-130": ["121", "122", "123", "124", "125", "126", "127", "128", "129", "130"],
      "131-140": ["131", "132", "133", "134", "135", "136", "137", "138", "139", "140"],
    };
   
  }

  void resetEmpGraphData(){
    if(rangeSelection){
      // to do
      selectedEmployeeRange = "101-110"; 
    }
    else{
      // to do
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Gap(size.height * 0.03),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Activity Area Dashboard',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            )
          ],
        ),
        Gap(size.height * 0.03),
        Expanded(
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDefaults.padding * 1.5,
                ),
                child: Container(
                  padding: const EdgeInsets.all(AppDefaults.padding),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(95, 154, 152, 152),
                    borderRadius: BorderRadius.all(Radius.circular(AppDefaults.borderRadius)),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(AppDefaults.padding),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(95, 154, 152, 152),
                      borderRadius: BorderRadius.all(Radius.circular(AppDefaults.borderRadius)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Gap(size.width * 0.05),
                            Container(
                                height: size.height * 0.4,
                                width: size.width * 0.3,
                                decoration: BoxDecoration(
                                    border: Border.all(color: const Color.fromARGB(137, 172, 170, 170)),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: Customs.WMSPieChart(
                                    title: "Trucks Info",
                                    dataSource: [PieData(xData: "Available",yData:  16,text:  "16"), PieData(xData: "Occupied",yData:  4,text:  "4")],
                                    pointColorMapper: (datum, index) {
                                      if (datum.text == '16') {
                                        return const Color.fromARGB(255, 159, 238, 161);
                                      } else {
                                        return const Color.fromARGB(255, 182, 62, 53);
                                      }
                                    })),
                            Gap(size.width * 0.05),
                            Container(
                                height: size.height * 0.4,
                                width: size.width * 0.3,
                                decoration: BoxDecoration(
                                    border: Border.all(color: const Color.fromARGB(137, 172, 170, 170)),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: Customs.WMSCartesianChart(
                                    title: 'Daywise In Bound and Out Bound',
                                    barCount: 2,
                                    barColors: [Colors.teal, Colors.greenAccent],
                                    dataSources: [inBoundData, outBoundData],
                                    yAxisTitle: 'Number of Vehicles')),
                          ],
                        ),
                        Gap(size.height * 0.1),
                        Row(
                          children: [
                            Gap(size.width * 0.05),
                            Container(
                                height: size.height * 0.4,
                                width: size.width * 0.3,
                                decoration: BoxDecoration(
                                    border: Border.all(color: const Color.fromARGB(137, 172, 170, 170)),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: Customs.WMSCartesianChart(
                                    title: 'Daywise Vehicle Engagement', barCount: 1, dataSources: [barData], yAxisTitle: 'Number of Vehicles')),
                            Gap(size.width * 0.05),
                            Container(
                                height: size.height * 0.4,
                                width: size.width * 0.3,
                                decoration: BoxDecoration(
                                    border: Border.all(color: const Color.fromARGB(137, 172, 170, 170)),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child:
                                    Customs.WMSPieChart(title: 'In Bound vs Out Bound', dataSource: [PieData(xData: "Total",yData:  10,text:  "10"), PieData(xData: "Active",yData:  4,text:  "4")])),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


// models for charts
class PieData {
  PieData(this.xData, this.yData, [this.text]);
  final String xData;
  final num yData;
  String? text;
}

class BarData {
  String xLabel;
  int yValue;
  String abbreviation;
  BarData({required this.xLabel, required this.yValue, required this.abbreviation});
}


class AnalogChartData {
        AnalogChartData(this.x, this.y, this.color);
            final String x;
            final double y;
            final Color color;
    }