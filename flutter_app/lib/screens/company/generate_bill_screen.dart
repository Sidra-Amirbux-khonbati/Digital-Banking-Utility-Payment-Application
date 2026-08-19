import 'package:flutter/material.dart';
import '../../services/api_service.dart';



class GenerateBillScreen extends StatefulWidget {

  final Map<String, dynamic> company;
  const GenerateBillScreen({
    super.key,
    required this.company,
  });


  @override
  State<GenerateBillScreen> createState() =>
      _GenerateBillScreenState();

}

class _GenerateBillScreenState
    extends State<GenerateBillScreen> {

  final customerAccountController =
      TextEditingController();

  final consumerNoController =
      TextEditingController();

  final billingMonthController =
      TextEditingController();

  final dueDateController =
      TextEditingController();

  final amountController =
      TextEditingController();

  final remarksController =
      TextEditingController();



  bool loading = false;



  Future<void> generateBill() async {


    setState(() {
      loading = true;
    });



    try {


      final response =
      await ApiService.generateBill({

        "company_id":
        widget.company["company_id"],


        "customer_account_no":
        int.parse(
          customerAccountController.text,
        ),


        "consumer_no":
        consumerNoController.text,


        "billing_month":
        billingMonthController.text,


        "due_date":
        dueDateController.text,


        "amount":
        double.parse(
          amountController.text,
        ),


        "remarks":
        remarksController.text,

      });



      setState(() {
        loading = false;
      });



      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
            response["message"] ??
                "Bill Generated Successfully",
          ),
        ),

      );



      Navigator.pop(context);



    } catch(error) {


      setState(() {
        loading = false;
      });


      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
            error.toString(),
          ),
        ),

      );

    }


  }

  Widget inputField(
      String label,
      TextEditingController controller,
      TextInputType type,
      ){

    return Padding(

      padding:
      const EdgeInsets.only(bottom:15),


      child: TextField(

        controller: controller,

        keyboardType: type,


        decoration: InputDecoration(

          labelText: label,

          border:
          OutlineInputBorder(

            borderRadius:
            BorderRadius.circular(12),

          ),

        ),

      ),

    );

  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(

      appBar: AppBar(

        title:
        const Text(
          "Generate Bill",
        ),

        backgroundColor:
        Colors.indigo,

      ),


      body: SingleChildScrollView(

        padding:
        const EdgeInsets.all(20),


        child: Column(

          children: [


            Text(

              "Company: ${widget.company["company_name"]}",

              style:
              const TextStyle(

                fontSize:18,

                fontWeight:
                FontWeight.bold,

              ),

            ),


            const SizedBox(height:20),



            inputField(

              "Customer Account No",

              customerAccountController,

              TextInputType.number,

            ),



            inputField(

              "Consumer No",

              consumerNoController,

              TextInputType.text,

            ),



            inputField(

              "Billing Month",

              billingMonthController,

              TextInputType.text,

            ),



            inputField(

              "Due Date (YYYY-MM-DD)",

              dueDateController,

              TextInputType.datetime,

            ),



            inputField(

              "Amount",

              amountController,

              TextInputType.number,

            ),



            inputField(

              "Remarks",

              remarksController,

              TextInputType.text,

            ),



            const SizedBox(height:20),



            SizedBox(

              width: double.infinity,


              child: ElevatedButton(

                style:
                ElevatedButton.styleFrom(

                  backgroundColor:
                  Colors.indigo,

                  padding:
                  const EdgeInsets.all(15),

                ),


                onPressed:
                loading
                    ? null
                    : generateBill,


                child:

                loading

                    ?

                const CircularProgressIndicator(
                  color: Colors.white,
                )

                    :

                const Text(

                  "Generate Bill",

                  style:
                  TextStyle(

                    color: Colors.white,

                    fontSize:16,

                  ),

                ),

              ),

            )


          ],

        ),

      ),

    );

  }


}