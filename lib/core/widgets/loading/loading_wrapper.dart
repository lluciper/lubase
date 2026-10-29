import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../index.dart';

class LoadingWrapper extends StatelessWidget {
  const LoadingWrapper({
    required this.viewModel,
    this.child = const SizedBox(),
    super.key,
  });

  final LoadingWrapperViewModel viewModel;
  final Widget child;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      child,
      BlocBuilder<LoadingWrapperViewModel, bool>(
        bloc: viewModel,
        builder: (context, isLoading) => isLoading
            ? Container(
                width: double.infinity,
                height: double.infinity,
                color: const Color.fromARGB(72, 0, 0, 0),
                child: const Center(child: ProgressIndicatorPlatform()),
              )
            : const SizedBox.shrink(),
      ),
    ],
  );
}

class LoadingWrapperViewModel extends BaseViewModel<bool> {
  LoadingWrapperViewModel() : super(false);

  void showLoading() {
    emit(true);
  }

  void dismissLoading() {
    emit(false);
  }
}
