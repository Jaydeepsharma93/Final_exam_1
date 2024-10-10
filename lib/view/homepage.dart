import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/homecontroller.dart';
import '../model/modelclass.dart';

class HomePage extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Products',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black54),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
            icon: Icon(Icons.shopping_cart),
          ),
        ],
        backgroundColor: Colors.deepPurpleAccent.shade100,
      ),
      body: StreamBuilder<List<Product>>(
        stream: controller.fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Loading indicator
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Error message
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products found.')); // No data message
          }

          final products = snapshot.data!;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.add_shopping_cart),
                      onPressed: () => controller.addToCart(product),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => showEditProductDialog(context, product),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => controller.deleteProduct(product.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddProductDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void showAddProductDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(hintText: 'Product Name'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(hintText: 'Product Price'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && priceController.text.isNotEmpty) {
                  double price = double.parse(priceController.text);
                  controller.addProduct(nameController.text, price);
                  Get.back();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void showEditProductDialog(BuildContext context, Product product) {
    TextEditingController nameController = TextEditingController(text: product.name);
    TextEditingController priceController = TextEditingController(text: product.price.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(hintText: 'Product Name'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(hintText: 'Product Price'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && priceController.text.isNotEmpty) {
                  double price = double.parse(priceController.text);
                  controller.editProduct(product.id, nameController.text, price);
                  Get.back();
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
