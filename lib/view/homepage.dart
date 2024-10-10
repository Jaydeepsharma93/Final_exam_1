import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../controller/homecontroller.dart';
import '../model/modelclass.dart';

class HomePage extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent.shade100,
      ),
      body: Obx(() {
        return ListView.builder(
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final product = controller.products[index];
            return ListTile(
              title: Text(product.name),
              subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.add_shopping_cart),
                    onPressed: () =>
                        controller.addToCart(product), // Add to cart
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
      }),
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
                if (nameController.text.isNotEmpty &&
                    priceController.text.isNotEmpty) {
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
    TextEditingController nameController =
        TextEditingController(text: product.name);
    TextEditingController priceController =
        TextEditingController(text: product.price.toString());

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
                if (nameController.text.isNotEmpty &&
                    priceController.text.isNotEmpty) {
                  double price = double.parse(priceController.text);
                  controller.editProduct(
                      product.id, nameController.text, price);
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
