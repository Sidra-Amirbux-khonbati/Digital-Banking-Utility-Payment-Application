import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_urls.dart';

class ApiService {

  static Future<Map<String, dynamic>> login(
    String email,
    String accountNo,
  ) async {
    final response = await http.post(
      Uri.parse(ApiUrls.login),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "account_no": accountNo}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> checkCompanyStatus(String email) async {
    final response = await http.get(
      Uri.parse("${ApiUrls.baseUrl}/company/status/$email"),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> companyLogin(
    String email,
    String accountNo,
  ) async {
    final response = await http.post(
      Uri.parse("${ApiUrls.baseUrl}/company/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contact_email": email,
        "company_account_no": accountNo,
      }),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> generateBill(
    Map<String, dynamic> data,
  ) async {
    final response = await http.post(
      Uri.parse("${ApiUrls.baseUrl}/bill/generate"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getCompanyBillSummary(
    String companyId,
  ) async {
    final response = await http.get(
      Uri.parse("${ApiUrls.baseUrl}/bill/company/$companyId/summary"),
    );
    return jsonDecode(response.body);
  }

  static Future<List<dynamic>> getCompanyBills(
    String companyId,
    String status,
  ) async {
    String url = "${ApiUrls.baseUrl}/bill/company/$companyId";
    if (status != "All") {
      url += "?status=$status";
    }
    final response = await http.get(Uri.parse(url));
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getBillStatistics(
    String companyId,
  ) async {
    final response = await http.get(
      Uri.parse("${ApiUrls.baseUrl}/bill/company/$companyId/statistics"),
    );
    return jsonDecode(response.body);
  }


  static Future<List<dynamic>> getCompanyPayments(
    String companyAccountNo,
  ) async {
    final response = await http.get(
      Uri.parse("${ApiUrls.baseUrl}/transaction/company/$companyAccountNo"),
    );
    return jsonDecode(response.body);
  }


  static Future<Map<String, dynamic>> getBalance(String accountNo) async {
    final response = await http.get(
      Uri.parse("${ApiUrls.baseUrl}/balance/$accountNo"),
    );
    return jsonDecode(response.body);
  }


  static Future<Map<String, dynamic>> depositMoney({
    required String accountNo,
    required double amount,
  }) async {
    final response = await http.post(
      Uri.parse("${ApiUrls.baseUrl}/transaction/deposit"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "from_account": null,
        "to_account": accountNo,
        "amount": amount,
        "narration_line1": "Cash Deposit",
        "narration_line2": "",
        "narration_line3": "",
      }),
    );
    return jsonDecode(response.body);
  }


  static Future<Map<String, dynamic>> transferMoney({
    required String fromAccount,
    required String toAccount,
    required double amount,
    required String narration1,
    required String narration2,
    required String narration3,
  }) async {
    final response = await http.post(
      Uri.parse("${ApiUrls.baseUrl}/transaction/transfer"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "from_account": fromAccount,
        "to_account": toAccount,
        "amount": amount,
        "narration_line1": narration1,
        "narration_line2": narration2,
        "narration_line3": narration3,
      }),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data["message"] ?? "Transfer Failed");
    }
  }


  static Future<List<dynamic>> getCustomerBills(
    String accountNo,
    String status,
  ) async {
    String url = "${ApiUrls.baseUrl}/bill/customer/$accountNo";
    if (status != "All") {
      url += "?status=$status";
    }
    final response = await http.get(Uri.parse(url));
    return jsonDecode(response.body);
  }


  static Future<Map<String, dynamic>> customerPayBill(String billId) async {
    final response = await http.post(
      Uri.parse("${ApiUrls.baseUrl}/bill/customer/pay"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"bill_id": billId}),
    );
    return jsonDecode(response.body);
  }


  static Future<List<dynamic>> getTransactionHistory(String accountNo) async {
    final response = await http.get(
      Uri.parse("${ApiUrls.baseUrl}/transaction/history/$accountNo"),
    );
    final data = jsonDecode(response.body);
    return data["transactions"];
  }


  static Future<List<dynamic>> getRecentTransactions(String accountNo) async {
    final response = await http.get(
      Uri.parse("${ApiUrls.baseUrl}/transaction/recent/$accountNo"),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception("Failed to load recent transactions");
  }


}
