import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../services/session_service.dart';

class QrGeneratorScreen extends StatefulWidget {
  const QrGeneratorScreen({super.key});

  @override
  State<QrGeneratorScreen> createState() => _QrGeneratorScreenState();
}

class _QrGeneratorScreenState extends State<QrGeneratorScreen> {
  final TextEditingController amountController = TextEditingController();

  String qrData = "";

  @override
  Widget build(BuildContext context) {
    final customer = SessionService.customer;

    if (customer == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Generate QR")),
        body: const Center(child: Text("Please login first.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Receive Money")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 35,
                      child: Icon(Icons.person, size: 35),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      "${customer["first_name"]} ${customer["last_name"]}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      customer["email"],
                      style: const TextStyle(color: Colors.grey),
                    ),

                    const Divider(height: 30),

                    const Text(
                      "Account Number",
                      style: TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      customer["account_no"],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,

              decoration: InputDecoration(
                labelText: "Enter Amount",
                prefixIcon: const Icon(Icons.currency_rupee),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              height: 55,

              child: ElevatedButton(
                onPressed: () {
                  if (amountController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter amount")),
                    );

                    return;
                  }

                  setState(() {
                    qrData =
                        "billexpress://transfer?to=${customer["account_no"]}&amount=${amountController.text}";
                  });
                },

                child: const Text(
                  "Generate QR",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 35),

            if (qrData.isNotEmpty)
              Center(
                child: Column(
                  children: [
                    QrImageView(
                      data: qrData,
                      version: QrVersions.auto,
                      size: 250,
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Scan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text("Account : ${customer["account_no"]}"),

                    Text("Amount : ${amountController.text}"),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
