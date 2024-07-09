# pawa_pay_flutter

This package allows African Flutter developers to easily add mobile money payments to their Flutter apps using PawaPay's API. Future releases will include support for more African countries.

## Features

Currently supported in Zambia:

- Airtel Money Deposits
- MoMo MTN Money Deposits
- Zamtel Money

More countries to be added in future updates.

## Getting Started

To use this package, you need to open an account with PawaPay and obtain an API key. If you are using the testing sandbox, set `debugMode` to `true` in the `Purchase` constructor. Make sure to set it to `false` when you are releasing your app.

```dart
debugMode = true
```

When using debug mode, set your debug api key as a compile time variable as like shown: `"--dart-define","pawa-pay-api=<APIKEY>"`

### Steps

1. Open an account at [PawaPay](https://pawapay.io).
2. Obtain your API key from the [PawaPay API documentation](https://docs.pawapay.co.uk/#tag/payouts).
3. Add the package to your Flutter project.

## Usage

Here is an example of how to use the package:

```dart
import 'package:pawa_pay_flutter/pawa_pay_flutter.dart';

final Purchase purchase = Purchase(apiKey: "<API_KEY>", debugMode: true);

// Making the customer make a deposit
String purchaseStatus = await purchase.customerDeposit(
  phone: '0973456049',
  amount: 100.00,
);

switch (purchaseStatus) {
  case 'PAYMENT_APPROVED':
    print('Successful payment');
    break;
  case 'PAYER_LIMIT_REACHED':
    print('Customer reached depositing limit');
    break;
  case 'PAYMENT_NOT_APPROVED':
    print('Customer did not approve payment');
    break;
  case 'INSUFFICIENT_BALANCE':
    print('Customer wallet balance isn\'t enough to make the purchase');
    break;
  default:
    print('An error occurred');
}
```

## Additional Information

For more detailed information on the API, visit the [PawaPay API documentation](https://docs.pawapay.co.uk/#tag/payouts).

### Contribution

Contributions are welcome! Please fork the repository and submit a pull request. Ensure your code adheres to the existing style and includes tests where applicable.

### Issues

Report issues or request features on the [GitHub issues page](https://github.com/KanyantaM/pawa_pay_flutter/issues).

### Contact

For support or questions, you can reach out via:

- [Luso Software](http://www.lusosoftware.com)
- [Twitter: @Its_Kanyanta](https://twitter.com/Its_Kanyanta)
- [LinkedIn: Kanyanta Makasa](https://www.linkedin.com/in/kanyanta-makasa)
- [GitHub: @KanyantaM](https://github.com/KanyantaM)

### License

This package is released under the [GPL License](https://www.gnu.org/licenses/gpl-3.0.en.html)
