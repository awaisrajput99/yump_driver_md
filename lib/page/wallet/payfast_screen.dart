// ignore_for_file: file_names

import 'dart:developer';

import 'package:yumprides_driver/model/payment_setting_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayFastScreen extends StatefulWidget {
  final String htmlData;
  final PayFast payFastSettingData;

  const PayFastScreen(
      {super.key, required this.htmlData, required this.payFastSettingData});

  @override
  State<PayFastScreen> createState() => _PayFastScreenState();
}

class _PayFastScreenState extends State<PayFastScreen> {
  WebViewController controller = WebViewController();

  @override
  void initState() {
    initController();
    super.initState();
  }

  initController() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest navigation) async {
            if (kDebugMode) {
              log("--->2 $navigation");
            }
            if (navigation.url == widget.payFastSettingData.returnUrl) {
              Navigator.pop(context, true);
            } else if (navigation.url == widget.payFastSettingData.notifyUrl) {
              Navigator.pop(context, false);
            } else if (navigation.url == widget.payFastSettingData.cancelUrl) {
              _showMyDialog();
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadHtmlString((widget.htmlData));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showMyDialog();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              _showMyDialog();
            },
            child: const Icon(
              Icons.arrow_back,
            ),
          ),
        ),
        body: WebViewWidget(controller: controller),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Payment'.tr),
          content: SingleChildScrollView(
            child: Text("Cancel Payment?".tr),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Exit'.tr,
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text(
                'Continue Payment'.tr,
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
