import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rotten_tomatoes/view_models/auth_view_model.dart';
import 'package:rotten_tomatoes/ui/pages/home_page.dart';
import 'package:rotten_tomatoes/ui/widgets/common/app_text_field.dart';
import 'package:rotten_tomatoes/ui/widgets/common/app_button.dart';
import 'package:rotten_tomatoes/utils/validators.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: BlocListener<AuthViewModel, AuthState>(
        listener: (context, state) {
          if (state is AuthError) _showError(context, state.message);
          if (state is Authenticated) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const HomePage()),
              (route) => false,
            );
          }
        },
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.red[900]!, Colors.red[600]!],
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.person_add,
                                color: Colors.white, size: 48),
                            const SizedBox(height: 12),
                            const Text(
                              'Créer un compte',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Rejoins Rotten Tomatoes gratuitement !',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextField(
                            controller: _nameController,
                            label: 'Nom complet',
                            prefixIcon: Icons.person_outline,
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            controller: _emailController,
                            label: 'Email',
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            controller: _passwordController,
                            label: 'Mot de passe',
                            prefixIcon: Icons.lock_outlined,
                            isPassword: true,
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            controller: _passwordConfirmController,
                            label: 'Confirmer le mot de passe',
                            prefixIcon: Icons.lock_outlined,
                            isPassword: true,
                          ),
                          const SizedBox(height: 28),
                          BlocBuilder<AuthViewModel, AuthState>(
                            builder: (context, state) {
                              return AppButton(
                                label: "S'inscrire",
                                isLoading: state is AuthLoading,
                                onPressed: () {
                                  final name = _nameController.text.trim();
                                  final email = _emailController.text.trim();
                                  final password =
                                      _passwordController.text.trim();
                                  final confirm =
                                      _passwordConfirmController.text.trim();

                                  final nameError =
                                      Validators.validateName(name);
                                  if (nameError != null) {
                                    _showError(context, nameError);
                                    return;
                                  }

                                  final emailError =
                                      Validators.validateEmail(email);
                                  if (emailError != null) {
                                    _showError(context, emailError);
                                    return;
                                  }

                                  final passwordError =
                                      Validators.validatePassword(password);
                                  if (passwordError != null) {
                                    _showError(context, passwordError);
                                    return;
                                  }

                                  if (password != confirm) {
                                    _showError(
                                        context, 'Mots de passe différents !');
                                    return;
                                  }

                                  context.read<AuthViewModel>().add(
                                        RegisterRequested(
                                            name, email, password),
                                      );
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: RichText(
                                text: TextSpan(
                                  text: "Déjà un compte ? ",
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.5),
                                    fontSize: 13,
                                  ),
                                  children: const [
                                    TextSpan(
                                      text: "Se connecter",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
