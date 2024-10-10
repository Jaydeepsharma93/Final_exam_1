import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/databasesev.dart';
import '../model/modelclass.dart';

class CartPage extends StatelessWidget {
  final DatabaseService dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: FutureBuilder<List<Product>>(
        future: dbService.getCartProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final products = snapshot.data ?? [];
          if (products.isEmpty) {
            return Center(child: Text('Your cart is empty.'));
          }
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                trailing: IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () async {
                    await dbService.deleteProductFromCart(product.id);
                    Get.snackbar('Removed', '${product.name} removed from cart');
                    Get.forceAppUpdate(); // Refresh the UI
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
