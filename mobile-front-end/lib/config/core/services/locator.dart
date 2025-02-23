import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../data/local_datasource.dart';
import '../../data/remote_datasource.dart';
import 'event_bus.dart';
import 'livekit_service.dart';

final locator = GetIt.instance;

@injectableInit
setupLocator() async {
  locator.registerLazySingleton(() => Bus());
  locator.registerLazySingleton(() => LocalDataSource());
  locator.registerLazySingleton(() => API());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => SnackbarService());

}
