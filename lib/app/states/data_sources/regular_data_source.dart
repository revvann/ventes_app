import 'package:flutter/cupertino.dart';
import 'package:ventes/app/network/presenters/regular_presenter.dart';

abstract class RegularDataSource<T extends RegularPresenter> {
  late T presenter;

  @mustCallSuper
  init() {
    presenter.contract = this;
  }
}
