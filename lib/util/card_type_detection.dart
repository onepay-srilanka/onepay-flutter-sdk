import 'package:ipg_flutter/resources/images.dart';

enum CardType { visa, masterCard, amex, unknown }

CardType detectCardType(String input) {
  final sanitized = input.replaceAll(RegExp(r'\s+'), '');

  if (sanitized.startsWith(RegExp(r'^4'))) {
    return CardType.visa;
  } else if (sanitized.startsWith(RegExp(r'^(5[1-5]|2[2-7])'))) {
    return CardType.masterCard;
  } else if (sanitized.startsWith(RegExp(r'^3[47]'))) {
    return CardType.amex;
  } else {
    return CardType.unknown;
  }
}

String? getCardImage(CardType type) {
  switch (type) {
    case CardType.visa:
      return AppImages.visa;
    case CardType.masterCard:
      return AppImages.master;
    case CardType.amex:
      return AppImages.amex;
    default:
      return null;
  }
}

extension CardTypeExtension on CardType {

  String get brand {
    switch (this) {
      case CardType.visa:
        return "VISA";
      case CardType.masterCard:
        return "MASTERCARD";
      case CardType.amex:
        return "AMEX";
      case CardType.unknown:
        return "";
    }
  }

  String get type {

    if (this == CardType.amex){
      return "NTB";
    }else{
      return "MASTERCARD";
    }
  }
}
