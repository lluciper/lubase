import 'package:flutter/material.dart';

import '../../../core/index.dart';
import '../../../resources/generated/l10n.dart';
import 'detail_view_model.dart';

class DetailPage extends BasePage {
  const DetailPage({this.id, super.key});

  /// From the route query, e.g. `lubase://app/home/detail?id=42`.
  final String? id;

  @override
  BasePageState<DetailPage, DetailViewModel> createState() =>
      _DetailPageState();
}

class _DetailPageState extends BasePageState<DetailPage, DetailViewModel> {
  @override
  DetailViewModel createViewModel() => DetailViewModel(widget.id);

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) =>
      AppBar(title: Text(S.current.detail_title));

  @override
  Widget buildBody(BuildContext context) {
    final id = viewModel.listen(context, (id) => id);
    return Center(
      child: Text(
        id == null ? S.current.detail_no_param : S.current.detail_param(id),
        textAlign: TextAlign.center,
      ),
    );
  }
}
