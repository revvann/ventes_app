import 'package:flutter/cupertino.dart';
import 'package:ventes/app/network/presenters/regular_presenter.dart';

abstract class RegularDataSource<T extends RegularPresenter> {
  late T presenter;

  T presenterBuilder();

  @mustCallSuper
  init() {
    presenter = presenterBuilder();
    presenter.contract = this;
  }
}
