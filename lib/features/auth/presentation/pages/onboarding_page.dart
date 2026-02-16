import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth/auth_bloc.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final displayNameController = TextEditingController();

  bool isLogin = true;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    displayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        /// show errors
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(isLogin ? "Login" : "Register"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              /// USERNAME
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              /// DISPLAY NAME (REGISTER ONLY)
              if (!isLogin)
                Column(
                  children: [
                    TextField(
                      controller: displayNameController,
                      decoration: const InputDecoration(
                        labelText: "Display Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),

              /// PASSWORD
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              /// LOGIN / REGISTER BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final username = usernameController.text.trim();
                    final password = passwordController.text.trim();
                    final displayName = displayNameController.text.trim();

                    if (username.isEmpty || password.isEmpty) return;

                    if (isLogin) {
                      context.read<AuthBloc>().add(
                            LoginEvent(username, password),
                          );
                    } else {
                      if (displayName.isEmpty) return;

                      context.read<AuthBloc>().add(
                            RegisterEvent(username, password, displayName),
                          );
                    }
                  },
                  child: Text(isLogin ? "Login" : "Register"),
                ),
              ),

              const SizedBox(height: 12),

              /// SWITCH MODE
              TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
                child: Text(
                  isLogin
                      ? "Don't have an account? Register"
                      : "Already have an account? Login",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
