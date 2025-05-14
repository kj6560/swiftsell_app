part of edit_product_controller;

class EditProductScreen
    extends WidgetView<EditProductScreen, EditProductControllerState> {
  EditProductScreen(super.controllerState, {super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: "Edit Product",
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is LoadProductUomSuccess) {
            controllerState.updateDropdownItems(state.response);
            controllerState.loadProductDetails();
          }
          if (state is GenerateBarcodeSuccess) {
            controllerState.barcodeImageUrl = state.barcodeUrl;
          } else if (state is LoadProductDetailSuccess) {
            controllerState.populateProductDetails(state.response);
          }
        },
        builder: (context, state) {
          if (state is LoadingProductDetail) {
            return Center(child: CircularProgressIndicator(color: Colors.teal));
          } else if (state is LoadProductDetailFailure) {
            return Center(child: Text("Failed To Load Product Details"));
          } else if (state is LoadProductDetailSuccess) {
            return _buildEditProductForm(context);
          } else {
            return Center(child: CircularProgressIndicator(color: Colors.teal));
          }
        },
      ),
    );
  }

  Widget _buildEditProductForm(BuildContext context) {
    print("Total Uom count: ${controllerState.dropdownItems.length}");
    return SingleChildScrollView(
      child: Form(
        key: controllerState.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min, // Prevents unnecessary stretching
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controllerState.nameController,
                decoration: InputDecoration(
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
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controllerState.priceController,
                decoration: InputDecoration(
                  labelText: 'Enter Product MRP',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product MRP';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controllerState.basePriceController,
                decoration: InputDecoration(
                  labelText: 'Enter Product Base Price',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product base price';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              width: 150,
              height: 30,
              child: ElevatedButton(
                onPressed: () {
                  controllerState.scanBarcode(context,controllerState.skuController);
                },
                child: Text('Scan Barcode', style: TextStyle(fontSize: 18)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controllerState.skuController,
                decoration: InputDecoration(
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
            ),
            SizedBox(
              width: 250,
              height: 35,
              child: ElevatedButton(
                onPressed: () {
                  controllerState.generateBarcode();
                },
                child: Text('Generate Barcode', style: TextStyle(fontSize: 18)),
              ),
            ),
            if (controllerState.barcodeImageUrl != null)
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      controllerState.barcodeImageUrl!,
                      width: 200,
                      height: 100,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Text("Failed to load barcode image");
                      },
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await controllerState.downloadBarcodeImage(context);
                      },
                      icon: Icon(Icons.download),
                      label: Text("Download Barcode"),
                    ),
                  ),
                ],
              ),
            // **Dropdown for UOM**
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<Uom>(
                decoration: InputDecoration(
                  labelText: 'Select UOM',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
                value: (controllerState.selectedUom != null &&
                        controllerState.dropdownItems
                            .contains(controllerState.selectedUom))
                    ? controllerState.selectedUom
                    : null,
                items: controllerState.dropdownItems.isNotEmpty
                    ? controllerState.dropdownItems.map((Uom uom) {
                        return DropdownMenuItem<Uom>(
                          value: uom,
                          child: Text("(${uom.title})"),
                        );
                      }).toList()
                    : [],
                onChanged: (Uom? newValue) {
                  if (newValue != null) {
                    controllerState.updateUom(newValue);
                  }
                },
              ),
            ),
            // **Submit Button**
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 50,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    controllerState.updateProduct();
                  },
                  child: Text('Submit', style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
