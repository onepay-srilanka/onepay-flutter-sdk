class CreateCustomerTokenRequest {
  CreateCustomerTokenRequest({
      this.appId, 
      this.firstName, 
      this.lastName, 
      this.email, 
      this.phoneNumber, 
      this.cardType, 
      this.cardBrand, 
      this.card, 
      this.device,
  this.deviceId});

  CreateCustomerTokenRequest.fromJson(dynamic json) {
    appId = json['app_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    cardType = json['card_type'];
    cardBrand = json['card_brand'];
    card = json['card'];
    device = json['device'] != null ? Device.fromJson(json['device']) : null;
    deviceId =  json['device_id'];
  }
  String? appId;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? cardType;
  String? cardBrand;
  String? card;
  Device? device;
  String? deviceId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['app_id'] = appId;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['email'] = email;
    map['phone_number'] = phoneNumber;
    map['card_type'] = cardType;
    map['card_brand'] = cardBrand;
    map['card'] = card;
    map['device_id'] = deviceId;
    if (device != null) {
      map['device'] = device?.toJson();
    }
    return map;
  }

}

class Device {
  Device({
    this.browser,
      this.browserDetails,});

  Device.fromJson(dynamic json) {
    browserDetails = json['browserDetails'] != null ? MainBrowserDetails.fromJson(json['browserDetails']) : null;
  }
  String? browser;
  MainBrowserDetails? browserDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['browser'] = browser;
    if (browserDetails != null) {
      map['browserDetails'] = browserDetails?.toJson();
    }
    return map;
  }

}

class MainBrowserDetails {
  MainBrowserDetails({
      this.browserDetails,});

  MainBrowserDetails.fromJson(dynamic json) {
    browserDetails = json['browserDetails'] != null ? BrowserDetails.fromJson(json['browserDetails']) : null;
  }
  BrowserDetails? browserDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (browserDetails != null) {
      map['browserDetails'] = browserDetails?.toJson();
    }
    return map;
  }

}

class BrowserDetails {
  BrowserDetails({
      this.javaEnabled="false",
      this.javaScriptEnabled="true",
      this.language="en-US",
      this.screenHeight="864",
      this.screenWidth="1536",
      this.timeZone="330",
      this.colorDepth="24",
      this.dSecureChallengeWindowSize="FULL_SCREEN"});

  BrowserDetails.fromJson(dynamic json) {
    javaEnabled = json['javaEnabled'];
    javaScriptEnabled = json['javaScriptEnabled'];
    language = json['language'];
    screenHeight = json['screenHeight'];
    screenWidth = json['screenWidth'];
    timeZone = json['timeZone'];
    colorDepth = json['colorDepth'];
    dSecureChallengeWindowSize = json['3DSecureChallengeWindowSize'];
  }
  String? javaEnabled;
  String? javaScriptEnabled;
  String? language;
  String? screenHeight;
  String? screenWidth;
  String? timeZone;
  String? colorDepth;
  String? dSecureChallengeWindowSize;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['javaEnabled'] = javaEnabled;
    map['javaScriptEnabled'] = javaScriptEnabled;
    map['language'] = language;
    map['screenHeight'] = screenHeight;
    map['screenWidth'] = screenWidth;
    map['timeZone'] = timeZone;
    map['colorDepth'] = colorDepth;
    map['3DSecureChallengeWindowSize'] = dSecureChallengeWindowSize;
    return map;
  }

}