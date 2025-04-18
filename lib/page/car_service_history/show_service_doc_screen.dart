import 'package:yumprides_driver/model/car_service_book_model.dart';
import 'package:yumprides_driver/themes/constant_colors.dart';
import 'package:yumprides_driver/utils/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class ShowServiceDocScreen extends StatelessWidget {
  final ServiceData serviceData;

  const ShowServiceDocScreen({super.key, required this.serviceData});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeProvider>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(serviceData.fileName.toString()),
      ),
      body: SfPdfViewerTheme(
        data: SfPdfViewerThemeData(
          progressBarColor: AppThemeData.primary200,
          backgroundColor: themeChange.getThem()
              ? AppThemeData.surface50Dark
              : AppThemeData.surface50, //<----
        ),
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: SfPdfViewer.network(
            // 'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
            serviceData.photoCarServiceBookPath.toString(),
          ),
        ),
      ),
    );
  }
}
