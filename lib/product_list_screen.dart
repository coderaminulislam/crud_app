import 'dart:convert';

import 'package:crud_app/product.dart';
import 'package:crud_app/update_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'add_product_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _getProductInProgress = false;
  List<Product> productList = [];
  @override
  void initState() {
    _getProductList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crud App'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: RefreshIndicator(
          //refresh screen
          onRefresh: _getProductList,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(textAlign: TextAlign.left, 'Product List'),
                const SizedBox(
                  height: 30,
                ),
                Visibility(
                  visible: _getProductInProgress == false,
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: ListView.separated(
                    itemCount: productList.length,
                    reverse: true,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return _ProductItemList(productList[index]);
                    },
                    separatorBuilder: (_, __) => const Divider(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async {
         final result= await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddProductScreen(),
              ));
         if(result == true){
           _getProductList();
         }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _ProductItemList(Product product) {
    return ListTile(
      // leading: Image.network(
      //     '${product.image}'),
      title: Text(product.productName),
      subtitle: Wrap(
        spacing: 6.0,
        children: [
          Text('Unit Price: ${product.unitePrice}'),
          Text('Quantity: ${product.quantity}'),
          Text('Total Price: ${product.totalPrice}'),
        ],
      ),
      trailing: Wrap(
        children: [
          IconButton(
              onPressed: () async {
              final result= await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateProductScreen(product: product,),
                    ));
              if(result == true){
                _getProductList();
              }
              },
              icon: const Icon(Icons.edit)),
          IconButton(
              onPressed: () {
                _showDeleteMessage(product.id);
              },
              icon: const Icon(Icons.delete)),
        ],
      ),
    );
  }

  Future<void> _getProductList() async {
    _getProductInProgress = true;
    productList.clear();
    setState(() {});
    const String getProductListUrl =
        'https://crud.teamrabbil.com/api/v1/ReadProduct';
    Uri uri = Uri.parse(getProductListUrl);

    Response response = await get(uri);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      //data decode
      final decodeData = jsonDecode(response.body);

      // get the list
      final jsonProductList = decodeData['data'];
      // loop over the list
      for (Map<String, dynamic> p in jsonProductList) {
        Product product = Product(
            productName: p['ProductName'] ?? 'Unknown',
            productCode: p['ProductCode'] ?? '',
            totalPrice: p['TotalPrice'] ?? '',
            image: p['Img'] ?? '',
            quantity: p['Qty'] ?? '',
            unitePrice: p['UnitPrice'] ?? '',
            id: p['_id'] ?? '');
        productList.add(product);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Get Product List Failed')));
    }
    _getProductInProgress = false;
    setState(() {});
  }

  void _showDeleteMessage(String productId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: const Text(
            textAlign: TextAlign.center,
            'Do you want to delete this product?',
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _deleteProductList(productId);
                Navigator.pop(context);
              },
              child: const Text('Yes! Delete'),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'))
          ],
        );
      },
    );
  }
  Future<void> _deleteProductList(String productId) async {
    _getProductInProgress = true;

    setState(() {});
     String deleteProductListUrl =
        'https://crud.teamrabbil.com/api/v1/DeleteProduct/${productId}';
    Uri uri = Uri.parse(deleteProductListUrl);

    Response response = await get(uri);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      //data decode
      _getProductList();
      }
     else {
     _getProductInProgress = false;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Delete Product Failed')));
    }

  }
}

