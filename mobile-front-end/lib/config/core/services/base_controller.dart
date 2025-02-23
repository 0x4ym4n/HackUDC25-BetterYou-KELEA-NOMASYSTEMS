import 'package:get/get.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../data/local_datasource.dart';
import '../../data/remote_datasource.dart';
import '../services/event_bus.dart';
import 'locator.dart';

class BaseGetxController extends GetxController {
  final api = locator<API>();
  final localDB = locator<LocalDataSource>();
  final eventbus = locator<Bus>();
  final dialogService = locator<DialogService>();
  final snackBarService = locator<SnackbarService>();
}
