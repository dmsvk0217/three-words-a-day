sealed class Result<T> {
  const Result();
  R when<R>(
          {required R Function(T) ok, required R Function(Object error) err}) =>
      switch (this) {
        Ok<T>(value: final v) => ok(v),
        Err<T>(error: final e) => err(e),
      };
}

class Ok<T> extends Result<T> {
  final T value;
  const Ok(this.value);
}

class Err<T> extends Result<T> {
  final Object error;
  const Err(this.error);
}
