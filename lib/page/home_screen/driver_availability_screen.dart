import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:yumprides_driver/page/home_screen/home_screen.dart';

import '../../constant/constant.dart';
import '../../controller/map_screen_controller.dart';
import '../../controller/dash_board_controller.dart';
import '../../controller/new_ride_controller.dart';
import '../../model/ride_request_notification_modal.dart';
import '../../model/user_model.dart';
import '../../themes/constant_colors.dart';
import '../../themes/custom_alert_dialog.dart';
import '../../themes/custom_dialog_box.dart';
import '../../utils/theme_provider.dart';

class DriverAvailabilityScreen extends StatefulWidget {
  const DriverAvailabilityScreen({super.key});

  @override
  State<DriverAvailabilityScreen> createState() => _DriverAvailabilityScreenState();
}

class _DriverAvailabilityScreenState extends State<DriverAvailabilityScreen> {
  final DashBoardController dashboardController = Get.put(DashBoardController());
  final NewRideController newRideController = Get.put(NewRideController());
  final MapScreenController mapScreenController = Get.put(MapScreenController());
  final RideRequestNotificationModel rideRequest = Get.arguments;


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final themeChange = Provider.of<ThemeProvider>(context);
   if(rideRequest == null) {
     return Scaffold();
   }
    return Scaffold(
      body: GetX<MapScreenController>(
        builder: (controller) => Column(
          children: [
            // Top half with map and back button
            Expanded(
              // flex: 1,
              child: Stack(
                children: [
                  GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: controller.center,
                      zoom: 14.0,
                    ),
                    markers: Set<Marker>.of(controller.markers.values),
                    onMapCreated: (GoogleMapController mapController) {
                      controller.mapController = mapController;
                      controller.moveToCurrentLocation();
                    },
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    compassEnabled: false,
                    polylines: Set<Polyline>.of(controller.polyLines.values),
                    myLocationEnabled: true,
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Icon(Icons.arrow_back, color: Colors.black),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

            // Lower half UI
            Expanded(
              // flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: themeChange.getThem() ? AppThemeData.grey900Dark : Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Departure and Destination
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              UserModel userModal = Constant.getUserData();
                              String id = userModal.userData!.id.toString();
                              final response = await controller.available(driverId: id, sessionId: rideRequest.sessionId);
                              if(response['success'] == true){
                                showDialog(
                                    context: context,
                                    builder:
                                        (BuildContext context) {
                                      return CustomDialogBox(
                                        title:
                                        "Thank you!"
                                            .tr,
                                        descriptions:
                                        "Thanks for letting us know you're available for the ride! Please hold on while the rider completes the payment. You'll receive a notification once the ride is confirmed, and you can view it under the 'All Rides' section."
                                            .tr,
                                        text: "Ok".tr,
                                        onPress: () {
                                          Get.offAll(()=> HomeScreen());
                                        },
                                        img: Image.asset(
                                            'assets/images/green_checked.png'),
                                      );
                                    });
                              } else {
                                showDialog(
                                    context: context,
                                    builder:
                                        (BuildContext context) {
                                      return CustomDialogBox(
                                        title:
                                        "Sorry!"
                                            .tr,
                                        descriptions:
                                        'You responded after the 30-second window, so this ride has been assigned to another driver. Hang tight—more ride opportunities are coming soon!'
                                            .tr,
                                        onPress: () {
                                          Get.offAll(()=> HomeScreen());
                                        },
                                        img: Image.asset(
                                            'assets/images/sorry_image.png'),
                                        text: 'Ok'.tr,
                                      );
                                    });
                              }
                            },

                            child: Text(controller.isAccepting.value ? "Please wait ..":"Available", style: TextStyle(
                              fontFamily: AppThemeData.bold,
                              fontSize: 18
                            ),),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              UserModel userModal = Constant.getUserData();
                              String id = userModal.userData!.id.toString();
                              final response =  await controller.busy(driverId: id, sessionId: rideRequest.sessionId);
                              if(response['success'] != "Failed"){
                                showDialog(
                                    context: context,
                                    builder:
                                        (BuildContext context) {
                                      return CustomDialogBox(
                                        title:
                                        "Thank you!"
                                            .tr,
                                        descriptions:
                                        "Thank you for your quick response. Since you're currently unavailable, this ride will be forwarded to the next nearby driver. Don't worry—we’ll reach out to you again shortly with another request to confirm your availability."                                            .tr,
                                        text: "Ok".tr,
                                        onPress: () {
                                          Get.offAll(()=> HomeScreen());
                                        },
                                        img: Image.asset(
                                            'assets/images/green_checked.png'),
                                      );
                                    });
                              } else {
                                showDialog(
                                    context: context,
                                    builder:
                                        (BuildContext context) {
                                      return CustomDialogBox(
                                        title:
                                        "Sorry!"
                                            .tr,
                                        descriptions:
                                        'You responded after the 30-second window, so this ride has been assigned to another driver. Hang tight—more ride opportunities are coming soon!'
                                            .tr,
                                        onPress: () {
                                          Get.offAll(()=> HomeScreen());
                                        },
                                        img: Image.asset(
                                            'assets/images/sorry_image.png'),
                                        text: 'Ok'.tr,
                                      );
                                    });                              }
                            },

                            child:  Text(controller.isRejecting.value ? "please wait ..": "Busy",style: TextStyle(
                                fontFamily: AppThemeData.bold,
                                fontSize: 18
                            ),),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Text("Departure Location", style: textTheme.labelLarge,),
                    const SizedBox(height: 4),
                    Text(rideRequest.departureName, style: textTheme.headlineLarge),

                    const SizedBox(height: 12),

                    Text("Destination Location", style: textTheme.labelLarge,),
                    const SizedBox(height: 4),
                    Text(rideRequest.destinationName, style: textTheme.headlineLarge),

                    const SizedBox(height: 15),
                    Row(
                      children: [
                        timeAndVehicleContainer('Pickup time', textTheme, rideRequest.pickupTime),
                        SizedBox(width: 20,),
                        timeAndVehicleContainer('Distance', textTheme, rideRequest.totalDistance),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Read-only fields
                    Text('Passenger name:', style: textTheme.labelLarge,),
                    SizedBox(height: 4,),
                    Text(rideRequest.passengerName, style: textTheme.headlineLarge),
                    Divider()




                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget timeAndVehicleContainer(String label, TextTheme textTheme, String value){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.labelLarge),
        SizedBox(height: 5,),
        Container(
          constraints: BoxConstraints(
            minWidth: 100
          ),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(4)
          ),
          child: Text(value,style: textTheme.headlineLarge),
        ),
      ],
    );
  }

  Widget buildReadOnlyField( String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        readOnly: true,
        initialValue: value,
        style: valueStyle(),
        decoration: InputDecoration(
          border: const UnderlineInputBorder(), // Default border
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey,),
          ),
          disabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
        ),
      ),
    );
  }

  TextStyle labelStyle() {
    return  TextStyle(fontSize: 16, fontFamily: AppThemeData.semiBold, color: Colors.grey);
  }

  TextStyle valueStyle() {
    return const TextStyle(fontSize: 20, fontFamily: AppThemeData.bold);
  }
}