class ThreeDSStatusResponse {
  ThreeDSStatusResponse({
      this.status, 
      this.message, 
      this.data,});

  ThreeDSStatusResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? ThreeDSStatusData.fromJson(json['data']) : null;
  }
  int? status;
  String? message;
  ThreeDSStatusData? data;

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

class ThreeDSStatusData {
  ThreeDSStatusData({
      this.isLoading, 
      this.updateDatetime, 
      this.isPay, 
      this.isAuthenticate,});

  ThreeDSStatusData.fromJson(dynamic json) {
    isLoading = json['is_loading'];
    updateDatetime = json['update_datetime'];
    isPay = json['is_pay'];
    isAuthenticate = json['is_authenticate'];
  }
  bool? isLoading;
  String? updateDatetime;
  bool? isPay;
  bool? isAuthenticate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['is_loading'] = isLoading;
    map['update_datetime'] = updateDatetime;
    map['is_pay'] = isPay;
    map['is_authenticate'] = isAuthenticate;
    return map;
  }

}