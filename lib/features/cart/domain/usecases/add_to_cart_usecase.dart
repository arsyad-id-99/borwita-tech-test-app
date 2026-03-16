import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

class AddToCartUseCase {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  Future<void> call(CartItem item) async {
    return await repository.addToCart(item);
  }
}
