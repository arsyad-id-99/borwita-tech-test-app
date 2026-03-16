import '../../../../core/database/database_helper.dart';
import '../../domain/entities/cart_item.dart';

abstract class CartLocalDataSource {
  Future<void> addToCart(CartItem item);
  Future<List<CartItem>> getCartItems();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final DatabaseHelper databaseHelper;

  CartLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<void> addToCart(CartItem item) async {
    final row = {
      'product_id': item.productId,
      'product_title': item.productTitle,
      'product_image': item.productImage,
      'category': item.category,
      'price': item.price,
      'quantity': item.quantity,
      'subtotal': item.subtotal,
      'created_at': item.createdAt,
    };

    await databaseHelper.insertCartItem(row);
  }

  @override
  Future<List<CartItem>> getCartItems() async {
    final List<Map<String, dynamic>> maps = await databaseHelper
        .fetchCartItems();

    return maps.map((map) {
      return CartItem(
        id: map['id'],
        productId: map['product_id'],
        productTitle: map['product_title'],
        productImage: map['product_image'],
        category: map['category'],
        price: map['price'],
        quantity: map['quantity'],
        subtotal: map['subtotal'],
        createdAt: map['created_at'],
      );
    }).toList();
  }
}
