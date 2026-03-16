import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core
import 'core/database/database_helper.dart';

// Features - Auth
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

// Features - Product
import 'features/product/data/datasources/product_remote_data_source.dart';
import 'features/product/data/repositories/product_repository_impl.dart';
import 'features/product/domain/repositories/product_repository.dart';
import 'features/product/domain/usecases/get_products_usecase.dart';
import 'features/product/presentation/bloc/product_bloc.dart';

// Features - Cart
import 'features/cart/data/datasources/cart_local_data_source.dart';
import 'features/cart/data/repositories/cart_repository_impl.dart';
import 'features/cart/domain/repositories/cart_repository.dart';
import 'features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'features/cart/domain/usecases/get_cart_items_usecase.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';

final sl = GetIt.instance; // sl = Service Locator

Future<void> init() async {
  // ==================== BLoCs ====================
  sl.registerFactory(() => AuthBloc(loginUseCase: sl()));
  sl.registerFactory(() => ProductBloc(getProductsUseCase: sl()));
  sl.registerFactory(
    () => CartBloc(getCartItemsUseCase: sl(), addToCartUseCase: sl()),
  );

  // ==================== UseCases ====================
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton(() => AddToCartUseCase(sl()));
  sl.registerLazySingleton(() => GetCartItemsUseCase(sl()));

  // ==================== Repositories ====================
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(localDataSource: sl()),
  );

  // ==================== Data Sources ====================
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<CartLocalDataSource>(
    () => CartLocalDataSourceImpl(databaseHelper: sl()),
  );

  // ==================== Core & External ====================
  // SharedPreferences (Async)
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Dio
  sl.registerLazySingleton(() {
    final dio = Dio(BaseOptions(baseUrl: 'https://fakestoreapi.com/'));
    return dio;
  });

  // Database Helper (SQLite)
  sl.registerLazySingleton(() => DatabaseHelper.instance);
}
