
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:warehouse_3d/pages/dashboard_utils/shared/constants/ghaps.dart';

import '../../constants/config.dart';
import '../../constants/defaults.dart';
import 'menu_tile.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // width: Responsive.isMobile(context) ? double.infinity : null,
      // width: MediaQuery.of(context).size.width < 1300 ? 260 : null,
      child: SafeArea(
        child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            gapH16,
            Text("Dashboard's",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.black),textAlign: TextAlign.center,),
            
            gapH16,
            Divider(
              thickness: 2,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDefaults.padding,
                ),
                child: ListView(
                  children: [
                    MenuTile(
                      isActive: true,
                      title: "Yard",
                    
                      onPressed: () {},
                    ),
                    MenuTile(
                      
                      title: "Storage",
                      
                      onPressed: () {},
                    ),
                    MenuTile(
                      title: "Staging",
                      
                      onPressed: () {},
                    ),
                    MenuTile(
                      title: "Activity",
                      
                      onPressed: () {},
                    ),
                    MenuTile(
                      title: "Receiving",
                     
                      onPressed: () {},
                    ),
                    MenuTile(
                      title: "Inspection",
                      
                      onPressed: () {},
                    ),
                   
                   
                  ],
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(AppDefaults.padding),
            //   child: Column(
            //     children: [
            //       if (Responsive.isMobile(context))
            //         const CustomerInfo(
            //           name: 'Tran Mau Tri Tam',
            //           designation: 'Visual Designer',
            //           imageSrc:
            //               'https://cdn.create.vista.com/api/media/small/339818716/stock-photo-doubtful-hispanic-man-looking-with-disbelief-expression',
            //         ),
            //       gapH8,
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}