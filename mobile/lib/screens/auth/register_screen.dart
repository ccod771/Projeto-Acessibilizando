import 'package:flutter/material.dart';

import '../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authService = AuthService();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _mobility = false;
  bool _speaks = true;
  bool _sensorySensitivity = false;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool _isLoading = false;

  static const primaryColor = Color(0xFF8A00C4);
  static const backgroundColor = Color(0xFF12121A);
  static const surfaceColor = Color(0xFF1A1921);
  static const inputColor = Color(0xFF24222C);
  static const textColor = Color(0xFFE7E3EA);
  static const secondaryTextColor = Color(0xFFB7B1BC);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  Future<void> _register() async {
    if (_isLoading) {
      return;
    }

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final ageText = _ageController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        ageText.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showMessage(
        'Preencha todos os campos obrigatórios.',
      );
      return;
    }

    final age = int.tryParse(ageText);

    if (age == null || age <= 0) {
      _showMessage(
        'Digite uma idade válida.',
      );
      return;
    }

    if (password != confirmPassword) {
      _showMessage(
        'As senhas não são iguais.',
      );
      return;
    }

    if (password.length < 8) {
      _showMessage(
        'A senha deve possuir pelo menos 8 caracteres.',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _authService.register(
        email: email,
        name: name,
        age: age,
        mobility: _mobility,
        speaks: _speaks,
        sensorySensitivity: _sensorySensitivity,
        password: password,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      if (result['success'] == true) {
        _showMessage(
          'Conta criada com sucesso!',
        );

        Navigator.pop(context);

        return;
      }

      final data = result['data'];

      String message = 'Erro ao criar conta.';

      if (data is Map) {
        if (data['email'] is List) {
          message = data['email'][0].toString();
        } else if (data['password'] is List) {
          message = data['password'][0].toString();
        } else if (data['detail'] != null) {
          message = data['detail'].toString();
        } else if (data['error'] != null) {
          message = data['error'].toString();
        }
      }

      _showMessage(message);
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      _showMessage(
        'Erro ao criar conta: $e',
      );
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(
              alpha: 0.08,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withValues(
                alpha: 0.10,
              ),
            ),
          ),
          child: const Text(
            'Criar conta',
            style: TextStyle(
              color: textColor,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            _buildBackgroundDecoration(),
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                20,
                18,
                20,
                32,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 500,
                  ),
                  child: Column(
                    children: [
                      _buildBrand(),
                      const SizedBox(height: 28),
                      _buildRegisterCard(),
                      const SizedBox(height: 24),
                      const Text(
                        'Suas informações ajudam a tornar o Acessibilizando mais inclusivo.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 12,
                          height: 1.4,
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
    );
  }

  Widget _buildBackgroundDecoration() {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -120,
            right: -100,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withValues(
                  alpha: 0.07,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            left: -120,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withValues(
                  alpha: 0.045,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrand() {
    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.white.withValues(
              alpha: 0.055,
            ),
            borderRadius: BorderRadius.circular(27),
            border: Border.all(
              color: Colors.white.withValues(
                alpha: 0.09,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(
                  alpha: 0.16,
                ),
                blurRadius: 30,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.09,
              ),
              borderRadius: BorderRadius.circular(21),
            ),
            child: Image.asset(
              'assets/logo.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Junte-se ao Acessibilizando',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontSize: 25,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 7),
        const Text(
          'Crie sua conta e ajude a tornar lugares mais acessíveis.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: secondaryTextColor,
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        22,
        25,
        22,
        22,
      ),
      decoration: BoxDecoration(
        color: surfaceColor.withValues(
          alpha: 0.96,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.055,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.24,
            ),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
            icon: Icons.person_outline_rounded,
            title: 'Seus dados',
            subtitle: 'Preencha suas informações básicas.',
          ),
          const SizedBox(height: 24),
          _buildFieldLabel('Nome'),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            enabled: !_isLoading,
            textInputAction: TextInputAction.next,
            style: const TextStyle(
              color: textColor,
              fontSize: 14,
            ),
            decoration: _inputDecoration(
              hintText: 'Digite seu nome',
              icon: Icons.person_outline_rounded,
            ),
          ),
          const SizedBox(height: 18),
          _buildFieldLabel('E-mail'),
          const SizedBox(height: 8),
          TextField(
            controller: _emailController,
            enabled: !_isLoading,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            style: const TextStyle(
              color: textColor,
              fontSize: 14,
            ),
            decoration: _inputDecoration(
              hintText: 'Digite seu e-mail',
              icon: Icons.email_outlined,
            ),
          ),
          const SizedBox(height: 18),
          _buildFieldLabel('Idade'),
          const SizedBox(height: 8),
          TextField(
            controller: _ageController,
            enabled: !_isLoading,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            style: const TextStyle(
              color: textColor,
              fontSize: 14,
            ),
            decoration: _inputDecoration(
              hintText: 'Digite sua idade',
              icon: Icons.cake_outlined,
            ),
          ),
          const SizedBox(height: 30),
          _buildSectionTitle(
            icon: Icons.accessibility_new_rounded,
            title: 'Acessibilidade',
            subtitle:
                'Essas informações ajudam a personalizar sua experiência.',
          ),
          const SizedBox(height: 16),
          _buildAccessibilityOption(
            title: 'Dificuldade de mobilidade',
            description:
                'Tenho dificuldade para me locomover.',
            value: _mobility,
            icon: Icons.directions_walk_rounded,
            onChanged: _isLoading
                ? null
                : (value) {
                    setState(() {
                      _mobility = value;
                    });
                  },
          ),
          const SizedBox(height: 10),
          _buildAccessibilityOption(
            title: 'Comunicação pela fala',
            description:
                'Consigo me comunicar pela fala.',
            value: _speaks,
            icon: Icons.record_voice_over_outlined,
            onChanged: _isLoading
                ? null
                : (value) {
                    setState(() {
                      _speaks = value;
                    });
                  },
          ),
          const SizedBox(height: 10),
          _buildAccessibilityOption(
            title: 'Sensibilidade sensorial',
            description:
                'Tenho sensibilidade a sons, luzes, cheiros ou texturas.',
            value: _sensorySensitivity,
            icon: Icons.sensors_outlined,
            onChanged: _isLoading
                ? null
                : (value) {
                    setState(() {
                      _sensorySensitivity = value;
                    });
                  },
          ),
          const SizedBox(height: 30),
          _buildSectionTitle(
            icon: Icons.lock_outline_rounded,
            title: 'Segurança',
            subtitle: 'Crie uma senha para proteger sua conta.',
          ),
          const SizedBox(height: 24),
          _buildFieldLabel('Senha'),
          const SizedBox(height: 8),
          TextField(
            controller: _passwordController,
            enabled: !_isLoading,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.next,
            style: const TextStyle(
              color: textColor,
              fontSize: 14,
            ),
            decoration: _inputDecoration(
              hintText: 'Mínimo de 8 caracteres',
              icon: Icons.lock_outline_rounded,
              suffixIcon: IconButton(
                tooltip: 'Mostrar ou ocultar senha',
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: secondaryTextColor,
                  size: 21,
                ),
                onPressed: _isLoading
                    ? null
                    : () {
                        setState(() {
                          _obscurePassword =
                              !_obscurePassword;
                        });
                      },
              ),
            ),
          ),
          const SizedBox(height: 18),
          _buildFieldLabel('Confirmar senha'),
          const SizedBox(height: 8),
          TextField(
            controller: _confirmPasswordController,
            enabled: !_isLoading,
            obscureText: _obscureConfirmPassword,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _register(),
            style: const TextStyle(
              color: textColor,
              fontSize: 14,
            ),
            decoration: _inputDecoration(
              hintText: 'Digite a senha novamente',
              icon: Icons.lock_outline_rounded,
              suffixIcon: IconButton(
                tooltip: 'Mostrar ou ocultar senha',
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: secondaryTextColor,
                  size: 21,
                ),
                onPressed: _isLoading
                    ? null
                    : () {
                        setState(() {
                          _obscureConfirmPassword =
                              !_obscureConfirmPassword;
                        });
                      },
              ),
            ),
          ),
          const SizedBox(height: 26),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                disabledBackgroundColor:
                    primaryColor.withValues(
                  alpha: 0.45,
                ),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: _isLoading ? null : _register,
              child: AnimatedSwitcher(
                duration: const Duration(
                  milliseconds: 180,
                ),
                child: _isLoading
                    ? const SizedBox(
                        key: ValueKey('loading'),
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Row(
                        key: ValueKey('register'),
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_add_alt_1_rounded,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Criar minha conta',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: secondaryTextColor,
              ),
              onPressed: _isLoading
                  ? null
                  : () {
                      Navigator.pop(context);
                    },
              child: const Text(
                'Já tenho uma conta',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: primaryColor.withValues(
              alpha: 0.14,
            ),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: primaryColor.withValues(
                alpha: 0.16,
              ),
            ),
          ),
          child: Icon(
            icon,
            color: primaryColor,
            size: 21,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  color: secondaryTextColor,
                  fontSize: 12,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccessibilityOption({
    required String title,
    required String description,
    required bool value,
    required IconData icon,
    required ValueChanged<bool>? onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: inputColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.04,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: value
                  ? primaryColor.withValues(
                      alpha: 0.15,
                    )
                  : Colors.white.withValues(
                      alpha: 0.05,
                    ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: value
                  ? primaryColor
                  : secondaryTextColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    color: secondaryTextColor,
                    fontSize: 11,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: primaryColor,
            activeThumbColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: textColor,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        color: secondaryTextColor,
        fontSize: 14,
      ),
      prefixIcon: Icon(
        icon,
        color: secondaryTextColor,
        size: 21,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: inputColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: Colors.white.withValues(
            alpha: 0.04,
          ),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: primaryColor,
          width: 1.5,
        ),
      ),
    );
  }
}