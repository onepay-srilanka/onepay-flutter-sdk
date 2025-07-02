import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/customer_list_response.dart';
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

  IPGBloc() {
    _customerListController = StreamController<Response<List<Customer>>>();
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

  dispose() {
    _customerListController.close();
  }
}
