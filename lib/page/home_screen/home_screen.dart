import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:yumprides_driver/controller/dash_board_controller.dart';
import 'package:yumprides_driver/controller/map_screen_controller.dart';
import 'package:yumprides_driver/controller/new_ride_controller.dart';
import 'package:yumprides_driver/page/loading_screen.dart';

import '../../constant/constant.dart';
import '../../constant/logdata.dart';
import '../../constant/send_notification.dart';
import '../../constant/show_toast_dialog.dart';
import '../../model/user_model.dart';
import '../../themes/constant_colors.dart';
import '../../utils/Preferences.dart';
import '../../utils/theme_provider.dart';
import '../dash_board.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    final newRideCotroller = Get.put(NewRideController());
    final themeChange = Provider.of<ThemeProvider>(context);
    final controllerDashBoard = Get.put(DashBoardController());
    return GetBuilder<MapScreenController>(
        init: MapScreenController(),
        builder: (controller){
          return controller.isLoading.value? LoadingScreen(controller: controller) :  Scaffold(
              key: _scaffoldKey,
              drawer: buildAppDrawer(context, controllerDashBoard),
              body: Stack(
                children: [
                  GoogleMap(
                    mapType: MapType.normal,
                    // Set initial camera position (will be updated when location is available)
                    initialCameraPosition: CameraPosition(
                      target: controller.center,
                      zoom: 14.0,
                    ),
                    // Use markers from controller
                    markers: Set<Marker>.of(controller.markers.values),
                    // Handle map creation
                    onMapCreated: (GoogleMapController mapController) {
                      controller.mapController = mapController;
                      // Move to current location if already available
                      controller.moveToCurrentLocation();
                    },
                    // Other map properties
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    compassEnabled: false,
                    polylines: Set<Polyline>.of(controller.polyLines.values),
                    myLocationEnabled: true,
                  ),
                  SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: appBarHome(
                            controller: newRideCotroller,
                            isDarkMode: themeChange.getThem(),
                            controllerDashBoard: controllerDashBoard),
                      )),

                ],
              )
          );
        });
  }

  Widget appBarHome(
      {required NewRideController controller,
      required bool isDarkMode,
      required DashBoardController controllerDashBoard}) {
    final themeChange = Provider.of<ThemeProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () async {
                    _scaffoldKey.currentState?.openDrawer();
                    // Scaffold.of(context).openDrawer();
                  },
                  child: Image.asset(
                    "assets/icons/ic_side_menu.png",
                    color: themeChange.getThem()
                        ? AppThemeData.grey900Dark
                        : AppThemeData.grey900,
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    "Status".tr,
                    style: TextStyle(
                      color: themeChange.getThem()
                          ? AppThemeData.grey500Dark
                          : AppThemeData.grey500,
                      fontFamily: AppThemeData.regular,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: controllerDashBoard.isActive.value,
                      activeColor: AppThemeData.success300,
                      inactiveTrackColor: AppThemeData.white90,
                      onChanged: (value) async {
                        await controllerDashBoard.getUsrData();
                        if (controllerDashBoard
                                .userModel.value.userData!.statutVehicule ==
                            "no") {
                          showAlertDialog(context, "vehicleInformation");
                        } else if (controllerDashBoard
                                    .userModel.value.userData!.isVerified ==
                                "no" ||
                            controllerDashBoard.userModel.value.userData!
                                .isVerified!.isEmpty) {
                          showAlertDialog(context, "document");
                        } else {
                          ShowToastDialog.showLoader("Please wait");

                          Map<String, dynamic> bodyParams = {
                            'id_driver': Preferences.getInt(Preferences.userId),
                            'online': controllerDashBoard.isActive.value
                                ? 'no'
                                : 'yes',
                          };

                          await controllerDashBoard
                              .changeOnlineStatus(bodyParams)
                              .then((value) {
                            if (value != null) {
                              if (value['success'] == "success") {
                                UserModel userModel = Constant.getUserData();
                                userModel.userData!.online =
                                    value['data']['online'];
                                controller.userModel.value = userModel;
                                Preferences.setString(Preferences.user,
                                    jsonEncode(userModel.toJson()));
                                controllerDashBoard.isActive.value =
                                    userModel.userData!.online == 'no'
                                        ? false
                                        : true;
                                ShowToastDialog.showToast(value['message']);
                              } else {
                                ShowToastDialog.showToast(value['error']);
                              }
                            }
                          });

                          ShowToastDialog.closeLoader();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
