import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'injection_container.dart' as di;

// Import BLoCs
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/product/presentation/bloc/product_bloc.dart';
import 'features/product/presentation/bloc/product_event.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';

// Import Pages
import 'features/auth/presentation/pages/login_page.dart';
import 'features/main/presentation/pages/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Dependency Injection
  await di.init();

  // Cek status login
  final prefs = di.sl<SharedPreferences>();
  final String? token = prefs.getString('auth_token');

  // Menentukan rute awal berdasarkan keberadaan token
  final String initialRoute = (token != null && token.isNotEmpty)
      ? '/main'
      : '/login';

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthBloc>()),
        BlocProvider(create: (_) => di.sl<ProductBloc>()..add(FetchProducts())),
        BlocProvider(create: (_) => di.sl<CartBloc>()),
      ],
      child: MaterialApp(
        title: 'FakeStore Smart Cart',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.grey.shade50,
        ),
        initialRoute: initialRoute,
        routes: {
          '/login': (context) => const LoginPage(),
          '/main': (context) => MainPage(),
        },
      ),
    );
  }
}
