import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:ipg_flutter/ipg_config.dart';
import 'package:ipg_flutter/models/create_customer_token_request.dart';
import 'package:ipg_flutter/repository/customer_repository.dart';
import 'package:ipg_flutter/resources/strings.dart';
import 'package:ipg_flutter/util/card_type_detection.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../models/create_customer_token_response.dart';
import '../networking/response.dart';
import '../util/custom_exception.dart';
import '../util/rsa_encryption_helper.dart';

class AddNewCardBloc {
  final TextEditingController name = TextEditingController();
  final TextEditingController cardNumber = TextEditingController();
  final TextEditingController expireDate = TextEditingController();
  final TextEditingController cvv = TextEditingController();
  final rsaHelper = RSAEncryptionHelper(publicKeyPem: IpgConfig.publicKeyPem);

  CardType cardType = CardType.unknown;
  late CustomerRepository _customerRepository;

  late StreamController<List<String>> _validateController;

  StreamSink<List<String>> get validateSink => _validateController.sink;

  Stream<List<String>> get validateStream => _validateController.stream;

  late StreamController<Response<Data>> _addNewCardController;

  StreamSink<Response<Data>> get addNewCardSink => _addNewCardController.sink;

  Stream<Response<Data>> get addNewCardStream => _addNewCardController.stream;

  bool isLoading = false;

  AddNewCardBloc() {
    _validateController = StreamController<List<String>>();
    _addNewCardController = StreamController<Response<Data>>();
    _customerRepository = CustomerRepository();
  }

  void validateForm() {
    List<String> errors = [];

    String name = this.name.text.trim();
    String card = cardNumber.text.replaceAll(' ', '');
    String expiry = expireDate.text;
    String cvv = this.cvv.text;

    // Name
    if (name.isEmpty || !RegExp(r'^[A-Za-z\s]+$').hasMatch(name)) {
      errors.add("Invalid name. Only letters and spaces allowed.");
    }

    // Card number
    if (card.length != 16 || !RegExp(r'^\d{16}$').hasMatch(card)) {
      errors.add("Card number must be 16 digits.");
    }

    // Card type
    if (cardType == CardType.unknown) {
      errors.add("Invalid car type. Only allow Visa, Master card and Amex");
    }

    // Expiry
    if (!RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$').hasMatch(expiry)) {
      errors.add("Expiry date must be in MM/YY format.");
    } else {
      final parts = expiry.split('/');
      int month = int.parse(parts[0]);
      int year = int.parse('20${parts[1]}');
      final now = DateTime.now();

      if (DateTime(year, month).isBefore(DateTime(now.year, now.month))) {
        errors.add("Card has expired.");
      }
    }

    // CVV
    if (cvv.length < 3 ||
        cvv.length > 4 ||
        !RegExp(r'^\d{3,4}$').hasMatch(cvv)) {
      errors.add("CVV must be 3 or 4 digits.");
    }
    validateSink.add(errors);
  }

  Future<String> _getUserAgent() async {
    WebViewController webController = WebViewController();
    final userAgent = await webController.runJavaScriptReturningResult(
      'navigator.userAgent',
    );
    if (kDebugMode) {
      print("USER AGENT: $userAgent");
    }
    return '$userAgent';
  }

  submitData(
    String appToken,
    String appId,
    String firstName,
    String lastName,
    String email,
    String phoneNumber,
  ) async {
    try {
      var agent = await _getUserAgent();
      var encryptedData = _getEncryptedCardData();
      var addNewCardRequest = CreateCustomerTokenRequest(
        appId: appId,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
        card: encryptedData,
        cardType: cardType.type,
        cardBrand: cardType.brand,
        device: Device(
          browserDetails: MainBrowserDetails(
            browser: agent,
            browserDetails: BrowserDetails(),
          ),
        ),
      );

      if (kDebugMode) {
        print("ENCRYPTED DATA: $encryptedData");
        print(
          "ADD NEW CARD REQUEST: ${jsonEncode(addNewCardRequest.toJson())}",
        );
      }
      CreateCustomerTokenResponse addNewCardResponse = await _customerRepository
          .createCustomerToken(addNewCardRequest, appToken);
      if (kDebugMode) {
        print("ADD NEW CARD RESPONSE: ${jsonEncode(addNewCardResponse.toJson())}");
      }
      if (addNewCardResponse.status == 200) {
        addNewCardSink.add(Response.completed(addNewCardResponse.data));
      } else {
        addNewCardSink.add(Response.error(addNewCardResponse.message));
      }
    } on UnauthorisedException {
      if (kDebugMode) {
        print("ADD NEW CARD ERROR: ${IPGErrorMessages.invalidAppToken}");
      }
      addNewCardSink.add(Response.error(IPGErrorMessages.invalidAppToken));
    } catch (e) {
      addNewCardSink.add(Response.error(e.toString()));
      if (kDebugMode) {
        print("ADD NEW CARD ERROR: ${e.toString()}");
      }
    }
  }

  String _getEncryptedCardData() {
    final splitExpireDate = expireDate.text.split("/");
    final cardData = {
      "month": splitExpireDate[0],
      "year": splitExpireDate[1],
      "nameOnCard": name.text,
      "number": cardNumber.text.replaceAll(' ', ''),
      "securityCode": cvv.text,
    };
    if (kDebugMode) {
      print("CARD DATA: $cardData");
    }
    return rsaHelper.encrypt(cardData);
  }

  dispose() {
    _validateController.close();
    _addNewCardController.close();
  }
}
