library spemai_chat_bot;

import '../ipg_config.dart';

class Response<T> {
  Status status;
  T? data;
  String? message;

  Response.loading(this.message) : status = Status.loading;

  Response.completed(this.data) : status = Status.completed;

  Response.error(this.message) : status = Status.error;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}
