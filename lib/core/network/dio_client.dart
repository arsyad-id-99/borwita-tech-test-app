import 'package:dio/dio.dart';

class DioClient {
  final Dio dio;

  DioClient() : dio = Dio(BaseOptions(baseUrl: 'https://fakestoreapi.com/')) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          String errorMessage = "Terjadi kesalahan yang tidak diketahui";
          if (e.type == DioExceptionType.connectionTimeout) {
            errorMessage = "Koneksi timeout";
          } else if (e.response != null) {
            errorMessage =
                e.response?.data['message'] ??
                "Error ${e.response?.statusCode}";
          }
          return handler.next(e.copyWith(message: errorMessage));
        },
      ),
    );
  }
}
