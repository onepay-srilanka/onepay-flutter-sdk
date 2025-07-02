class CustomerListResponse {
  CustomerListResponse({
      this.status, 
      this.message, 
      this.data,});

  CustomerListResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Customer.fromJson(v));
      });
    }
  }
  int? status;
  String? message;
  List<Customer>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Customer {
  Customer({
      this.customerId, 
      this.customerName, 
      this.email, 
      this.phone, 
      this.createdAt, 
      this.cards,});

  Customer.fromJson(dynamic json) {
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    email = json['email'];
    phone = json['phone'];
    createdAt = json['created_at'];
    if (json['cards'] != null) {
      cards = [];
      json['cards'].forEach((v) {
        cards?.add(Cards.fromJson(v));
      });
    }
  }
  String? customerId;
  String? customerName;
  String? email;
  String? phone;
  String? createdAt;
  List<Cards>? cards;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['customer_id'] = customerId;
    map['customer_name'] = customerName;
    map['email'] = email;
    map['phone'] = phone;
    map['created_at'] = createdAt;
    if (cards != null) {
      map['cards'] = cards?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Cards {
  Cards({
      this.tokenId, 
      this.cardMask, 
      this.cardExpire, 
      this.cardType,});

  Cards.fromJson(dynamic json) {
    tokenId = json['token_id'];
    cardMask = json['card_mask'];
    cardExpire = json['card_expire'];
    cardType = json['card_type'];
  }
  String? tokenId;
  String? cardMask;
  String? cardExpire;
  String? cardType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token_id'] = tokenId;
    map['card_mask'] = cardMask;
    map['card_expire'] = cardExpire;
    map['card_type'] = cardType;
    return map;
  }

}