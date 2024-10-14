import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_mongo_lab1/Page/login_screen.dart';
import 'package:flutter_mongo_lab1/Widget/customCliper.dart';
import 'package:flutter_mongo_lab1/controllers/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        await AuthController().register(
          context,
          usernameController.text,
          passwordController.text,
          nameController.text,
          roleController.text,
          emailController.text,
        );
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            // ตกแต่ง Background ใหม่ด้วยไล่สีสดใส
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: Transform.rotate(
                angle: -pi / 3.5,
                child: ClipPath(
                  clipper: ClipPainter(),
                  child: Container(
                    height: MediaQuery.of(context).size.height * .6,
                    width: MediaQuery.of(context).size.width * .8,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color(0xffF5A623),
                          Color(0xffF76B1C),
                          Color(0xffD7263D),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .2),
                      // ตกแต่ง Title ใหม่ให้ดูทันสมัยและสะดุดตา
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Register  ',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                          children: [
                            TextSpan(
                              text: '',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffD7263D),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50),
                      // ตกแต่งช่องกรอกข้อมูลใหม่
                      Column(
                        children: <Widget>[
                          _buildTextField(
                              "Username", usernameController, false),
                          _buildTextField("Password", passwordController, true),
                          _buildTextField("Name", nameController, false),
                          _buildTextField("Role", roleController, false),
                          _buildTextField(
                              "Email Address", emailController, false,
                              email: true),
                        ],
                      ),
                      SizedBox(height: 20),
                      // ตกแต่งปุ่ม Register ใหม่
                      GestureDetector(
                        onTap: _register,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.grey.shade400,
                                offset: Offset(2, 4),
                                blurRadius: 5,
                                spreadRadius: 2,
                              )
                            ],
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xffF76B1C),
                                Color(0xffD7263D),
                              ],
                            ),
                          ),
                          child: Text(
                            'Register',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(height: height * .02),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          padding: EdgeInsets.all(15),
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Already have an account?',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Login',
                                style: TextStyle(
                                  color: Color(0xffD7263D),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 40,
              left: 0,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
                        child: Icon(Icons.keyboard_arrow_left,
                            color: Colors.black),
                      ),
                      Text('Back',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, bool obscure,
      {bool email = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xff14279B),
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: controller,
            obscureText: obscure,
            keyboardType:
                email ? TextInputType.emailAddress : TextInputType.text,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
              fillColor: Colors.grey.shade100,
              filled: true,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your $label';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
