import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

abstract class AuthRemoteDataSource {
  Future<String> login(String username, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<String> login(String username, String password) async {
    try {
      final response = await dio.post(
        'https://fakestoreapi.com/auth/login',
        data: {'username': username, 'password': password},
      );
      return response.data['token'];
    } on DioException catch (e) {
      debugPrint('DioException: ${e.message}');
      throw Exception(e.message ?? 'Gagal melakukan login');
    } catch (e) {
      debugPrint('Unknown error: $e');
      throw Exception('Terjadi kesalahan yang tidak diketahui');
    }
  }
}
