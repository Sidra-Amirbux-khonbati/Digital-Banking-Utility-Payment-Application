import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../transaction/transfer_screen.dart';


class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController controller = MobileScannerController();

  bool scanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Scanner"),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () {
              controller.toggleTorch();
            },
          ),
        ],
      ),

      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
  if (scanned) return;

  final Barcode? barcode = capture.barcodes.firstOrNull;

  if (barcode == null) return;

  scanned = true;

  final String result = barcode.rawValue ?? "";

  try {
    final Uri uri = Uri.parse(result);

    if (uri.scheme == "billexpress" &&
        uri.host == "transfer") {

      final String toAccount =
          uri.queryParameters["to"] ?? "";

      final String amount =
          uri.queryParameters["amount"] ?? "";

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => TransferScreen(
            toAccount: toAccount,
            amount: amount,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid Bill Express QR Code"),
        ),
      );

      scanned = false;
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Invalid QR Code"),
      ),
    );

    scanned = false;
  }
},
          ),

          Align(
            alignment: Alignment.center,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}