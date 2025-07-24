library spemai_chat_bot;

import '../ipg_config.dart';

class Response<T> {
  Status status;
  T? data;
  String? message;
  int? errorCode;

  Response.loading(this.message) : status = Status.loading;

  Response.completed(this.data, {this.message}) : status = Status.completed;

  Response.error(this.message, {this.errorCode = 0}) : status = Status.error;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}
