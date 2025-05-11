part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class LoadProductList extends ProductEvent {
  const LoadProductList();
}

class AddNewProduct extends ProductEvent {
  final String name;
  final double price;
  final double base_price;
  final String sku;
  final int uom_id;

  const AddNewProduct(
      {required this.name,
      required this.price,
      required this.sku,
      required this.base_price,
      required this.uom_id});
}

class DeleteProduct extends ProductEvent {
  final int id;

  const DeleteProduct({
    required this.id,
  });
}

class LoadProductDetail extends ProductEvent {
  final String product_id;

  const LoadProductDetail({required this.product_id});
}

class LoadProductUom extends ProductEvent {
  const LoadProductUom();
}

class GenerateBarcode extends ProductEvent {
  final String barcodeValue;

  GenerateBarcode({required this.barcodeValue});
}
