import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:warehouse_3d/pages/dashboard_utils/shared/constants/defaults.dart';

class YardAreaDashboard extends StatelessWidget {
  YardAreaDashboard({super.key});

  
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


  List<BarData> vehicleDetentionData = [
    BarData(xLabel: '<1 day', yValue: 10, abbreviation: 'Monday'),
    BarData(xLabel: '1-7 days', yValue: 4, abbreviation: 'Tuesday'),
    BarData(xLabel: '>7 days', yValue: 6, abbreviation: 'Wednesday'),
  ];

  // Define lists for job card statuses and their corresponding values (replace with actual data)
  List<BarData> barData = [
    BarData(xLabel: 'Mon', yValue: 10, abbreviation: 'Monday'),
    BarData(xLabel: 'Tue', yValue: 4, abbreviation: 'Tuesday'),
    BarData(xLabel: 'Wed', yValue: 6, abbreviation: 'Wednesday'),
    BarData(xLabel: 'Thu', yValue: 3, abbreviation: 'Thursday'),
    BarData(xLabel: 'Fri', yValue: 20, abbreviation: 'Friday'),
    BarData(xLabel: 'Sat', yValue: 2, abbreviation: 'Saturday'),
    BarData(xLabel: 'Sun', yValue: 2, abbreviation: 'Sunday')
  ];

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

  List<BarData> loadingVehiclesData = [
    BarData(xLabel: 'Mon', yValue: 3, abbreviation: 'Monday'),
    BarData(xLabel: 'Tue', yValue: 8, abbreviation: 'Tuesday'),
    BarData(xLabel: 'Wed', yValue: 8, abbreviation: 'Wednesday'),
    BarData(xLabel: 'Thu', yValue: 5, abbreviation: 'Thursday'),
    BarData(xLabel: 'Fri', yValue: 1, abbreviation: 'Friday'),
    BarData(xLabel: 'Sat', yValue: 12, abbreviation: 'Saturday'),
    BarData(xLabel: 'Sun', yValue: 9, abbreviation: 'Sunday')
  ];

  // Define lists for job card statuses and their corresponding values (replace with actual data)
  List<BarData> unloadingVehiclesData = [
    BarData(xLabel: 'Mon', yValue: 8, abbreviation: 'Monday'),
    BarData(xLabel: 'Tue', yValue: 8, abbreviation: 'Tuesday'),
    BarData(xLabel: 'Wed', yValue: 15, abbreviation: 'Wednesday'),
    BarData(xLabel: 'Thu', yValue: 7, abbreviation: 'Thursday'),
    BarData(xLabel: 'Fri', yValue: 20, abbreviation: 'Friday'),
    BarData(xLabel: 'Sat', yValue: 10, abbreviation: 'Saturday'),
    BarData(xLabel: 'Sun', yValue: 2, abbreviation: 'Sunday')
  ];

  final List<AnalogChartData> avgYardTime = [
    AnalogChartData('Yard time', 45, Color.fromRGBO(147,0,119,1)),
    AnalogChartData('rest', 55, Colors.transparent),
    // AnalogChartData('rest', 75, Color.fromRGBO(9, 0, 136, 1))
    // AnalogChartData('Jack', 34, Color.fromRGBO(228,0,124,1)),
    // AnalogChartData('Others', 52, Color.fromRGBO(255,189,57,1))
  ];

 final List<AnalogChartData> loadingUnloadingCount = [
    // AnalogChartData('Yard time', 45, Color.fromRGBO(147,0,119,1)),
    // AnalogChartData('rest', 55, Colors.transparent),
    AnalogChartData('Loading', 75, Color.fromRGBO(9, 0, 136, 1)),
    AnalogChartData('Unloading', 34, Color.fromRGBO(138, 68, 27, 1))
    // AnalogChartData('Others', 52, Color.fromRGBO(255,189,57,1))
  ];

  final List<ChartData> chartData = [
            ChartData('Loading', 25),
            ChartData('Unloading', 38),
            // ChartData('Jack', 34),
            // ChartData('Others', 52)
        ];

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
              'Yard Area Dashboard',
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
                                  dataSource: [PieData(xData: "Available",yData:  16,text: "16"), PieData(xData: "Occupied",yData:  4,text:  "4")],
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
            ],
          ),
        ),
      ],
    );
  }
}

    class ChartData {
        ChartData(this.x, this.y);
        final String x;
        final double y;
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