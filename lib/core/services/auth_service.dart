import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = "http://192.168.0.106:5000/api";

  Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/auth/signup");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );

    dynamic data;

    try {
      data = jsonDecode(response.body);
    } catch (e) {
      throw Exception("Server returned invalid response");
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      return data;
    } else {
      if (data["msg"] != null) {
        throw Exception(data["msg"]);
      } else if (data["errors"] != null) {
        throw Exception(data["errors"][0]["msg"]);
      } else {
        throw Exception("Something went wrong");
      }
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/auth/login");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw data["msg"] ?? "Login failed";
    }
  }

  Future<Map<String, dynamic>> sendOtp({
    required String userId,
    required String phone,
  }) async {
    final url = Uri.parse("$baseUrl/auth/send-otp");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"userId": userId, "phone": "0$phone"}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw data["msg"] ?? "Something went wrong";
    }
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String userId,
    required String otp,
  }) async {
    final url = Uri.parse("$baseUrl/auth/verify-otp");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"userId": userId, "otp": otp}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw data["msg"] ?? "OTP verification failed";
    }
  }
}
