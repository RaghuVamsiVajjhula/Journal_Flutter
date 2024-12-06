import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/providers/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();

  Future<void> _saveAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _usernameController.text);
    if (!mounted) return;
    Navigator.pushNamed(context, '/WelcomeScreen');
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = Provider.of<ThemeProvider>(context).themeMode;
    final backgroundColor =
        themeMode == ThemeMode.dark ? Colors.black : Colors.white;
    final textColors =
        themeMode == ThemeMode.dark ? Colors.white : Colors.black;
    final containerColor =
        themeMode == ThemeMode.dark ? Colors.grey[900] : Colors.grey[200];

    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 1),
                child: Image.asset(
                  'assets/TRAVEL.png',
                  width: 190,
                  height: 120,
                  errorBuilder: (context, error, stackTrace) {
                    print('Error loading image: $error');
                    return const SizedBox(
                      width: 190,
                      height: 120,
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 20.0),
                margin: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 50.0),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 5,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    color: containerColor,
                    borderRadius: BorderRadius.circular(45.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "Welcome!",
                        style: TextStyle(
                          fontSize: 30,
                          color: textColors,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: TextField(
                        style: TextStyle(color: textColors),
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter your username',
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _saveAndNavigate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[900],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        textStyle: const TextStyle(fontSize: 19),
                      ),
                      child: const Text(
                        "Continue",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
