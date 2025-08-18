/// Simple result type to wrap success or failure.
class Result<T> {
  Result.success(this.data) : error = null;
  Result.failure(this.error) : data = null;

  final T? data;
  final Object? error;

  bool get isSuccess => error == null;
}
