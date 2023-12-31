import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'signup.dart';
import 'background.dart';

class OwnerLoginScreen extends StatefulWidget {
  const OwnerLoginScreen({Key? key}) : super(key: key);

  @override
  State<OwnerLoginScreen> createState() => _OwnerLoginScreenState();
}

class _OwnerLoginScreenState extends State<OwnerLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _showError = false;

  Future<void> _login() async {
    try {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        setState(() {
          _showError = false;
        });
        return;
      }

      // Check if the email exists in theOwner collection in Firestore.
      QuerySnapshot owners = await FirebaseFirestore.instance
        .collection("Owners")
        .where("email", isEqualTo: email)
        .get();

    if (owners.docs.isEmpty) {
      setState(() {
        _showError = true;
      });
      return;
    }


      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        Navigator.pushReplacementNamed(context, '/ownerdashboard');
      } 
      else {
        setState(() {
          _showError = true;
        });
      }
    } catch (e) {
      print('Login failed: $e');

      setState(() {
        _showError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {

                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 8,
                        blurRadius: 20,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset('assets/logo_name_white.png'), 
                  ),
                ),
              ),
              const SizedBox(height: 50),
              const Text(
                "Parking Owner App",
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 126, 253),
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Login to your parking spot owner account",
                style: TextStyle(
                  color: Color.fromARGB(255, 100, 100, 100),
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 40),
              _buildTextField(
                controller: _emailController,
                hintText: "Email",
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _passwordController,
                hintText: "Password",
                obscureText: true,
                prefixIcon: Icons.lock,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showError = false;
                  });
                  _login();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  backgroundColor: Color.fromARGB(255, 116, 82, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: const Size(200, 50),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (_showError)
                const SizedBox(height: 10),
                const Text(
                  'Invalid email or password.',
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                ),
              const SizedBox(height: 30),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/ownerforgotpassword');
                },
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      color: Color.fromARGB(255, 100, 100, 100),
                      fontSize: 16.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const OwnerSignUpScreen()),
                      );
                    },
                    child: const Text(
                      "Create Owner Account",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(prefixIcon, color: Colors.blue),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
