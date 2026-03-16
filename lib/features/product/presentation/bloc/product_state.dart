import 'package:equatable/equatable.dart';
// Asumsikan Anda memiliki entitas Product di domain layer
import '../../domain/entities/product.dart';

enum ProductStatus { initial, loading, success, failure }

class ProductState extends Equatable {
  final ProductStatus status;
  final List<Product> allProducts;
  final List<Product> displayedProducts;
  final String errorMessage;

  const ProductState({
    this.status = ProductStatus.initial,
    this.allProducts = const [],
    this.displayedProducts = const [],
    this.errorMessage = '',
  });

  ProductState copyWith({
    ProductStatus? status,
    List<Product>? allProducts,
    List<Product>? displayedProducts,
    String? errorMessage,
  }) {
    return ProductState(
      status: status ?? this.status,
      allProducts: allProducts ?? this.allProducts,
      displayedProducts: displayedProducts ?? this.displayedProducts,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
    status,
    allProducts,
    displayedProducts,
    errorMessage,
  ];
}
