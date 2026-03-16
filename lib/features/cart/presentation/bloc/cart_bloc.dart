import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/usecases/get_cart_items_usecase.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';

// --- Events ---
abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class LoadCart extends CartEvent {}

class AddItemToCart extends CartEvent {
  final CartItem item;

  const AddItemToCart(this.item);

  @override
  List<Object> get props => [item];
}

// --- States ---
abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;
  final double total;
  final double discount;
  final double finalTotal;

  CartLoaded({required this.items})
    : total = items.fold(0, (sum, item) => sum + item.subtotal),
      // Logika diskon: Jika total > 200, diskon 10% (0.1), jika tidak 0
      discount = (items.fold(0.0, (sum, item) => sum + item.subtotal) > 200)
          ? items.fold(0.0, (sum, item) => sum + item.subtotal) * 0.1
          : 0,
      // Final total = total - diskon
      finalTotal =
          items.fold(0.0, (sum, item) => sum + item.subtotal) -
          ((items.fold(0.0, (sum, item) => sum + item.subtotal) > 200)
              ? items.fold(0.0, (sum, item) => sum + item.subtotal) * 0.1
              : 0);

  @override
  List<Object> get props => [items, total, discount, finalTotal];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object> get props => [message];
}

// --- BLoC ---
class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartItemsUseCase getCartItemsUseCase;
  final AddToCartUseCase addToCartUseCase;

  CartBloc({required this.getCartItemsUseCase, required this.addToCartUseCase})
    : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddItemToCart>(_onAddItemToCart);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final items = await getCartItemsUseCase();
      emit(CartLoaded(items: items));
    } catch (e) {
      emit(CartError('Gagal memuat keranjang: ${e.toString()}'));
    }
  }

  Future<void> _onAddItemToCart(
    AddItemToCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      await addToCartUseCase(event.item);
      add(LoadCart());
    } catch (e) {
      emit(CartError('Gagal menambahkan ke keranjang: ${e.toString()}'));
    }
  }
}
