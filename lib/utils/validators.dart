class Validators {
  static String? validateEmail(String email) {
    if (email.isEmpty) return 'Email obligatoire !';
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(email)) return 'Email invalide !';
    return null;
  }

  static String? validatePassword(String password, {int minLength = 6}) {
    if (password.isEmpty) return 'Mot de passe obligatoire !';
    if (password.length < minLength) {
      return 'Minimum $minLength caractères !';
    }
    return null;
  }

  static String? validateName(String name) {
    if (name.isEmpty) return 'Nom obligatoire !';
    final nameRegex = RegExp(
      r'^[a-zA-ZàâäéèêëîïôöùûüÿçÀÂÄÉÈÊËÎÏÔÖÙÛÜŸÇ\s]+$',
    );
    if (!nameRegex.hasMatch(name)) return 'Lettres uniquement !';
    return null;
  }
}
