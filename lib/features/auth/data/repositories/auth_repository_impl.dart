import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<String> login(String username, String password) async {
    final token = await remoteDataSource.login(username, password);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);

    return token;
  }
}
