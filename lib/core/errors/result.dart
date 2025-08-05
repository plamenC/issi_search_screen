// Result type for better error handling
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Error<T> extends Result<T> {
  final String message;
  final Exception? exception;
  const Error(this.message, [this.exception]);
}

class Loading<T> extends Result<T> {
  const Loading();
}

// Extension methods for easier handling
extension ResultExtensions<T> on Result<T> {
  bool get isSuccess => this is Success<T>;
  bool get isError => this is Error<T>;
  bool get isLoading => this is Loading<T>;

  T? get data => isSuccess ? (this as Success<T>).data : null;
  String? get errorMessage => isError ? (this as Error<T>).message : null;

  Result<R> map<R>(R Function(T) transform) {
    return when(
      success: (data) => Success(transform(data)),
      error: (message, exception) => Error(message, exception),
      loading: () => const Loading(),
    );
  }

  R when<R>({
    required R Function(T data) success,
    required R Function(String message, Exception? exception) error,
    required R Function() loading,
  }) {
    switch (this) {
      case Success<T>():
        return success((this as Success<T>).data);
      case Error<T>():
        return error((this as Error<T>).message, (this as Error<T>).exception);
      case Loading<T>():
        return loading();
    }
  }
}
