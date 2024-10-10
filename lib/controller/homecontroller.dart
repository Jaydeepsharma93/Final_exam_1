import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../model/modelclass.dart';
import 'databasesev.dart';

class HomeController extends GetxController {
  var cartProducts = <Product>[].obs;
  final DatabaseService _databaseService = DatabaseService();

  @override
  void onInit() {
    fetchCartProducts(); // Load cart products on initialization
    super.onInit();
  }

  Stream<List<Product>> fetchProducts() {
    return FirebaseFirestore.instance
        .collection('products')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList());
  }

  Future<List<Product>> fetchCartProducts() async {
    cartProducts.value = await _databaseService.getCartProducts();
    return cartProducts;
  }

  Future<void> addProduct(String name, double price) async {
    var newProduct = Product(id: DateTime.now().toString(), name: name, price: price);
    await FirebaseFirestore.instance.collection('products').doc(newProduct.id).set(newProduct.toJson());
  }

  Future<void> deleteProduct(String id) async {
    await FirebaseFirestore.instance.collection('products').doc(id).delete();
  }

  Future<void> editProduct(String id, String name, double price) async {
    var updatedProduct = Product(id: id, name: name, price: price);
    await FirebaseFirestore.instance.collection('products').doc(id).update(updatedProduct.toJson());
  }

  Future<void> addToCart(Product product) async {
    await _databaseService.insertProduct(product);
  }

  Future<void> deleteFromCart(String id) async {
    await _databaseService.deleteProductFromCart(id);
  }
}
