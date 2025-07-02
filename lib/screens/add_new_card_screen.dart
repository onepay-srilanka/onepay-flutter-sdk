import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ipg_flutter/bloc/add_new_card_bloc.dart';
import 'package:ipg_flutter/resources/images.dart';
import 'package:ipg_flutter/resources/strings.dart';
import 'package:ipg_flutter/util/card_number_input_formatter.dart';
import 'package:ipg_flutter/util/card_type_detection.dart';

import '../ipg_config.dart';
import '../resources/colors.dart';
import '../util/common_alert_dialogs.dart';
import '../util/expiry_date_input_formatter.dart';
import '../widgets/inter_bold_text.dart';
import '../widgets/inter_medium_text.dart';
import '../widgets/rounded_button.dart';
import '../widgets/rounded_text_field.dart';
import '3ds_screen.dart';

class AddNewCardBottomSheet extends StatefulWidget {
  final String appToken;
  final String appId;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final void Function(bool status, String? errorMessage)? addCardEventCallback;

  AddNewCardBottomSheet({
    super.key,
    required this.appToken,
    required this.appId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.addCardEventCallback,
  }) {
    if (kDebugMode) {
      print(
        "CONSUMER DATA: appToken: $appToken, appId: $appId, firstName: $firstName,"
        " lastName: $lastName, email: $email, phone: $phoneNumber",
      );
    }
  }

  @override
  State<AddNewCardBottomSheet> createState() => _AddNewCardBottomSheetState();
}

class _AddNewCardBottomSheetState extends State<AddNewCardBottomSheet> {
  late AddNewCardBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = AddNewCardBloc();
    _listenToListStream();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(80),
                  child: Container(height: 3, width: 60, color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 18),
            InterBoldText(
              AppStrings.addCard,
              fontSize: 16,
              color: Colors.black,
            ),
            SizedBox(height: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 31, right: 31),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      InterMediumText(
                        AppStrings.nameOnCard,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      SizedBox(height: 8),
                      RoundedTextField(
                        controller: _bloc.name,
                        hintText: AppStrings.nameOnCardHint,
                        backgroundColor: Colors.white,
                        height: 36,
                        keyboardType: TextInputType.name,
                        maxLength: 100,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 31, right: 31),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      InterMediumText(
                        AppStrings.cardNumber,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      SizedBox(height: 8),
                      RoundedTextField(
                        controller: _bloc.cardNumber,
                        hintText: AppStrings.cardNumberHint,
                        backgroundColor: Colors.white,
                        height: 36,
                        maxLength: 19,
                        keyboardType: TextInputType.number,
                        inputFormatters: [CardNumberInputFormatter()],
                        suffixImage:
                            getCardImage(_bloc.cardType) != null
                                ? Image.asset(
                                  getCardImage(_bloc.cardType)!,
                                  package: AppStrings.packageName,
                                )
                                : null,
                        onChanged: (cardNumber) {
                          final cardType = detectCardType(cardNumber);
                          setState(() {
                            _bloc.cardType = cardType;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 31.0, right: 31.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 75,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InterMediumText(
                            AppStrings.expireDate,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          SizedBox(height: 8),
                          RoundedTextField(
                            controller: _bloc.expireDate,
                            hintText: AppStrings.expireDateHint,
                            backgroundColor: Colors.white,
                            height: 36,
                            maxLength: 5,
                            inputFormatters: [ExpiryDateInputFormatter()],
                            keyboardType: TextInputType.datetime,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 75,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InterMediumText(
                            AppStrings.cvv,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          SizedBox(height: 8),
                          RoundedTextField(
                            controller: _bloc.cvv,
                            hintText: AppStrings.cvvHint,
                            backgroundColor: Colors.white,
                            height: 36,
                            maxLength: 3,
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 31.0, right: 31.0),
              child: RoundedButton(
                text: AppStrings.addCard,
                leadingIcon: null,
                backgroundColor: AppColors.onyx,
                textColor: AppColors.white,
                borderRadius: 8,
                fontSize: 14,
                height: 36,
                onPressed: _bloc.isLoading ? null : () => {_bloc.validateForm()},
                circularProgressBarColor: Colors.white,
                isLoading: _bloc.isLoading,

              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  width: 13,
                  height: 13,
                  AppImages.securityShield,
                  package: AppStrings.packageName,
                ),
                SizedBox(width: 2),
                InterMediumText(
                  AppStrings.securedBySpemai,
                  fontSize: 10,
                  color: AppColors.carbonGrey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _listenToListStream() {
    _bloc.validateStream.listen((errors) {
      if (!mounted) return;
      FocusScope.of(context).unfocus();
      if (errors.isNotEmpty) {
        showErrorDialog(context, errors);
        return;
      }
      setState(() {
        _bloc.isLoading = true;
      });
      _bloc.submitData(
        widget.appToken,
        widget.appId,
        widget.firstName,
        widget.lastName,
        widget.email,
        widget.phoneNumber,
      );
    });

    _bloc.addNewCardStream.listen((data) {
      if (!mounted) return;

      switch (data.status) {
        case Status.loading:
          setState(() {
            _bloc.isLoading = true;
          });
          break;
        case Status.completed:
          setState(() {
            _bloc.isLoading = false;
          });
          var callBackData = data.data?.data!;
          if (callBackData!.isAlreadyToken == true) {
            widget.addCardEventCallback?.call(
              false,
              IPGErrorMessages.alreadyTokenizedCard,
            );
          } else {
            _open3dsScreen(callBackData);
          }
          break;
        case Status.error:
          setState(() {
            _bloc.isLoading = false;
          });
          widget.addCardEventCallback?.call(false, data.message);
          break;
      }
    });
  }

  void _open3dsScreen(callBackData) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ThreeDSecureScreen(
              customerTokenData: callBackData,
              appToken: widget.appToken,
            ),
      ),
    ).then((result) {
      if (result != null && mounted) {
        if (result is String) {
          widget.addCardEventCallback?.call(false, result);
        } else {
          Navigator.pop(context);
          widget.addCardEventCallback?.call(true, null);
        }
      }
    });
  }
}
