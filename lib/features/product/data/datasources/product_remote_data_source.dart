import 'package:dio/dio.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await dio.get('https://fakestoreapi.com/products');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        return data.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception(
          'Gagal memuat data produk dengan status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Gagal mengambil data produk dari server');
    } catch (e) {
      throw Exception('Terjadi kesalahan yang tidak diketahui: $e');
    }
  }
}
