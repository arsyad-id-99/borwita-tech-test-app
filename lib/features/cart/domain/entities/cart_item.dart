import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final int? id; // Nullable karena auto-increment di SQLite
  final int productId;
  final String productTitle;
  final String productImage;
  final String category;
  final double price;
  final int quantity;
  final double subtotal;
  final String createdAt;

  const CartItem({
    this.id,
    required this.productId,
    required this.productTitle,
    required this.productImage,
    required this.category,
    required this.price,
    required this.quantity,
    required this.subtotal,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    productId,
    productTitle,
    productImage,
    category,
    price,
    quantity,
    subtotal,
    createdAt,
  ];
}
