import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_event.dart';
import 'product_state.dart';
import '../../domain/usecases/get_products_usecase.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase getProductsUseCase;

  ProductBloc({required this.getProductsUseCase})
    : super(const ProductState()) {
    on<FetchProducts>(_onFetchProducts);
    on<SearchProducts>(_onSearchProducts);
    on<FilterByCategory>(_onFilterByCategory);
    on<SortProducts>(_onSortProducts);
  }

  Future<void> _onFetchProducts(
    FetchProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      final products = await getProductsUseCase();
      emit(
        state.copyWith(
          status: ProductStatus.success,
          allProducts: products,
          displayedProducts: products,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onSearchProducts(SearchProducts event, Emitter<ProductState> emit) {
    final query = event.query.toLowerCase();
    final filtered = state.allProducts.where((p) {
      return p.title.toLowerCase().contains(query);
    }).toList();
    emit(state.copyWith(displayedProducts: filtered));
  }

  void _onFilterByCategory(FilterByCategory event, Emitter<ProductState> emit) {
    if (event.category.isEmpty || event.category == 'All') {
      emit(state.copyWith(displayedProducts: state.allProducts));
      return;
    }
    final filtered = state.allProducts
        .where((p) => p.category == event.category)
        .toList();
    emit(state.copyWith(displayedProducts: filtered));
  }

  void _onSortProducts(SortProducts event, Emitter<ProductState> emit) {
    final sortedList = List.of(state.displayedProducts);
    if (event.isAscending) {
      sortedList.sort((a, b) => a.price.compareTo(b.price)); // Low to High
    } else {
      sortedList.sort((a, b) => b.price.compareTo(a.price)); // High to Low
    }
    emit(state.copyWith(displayedProducts: sortedList));
  }
}
