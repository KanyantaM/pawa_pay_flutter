import 'package:flutter_test/flutter_test.dart';
import 'package:pawa_pay_flutter/pawa_pay_flutter.dart';

/// A list of phone numbers and their corresponding expected status messages.
/// The keys of each map are 'number' and 'message', and the values are the phone number
/// and expected status message, respectively.
List<Map<String, String>> testCases = [
  // Phone number 0973456019 is expected to return the 'PAYER_LIMIT_REACHED' status message.
  {'number': '0973456019', 'message': 'PAYER_LIMIT_REACHED'},
  // Phone number 0973456039 is expected to return the 'PAYMENT_NOT_APPROVED' status message.
  {'number': '0973456039', 'message': 'PAYMENT_NOT_APPROVED'},
  // Phone number 0973456049 is expected to return the 'INSUFFICIENT_BALANCE' status message.
  {'number': '0973456049', 'message': 'INSUFFICIENT_BALANCE'},
  // Phone number 0973456069 is expected to return the 'OTHER_ERROR' status message.
  {'number': '0973456069', 'message': 'OTHER_ERROR'},
  // Phone number 0973456129 is expected to return the 'NO CALLBACK (stuck in SUBMITTED state)' status message.
  {'number': '0973456129', 'message': 'NO CALLBACK (stuck in SUBMITTED state)'},
  // Phone number 0973456789 is expected to return the 'N/A (COMPLETED)' status message.
  {'number': '0973456789', 'message': 'N/A (COMPLETED)'}
];

///TestAPI
const appToken = String.fromEnvironment(
  'pawa-pay-api',
);
void main() {
  test(
    'checking deposits',
    () async {
      double amount = 100.00;
      final Purchase purchase = Purchase(apiKey: appToken);
      for (var testCase in testCases) {
        expect(
          await purchase.customerDeposite(
            phone: testCase['number'] ?? '',
            amount: amount,
          ),
          testCase['message'] ?? '',
        );
      }
    },
  );
}
