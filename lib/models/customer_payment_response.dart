class CustomerPaymentResponse {
  CustomerPaymentResponse({
      this.status, 
      this.message, 
      this.data,});

  CustomerPaymentResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? CustomerPaymentData.fromJson(json['data']) : null;
  }
  int? status;
  String? message;
  CustomerPaymentData? data;

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

class CustomerPaymentData {
  CustomerPaymentData({
      this.paymentStatus,});

  CustomerPaymentData.fromJson(dynamic json) {
    paymentStatus = json['payment_status'];
  }
  bool? paymentStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['payment_status'] = paymentStatus;
    return map;
  }

}