import '../entities/cart_item.dart';

abstract class CartRepository {
  Future<void> addToCart(CartItem item);
  Future<List<CartItem>> getCartItems();
}
