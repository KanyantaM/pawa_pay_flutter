library pawa_pay_flutter;

import 'src/api_endpoint.dart';

export './src/api_endpoint.dart';

//The Purchase class
class Purchase {
  final String apiKey;
  final bool debugeMode;
  Purchase({this.debugeMode = true, required this.apiKey})
      : _pawaPayRepo = PawaPayRepo(
          apiKey: apiKey,
          debugMode: debugeMode,
        );

  /// Initiates a deposit using the provided phone number and amount.
  ///
  /// The [phone] parameter should be a string representing the phone number of the
  /// payer. The [amount] parameter should be a double representing the amount
  /// to be deposited.
  ///
  /// This function returns a [Future] that completes with a [String] containing the
  /// message returned after the deposit process is completed.
  Future<String> customerDeposite(
      {required String phone, required double amount}) async {
    try {
      Map<String, dynamic> result = await _pawaPayRepo.initiateDeposit(
        phone: phone,
        amount: amount.toStringAsFixed(2),
      );
      String id = result['depositId'];
      Future.delayed(const Duration(seconds: 5), () async {
        Map<String, dynamic> result2 =
            await _pawaPayRepo.checkDepositStatus(depositId: id);
        return (result2["status"]);
      });
      Map<String, dynamic> result2 =
          await _pawaPayRepo.checkDepositStatus(depositId: id);
      return (result2["status"]);
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> restaurantWithdrawal() async {
    return '';
  }

  final PawaPayRepo _pawaPayRepo;
}
