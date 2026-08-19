import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class DepositMoneyScreen extends StatefulWidget {
  final Map<String, dynamic> customer;

  const DepositMoneyScreen({
    super.key,
    required this.customer,
  });

  @override
  State<DepositMoneyScreen> createState() => _DepositMoneyScreenState();
}

class _DepositMoneyScreenState extends State<DepositMoneyScreen> {
  final TextEditingController amountController = TextEditingController();

  bool isLoading = false;
  double currentBalance = 0;

  @override
  void initState() {
    super.initState();
    loadBalance();
  }

  Future<void> loadBalance() async {
    try {
      final balance = await ApiService.getBalance(
        widget.customer["account_no"].toString(),
      );

      setState(() {
        currentBalance =
            double.tryParse(balance["running_balance"].toString()) ?? 0;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> depositMoney() async {
    if (amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter deposit amount")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await ApiService.depositMoney(
        accountNo: widget.customer["account_no"].toString(),
        amount: double.parse(amountController.text),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response["message"]),
          backgroundColor: Colors.green,
        ),
      );

      amountController.clear();

      loadBalance();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
        title: const Text("Deposit Money"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            Card(
              elevation: 4,
              child: ListTile(
                leading: const Icon(Icons.account_balance_wallet),
                title: const Text("Current Balance"),
                subtitle: Text(
                  "Rs. ${currentBalance.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            TextFormField(
              initialValue:
                  widget.customer["account_no"].toString(),
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Account Number",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.credit_card),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Deposit Amount",
                hintText: "Enter Amount",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.currency_rupee),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : depositMoney,
                icon: const Icon(Icons.account_balance),
                label: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Deposit Money",
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}