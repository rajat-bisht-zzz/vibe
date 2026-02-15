import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibe/core/ui/font/app_font_style.dart';
import 'package:vibe/core/ui/sizes/app_sizes.dart';
import '../bloc/auth/auth_bloc.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.l),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome to Vibe",
                style: AppTextStyles.title,
              ),
              const SizedBox(height: AppSizes.m),
              Text(
                "Enter your name to continue",
                style: AppTextStyles.bodySecondary,
              ),
              const SizedBox(height: AppSizes.l),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: "Your name",
                ),
              ),
              const SizedBox(height: AppSizes.l),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final name = _controller.text.trim();
                    if (name.isEmpty) return;

                    context.read<AuthBloc>().add(RegisterUserEvent(name));
                  },
                  child: const Text("Continue"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
