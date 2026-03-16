import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class FetchProducts extends ProductEvent {}

class SearchProducts extends ProductEvent {
  final String query;
  const SearchProducts(this.query);
  @override
  List<Object> get props => [query];
}

class FilterByCategory extends ProductEvent {
  final String category;
  const FilterByCategory(this.category);
  @override
  List<Object> get props => [category];
}

class SortProducts extends ProductEvent {
  final bool isAscending; // true: Low to High, false: High to Low
  const SortProducts(this.isAscending);
  @override
  List<Object> get props => [isAscending];
}
