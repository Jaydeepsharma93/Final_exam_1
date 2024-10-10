import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../model/modelclass.dart';
import 'databasesev.dart';

class HomeController extends GetxController {
  var products = <Product>[].obs;
  var cartProducts = <Product>[].obs; // To store cart products

  final DatabaseService _databaseService = DatabaseService();

  @override
  void onInit() {
    fetchProducts();
    fetchCartProducts(); // Load cart products on initialization
    super.onInit();
  }

  void fetchProducts() async {
    var querySnapshot = await FirebaseFirestore.instance.collection('products').get();
    products.value = querySnapshot.docs.map((doc) => Product.fromJson(doc.data())).toList();
  }

  void fetchCartProducts() async {
    cartProducts.value = await _databaseService.getCartProducts();
  }

  void addProduct(String name, double price) async {
    var newProduct = Product(id: DateTime.now().toString(), name: name, price: price);
    await FirebaseFirestore.instance.collection('products').doc(newProduct.id).set(newProduct.toJson());
    fetchProducts();
  }

  void deleteProduct(String id) async {
    await FirebaseFirestore.instance.collection('products').doc(id).delete();
    fetchProducts();
  }

  void editProduct(String id, String name, double price) async {
    var updatedProduct = Product(id: id, name: name, price: price);
    await FirebaseFirestore.instance.collection('products').doc(id).update(updatedProduct.toJson());
    fetchProducts();
  }

  void addToCart(Product product) async {
    await _databaseService.insertProduct(product);
    fetchCartProducts(); // Refresh cart products
  }

  void deleteFromCart(String id) async {
    await _databaseService.deleteProductFromCart(id);
    fetchCartProducts(); // Refresh cart products
  }
}
