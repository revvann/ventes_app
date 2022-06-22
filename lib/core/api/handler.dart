import 'package:get/get.dart';
import 'package:ventes/app/api/contracts/base_contract.dart';
import 'package:ventes/core/api/fetcher.dart';

///
///type parameter
/// T => result type parameter, pass to onSuccess
/// F => fetcher's function type
///
class DataHandler<T, F extends Function> implements BaseContract<T> {
  DataHandler(
    this.id, {
    required this.fetcher,
    Function()? onStart,
    Function(T)? onSuccess,
    Function(String)? onError,
    Function(String)? onFailed,
    Function()? onComplete,
  }) {
    fetcher.handler = this;
    this.onStart = startBuilder(onStart);
    this.onSuccess = successBuilder(onSuccess);
    this.onFailed = failedBuilder(onFailed);
    this.onError = errorBuilder(onError);
    this.onComplete = completeBuilder(onComplete);
  }

  String id;
  DataFetcher<F, T> fetcher;

  final Rx<bool> _onProcess = Rx<bool>(false);
  bool get onProcess => _onProcess.value;
  set onProcess(bool value) => _onProcess.value = value;

  Function() startBuilder(Function()? callback) {
    return () {
      onProcess = true;
      callback?.call();
    };
  }

  Function(T) successBuilder(Function(T)? callback) {
    return (param) {
      callback?.call(param);
    };
  }

  Function(String) failedBuilder(Function(String)? callback) {
    return (param) {
      callback?.call(param);
    };
  }

  Function(String) errorBuilder(Function(String)? callback) {
    return (param) {
      callback?.call(param);
    };
  }

  Function() completeBuilder(Function()? callback) {
    return () {
      callback?.call();
      onProcess = false;
    };
  }

  @override
  late Function() onComplete;

  @override
  late Function(String) onError;

  @override
  late Function(String) onFailed;

  @override
  late Function() onStart;

  @override
  late Function(T) onSuccess;
}
