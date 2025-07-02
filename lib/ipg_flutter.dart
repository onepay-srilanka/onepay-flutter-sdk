import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ipg_flutter/bloc/ipg_bloc.dart';
import 'package:ipg_flutter/models/customer_list_response.dart';
import 'package:ipg_flutter/resources/colors.dart';
import 'package:ipg_flutter/screens/add_new_card_screen.dart';

import 'ipg_config.dart';

class Ipg {
  final String appToken;
  final String appId;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  late final IPGBloc _bloc;

  Ipg.init({
    required this.appToken,
    required this.appId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
  }) {
    _bloc = IPGBloc();
  }

  void Function(bool status, String? errorMessage)? addCardEventCallback;
  void Function(List<Customer> customers, String? errorMessage)? getCustomersEventCallback;

  void addNewCard(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      isScrollControlled: true, // Allows full-screen height
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: DraggableScrollableSheet(
            expand: false,
            // Prevents full expansion
            initialChildSize: 0.5,
            // Initial height as a fraction of screen height
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: AddNewCardBottomSheet(
                  appToken: appToken,
                  appId: appId,
                  firstName: firstName,
                  lastName: lastName,
                  email: email,
                  phoneNumber: phoneNumber,
                  addCardEventCallback: addCardEventCallback,
                ),
              );
            },
          ),
        );
      },
    );
  }

  getCustomers() async {

    _bloc.customerListStream.listen((data) {
      switch (data.status){
        case Status.loading:
          break;
        case Status.completed:
          getCustomersEventCallback?.call(data.data!, null);
          break;
        case Status.error:
          getCustomersEventCallback?.call([], data.message);
          break;
      }
    });
    _bloc.getCustomers(appToken);
  }

  void dispose() {
    if (kDebugMode) {
      _bloc.dispose();
      print("Disposed");
    }
  }
}
