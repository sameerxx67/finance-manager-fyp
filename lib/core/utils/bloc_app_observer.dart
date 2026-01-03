import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocAppObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);

    debugPrint("onCreate : $bloc");
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);

    debugPrint("onClose : $bloc");
  }
}
