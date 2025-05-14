part of product_detail_library;

class ProductDetailScreen
    extends WidgetView<ProductDetailScreen, ProductDetailControllerState> {
  ProductDetailScreen(super.controllerState, {super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: "Product Detail",

      fabIcon: Icons.edit,
      onFabPressed: () {
        Navigator.popAndPushNamed(context, AppRoutes.newProduct);
      },
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is DeleteProductSuccess) {
            controllerState.postDelete();
          }
        },
        builder: (context, state) {
          if (state is LoadingProductDetail) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.teal));
          } else if (state is LoadProductDetailSuccess) {
            final product = state.response;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buildInfoRow("Product Name", product.name),
                      buildInfoRow("Product SKU", product.sku),
                      buildInfoRow("Product MRP", "${product.productMrp}",
                          isCurrency: true),
                      buildInfoRow("Base Price", "${product.basePrice}",
                          isCurrency: true),
                      buildInfoRow("UOM", product.uom?.slug ?? '-'),
                      buildInfoRow(
                          "Active", product.isActive == 1 ? 'Yes' : 'No'),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.popAndPushNamed(
                                context,
                                AppRoutes.editProduct,
                                arguments: {
                                  "product_id": controllerState.product_id
                                },
                              );
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Edit",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              controllerState.deleteProduct();
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Delete",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: Text("Product Loading Failed"));
          }
        },
      ),
    );
  }

  Widget buildInfoRow(String label, String value, {bool isCurrency = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$label:",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                if (isCurrency) const Icon(Icons.currency_rupee, size: 16),
                Flexible(
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
