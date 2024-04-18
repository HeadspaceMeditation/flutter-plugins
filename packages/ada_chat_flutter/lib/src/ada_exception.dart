class AdaException implements Exception {
  const AdaException(this.error);

  final String error;

  @override
  String toString() => 'AdaException{error: $error}';
}

class AdaExecException extends AdaException {
  const AdaExecException(super.error);

  @override
  String toString() => 'AdaExecException{error: $error}';
}

class AdaNullResultException extends AdaException {
  const AdaNullResultException() : super('Result is null');

  @override
  String toString() => 'AdaNullResultException{}';
}
