abstract class BaseContract<T, S> {
  late Function()? onStart;
  late S Function(T)? onSuccess;
  late Function(String)? onFailed;
  late Function(String)? onError;
  late Function()? onComplete;
}
