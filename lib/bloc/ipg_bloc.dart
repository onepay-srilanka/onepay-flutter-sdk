import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:ipg_flutter/models/customer_payment_request.dart';

import '../models/customer_list_response.dart';
import '../models/customer_payment_response.dart';
import '../networking/response.dart';
import '../repository/customer_repository.dart';
import '../resources/strings.dart';
import '../util/custom_exception.dart';

class IPGBloc {
  late StreamController<Response<List<Customer>>> _customerListController;

  StreamSink<Response<List<Customer>>> get customerListSink =>
      _customerListController.sink;

  Stream<Response<List<Customer>>> get customerListStream =>
      _customerListController.stream;

  late CustomerRepository _customerRepository;

  late StreamController<Response<CustomerPaymentData>>
  _customerPaymentResponseController;

  StreamSink<Response<CustomerPaymentData>> get customerPaymentResponseSink =>
      _customerPaymentResponseController.sink;

  Stream<Response<CustomerPaymentData>> get customerPaymentResponseStream =>
      _customerPaymentResponseController.stream;

  IPGBloc() {
    _customerListController = StreamController<Response<List<Customer>>>();
    _customerPaymentResponseController =
        StreamController<Response<CustomerPaymentData>>();
    _customerRepository = CustomerRepository();
  }

  getCustomers(String appToken) async {
    try {
      CustomerListResponse customerListResponse = await _customerRepository
          .getCustomers(appToken);
      if (kDebugMode) {
        print("CUSTOMER LIST: $customerListResponse");
      }
      if (customerListResponse.status == 200) {
        customerListSink.add(Response.completed(customerListResponse.data!));
      } else {
        if (kDebugMode) {
          print(
            "CUSTOMER LIST FAILED MESSAGE: ${customerListResponse.message}",
          );
        }
        customerListSink.add(Response.error(customerListResponse.message));
      }
    } on UnauthorisedException {
      if (kDebugMode) {
        print("CUSTOMER LIST ERROR: ${IPGErrorMessages.invalidAppToken}");
      }
      customerListSink.add(Response.error(IPGErrorMessages.invalidAppToken));
    } catch (e) {
      customerListSink.add(Response.error(e.toString()));
      if (kDebugMode) {
        print("CUSTOMER LIST ERROR: ${e.toString()}");
      }
    }
  }

  makeCustomerPayment(
    String amount,
    String currency,
    String customerCardToken,
    String appId,
    String appToken,
  ) async {
    try {
      final payloadData = CustomerPaymentRequest(
        cardToken: customerCardToken,
        appId: appId,
        amount: amount,
        currency: currency,
      );
      CustomerPaymentResponse customerPaymentResponse =
          await _customerRepository.makeCustomerPayment(payloadData, appToken);
      if (kDebugMode) {
        print("CUSTOMER PAYMENT: $customerPaymentResponse");
      }
      if (customerPaymentResponse.status == 200) {
        customerPaymentResponseSink.add(
          Response.completed(
            customerPaymentResponse.data!,
            message: customerPaymentResponse.message,
          ),
        );
      } else {
        if (kDebugMode) {
          print(
            "CUSTOMER PAYMENT FAILED MESSAGE: ${customerPaymentResponse.message}",
          );
        }
        customerPaymentResponseSink.add(
          Response.error(customerPaymentResponse.message),
        );
      }
    } on UnauthorisedException {
      if (kDebugMode) {
        print("CUSTOMER PAYMENT ERROR: ${IPGErrorMessages.invalidAppToken}");
      }
      customerPaymentResponseSink.add(
        Response.error(IPGErrorMessages.invalidAppToken),
      );
    } catch (e) {
      customerPaymentResponseSink.add(Response.error(e.toString()));
      if (kDebugMode) {
        print("CUSTOMER PAYMENT ERROR: ${e.toString()}");
      }
    }
  }

  dispose() {
    _customerListController.close();
  }
}
