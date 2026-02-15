import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  // Base URL for the API
  // 10.0.2.2 points to the host machine's localhost when running in Android emulator
  // For physical devices, this would be the actual IP address of the server
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  
  // Headers for API requests
  static final Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  // Analyze text sentiment
  static Future<Map<String, dynamic>> analyzeText(String text) async {
    final response = await http.post(
      Uri.parse('$baseUrl/analyze/'),
      headers: headers,
      body: jsonEncode({'text': text}),
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to analyze text: ${response.statusCode}');
    }
  }
  
  // Analyze URL content and sentiment
  static Future<Map<String, dynamic>> analyzeUrl(String url) async {
    final response = await http.post(
      Uri.parse('$baseUrl/analyze_url/'),
      headers: headers,
      body: jsonEncode({'url': url}),
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to analyze URL: ${response.statusCode}');
    }
  }
  
  // Analyze image sentiment
  static Future<Map<String, dynamic>> analyzeImage(File imageFile) async {
    // Create a multipart request
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/analyze_image/'),
    );
    
    // Add the file to the request
    request.files.add(await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
    ));
    
    // Send the request
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to analyze image: ${response.statusCode}');
    }
  }
}
