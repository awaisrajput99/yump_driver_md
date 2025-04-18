// ignore_for_file: must_be_immutable

import 'package:yumprides_driver/calling_module/receive_call/backend/call_notifications.dart';
import 'package:yumprides_driver/constant/constant.dart';
import 'package:yumprides_driver/controller/dash_board_controller.dart';
import 'package:yumprides_driver/page/auth_screens/vehicle_info_screen.dart';
import 'package:yumprides_driver/page/document_status/document_status_screen.dart';
import 'package:yumprides_driver/page/home_screen/home_screen.dart';
import 'package:yumprides_driver/page/new_ride_screens/new_ride_screen.dart';
import 'package:yumprides_driver/themes/constant_colors.dart';
import 'package:yumprides_driver/themes/responsive.dart';
import 'package:yumprides_driver/utils/theme_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  DateTime backPress = DateTime.now();
  @override
  void initState() {
    super.initState();
    // listenForInvitations(
    //   context,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashBoardController>(
      init: DashBoardController(),
      builder: (controller) {
        listenForInvitations(
            context, controller.userModel.value.userData!.fbId!);

        controller.getDrawerItem();
        return WillPopScope(
          onWillPop: () async {
            final timeGap = DateTime.now().difference(backPress);
            final cantExit = timeGap >= const Duration(seconds: 2);
            backPress = DateTime.now();
            if (cantExit) {
              var snack = SnackBar(
                content: Text(
                  'Press Back button again to Exit'.tr,
                  style: TextStyle(color: Colors.white),
                ),
                duration: Duration(seconds: 2),
                backgroundColor: Colors.black,
              );
              ScaffoldMessenger.of(context).showSnackBar(snack);
              return false; // false will do nothing when back press
            } else {
              return true; // true will exit the app
            }
          },
          // child: Scaffold(body: NewRideScreen()),
          child: HomeScreen(),
        );
      },
    );
  }
}

buildAppDrawer(BuildContext context, DashBoardController controller) {
  final themeChange = Provider.of<ThemeProvider>(context);
  var drawerOptions = <Widget>[];
  for (var i = 0; i < controller.drawerItems.length; i++) {
    var d = controller.drawerItems[i];
    drawerOptions.add(
      InkWell(
        onTap: () {
          controller.onSelectItem(i);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Visibility(
              visible: d.section != null,
              child: Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 10, left: 16),
                child: Text(
                  d.section ?? '',
                  style: TextStyle(
                    color: themeChange.getThem() ? Colors.black : Colors.black,
                    fontSize: 14,
                    fontFamily: AppThemeData.regular,
                  ),
                ),
              ),
            ),
            d.isSwitch == true
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  (i == (controller.drawerItems.length - 1))
                                      ? 16
                                      : 0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  d.icon,
                                  width: 24,
                                  height: 24,
                                  colorFilter: ColorFilter.mode(
                                    i == (controller.drawerItems.length - 1)
                                        ? AppThemeData.error50
                                        : i == 0
                                            ? AppThemeData.primary200
                                            : themeChange.getThem()
                                                ? AppThemeData.grey900Dark
                                                : AppThemeData.grey900,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  d.title,
                                  style: TextStyle(
                                    color:
                                        i == (controller.drawerItems.length - 1)
                                            ? AppThemeData.error50
                                            : i == 0
                                                ? AppThemeData.primary200
                                                : themeChange.getThem()
                                                    ? AppThemeData.grey900Dark
                                                    : AppThemeData.grey900,
                                    fontSize: 16,
                                    fontFamily: AppThemeData.medium,
                                  ),
                                ),
                              ]),
                        ),
                        d.isSwitch == true
                            ? SizedBox(
                                // height: 25,
                                // child: Switch(
                                //   trackOutlineColor:
                                //       WidgetStateProperty.resolveWith<Color>(
                                //           (Set<WidgetState> states) {
                                //     return Colors.transparent;
                                //   }),
                                //   inactiveTrackColor: themeChange.getThem()
                                //       ? AppThemeData.grey300Dark
                                //       : AppThemeData.grey300,
                                //   activeTrackColor: AppThemeData.primary200,
                                //   thumbColor: WidgetStateProperty.resolveWith<Color>(
                                //       (Set<WidgetState> states) {
                                //     return themeChange.getThem()
                                //         ? AppThemeData.white90
                                //         : AppThemeData.grey80Dark;
                                //   }),
                                //   value: themeChange.getThem(),
                                //   onChanged: (value) =>
                                //       (themeChange.darkTheme = value == true ? 0 : 1),
                                // ),
                                )
                            : SvgPicture.asset(
                                'assets/icons/ic_right_arrow.svg',
                                width: 20,
                                height: 20,
                                colorFilter: ColorFilter.mode(
                                  themeChange.getThem()
                                      ? AppThemeData.grey400Dark
                                      : AppThemeData.grey400,
                                  BlendMode.srcIn,
                                ),
                              ),
                      ],
                    ),
                  ),
            if ((controller.drawerItems.length - 2) > i)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                height: 0.5,
                color: themeChange.getThem()
                    ? AppThemeData.grey200Dark
                    : AppThemeData.grey200,
              )
          ],
        ),
      ),
    );
  }

  return Drawer(
    width: Responsive.width(85, context),
    backgroundColor: themeChange.getThem()
        ? AppThemeData.surface50Dark
        : AppThemeData.surface50,
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const SizedBox(height: 40),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {},
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(80.0),
                  child:
                      controller.userModel.value.userData!.photoPath?.isEmpty ==
                              true
                          ? CachedNetworkImage(
                              imageUrl: Constant.placeholderUrl!,
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Center(
                                child: CircularProgressIndicator(
                                    value: downloadProgress.progress),
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                "assets/images/appIcon.png",
                              ),
                            )
                          : CachedNetworkImage(
                              imageUrl: controller
                                  .userModel.value.userData!.photoPath
                                  .toString(),
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Center(
                                child: CircularProgressIndicator(
                                    value: downloadProgress.progress),
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                "assets/images/appIcon.png",
                              ),
                            ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                "${controller.userModel.value.userData!.prenom} ${controller.userModel.value.userData!.nom}",
                style: TextStyle(
                  color: themeChange.getThem()
                      ? AppThemeData.grey900Dark
                      : AppThemeData.grey900,
                  fontSize: 22,
                  fontFamily: AppThemeData.regular,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '${controller.userModel.value.userData!.email}',
                style: TextStyle(
                  color: themeChange.getThem()
                      ? AppThemeData.grey500Dark
                      : AppThemeData.grey500,
                  fontSize: 14,
                  fontFamily: AppThemeData.regular,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Column(children: drawerOptions),
          ],
        ),
      ],
    ),
  );
}

Future<void> showAlertDialog(BuildContext context, String type) async {
  return showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        // <-- SEE HERE
        title: Text('Information'.tr),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                  'To start earning with Yum Rides you need to fill in your information'
                      .tr),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'No'.tr,
              style: TextStyle(
                fontSize: 16,
                fontFamily: AppThemeData.regular,
                color: AppThemeData.primary200,
              ),
            ),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            child: Text(
              'Yes'.tr,
              style: TextStyle(
                fontSize: 16,
                fontFamily: AppThemeData.regular,
                color: AppThemeData.primary200,
              ),
            ),
            onPressed: () {
              if (type == "document") {
                Get.back();
                Get.to(DocumentStatusScreen());
              } else {
                Get.back();
                Get.to(const VehicleInfoScreen());
              }
            },
          ),
        ],
      );
    },
  );
}

class DrawerItem {
  String? title;
  String? icon;
  String? section;
  bool? isSwitch;

  DrawerItem(this.title, this.icon, {this.section, this.isSwitch});
}
