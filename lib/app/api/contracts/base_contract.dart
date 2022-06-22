abstract class BaseContract<T> {
  late Function() onStart;
  late Function(T) onSuccess;
  late Function(String) onFailed;
  late Function(String) onError;
  late Function() onComplete;
}
