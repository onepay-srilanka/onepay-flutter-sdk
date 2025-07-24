class CustomerPaymentRequest {
  CustomerPaymentRequest({
      required this.cardToken,
      required this.appId,
      required this.amount,
      required this.currency,});

  CustomerPaymentRequest.fromJson(dynamic json) {
    cardToken = json['card_token'];
    appId = json['app_id'];
    amount = json['amount'];
    currency = json['currency'];
  }

  String cardToken = "";
  String appId = "";
  String amount = "";
  String currency = "";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['card_token'] = cardToken;
    map['app_id'] = appId;
    map['amount'] = amount;
    map['currency'] = currency;
    return map;
  }

}