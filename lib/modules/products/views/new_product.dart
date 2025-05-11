part of new_product_library;

class NewProduct extends WidgetView<NewProduct, NewProductControllerState> {
  NewProduct(super.controllerState, {super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: "New Product",
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {

          if (state is GenerateBarcodeSuccess) {
            controllerState.onBarcodeGenerated(state);
          }
        },
        builder: (context, state) {
          if (state is LoadingProductUom) {
            return Center(child: CircularProgressIndicator(color: Colors.teal));
          }

          if (state is LoadProductUomFailure) {
            return Center(child: Text("Failed To Load UOMs"));
          }

          if (state is LoadProductUomSuccess || state is GenerateBarcodeSuccess) {
            // Set default UOM if not already selected
            if (controllerState.selectedUom == null &&
                state is LoadProductUomSuccess &&
                state.response.isNotEmpty) {
              controllerState.selectedUom = state.response.first;
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Form(
                key: controllerState.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    /// Product Name Field
                    TextFormField(
                      controller: controllerState.nameController,
                      decoration: const InputDecoration(
                        labelText: 'Enter Product Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    /// Product MRP Field
                    TextFormField(
                      controller: controllerState.priceController,
                      decoration: const InputDecoration(
                        labelText: 'Enter Product MRP',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product MRP';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    /// Product Base Price Field
                    TextFormField(
                      controller: controllerState.basePriceController,
                      decoration: const InputDecoration(
                        labelText: 'Enter Product Base Price',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter base price';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    /// Scan Barcode Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          controllerState.scanBarcode(context, controllerState.skuController);
                        },
                        child: const Text('Scan Barcode', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 10),

                    /// Product SKU Field
                    TextFormField(
                      controller: controllerState.skuController,
                      decoration: const InputDecoration(
                        labelText: 'Product SKU for/from barcode',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Product SKU is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    /// Generate Barcode Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controllerState.barcodeImageUrl.isEmpty
                            ? () {
                          controllerState.generateBarcode();
                        }
                            : null,
                        child: const Text('Generate Barcode', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 10),

                    /// Barcode Display and Download
                    if (state is GenerateBarcodeSuccess || (state is LoadProductUomSuccess && controllerState.barcodeImageUrl != ""))
                      Column(
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                controllerState.barcodeImageUrl,
                                width: 200,
                                height: 100,
                                fit: BoxFit.contain,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(child: CircularProgressIndicator());
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Text("Failed to load barcode image");
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                await controllerState.downloadBarcodeImage(context);
                              },
                              icon: const Icon(Icons.download),
                              label: const Text("Download Barcode"),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 10),

                    /// UOM Dropdown
                    DropdownButtonFormField<Uom>(
                      decoration: const InputDecoration(
                        labelText: 'Select UOM',
                        border: OutlineInputBorder(),
                      ),
                      value: controllerState.selectedUom,
                      items: state is LoadProductUomSuccess && state.response.isNotEmpty
                          ? state.response.map((Uom uom) {
                        return DropdownMenuItem<Uom>(
                          value: uom.id == 0 ? null : uom,
                          child: Text("${uom.slug} (${uom.title})"),
                        );
                      }).toList()
                          : [],
                      onChanged: (Uom? newValue) {
                        if (newValue != null) {
                          controllerState.updateDropdownItems(newValue);
                        }
                      },
                      validator: (value) {
                        if (value == null) return "Please select a UOM";
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),

                    /// Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          controllerState.createNewProduct();
                        },
                        child: const Text('Submit', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}