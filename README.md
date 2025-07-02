`ipg_flutter` is a Flutter plugin that allows merchants registered with **Spemai (Pvt) Ltd** to securely save their customers’ card details and retrieve them later for fast and secure payments.

## Features

- Securely save customer card details
- Retrieve saved cards 
- Perform card-based payments with previously saved cards
- Three powerful callback handlers:
    - `addCardEventCallback` – card addition status
    - `getCustomersEventCallback` – returns saved cards
    - `paymentStatusEventCallback` – returns payment results


## Getting started

Add the dependency in your `pubspec.yaml`:
```yaml
dependencies:
  ipg_flutter: ^1.0.0
```

## Usage

```dart
var ipg = Ipg.init(
appToken: 'your_token',
appId: 'your_app_id',
firstName: 'John',
lastName: 'Doe',
email: 'john.doe@sample.com',
phoneNumber: '0000000000',
);

// Start card addition flow
ipg.addNewCard(context);

// Callback when card add flow completes
ipg.addCardEventCallback = (status, errorMessage) {
print("Adding card result: $status - $errorMessage");
};

// Retrieve customer list (saved cards)
ipg.getCustomers();

// Callback when customers are retrieved
ipg.getCustomersEventCallback = (customerList, errorMessage) {
print("Customers: $customerList");
};

// Listen to payment status
ipg.paymentStatusCallback = (status, errorMessage ) {
print("Payment Status: $status - $errorMessage");
};
```
---

## 📦 Example

Clone the repo and run the example:

```bash
cd example
flutter create
flutter run
```

You can also view the code in the [`example/`](example) folder.

---

## 🧩 API Reference

| Method                          | Description                              |
|---------------------------------|------------------------------------------|
| `Ipg.init(...)`                 | Initializes the IPG with merchant/user   |
| `ipg.addNewCard(context)`       | Launches secure add-card flow            |
| `ipg.getCustomers()`            | Fetches list of saved customer cards     |
| `addCardEventCallback`          | Callback for add card result             |
| `getCustomersEventCallback`     | Callback for saved customers             |
| `paymentStatusCallback`         | Callback for payment completion status   |

---

## ❓ FAQ

### Is this plugin secure?

Yes, it uses encrypted communication and secure storage through Spemai's backend.

### Can any app use this?

Only merchants registered with Spemai (Pvt) Ltd can use this plugin via provided credentials.

### Which platforms are supported?

- ✅ Android
- ✅ iOS
- ❌ Web (planned)

## 📄 License

[MIT License](LICENSE)

---

## 🔗 Links

- [Homepage](https://github.com/onepay-srilanka/onepay-flutter-sdk)
- [Repository](https://github.com/onepay-srilanka/onepay-flutter-sdk)
- [Issue Tracker](https://github.com/onepay-srilanka/onepay-flutter-sdk/issues)
- [Documentation](https://github.com/onepay-srilanka/onepay-flutter-sdk#readme)
