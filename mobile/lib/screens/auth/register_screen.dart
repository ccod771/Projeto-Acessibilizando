import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  void _register() {
    // Vamos conectar com a API depois.
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF8A00C4);
    const backgroundColor = Color(0xFF12121A);
    const surfaceColor = Color(0xFF1A1921);
    const inputColor = Color(0xFF24222C);
    const textColor = Color(0xFFE7E3EA);
    const secondaryTextColor = Color(0xFFB7B1BC);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        title: const Text(
          'Criar conta',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 500,
              ),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Crie sua conta',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Preencha seus dados para começar.',
                      style: TextStyle(
                        color: secondaryTextColor,
                      ),
                    ),

                    const SizedBox(height: 32),

                    TextField(
                      controller: _nameController,
                      style: const TextStyle(
                        color: textColor,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Nome',
                        labelStyle: const TextStyle(
                          color: secondaryTextColor,
                        ),
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: secondaryTextColor,
                        ),
                        filled: true,
                        fillColor: inputColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: primaryColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                        color: textColor,
                      ),
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        labelStyle: const TextStyle(
                          color: secondaryTextColor,
                        ),
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: secondaryTextColor,
                        ),
                        filled: true,
                        fillColor: inputColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: primaryColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        color: textColor,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Idade',
                        labelStyle: const TextStyle(
                          color: secondaryTextColor,
                        ),
                        prefixIcon: const Icon(
                          Icons.cake_outlined,
                          color: secondaryTextColor,
                        ),
                        filled: true,
                        fillColor: inputColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: primaryColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Acessibilidade',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),

                    const SizedBox(height: 8),

                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'Possui dificuldade de mobilidade?',
                        style: TextStyle(
                          color: textColor,
                        ),
                      ),
                      activeTrackColor: primaryColor,
                      value: _mobility,
                      onChanged: (value) {
                        setState(() {
                          _mobility = value;
                        });
                      },
                    ),

                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'Consegue se comunicar pela fala?',
                        style: TextStyle(
                          color: textColor,
                        ),
                      ),
                      activeTrackColor: primaryColor,
                      value: _speaks,
                      onChanged: (value) {
                        setState(() {
                          _speaks = value;
                        });
                      },
                    ),

                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'Possui sensibilidade sensorial?',
                        style: TextStyle(
                          color: textColor,
                        ),
                      ),
                      activeTrackColor: primaryColor,
                      value: _sensorySensitivity,
                      onChanged: (value) {
                        setState(() {
                          _sensorySensitivity = value;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(
                        color: textColor,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        labelStyle: const TextStyle(
                          color: secondaryTextColor,
                        ),
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: secondaryTextColor,
                        ),
                        filled: true,
                        fillColor: inputColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: primaryColor,
                            width: 1.5,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: secondaryTextColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      style: const TextStyle(
                        color: textColor,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Confirmar senha',
                        labelStyle: const TextStyle(
                          color: secondaryTextColor,
                        ),
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: secondaryTextColor,
                        ),
                        filled: true,
                        fillColor: inputColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: primaryColor,
                            width: 1.5,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: secondaryTextColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    SizedBox(
                      height: 52,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _register,
                        child: const Text(
                          'Criar conta',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: primaryColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Já tenho uma conta',
                      ),
                    ),
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
