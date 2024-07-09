import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:uuid/uuid.dart';

class PawaPayApi {
  final String apiKey;
  final bool debugMode;

  PawaPayApi({required this.debugMode, required this.apiKey});

  /// Initiates a deposit using the provided phone number and amount.
  ///
  /// The [phone] parameter should be a string representing the phone number of the
  /// payer. The [amount] parameter should be a string representing the amount
  /// to be deposited.
  ///
  /// This function returns a [Future] that completes with a [Map] containing the
  /// details of the initiated deposit.
  ///
  /// If the initiation is successful, the map will contain the following keys:
  /// - [depositId]: a unique identifier for the deposit.
  /// - [amount]: the amount deposited.
  /// - [currency]: the currency of the deposit.
  /// - [country]: the country of the deposit.
  /// - [correspondent]: the correspondent of the deposit.
  /// - [payer]: the payer details.
  ///   - [type]: the type of the payer.
  ///   - [address]: the address of the payer.
  ///     - [value]: the value of the payer's address.
  /// - [customerTimestamp]: the timestamp when the deposit was initiated.
  /// - [statementDescription]: a description of the deposit.
  ///
  /// If the initiation fails, the map will contain the following keys:
  /// - [depositId]: a unique identifier for the deposit.
  /// - [message]: a message indicating the failure.
  /// - [created]: the timestamp when the failure occurred.
  Future<Map<String, dynamic>> initiateDeposit({
    required String phone,
    required String amount,
  }) async {
    // URI for the API endpoint
    String apiUrl = debugMode? 'https://api.sandbox.pawapay.cloud/deposits' : 'https://api.pawapay.cloud/deposits';

    // Generate a unique ID for the deposit
    final String uuid = const Uuid().v4();

    // Initialize the correspondent based on the phone number
    String correspondent = '';
    String number = phone.trim();

    if (number.startsWith("097") || number.startsWith("077")) {
      correspondent = 'AIRTEL_OAPI_ZMB';
    } else if (number.startsWith("096") || number.startsWith("076")) {
      correspondent = 'MTN_MOMO_ZMB';
    } else {
      correspondent = 'ZAMTEL_ZMB';
    }

    // Prepare the request headers
    final Map<String, String> headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    // Prepare the request body
    final Map<String, dynamic> body = {
      'depositId': uuid,
      'amount': amount,
      'currency': 'ZMW',
      'country': 'ZMB',
      'correspondent': correspondent,
      'payer': {
        'type': 'MSISDN',
        'address': {
          'value': "26$phone",
        },
      },
      'customerTimestamp': DateTime.now().toIso8601String(),
      'statementDescription': 'Payment for order',
    };

    // Send a POST request to the Pawapay API to initiate the deposit
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(body),
      );

      // Check the response status code
      if (response.statusCode == 200 || response.statusCode == 201) {
        // If the request is successful, decode the response body as a JSON map
        return jsonDecode(response.body);
      } else {
        // If the request fails, decode the response body as a JSON map
        return jsonDecode(response.body);
      }
    } catch (e) {
      // If an exception occurs, return a map with error details
      return {
        'depositId': uuid,
        'message': 'Failed to initiate deposit',
        "created": DateTime.now().toIso8601String()
      };
    }
  }

  /// Checks the status of a deposit.
  ///
  /// This function takes a [depositId] as a parameter and makes a GET request
  /// to the Pawapay API to retrieve the status of the deposit. The response is
  /// then decoded and returned as a [Map].
  ///
  /// If the request is successful, the map will contain the details of the
  /// deposit. If the request fails, the map will contain a message indicating
  /// the failure and the timestamp when the failure occurred.
  ///
  /// The [depositId] parameter should be a string representing the unique
  /// identifier of the deposit.
  Future<Map<String, dynamic>> checkDepositStatus(
      {required String depositId}) async {
    // Trim the deposit id
    String id = depositId.trim();
    // Construct the API URL
    final String apiUrl = 'https://api.sandbox.pawapay.cloud/deposits/$id';

    // Construct the request headers
    final Map<String, String> headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    try {
      // Make the GET request
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );

      // If the request is successful, return the decoded response
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body)[0];
      } else {
        return jsonDecode(response.body)[0];
      }
    } catch (e) {
      // If the request fails, return a map with a message and the timestamp
      return {
        'depositId': id,
        'message': 'Failed to check deposit status',
        "created": DateTime.now().toIso8601String()
      };
    }
  }
}
