import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class CompanyStatusScreen extends StatefulWidget {
  const CompanyStatusScreen({super.key});

  @override
  State<CompanyStatusScreen> createState() =>
      _CompanyStatusScreenState();
}

class _CompanyStatusScreenState
    extends State<CompanyStatusScreen> {

  final TextEditingController emailController =
      TextEditingController();

  Map<String, dynamic>? result;

  bool loading = false;

  Future<void> checkStatus() async {

    setState(() {
      loading = true;
    });

    try {

      final response =
          await ApiService.checkCompanyStatus(
              emailController.text);

      setState(() {
        result = response;
      });

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(
          content: Text(e.toString()),
        ),

      );

    }

    setState(() {
      loading = false;
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Check Request Status"),
      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(

              controller: emailController,

              decoration: const InputDecoration(
                labelText: "Company Email",
                border: OutlineInputBorder(),
              ),

            ),

            const SizedBox(height: 20),

            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                onPressed: loading ? null : checkStatus,

                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Check Status"),

              ),

            ),

            const SizedBox(height: 30),

            if (result != null)
              buildStatusCard(),

          ],

        ),

      ),

    );

  }

  Widget buildStatusCard() {

    final data = result!["data"];

    final status = data["status"];

    if (status == "Pending") {

      return Card(

        child: ListTile(

          leading: const Icon(
            Icons.hourglass_empty,
            color: Colors.orange,
          ),

          title: const Text("Pending"),

          subtitle: const Text(
              "Your request is waiting for Admin approval."),

        ),

      );

    }

    if (status == "Rejected") {

      return Card(

        child: ListTile(

          leading: const Icon(
            Icons.cancel,
            color: Colors.red,
          ),

          title: const Text("Rejected"),

          subtitle: const Text(
              "Please contact administrator."),

        ),

      );

    }

    final company = data["company"];

    return Card(

      child: Padding(

        padding: const EdgeInsets.all(15),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Row(

              children: [

                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),

                SizedBox(width: 8),

                Text(
                  "Approved",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],

            ),

            const SizedBox(height: 15),

            Text(
                "Company Name : ${company["company_name"]}"),

            Text(
                "Company ID : ${company["company_id"]}"),

            Text(
                "Company Account No : ${company["company_account_no"]}"),

          ],

        ),

      ),

    );

  }

}

