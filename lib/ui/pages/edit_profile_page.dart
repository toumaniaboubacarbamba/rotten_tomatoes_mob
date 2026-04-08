import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rotten_tomatoes/entities/account.dart';
import 'package:rotten_tomatoes/view_models/auth_view_model.dart';
import 'package:rotten_tomatoes/ui/pages/login_page.dart';
import 'package:rotten_tomatoes/ui/widgets/common/app_text_field.dart';
import 'package:rotten_tomatoes/ui/widgets/common/app_button.dart';
import 'package:rotten_tomatoes/utils/validators.dart';

class EditProfilePage extends StatefulWidget {
  final Account user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _nameController;
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Modifier le profil')),
      body: BlocConsumer<AuthViewModel, AuthState>(
        listener: (context, state) {
          if (state is AuthError) _showError(context, state.message);
          
          if (state is Authenticated) {
            _showSuccess(context, 'Profil mis à jour avec succès !');
            Navigator.pop(context);
          }
          
          if (state is AuthSuccess) {
            _showSuccess(context, 'Mot de passe modifié ! Reconnecte-toi.');
            Future.delayed(const Duration(seconds: 5), () {
              if (!mounted) return;
              context.read<AuthViewModel>().add(LogoutRequested());
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            });
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informations personnelles',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _nameController,
                  label: 'Nom complet',
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Email (non modifiable)',
                  hintText: widget.user.email,
                  prefixIcon: Icons.email_outlined,
                  enabled: false,
                ),
                const SizedBox(height: 40),
                Divider(color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
                const SizedBox(height: 24),
                Text(
                  'Modifier le mot de passe',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Laisse vide si tu ne veux pas changer',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _currentPasswordController,
                  label: 'Mot de passe actuel',
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _newPasswordController,
                  label: 'Nouveau mot de passe',
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirmer le nouveau mot de passe',
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                ),
                const SizedBox(height: 48),
                AppButton(
                  label: 'Enregistrer les modifications',
                  isLoading: state is AuthLoading,
                  onPressed: () {
                    final name = _nameController.text.trim();
                    final currentPass = _currentPasswordController.text.trim();
                    final newPass = _newPasswordController.text.trim();
                    final confirmPass = _confirmPasswordController.text.trim();

                    // Validation du nom
                    final nameError = Validators.validateName(name);
                    if (nameError != null) {
                      _showError(context, nameError);
                      return;
                    }

                    // Si on essaie de changer le mot de passe
                    if (newPass.isNotEmpty || currentPass.isNotEmpty) {
                      if (currentPass.isEmpty) {
                        _showError(context, 'Le mot de passe actuel est obligatoire !');
                        return;
                      }
                      
                      final passError = Validators.validatePassword(newPass);
                      if (passError != null) {
                        _showError(context, 'Nouveau mot de passe : $passError');
                        return;
                      }

                      if (newPass != confirmPass) {
                        _showError(context, 'Les mots de passe ne correspondent pas !');
                        return;
                      }

                      context.read<AuthViewModel>().add(
                        UpdatePasswordRequested(currentPass, newPass),
                      );
                      return;
                    }

                    // Sinon, mise à jour du profil uniquement
                    context.read<AuthViewModel>().add(
                      UpdateProfileRequested(name),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
