import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';

class QRScan extends StatelessWidget {
  const QRScan({super.key, required this.frndIdC});
  final TextEditingController frndIdC;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QRCodeDartScanView(
        scanInvertedQRCode: true,
        typeScan: TypeScan.live,
        formats: const [BarcodeFormat.qrCode],
        onCapture: (Result result) {
          if (result.text.length == 28) {
            frndIdC.text = result.text;
            Get.back();
          }
        },
      ),
    );
  }
}
