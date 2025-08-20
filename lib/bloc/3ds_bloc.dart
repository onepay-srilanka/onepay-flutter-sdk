import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../models/three_d_s_status_response.dart';
import '../networking/response.dart';
import '../repository/customer_repository.dart';
import '../resources/strings.dart';
import '../util/custom_exception.dart';

class ThreeDSBloc {
  late CustomerRepository _customerRepository;

  late StreamController<Response<ThreeDSStatusData>> _check3DSStatusController;

  StreamSink<Response<ThreeDSStatusData>> get check3DSStatusSink =>
      _check3DSStatusController.sink;

  Stream<Response<ThreeDSStatusData>> get check3DSStatusStream =>
      _check3DSStatusController.stream;

  Timer? _pollingTimer;

  ThreeDSBloc() {
    _check3DSStatusController = StreamController<Response<ThreeDSStatusData>>();
    _customerRepository = CustomerRepository();
  }

  checkStatus(String cardToken, String appToken) async {
    _pollingTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      try {
        ThreeDSStatusResponse statusResponse = await _customerRepository
            .get3DSStatus(cardToken, appToken);
        if (kDebugMode) {
          print("3DS STATUS: ${jsonEncode(statusResponse.toJson())}");
        }
        if (statusResponse.status == 200) {
          if (statusResponse.data!.isLoading == false && statusResponse.data!.isAuthenticate == true) {
            timer.cancel();
            check3DSStatusSink.add(Response.completed(statusResponse.data!));
          }else if (statusResponse.data!.isLoading == false && statusResponse.data!.isAuthenticate == false){

            if (kDebugMode) {
              print("3DS STATUS FAILED MESSAGE: ${statusResponse.message}");
            }
            timer.cancel();
            check3DSStatusSink.add(Response.error(statusResponse.message));
          }
        } else {
          if (kDebugMode) {
            print("3DS STATUS FAILED MESSAGE: ${statusResponse.message}");
          }
          check3DSStatusSink.add(Response.error(statusResponse.message, errorCode: 1));
        }
      } on UnauthorisedException {
        timer.cancel();
        if (kDebugMode) {
          print("3DS STATUS ERROR: ${IPGErrorMessages.invalidAppToken}");
        }
        check3DSStatusSink.add(
          Response.error(IPGErrorMessages.invalidAppToken),
        );
      } catch (e) {
        timer.cancel();
        check3DSStatusSink.add(Response.error(e.toString()));
        if (kDebugMode) {
          print("3DS STATUS ERROR: ${e.toString()}");
        }
      }
    });
  }

  dispose() {
    _check3DSStatusController.close();
    _pollingTimer?.cancel();
  }
}
