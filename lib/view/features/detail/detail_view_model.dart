import '../../../core/index.dart';

/// One ViewModel per [id] (DetailPage creates it, keyed by id): the route/deep-link param arrives
/// through the constructor. Loading data by [id] later belongs here.
class DetailViewModel extends BaseViewModel<String?> {
  DetailViewModel(super.id);
}
