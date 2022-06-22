import 'package:get/get.dart';
import 'package:ventes/core/api/handler.dart';

///
/// type parameters
/// T => param for Function
/// R =>param for data handler's result;
///
class DataFetcher<T extends Function, R> {
  DataFetcher({required this.builder});

  late DataHandler<R, T> handler;
  T Function(DataHandler<R, T> handler) builder;
  T get run => builder(handler);
}

///
/// fetcher for get simple response (without processing first)
/// R type param will be result type
///
class SimpleFetcher<R> extends DataFetcher<Function(), R> {
  Future<Response> Function() responseBuilder;
  SimpleFetcher({
    required this.responseBuilder,
    String failedMessage = "",
  }) : super(
          builder: (handler) {
            return () async {
              handler.onStart();
              try {
                Response response = await responseBuilder();
                if (response.statusCode == 200) {
                  handler.onSuccess(response.body);
                } else {
                  handler.onFailed(failedMessage);
                }
              } catch (e) {
                handler.onError(e.toString());
              }
              handler.onComplete();
            };
          },
        );
}
