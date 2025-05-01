import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class NetworkStatusService {
  static final NetworkStatusService _instance = NetworkStatusService._internal();
  factory NetworkStatusService() => _instance;
  NetworkStatusService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription; // 🔥 Corrected Type

  /// Check current internet connection
  Future<bool> checkInternetConnection({Duration timeout = const Duration(seconds: 5)}) async {
    try {
      var connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        return false;
      }

      final response = await http.get(Uri.parse('https://www.google.com')).timeout(timeout);
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// Listen to live internet changes
  void listenToInternetChanges(BuildContext context) {
    _subscription ??= _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> resultList) async {
      final hasInternet = await checkInternetConnection();

      if (!hasInternet) {
        _showToast("🔌 No internet connection", context, Colors.red);
      } else {
        _showToast("✅ Internet is back", context, Colors.green);
      }
    });
  }

  /// Stop listening
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }

  /// Show toast
  void _showToast(String message, BuildContext context, Color backgroundColor) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}