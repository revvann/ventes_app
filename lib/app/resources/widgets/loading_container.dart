import 'package:flutter/material.dart' hide MenuItem;
import 'package:ventes/app/resources/widgets/loader.dart';

class LoadingContainer extends StatelessWidget {
  bool isLoading;
  Widget child;
  double width;

  LoadingContainer({required this.isLoading, required this.child, this.width = 15});

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: LoaderAnimation(
              strokeWidth: width / 15 * 3,
              width: width,
            ),
          )
        : child;
  }
}
