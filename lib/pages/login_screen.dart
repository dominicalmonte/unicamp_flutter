import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart' as localAuthProvider; // Alias for your custom provider
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  void closeKeyboard() {
    FocusScope.of(context).unfocus();
  }

  Future<void> _login(BuildContext context) async {
  closeKeyboard();

  if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
    setState(() {
      _errorMessage = 'Invalid Email/Password';
    });
    return;
  }

  setState(() {
    _isLoading = true;
    _errorMessage = ''; 
  });

  final authProvider = Provider.of<localAuthProvider.AuthProvider>(context, listen: false); 
  final error = await authProvider.login(
    _emailController.text.trim(),
    _passwordController.text.trim(),
  );

  setState(() {
    _isLoading = false;
    // Only set error message if there's an actual error
    _errorMessage = error ?? ''; 
  });

  if (error == null) {
    Navigator.pushReplacementNamed(context, '/home');
  }
}

Future<void> _loginWithGoogle(BuildContext context) async {
  setState(() {
    _isLoading = true;
    _errorMessage = ''; // Reset error message
  });

  final authProvider = Provider.of<localAuthProvider.AuthProvider>(context, listen: false);
  final error = await authProvider.loginWithGoogle();

  setState(() {
    _isLoading = false;
    // Only set error message if there's an actual error
    _errorMessage = error ?? ''; 
  });

  if (error == null) {
    Navigator.pushReplacementNamed(context, '/home');
  }
}

Future<void> _loginAsGuest(BuildContext context) async {
  setState(() {
    _isLoading = true;
    _errorMessage = ''; // Reset error message
  });

  final authProvider = Provider.of<localAuthProvider.AuthProvider>(context, listen: false);
  final error = await authProvider.loginAsGuest();

  setState(() {
    _isLoading = false;
    // Only set error message if there's an actual error
    _errorMessage = error ?? ''; 
  });

  if (error == null) {
    Navigator.pushReplacementNamed(context, '/home');
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
  }
}
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/Main Page.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 50.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // App Logo
                    Image.asset(
                      "assets/UniCampAlt.png",
                      height: MediaQuery.of(context).size.height * 0.1, // Dynamic sizing
                    ),
                    const SizedBox(height: 20),
                    // Login Container
                    Container(
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 16.0),
                            child: Text(
                              "Sign in",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3D00A5),
                              ),
                            ),
                          ),
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: "Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                            ),
                          ),
                          const SizedBox(height: 20),
                          FractionallySizedBox(
                            widthFactor: 0.6,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : () => _login(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3D00A5),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text("Login", style: TextStyle(color: Color(0xFFEEEEEE))),
                            ),
                          ),
                          const SizedBox(height: 16),
                          FractionallySizedBox(
                            widthFactor: 0.6,
                            child: OutlinedButton.icon(
                              onPressed: _isLoading ? null : () => _loginWithGoogle(context),
                              icon: const FaIcon(
                                FontAwesomeIcons.google,
                                color: Colors.red,
                              ),
                              label: const Text("Sign in with Google"),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          FractionallySizedBox(
                            widthFactor: 0.6,
                            child: OutlinedButton(
                              onPressed: _isLoading ? null : () => _loginAsGuest(context),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                side: BorderSide(color: Colors.grey.shade400),
                              ),
                              child: const Text(
                                "Login as Guest",
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),
                          ),
                          if (_errorMessage.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Text(
                                _errorMessage,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
