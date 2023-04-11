/// Class for representing the result of some operation,
/// where the result can either be a success or an error.

class Result {
  Result._();

  factory Result.success(String message, int code) = SuccessResult;

  factory Result.error(String message, int code) = ErrorResult;
}

/// This defines the ErrorResult, which store
/// information about the error that occurred.

class ErrorResult extends Result {
  ErrorResult(this.msg, this.code) : super._();

  final String msg;
  final int code;
}

/// This defines the SuccessResult. which store
/// information about the successful operation

class SuccessResult extends Result {
  SuccessResult(this.msg, this.code) : super._();

  final String msg;
  final int code;
}

/// Generic response class
class GenericResponse<T> {
  final Result? result;
  final T? data;

  GenericResponse({this.result, this.data});
}

/// Response codes
abstract class ResponseCode {
  ResponseCode._();

  static const int ok = 200;
  static const int error = 400;
}
