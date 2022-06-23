import 'package:get/get.dart';
import 'package:ventes/app/api/contracts/base_contract.dart';
import 'package:ventes/core/api/fetcher.dart';

///
///type parameter
/// [R] result type parameter, pass to onSuccess
/// [F] fetcher's function type
/// [D] Data type, data to handler
///
class DataHandler<D, R, F extends Function> implements BaseContract<R, D> {
  DataHandler(
    this.id, {
    required this.fetcher,
    required D initialValue,
    this.onStart,
    this.onSuccess,
    this.onError,
    this.onFailed,
    this.onComplete,
  }) {
    fetcher.handler = this;
    _data = Rx<D>(initialValue);
  }

  String id;
  DataFetcher<F, R> fetcher;
  late Rx<D> _data;

  D get value => _data.value;

  final Rx<bool> _onProcess = Rx<bool>(false);
  bool get onProcess => _onProcess.value;
  set onProcess(bool value) => _onProcess.value = value;

  void start() {
    onProcess = true;
    onStart?.call();
  }

  void success(R param) {
    if (onSuccess != null) {
      _data.value = onSuccess!(param);
    }
  }

  void failed(String param) {
    onFailed?.call(param);
  }

  void error(String param) {
    onError?.call(param);
  }

  void complete() {
    onComplete?.call();
    onProcess = false;
  }

  @override
  late Function()? onComplete;

  @override
  late Function(String)? onError;

  @override
  late Function(String)? onFailed;

  @override
  late Function()? onStart;

  @override
  late D Function(R)? onSuccess;
}
