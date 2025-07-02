class CreateCustomerTokenResponse {
  CreateCustomerTokenResponse({
      this.status, 
      this.message, 
      this.data,});

  CreateCustomerTokenResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  int? status;
  String? message;
  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

class Data {
  Data({
      this.status, 
      this.message, 
      this.data,});

  Data.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? CallbackData.fromJson(json['data']) : null;
  }
  int? status;
  String? message;
  CallbackData? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

class CallbackData {
  CallbackData({
      this.isAlreadyToken, 
      this.cardToken, 
      this.onepayTransactionId, 
      this.customerId,});

  CallbackData.fromJson(dynamic json) {
    isAlreadyToken = json['is_already_token'];
    cardToken = json['card_token'];
    onepayTransactionId = json['onepay_transaction_id'];
    customerId = json['customer_id'];
    acsUrl = json['acs_url'];
    acsCreq = json['acs_creq'];
  }
  bool? isAlreadyToken;
  String? cardToken;
  String? onepayTransactionId;
  String? customerId;
  String? acsUrl;
  String? acsCreq;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['is_already_token'] = isAlreadyToken;
    map['card_token'] = cardToken;
    map['onepay_transaction_id'] = onepayTransactionId;
    map['customer_id'] = customerId;
    map['acs_url'] = acsUrl;
    map['acs_creq'] = acsCreq;
    return map;
  }

}