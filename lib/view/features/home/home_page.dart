import 'package:flutter/material.dart';

import '../../../app_router.dart';
import '../../../core/index.dart';
import '../../../resources/generated/l10n.dart';
import 'home_view_model.dart';

class HomePage extends BasePage {
  const HomePage({super.key});

  @override
  BasePageState<HomePage, HomeViewModel> createState() => _HomePageState();
}

class _HomePageState extends BasePageState<HomePage, HomeViewModel> {
  @override
  HomeViewModel createViewModel() => HomeViewModel();

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => AppBar(
    title: Text(S.current.home_title),
    actions: [
      IconButton(
        icon: const Icon(Icons.logout),
        tooltip: S.current.logout,
        onPressed: () => viewModel.logout().subscribeHandleError(this),
      ),
    ],
  );

  @override
  Widget buildBody(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(S.current.welcome, textAlign: TextAlign.center),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => const DetailRoute().push(context),
          child: Text(S.current.home_open_detail),
        ),
      ],
    ),
  );
}
