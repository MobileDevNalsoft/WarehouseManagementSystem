import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:warehouse_3d/pages/customs/customs.dart';
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
     double aspectRatio = size.width / size.height;
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                      margin: EdgeInsets.all(aspectRatio * 8),
                      height: size.height * 0.45,
                      width: size.width * 0.25,
                      decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                      padding: EdgeInsets.all(size.height * 0.035),
                      alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                       Text(
                          'Vehicle Detention',
                          style: TextStyle(fontSize: aspectRatio * 10, fontWeight: FontWeight.bold),
                        ),
                      SizedBox(
                          height: size.height * 0.3,
                            width: size.width * 0.25,
                        child: Customs.WMSCartesianChart(
                            title: '', barCount: 1, dataSources: [vehicleDetentionData], yAxisTitle: 'Number of Vehicles',legendVisibility: false),
                      ),
                    ],
                  )),
             Container(
                      margin: EdgeInsets.all(aspectRatio * 8),
                      height: size.height * 0.45,
                      width: size.width * 0.25,
                      decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [const BoxShadow(color: Colors.grey, blurRadius: 5)]),
                      padding: EdgeInsets.all(size.height * 0.035),
                      alignment: Alignment.topCenter,
                  child: Customs.WMSPieChart(
                      title: ChartTitle(
                            text: 'Yard Utilization',
                            alignment: ChartAlignment.near,
                            textStyle: TextStyle(fontSize: aspectRatio * 8, fontWeight: FontWeight.bold),
                          ),
                    dataSource: [PieData(xData: "Available Locations", yData: 10,text: "10"), PieData(xData: "Occupied", yData: 4, text: "4")],
                    legendVisibility: true,
                    pointColorMapper: (piedata, index) {
                      if (index == 0) {
                        return Color.fromRGBO(255, 182, 24, 1);
                      } else if (index == 1) {
                        return Color.fromRGBO(161, 40, 40, 0.8);
                      }
                    },
                  )),
              Container(
                      margin: EdgeInsets.all(aspectRatio * 8),
                      height: size.height * 0.45,
                      width: size.width * 0.25,
                      decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)]),
                      padding: EdgeInsets.all(size.height * 0.035),
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Day Wise Task Summary ',
                            style: TextStyle(fontSize: aspectRatio * 10, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: size.height * 0.3,
                            width: size.width * 0.25,
                        child: WMSCartesianChart(
                                  
                            title: '',
                            primaryColor: Colors.blueAccent,
                            secondaryColor: const Color.fromARGB(255, 138, 40, 155),
                            barCount: 2,
                            isLegendVisible: true,
                            legendText: ["Loading", "Unloading"],
                            dataSources: [inBoundData, outBoundData],
                            yAxisTitle: 'Number of Vehicles'),
                      ),
                    ],
                  )),
            ],
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
                Container(
                      margin: EdgeInsets.all(aspectRatio * 8),
                      height: size.height * 0.45,
                      width: size.width * 0.25,
                      decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [const BoxShadow(color: Colors.grey, blurRadius: 5)]),
                      padding: EdgeInsets.all( size.height * 0.035),
                      alignment: Alignment.topCenter,
                  child: Customs.WMSSfCircularChart(size: size, chartData: avgYardTime, title: "Average Yard Time", contentText: "5h 25m",width: 150,height: 150,radius: "72%")),
           
             Container(
                      margin: EdgeInsets.all(aspectRatio * 8),
                      height: size.height * 0.45,
                      width: size.width * 0.25,
                      decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [const BoxShadow(color: Colors.grey, blurRadius: 5)]),
                      padding: EdgeInsets.all(size.height * 0.035),
                      alignment: Alignment.topCenter, 
         child:   SfCircularChart(
              title:ChartTitle(text: "Previous month yard acitvity"),
              legend: Legend(isResponsive: true,isVisible: true),
            series: <CircularSeries>[
                // Renders radial bar chart
                RadialBarSeries<ChartData, String>(
                    dataSource: chartData,
                   dataLabelSettings: DataLabelSettings(
                        // Renders the data label
                        isVisible: true,
                          textStyle: TextStyle(fontWeight: FontWeight.bold),
                        alignment: ChartAlignment.near
                    ),
                    name: "Loading and Unloading Count",
                    pointColorMapper: (datum, index) {
                      if(datum.x=="Loading"){
                        return  Color.fromRGBO(187, 44, 42, 1);
                      }
                      else{
                        return const Color.fromRGBO(	255,	166	,0,1);
                      }
                    },
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    
                )
            ]
        ))
            ],
          ),
          
        ],
      ),
    );
  }
}

    class ChartData {
        ChartData(this.x, this.y);
        final String x;
        final double y;
    }
// models for charts
// class PieData {
//   PieData(this.xData, this.yData, [this.text]);
//   final String xData;
//   final num yData;
//   String? text;
// }

// class BarData {
//   String xLabel;
//   int yValue;
//   String abbreviation;
//   BarData({required this.xLabel, required this.yValue, required this.abbreviation});
// }


// class AnalogChartData {
//         AnalogChartData(this.x, this.y, this.color);
//             final String x;
//             final double y;
//             final Color color;
//     }