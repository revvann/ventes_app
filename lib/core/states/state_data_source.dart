import 'package:flutter/cupertino.dart';
import 'package:ventes/app/api/presenters/regular_presenter.dart';

abstract class StateDataSource<T extends RegularPresenter> {
  late T presenter;

  T presenterBuilder();

  @mustCallSuper
  init() {
    presenter = presenterBuilder();
    presenter.contract = this;
  }

  @mustCallSuper
  ready() {}

  @mustCallSuper
  close() {}
}
