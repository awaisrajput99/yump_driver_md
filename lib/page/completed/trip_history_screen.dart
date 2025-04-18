import 'package:yumprides_driver/constant/constant.dart';
import 'package:yumprides_driver/controller/payment_controller.dart';
import 'package:yumprides_driver/model/tax_model.dart';
import 'package:yumprides_driver/themes/app_bar_custom.dart';
import 'package:yumprides_driver/themes/button_them.dart';
import 'package:yumprides_driver/themes/constant_colors.dart';
import 'package:yumprides_driver/themes/custom_widget.dart';
import 'package:yumprides_driver/utils/theme_provider.dart';
import 'package:yumprides_driver/widget/StarRating.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';

class TripHistoryScreen extends StatelessWidget {
  const TripHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final themeChange = Provider.of<ThemeProvider>(context);
    return GetX<PaymentController>(
        init: PaymentController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.getThem()
                ? AppThemeData.grey80Dark
                : AppThemeData.white90,
            appBar: AppbarCustom(title: "Trip Details".tr),
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: themeChange.getThem()
                                ? AppThemeData.surface50Dark
                                : AppThemeData.surface50,
                            borderRadius:
                            const BorderRadius.all(Radius.circular(15.0)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            controller.data.value.rideDate
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontFamily: AppThemeData.regular,
                                            ),
                                          ),
                                          ButtonThem.statusButton(
                                            radius: 6,
                                            context,
                                            title: controller.data.value.statut
                                                .toString(),
                                            btnHeight: 40,
                                            btnWidthRatio: 0.30,
                                            btnColor: Constant.statusTextColor(
                                                controller.data.value),
                                            txtColor: Constant.statusTextColor(
                                                controller.data.value),
                                            onPress: () async {},
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            children: [
                                              SvgPicture.asset(
                                                "assets/icons/ic_source.svg",
                                                height: 24,
                                                fit: BoxFit.cover,
                                              ),
                                              Image.asset(
                                                "assets/icons/line.png",
                                                height: 30,
                                                color: AppThemeData.grey400,
                                                fit: BoxFit.cover,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: Text(
                                              controller.data.value.departName
                                                  .toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      /* ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount:
                                          controller.data.value.stops!.length,
                                      itemBuilder: (context, int index) {
                                        return Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  String.fromCharCode(
                                                      index + 65),
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Image.asset(
                                                  "assets/icons/line.png",
                                                  height: 30,
                                                  color: ConstantColors
                                                      .hintTextColor,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    controller.data.value
                                                        .stops![index].location
                                                        .toString(),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const Divider(),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      }),*/
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/ic_destenation.svg",
                                            height: 24,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: Text(
                                              controller.data.value.destinationName
                                                  .toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ]),
                              ),
                              dividerCust(isDarkMode: themeChange.getThem()),
                              const SizedBox(
                                height: 16,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              TextScroll(
                                                '${double.parse(controller.data.value.distance.toString()).toStringAsFixed(int.parse(Constant.decimal!))} ${Constant.distanceUnit}',
                                                mode: TextScrollMode.bouncing,
                                                pauseBetween:
                                                const Duration(seconds: 2),
                                                style: TextStyle(
                                                    color: AppThemeData.primary400,
                                                    fontSize: 18,
                                                    fontFamily:
                                                    AppThemeData.semiBold),
                                              ),
                                              Text("Distance".tr,
                                                  style: TextStyle(
                                                      color: themeChange.getThem()
                                                          ? AppThemeData.grey900Dark
                                                          : AppThemeData.grey900,
                                                      fontSize: 12,
                                                      fontFamily:
                                                      AppThemeData.regular)),
                                            ],
                                          ),
                                        ),
                                        /*   const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            controller.data.value.numberPoeple
                                                .toString(),
                                            style: TextStyle(
                                                color: AppThemeData.primary400,
                                                fontSize: 18,
                                                fontFamily:
                                                    AppThemeData.semiBold),
                                          ),
                                          Text("Passangers".tr,
                                              style: TextStyle(
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.grey900Dark
                                                      : AppThemeData.grey900,
                                                  fontSize: 12,
                                                  fontFamily:
                                                      AppThemeData.regular)),
                                        ],
                                      ),
                                    ),*/
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              TextScroll(
                                                controller.data.value.duree
                                                    .toString(),
                                                mode: TextScrollMode.bouncing,
                                                pauseBetween:
                                                const Duration(seconds: 2),
                                                style: TextStyle(
                                                    color: AppThemeData.primary400,
                                                    fontSize: 18,
                                                    fontFamily:
                                                    AppThemeData.semiBold),
                                              ),
                                              Text("Duration".tr,
                                                  style: TextStyle(
                                                      color: themeChange.getThem()
                                                          ? AppThemeData.grey900Dark
                                                          : AppThemeData.grey900,
                                                      fontSize: 12,
                                                      fontFamily:
                                                      AppThemeData.regular)),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Text(
                                                Constant().amountShow(
                                                    amount: controller
                                                        .data.value.montant
                                                        .toString()),
                                                style: TextStyle(
                                                    color: AppThemeData.primary400,
                                                    fontSize: 18,
                                                    fontFamily:
                                                    AppThemeData.semiBold),
                                              ),
                                              Text("Trip Price".tr,
                                                  style: TextStyle(
                                                      color: themeChange.getThem()
                                                          ? AppThemeData.grey900Dark
                                                          : AppThemeData.grey900,
                                                      fontSize: 12,
                                                      fontFamily:
                                                      AppThemeData.regular)),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 32,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 16),
                                      child: Row(
                                        children: [
                                          ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl: controller
                                                  .data.value.photoPath
                                                  .toString(),
                                              height: 45,
                                              width: 45,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  Constant.loader(context,
                                                      isDarkMode:
                                                      themeChange.getThem()),
                                              errorWidget: (context, url, error) =>
                                                  Image.asset(
                                                    "assets/images/appIcon.png",
                                                  ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.only(left: 12.0),
                                              child: controller.data.value
                                                  .rideType! ==
                                                  'driver' &&
                                                  controller.data.value
                                                      .existingUserId
                                                      .toString() ==
                                                      "null"
                                                  ? Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      '${controller.data.value.userInfo!.name}',
                                                      style: TextStyle(
                                                        color: themeChange
                                                            .getThem()
                                                            ? AppThemeData
                                                            .grey900Dark
                                                            : AppThemeData
                                                            .grey900,
                                                        fontSize: 16,
                                                        fontFamily:
                                                        AppThemeData
                                                            .semiBold,
                                                      )),
                                                  Text(
                                                      '${controller.data.value.userInfo!.email}',
                                                      style: const TextStyle(
                                                          color:
                                                          Colors.black87,
                                                          fontWeight:
                                                          FontWeight
                                                              .w400)),
                                                ],
                                              )
                                                  : Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      '${controller.data.value.prenom.toString()} ${controller.data.value.nom.toString()}',
                                                      style: TextStyle(
                                                        color: themeChange
                                                            .getThem()
                                                            ? AppThemeData
                                                            .grey900Dark
                                                            : AppThemeData
                                                            .grey900,
                                                        fontSize: 16,
                                                        fontFamily:
                                                        AppThemeData
                                                            .semiBold,
                                                      )),
                                                  StarRating(
                                                      size: 18,
                                                      rating: double.parse(
                                                          controller
                                                              .data
                                                              .value
                                                              .moyenneDriver
                                                              .toString()),
                                                      color: AppThemeData
                                                          .warning200),
                                                ],
                                              ),
                                            ),
                                          ),
                                          /*Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                if (controller.data.value
                                                            .rideType! ==
                                                        'driver' &&
                                                    controller.data.value
                                                            .existingUserId
                                                            .toString() ==
                                                        "null") {
                                                  Constant.makePhoneCall(
                                                      controller.data.value
                                                          .userInfo!.phone
                                                          .toString());
                                                } else {
                                                  Constant.makePhoneCall(
                                                      controller
                                                          .data.value.phone
                                                          .toString());
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor:
                                                    AppThemeData.new200,
                                                shape: const CircleBorder(),
                                                backgroundColor:
                                                    AppThemeData.new200,
                                                padding: const EdgeInsets.all(
                                                    6), // <-- Splash color
                                              ),
                                              child: const Icon(
                                                Icons.call,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )*/
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: themeChange.getThem()
                                  ? AppThemeData.surface50Dark
                                  : AppThemeData.surface50,
                              borderRadius:
                              const BorderRadius.all(Radius.circular(15.0)),
                            ),
                            child: Column(
                              children: [
                                listTile(
                                    isDarkMode: themeChange.getThem(),
                                    lbl: "Ride Cost",
                                    value: Constant().amountShow(
                                      amount:
                                      controller.data.value.baseCost.toString(),
                                    )),
                                dividerCust(isDarkMode: themeChange.getThem()),
                                /*  listTile(
                              isDarkMode: themeChange.getThem(),
                              lbl: "Discount",
                              value:
                                  "(-${Constant().amountShow(amount: controller.discountAmount.value.toString())})",
                              valueColor: AppThemeData.warning200,
                            ),*/
                                listTile(
                                    isDarkMode: themeChange.getThem(),
                                    lbl: "Tax",
                                    value: Constant().amountShow(
                                      amount:
                                      controller.data.value.taxAmount,
                                    )),
                                dividerCust(isDarkMode: themeChange.getThem()),

                                /*ListView.builder(
                              itemCount: controller.data.value.taxModel!.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                TaxModel taxModel =
                                    controller.data.value.taxModel![index];
                                return Column(
                                  children: [
                                    listTile(
                                      isDarkMode: themeChange.getThem(),
                                      lbl:
                                          '${taxModel.libelle.toString()} (${taxModel.type == "Fixed" ? Constant().amountShow(amount: taxModel.value) : "${taxModel.value}%"})',
                                      value: Constant().amountShow(
                                          amount: controller
                                              .calculateTax(taxModel: taxModel)
                                              .toString()),
                                    ),
                                    dividerCust(
                                        isDarkMode: themeChange.getThem()),
                                  ],
                                );
                              },
                            ),*/

                                // Row(
                                //   children: [
                                //     Expanded(
                                //         child: Text(
                                //       "${Constant.taxName} ${Constant.taxType.toString() == "Percentage" ? "(${Constant.taxValue}%)" : "(${Constant.taxValue})"}",
                                //       style: TextStyle(
                                //           letterSpacing: 1.0,
                                //           color: ConstantColors.subTitleTextColor,
                                //           fontWeight: FontWeight.w600),
                                //     )),
                                //     Text(
                                //         Constant().amountShow(
                                //             amount: controller.taxAmount.value
                                //                 .toString()),
                                //         style: TextStyle(
                                //             letterSpacing: 1.0,
                                //             color: ConstantColors.titleTextColor,
                                //             fontWeight: FontWeight.w800)),
                                //   ],
                                // ),
                                /*         listTile(
                              isDarkMode: themeChange.getThem(),
                              lbl: "Driver Tip",
                              value: Constant().amountShow(
                                  amount:
                                      controller.tipAmount.value.toString()),
                            ),*/
                                dividerCust(isDarkMode: themeChange.getThem()),
                                listTile(
                                    isDarkMode: themeChange.getThem(),
                                    lbl: "Total",
                                    value: Constant().amountShow(
                                        amount:
                                        controller.data.value.netCost),
                                    valueColor: AppThemeData.primary200),
                              ],
                            ),
                          ),
                        ),
                        /*          listTile(
                        isDarkMode: themeChange.getThem(),
                        lbl: "Admin commission",
                        value:
                            "(-${Constant().amountShow(amount: controller.adminCommission.value.toString())})",
                        valueColor: AppThemeData.warning200),*/
                        /* Container(
                      decoration: BoxDecoration(
                        color: themeChange.getThem()
                            ? AppThemeData.surface50Dark
                            : AppThemeData.surface50,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Note : Admin commission will be debited from your wallet balance. \n\nAdmin commission will apply on trip Amount minus Discount(If applicable)."
                                  .tr,
                              style: TextStyle(
                                  fontFamily: AppThemeData.light,
                                  color: AppThemeData.warning200),
                            )
                          ],
                        ),
                      ),
                    ),*/
                      ],
                    ),
                  ),
                ),
                if(controller.data.value.statutPaiement == 'yes')
                  Positioned(
                    left: size.width*0.3,
                    bottom: 15,
                    child: Image.asset("assets/images/md_paid_stamp.png",
                    width: size.width * 0.4,
                      height: size.width * 0.4,
                    ),
                  )
              ],
            ),
          );
        });
  }
}
