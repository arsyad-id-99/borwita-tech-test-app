import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_data_source.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;

  CartRepositoryImpl({required this.localDataSource});

  @override
  Future<void> addToCart(CartItem item) async {
    await localDataSource.addToCart(item);
  }

  @override
  Future<List<CartItem>> getCartItems() async {
    return await localDataSource.getCartItems();
  }
}
