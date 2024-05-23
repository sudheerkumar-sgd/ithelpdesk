import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:smartuaq/core/config/flavor_config.dart';
import 'package:smartuaq/core/network/network_info.dart';
import 'package:smartuaq/data/remote/dio_logging_interceptor.dart';
import 'package:smartuaq/data/remote/remote_data_source.dart';
import 'package:smartuaq/data/repository/apis_repository_impl.dart';
import 'package:smartuaq/domain/repository/apis_repository.dart';
import 'package:smartuaq/domain/usecase/docverification_usecase.dart';
import 'package:smartuaq/domain/usecase/mywallet_usecase.dart';
import 'package:smartuaq/domain/usecase/requests_usecase.dart';
import 'package:smartuaq/domain/usecase/services_usecase.dart';
import 'package:smartuaq/domain/usecase/login_usecase.dart';
import 'package:smartuaq/presentation/bloc/docverification/docverification_bloc.dart';
import 'package:smartuaq/presentation/bloc/login/login_bloc.dart';
import 'package:smartuaq/presentation/bloc/mywallet/mywallet_bloc.dart';
import 'package:smartuaq/presentation/bloc/services/requests_bloc.dart';
import 'package:smartuaq/presentation/bloc/services/services_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /**
   * ! Features
   */
  // Bloc
  sl.registerFactory(
    () => LoginBloc(
      loginUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => ServicesBloc(
      servicesUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => MyWalletBloc(
      myWalletUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => DocVerificationBloc(
      docVerificationUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => RequestsBloc(
      requestsUseCase: sl(),
    ),
  );
  // Use Case
  sl.registerLazySingleton(() => ServicesUseCase(apisRepository: sl()));
  sl.registerLazySingleton(() => LoginUseCase(apisRepository: sl()));
  sl.registerLazySingleton(() => MyWalletUseCase(apisRepository: sl()));
  sl.registerLazySingleton(() => DocVerificationUseCase(apisRepository: sl()));
  sl.registerLazySingleton(() => RequestsUseCase(apisRepository: sl()));

  // Repository
  sl.registerLazySingleton<ApisRepository>(
      () => ApisRepositoryImpl(dataSource: sl(), networkInfo: sl()));

  // Data Source
  sl.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(dio: sl()));

  /**
   * ! Core
   */
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  /**
   * ! External
   */
  sl.registerLazySingleton(() {
    final dio = Dio();
    dio.options.baseUrl = FlavorConfig.instance.values.portalBaseUrl;
    dio.interceptors.add(DioLoggingInterceptor());
    return dio;
  });
}
