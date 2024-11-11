import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:warehouse_3d/pages/customs/customs.dart';
import 'package:warehouse_3d/pages/dashboard_utils/shared/constants/defaults.dart';

class StagingAreaDashboard extends StatelessWidget {
  StagingAreaDashboard({super.key});

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
              'Staging Area Dashboard',
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
                                    dataSource: [PieData("Available", 16, "16"), PieData("Occupied", 4, "4")],
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
                                    Customs.WMSPieChart(title: 'In Bound vs Out Bound', dataSource: [PieData("Total", 10, "10"), PieData("Active", 4, "4")])),
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
