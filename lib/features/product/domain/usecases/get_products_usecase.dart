import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  // Method call() memungkinkan instance class ini dipanggil seperti fungsi biasa
  Future<List<Product>> call() async {
    return await repository.getProducts();
  }
}
