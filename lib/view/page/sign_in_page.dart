import 'package:chat_app/router/routes.dart';
import 'package:chat_app/view_model/sign_in_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _nameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Let's",
                  style: TextStyle(fontSize: 40),
                ),
                const SizedBox(width: 10),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade600,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Chat",
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: ClipOval(
                        child: Container(
                          width: 14,
                          height: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 1,
                      left: 1,
                      child: ClipOval(
                        child: Container(
                          width: 12,
                          height: 12,
                          color: Colors.red.shade400,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Sign in form
            Form(
              key: _formKey,
              child: Consumer<SignInPageViewModel>(
                builder: (context, value, child) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _emailTextController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        icon: const Icon(Icons.mail),
                        labelText: "Email",
                      ),
                      validator: value.emailValidation,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passwordTextController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        icon: const Icon(Icons.lock),
                        labelText: "Password",
                      ),
                      obscureText: true,
                      validator: value.passwordValidation,
                    ),
                    if (value.type == SignInPageContentType.registration)
                      const SizedBox(height: 12),
                    if (value.type == SignInPageContentType.registration)
                      TextFormField(
                        controller: _nameTextController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          icon: const Icon(Icons.person),
                          labelText: "Display Name",
                          helperText: "You can change this later",
                        ),
                        validator: value.nameValidation,
                      ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            foregroundColor: Colors.grey,
                          ),
                          onPressed: value.changeType,
                          child: Text(
                            value.type == SignInPageContentType.signIn
                                ? "Create an account"
                                : "Forwards sign in",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                        const SizedBox(width: 12),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.grey.shade800,
                          ),
                          onPressed: _signInOrCreateAccount,
                          child: Text(
                            value.type == SignInPageContentType.signIn
                                ? "Sign In"
                                : "Create Account",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signInOrCreateAccount() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final value = context.read<SignInPageViewModel>();
    String? errorMessage;
    if (value.type == SignInPageContentType.signIn) {
      errorMessage = await value.signIn(
        _emailTextController.text,
        _passwordTextController.text,
      );
    } else {
      errorMessage = await value.createAccount(
        _emailTextController.text,
        _passwordTextController.text,
        _nameTextController.text,
      );
    }
    if (!mounted) return;
    if (errorMessage == null) {
      context.pushReplacement(Routes.chat.path);
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }
}
