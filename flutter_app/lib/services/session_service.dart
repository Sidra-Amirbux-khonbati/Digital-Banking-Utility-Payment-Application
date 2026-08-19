class SessionService {
  static Map<String, dynamic>? customer;

  static void saveCustomer(Map<String, dynamic> data) {
    customer = data;
  }
  static void logout() {
    customer = null;
  }
}