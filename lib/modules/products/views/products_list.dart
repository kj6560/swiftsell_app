import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swiftsell/core/widgets/base_screen.dart';

import '../../../core/routes.dart';
import '../../../core/widgets/base_widget.dart';
import '../bloc/product_bloc.dart';
import '../models/products_model.dart';
import 'ProductsListController.dart';

class ProductsList extends WidgetView<ProductsList, ProductsListControllerState> {
  ProductsList(super.controllerState, {super.key});
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Products',
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is LoadProductListFailure) {
            print("trigger change");
            controllerState.changeSubscriptionStatus(false);
          }else if(state is LoadProductSuccess) {
            controllerState.changeSubscriptionStatus(true);
          }
        },
        builder: (context, state) {
          if (state is LoadingProductList) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(color: Colors.teal),
                  SizedBox(height: 8),
                  Text("Loading"),
                ],
              ),
            );
          } else if (state is LoadProductSuccess) {
            List<Product> allProducts = state.response;
            List<Product> filteredProducts = List.from(allProducts);

            return StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Search Products...",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (query) {
                          query = query.toLowerCase();
                          setState(() {
                            if (query.isEmpty) {
                              filteredProducts = List.from(allProducts);
                            } else {
                              filteredProducts = allProducts.where((product) {
                                return product.name
                                    .toLowerCase()
                                    .contains(query) ||
                                    product.sku.toLowerCase().contains(query);
                              }).toList();
                            }
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: filteredProducts.isEmpty
                          ? Center(child: Text("No products found"))
                          : ListView.builder(
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          Product product = filteredProducts[index];
                          return InkWell(
                            onTap: () {
                              Navigator.popAndPushNamed(
                                context,
                                AppRoutes.productDetails,
                                arguments: {"product_id": product.id},
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 6.0),
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(Icons.qr_code,
                                              size: 18,
                                              color: Colors.grey[700]),
                                          SizedBox(width: 6),
                                          Text(
                                            "SKU: ",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              product.sku,
                                              style:
                                              TextStyle(fontSize: 16),
                                              overflow:
                                              TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Icon(Icons.currency_rupee,
                                              size: 18,
                                              color: Colors.green[700]),
                                          SizedBox(width: 6),
                                          Text(
                                            "${product.productMrp}",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green[800],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          } else if (state is LoadProductListFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.error),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(color: Colors.teal),
            );
          }
        },
      ),
      onFabPressed: () {
        print("has subscription: ${controllerState.hasActiveSubscription}");
        if (controllerState.hasActiveSubscription) {
          Navigator.pushNamed(context, AppRoutes.newProduct);
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Subscription Required"),
                content: Text(
                    "You don't have an active subscription. Please contact Admin."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("OK", style: TextStyle(color: Colors.teal)),
                  ),
                ],
              );
            },
          );
        }
      },
      appBarActions: [
        IconButton(
          icon: Icon(Icons.local_offer, color: Colors.white),
          onPressed: () {
            if (controllerState.hasActiveSubscription) {
              Navigator.popAndPushNamed(context, AppRoutes.listSchemes);
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Subscription Required"),
                    content: Text(
                        "You don't have an active subscription. Please contact Admin."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text("OK", style: TextStyle(color: Colors.teal)),
                      ),
                    ],
                  );
                },
              );
            }
            print("schemes clicked");
          },
        ),
      ],
    );
  }
}
