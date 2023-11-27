import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';

class OwnerSignUpScreen extends StatefulWidget {
  const OwnerSignUpScreen({Key? key}) : super(key: key);

  @override
  _OwnerSignUpScreenState createState() => _OwnerSignUpScreenState();
}

class _OwnerSignUpScreenState extends State<OwnerSignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _showError = false;
  String _errorMessage = '';

  void _showRegistrationSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Registration Successful'),
          content: const Text('Your account has been created successfully. Please log in.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OwnerLoginScreen()));
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _signUpWithEmailAndPassword() async {
    try {
      String name = _nameController.text.trim();
      String phone = _phoneController.text.trim();
      String idNumber = _idNumberController.text.trim();
      String username = _usernameController.text.trim();
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

   
      if (phone.isEmpty || !RegExp(r'^\d{9,10}$').hasMatch(phone)) {
        setState(() {
          _showError = true;
          _errorMessage = 'Phone number must contain 9 or 10 digits.';
        });
        return;
      }

    
      if (idNumber.isEmpty || !RegExp(r'^[a-zA-Z0-9]{10,12}$').hasMatch(idNumber)) {
        setState(() {
          _showError = true;
          _errorMessage = 'NIC number must contain 10 or 12 digits.';
        });
        return;
      }

      if (name.isEmpty ||
          username.isEmpty ||
          email.isEmpty ||
          password.isEmpty) {
        setState(() {
          _showError = true;
          _errorMessage = 'Please fill in all required fields.';
        });
        return;
      }

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
    
        _showRegistrationSuccessDialog();
      } else {
        setState(() {
          _showError = true;
          _errorMessage = 'An error occurred during signup. Please try again later.';
        });
      }
    } catch (e) {
      setState(() {
        _showError = true;
        _errorMessage = 'Signup failed: A network error has occurred. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Account')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10.0),
              
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 8,
                      blurRadius: 15,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                
                child: ClipRRect(
                  
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('assets/logo_name_white.png'),
                ),
              ),
              const SizedBox(height: 40.0),
              _buildTextField(
                controller: _nameController,
                hintText: "Name",
                icon: Icons.person,
              ),
              const SizedBox(height: 16.0),
              _buildTextField(
                controller: _phoneController,
                hintText: "Phone",
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16.0),
              _buildTextField(
                controller: _idNumberController,
                hintText: "NIC Number",
                icon: Icons.badge,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              _buildTextField(
                controller: _usernameController,
                hintText: "Username",
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16.0),
              _buildTextField(
                controller: _emailController,
                hintText: "Email",
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16.0),
              _buildTextField(
                controller: _passwordController,
                hintText: "Password",
                icon: Icons.lock,
                obscureText: true,
              ),
              if (_showError)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 28.0),
              ElevatedButton(
                onPressed: _signUpWithEmailAndPassword,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0), backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  minimumSize: const Size(200, 50), 
                ),
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ),
              const SizedBox(height: 5.0),
              TextButton(
                onPressed: () {
                 
                 Navigator.pushReplacementNamed(context, '/login'); 
                },
                child: const Text(
                  "Already have an account? Log in",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue,
                  ),
                ),
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
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.blue),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
