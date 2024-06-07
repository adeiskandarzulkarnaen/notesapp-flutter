import 'package:flutter/material.dart';
import 'package:notesappflutter/pages/notes/notes_page.dart';
import 'package:notesappflutter/pages/auth/register_page.dart';
import 'package:notesappflutter/services/auth_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthServices _authServices = AuthServices();

  bool isObscure = true;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),

                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    hintText: "input username",
                    labelText: "username",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_2_outlined),
                  ),
                ),
                const SizedBox(height: 14),

                TextFormField(
                  controller: _passwordController,
                  obscureText: isObscure,
                  decoration: InputDecoration(
                    hintText: "input password",
                    labelText: "password",
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: isObscure
                          ? const Icon(Icons.visibility_outlined)
                          : const Icon(Icons.visibility_off_outlined),
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onLoginButtonTapped,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0), 
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8.0)
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("belum punya akun?"),
                    TextButton(
                      child: const Text("register"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterPage()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onLoginButtonTapped() async {
    final result = await _authServices.login(
      username: _usernameController.text,
      password: _passwordController.text,
    );

    if (!mounted) return; // Check if the widget is still mounted
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted && Navigator.of(dialogContext).canPop()) {
            Navigator.of(dialogContext).pop();
          }
        });
        return AlertDialog(
          title: Text(result.status),
          content: Text(result.message),
        );
      },
    );

    if (result.status == "success" && mounted) {
      /* pindah ke halaman notes page jika  success */
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NotesPage()),
      );
    }
  }
}