import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/index.dart';
import '../di/dependence.dart';

/// Every ViewModel needs to inherit from this class.
/// Mỗi ViewModel cần kế thừa từ lớp này.
///
/// Pass the initial state to `super`.
/// Truyền state khởi tạo cho `super`.
abstract class BaseViewModel<T> extends Cubit<T> {
  BaseViewModel(super.initialState);

  @protected
  Repository get repository => getIt<Repository>();
}

extension ViewModelExtension<VM extends BaseViewModel<StateT>, StateT> on VM {
  /// Watches part of the state: the widget of [context] rebuilds only when
  /// [selector]'s result changes. [context] must be inside the page (every
  /// `buildBody` context is).
  /// Theo dõi một phần state: widget của [context] chỉ rebuild khi kết quả
  /// [selector] đổi.
  Selected listen<Selected>(
    BuildContext context,
    Selected Function(StateT value) selector,
  ) => context.select<VM, Selected>((viewModel) => selector(viewModel.state));
}
