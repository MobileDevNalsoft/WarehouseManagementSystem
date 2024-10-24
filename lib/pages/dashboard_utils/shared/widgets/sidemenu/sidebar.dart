
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Dashboard",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.black),),
            
            gapH16,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDefaults.padding,
                ),
                child: ListView(
                  children: [
                    MenuTile(
                      title: "Yard",
                      activeIconSrc: "assets/icons/store_light.svg",
                      inactiveIconSrc: "assets/icons/store_filled.svg",
                      onPressed: () {},
                    ),
                    MenuTile(
                      title: "Storage",
                      activeIconSrc: "assets/icons/store_light.svg",
                      inactiveIconSrc: "assets/icons/store_filled.svg",
                      onPressed: () {},
                    ),
                    MenuTile(
                      title: "Staging",
                      activeIconSrc: "assets/icons/store_light.svg",
                      inactiveIconSrc: "assets/icons/store_filled.svg",
                      onPressed: () {},
                    ),
                    MenuTile(
                      title: "Activity",
                      activeIconSrc: "assets/icons/store_light.svg",
                      inactiveIconSrc: "assets/icons/store_filled.svg",
                      onPressed: () {},
                    ),
                    MenuTile(
                      title: "Receiving",
                      activeIconSrc: "assets/icons/store_light.svg",
                      inactiveIconSrc: "assets/icons/store_filled.svg",
                      onPressed: () {},
                    ),
                    MenuTile(
                      title: "Inspection",
                      activeIconSrc: "assets/icons/store_light.svg",
                      inactiveIconSrc: "assets/icons/store_filled.svg",
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