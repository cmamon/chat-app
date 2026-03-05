import 'package:flutter/material.dart';
import 'package:kora_chat/theme/kora_design_system.dart';

class AuthViewLayout extends StatelessWidget {
  final List<Widget> children;

  const AuthViewLayout({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    // Detect if we are on desktop or wide screen
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: KoraColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: KoraSpacing.xl),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isDesktop ? 450 : double.infinity,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: KoraSpacing.xxl),
                    ...children,
                    const SizedBox(height: KoraSpacing.xxl),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
