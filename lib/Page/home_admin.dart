import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mongo_lab1/Page/EditProductPage.dart';
import 'dart:math';
import 'package:flutter_mongo_lab1/Widget/customCliper.dart';
import 'package:flutter_mongo_lab1/controllers/auth_controller.dart';
import 'package:flutter_mongo_lab1/models/user_model.dart';
import 'package:flutter_mongo_lab1/providers/user_provider.dart';
import 'package:flutter_mongo_lab1/models/product_model.dart';
import 'package:flutter_mongo_lab1/controllers/product_controller.dart';
import 'package:provider/provider.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  List<ProductModel> products = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการออกจากระบบ'),
          content: const Text('คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('ออกจากระบบ'),
              onPressed: () {
                Provider.of<UserProvider>(context, listen: false).onLogout();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _fetchProducts() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final productList = await ProductController().getProducts(context);
      setState(() {
        products = productList;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Error fetching products: $error';
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching products: $error')));
    }
  }

  void updateProduct(ProductModel product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditProductPage(product: product),
      ),
    );
  }

  Future<void> deleteProduct(ProductModel product) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการลบสินค้า'),
          content: const Text('คุณแน่ใจหรือไม่ว่าต้องการลบสินค้านี้?'),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('ลบ'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      try {
        await ProductController().deleteProduct(context, product.id);
        await _fetchProducts();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('ลบสินค้าสำเร็จ')));
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting product: $error')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: [
            // Background
            Positioned(
              top: -height * .15,
              right: -width * .4,
              child: Transform.rotate(
                angle: -pi / 3.5,
                child: ClipPath(
                  clipper: ClipPainter(),
                  child: Container(
                    height: height * .5,
                    width: width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xffE9EFEC),
                          Color.fromARGB(255, 216, 151, 21),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: height * .1),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Manage ',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                          color: Color(0xffC7253E),
                        ),
                        children: [
                          TextSpan(
                            text: 'products',
                            style: TextStyle(
                                color: Color(0xffE85C0D), fontSize: 35),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // Token Display
                    Consumer<UserProvider>(
                      builder: (context, userProvider, _) {
                        return Column(
                          children: [
                            _buildTokenDisplay('Access Token:',
                                userProvider.accessToken, Color(0xff821131)),
                            SizedBox(height: 15),
                            _buildTokenDisplay('Refresh Token:',
                                userProvider.refreshToken, Color(0xffFABC3F)),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                AuthController().refreshToken(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff821131),
                              ),
                              child: Text('Update Token',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        );
                      },
                    ),

                    SizedBox(height: 20),
                    // Add New Product Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/add_product');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff821131),
                      ),
                      child: Text('Add', style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(height: 20),

                    // Products List
                    if (isLoading)
                      CircularProgressIndicator()
                    else if (errorMessage != null)
                      Text(errorMessage!)
                    else
                      _buildProductList(),
                  ],
                ),
              ),
            ),
            // LogOut Button
            Positioned(
              top: 50.0,
              right: 16.0,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _showLogoutConfirmationDialog(context);
                },
                child: Icon(
                  Icons.logout,
                  color: Color(0xff821131),
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTokenDisplay(String label, String? token, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold)),
        Text(token ?? 'ไม่พบข้อมูล',
            style: TextStyle(fontSize: 16, color: color)),
      ],
    );
  }

  Widget _buildProductList() {
    return Column(
      children: List.generate(products.length, (index) {
        final product = products[index];
        return Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  color: Color.fromARGB(255, 225, 215, 183), width: 1.0),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productName,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffC7253E)),
                    ),
                    Text('ประเภท: ${product.productType}',
                        style: TextStyle(fontSize: 14)),
                    Text('ราคา: \$${product.price}',
                        style: TextStyle(fontSize: 14)),
                    Text('หน่วย: ${product.unit}',
                        style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              // Edit and Delete buttons
              IconButton(
                icon: Icon(Icons.edit, color: Color(0xffFABC3F)),
                onPressed: () {
                  updateProduct(product);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Color(0xff821131)),
                onPressed: () {
                  deleteProduct(product);
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
