import 'dart:convert';

import 'package:crud_app/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class UpdateProductScreen extends StatefulWidget {
  const UpdateProductScreen({super.key, required this.product});
  final Product product;

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreen();
}

class _UpdateProductScreen extends State<UpdateProductScreen> {
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _unitPriceTEController = TextEditingController();
  final TextEditingController _quantityTEController = TextEditingController();
  final TextEditingController _totalTEController = TextEditingController();
  final TextEditingController _imageTEController = TextEditingController();
  final TextEditingController _productCodeTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _updateProductInProgress = false;

  @override
  void initState() {
    super.initState();
    _nameTEController.text = widget.product.productName;
    _unitPriceTEController.text = widget.product.unitePrice;
    _quantityTEController.text = widget.product.quantity;
    _totalTEController.text = widget.product.totalPrice;
    _imageTEController.text = widget.product.image;
    _productCodeTEController.text = widget.product.productCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _nameTEController,
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    hintText: 'Product Name',
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'write product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _unitPriceTEController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Unite Price',
                    hintText: 'Price',
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'write Unite Price';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _quantityTEController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    hintText: 'Quantity',
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'write product Quantity';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _productCodeTEController,
                  decoration: InputDecoration(
                    labelText: 'Product Code',
                    hintText: 'Product Code',
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'write product code';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _totalTEController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Total Price',
                    hintText: 'Total Price',
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'write total price';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _imageTEController,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    labelText: 'Image',
                    hintText: 'Image',
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Image URL';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        fixedSize: Size.fromWidth(double.maxFinite),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 20)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _updateProduct();
                      }
                    },
                    child: Text('Update Product'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateProduct() async {
    _updateProductInProgress = true;
    setState(() {});
    String updateProductUrl =
        'https://crud.teamrabbil.com/api/v1/UpdateProduct/${widget.product.id}';
    Uri uri = Uri.parse(updateProductUrl);
    Map<String, String> inputData ={
      "Img":_imageTEController.text,
      "ProductCode":_productCodeTEController.text,
      "ProductName":_nameTEController.text,
      "Qty":_quantityTEController.text,
      "TotalPrice":_totalTEController.text,
      "UnitPrice":_unitPriceTEController.text
    };
    Response response =
        await post(uri, headers: {'content-type': 'application/json'}, body:jsonEncode(inputData) );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Update Product Success')));
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Update Product Failed')));
    }

    _updateProductInProgress = false;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _nameTEController.dispose();
    _unitPriceTEController.dispose();
    _quantityTEController.dispose();
    _totalTEController.dispose();
    _imageTEController.dispose();
  }
}
