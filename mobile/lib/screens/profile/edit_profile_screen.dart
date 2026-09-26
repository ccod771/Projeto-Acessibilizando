import 'package:flutter/material.dart';

import '../../services/auth_service.dart';


class EditProfileScreen extends StatefulWidget {

  const EditProfileScreen({
    super.key,
  });

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}


class _EditProfileScreenState
    extends State<EditProfileScreen> {

  static const primaryColor =
      Color(0xFF8A00C4);

  static const backgroundColor =
      Color(0xFF12121A);

  static const surfaceColor =
      Color(0xFF1A1921);

  static const inputColor =
      Color(0xFF24222C);

  static const textColor =
      Color(0xFFE7E3EA);

  static const secondaryTextColor =
      Color(0xFFB7B1BC);


  final AuthService _authService =
      AuthService();

  final TextEditingController _nameController =
      TextEditingController();

  final TextEditingController _emailController =
      TextEditingController();


  bool _mobility = false;

  bool _speaks = true;

  bool _sensorySensitivity = false;

  bool _isLoading = true;

  bool _isSaving = false;


  @override
  void initState() {
    super.initState();

    _loadProfile();
  }


  @override
  void dispose() {

    _nameController.dispose();

    _emailController.dispose();

    super.dispose();
  }


  Future<void> _loadProfile() async {

    try {

      final user =
          await _authService.getMe();

      if (!mounted) {
        return;
      }

      if (user == null) {

        _showMessage(
          'Não foi possível carregar seu perfil.',
        );

        Navigator.pop(context);

        return;
      }

      _nameController.text =
          user['name']?.toString() ?? '';

      _emailController.text =
          user['email']?.toString() ?? '';

      setState(() {

        _mobility =
            user['mobility'] == true;

        _speaks =
            user['speaks'] != false;

        _sensorySensitivity =
            user['sensory_sensitivity'] == true;

        _isLoading = false;
      });

    } catch (e) {

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      _showMessage(
        'Erro ao carregar seu perfil.',
      );
    }
  }


  Future<void> _saveProfile() async {

    if (_isSaving) {
      return;
    }

    final name =
        _nameController.text.trim();

    final email =
        _emailController.text.trim();


    if (name.isEmpty) {

      _showMessage(
        'O nome é obrigatório.',
      );

      return;
    }


    if (email.isEmpty) {

      _showMessage(
        'O e-mail é obrigatório.',
      );

      return;
    }


    setState(() {
      _isSaving = true;
    });


    try {

      final result =
          await _authService.updateProfile(
        name: name,
        email: email,
        mobility: _mobility,
        speaks: _speaks,
        sensorySensitivity:
            _sensorySensitivity,
      );


      if (!mounted) {
        return;
      }


      setState(() {
        _isSaving = false;
      });


      if (result['success'] == true) {

        _showMessage(
          'Perfil atualizado com sucesso!',
        );

        Navigator.pop(
          context,
          true,
        );

        return;
      }


      final data = result['data'];

      String message =
          'Não foi possível atualizar o perfil.';


      if (data is Map) {

        if (data['email'] is List) {

          message =
              data['email'][0].toString();

        } else if (data['name'] is List) {

          message =
              data['name'][0].toString();

        } else if (data['detail'] != null) {

          message =
              data['detail'].toString();

        } else if (data['error'] != null) {

          message =
              data['error'].toString();
        }
      }


      _showMessage(message);

    } catch (e) {

      if (!mounted) {
        return;
      }

      setState(() {
        _isSaving = false;
      });

      _showMessage(
        'Erro ao atualizar perfil.',
      );
    }
  }


  void _showMessage(String message) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior:
            SnackBarBehavior.floating,
        margin:
            const EdgeInsets.all(16),
        backgroundColor:
            surfaceColor,
        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(14),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          backgroundColor,

      appBar: AppBar(

        backgroundColor:
            backgroundColor,

        foregroundColor:
            textColor,

        elevation: 0,

        scrolledUnderElevation: 0,

        title: Container(

          padding:
              const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 7,
          ),

          decoration:
              BoxDecoration(
            color:
                Colors.white.withValues(
              alpha: 0.08,
            ),
            borderRadius:
                BorderRadius.circular(18),
            border:
                Border.all(
              color:
                  Colors.white.withValues(
                alpha: 0.10,
              ),
            ),
          ),

          child: const Text(
            'Editar perfil',
            style: TextStyle(
              color: textColor,
              fontSize: 17,
              fontWeight:
                  FontWeight.w700,
            ),
          ),
        ),
      ),


      body: SafeArea(

        child: _isLoading

            ? const Center(
                child:
                    CircularProgressIndicator(
                  color: primaryColor,
                ),
              )

            : SingleChildScrollView(

                padding:
                    const EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  32,
                ),

                child: Column(
                  children: [

                    _buildProfileHeader(),

                    const SizedBox(
                      height: 22,
                    ),

                    _buildProfileCard(),

                  ],
                ),
              ),
      ),
    );
  }


  Widget _buildProfileHeader() {

    return Column(
      children: [

        Container(

          width: 82,
          height: 82,

          decoration:
              BoxDecoration(
            color:
                primaryColor.withValues(
              alpha: 0.14,
            ),
            shape:
                BoxShape.circle,
            border:
                Border.all(
              color:
                  primaryColor.withValues(
                alpha: 0.25,
              ),
            ),
          ),

          child: const Icon(
            Icons.person_rounded,
            color: primaryColor,
            size: 42,
          ),
        ),

        const SizedBox(
          height: 14,
        ),

        const Text(
          'Meu perfil',
          style: TextStyle(
            color: textColor,
            fontSize: 24,
            fontWeight:
                FontWeight.w700,
          ),
        ),

        const SizedBox(
          height: 6,
        ),

        const Text(
          'Atualize suas informações pessoais e de acessibilidade.',
          textAlign:
              TextAlign.center,
          style: TextStyle(
            color:
                secondaryTextColor,
            fontSize: 13,
            height: 1.4,
          ),
        ),
      ],
    );
  }


  Widget _buildProfileCard() {

    return Container(

      width: double.infinity,

      padding:
          const EdgeInsets.fromLTRB(
        22,
        25,
        22,
        22,
      ),

      decoration:
          BoxDecoration(
        color:
            surfaceColor,
        borderRadius:
            BorderRadius.circular(24),
        border:
            Border.all(
          color:
              Colors.white.withValues(
            alpha: 0.055,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(
              alpha: 0.20,
            ),
            blurRadius: 25,
            offset:
                const Offset(0, 10),
          ),
        ],
      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          _buildSectionTitle(
            icon:
                Icons.person_outline_rounded,
            title:
                'Seus dados',
            subtitle:
                'Mantenha suas informações atualizadas.',
          ),

          const SizedBox(
            height: 24,
          ),

          _buildFieldLabel(
            'Nome',
          ),

          const SizedBox(
            height: 8,
          ),

          TextField(

            controller:
                _nameController,

            enabled:
                !_isSaving,

            style:
                const TextStyle(
              color:
                  textColor,
              fontSize: 14,
            ),

            decoration:
                _inputDecoration(
              hintText:
                  'Digite seu nome',
              icon:
                  Icons.person_outline_rounded,
            ),
          ),

          const SizedBox(
            height: 18,
          ),

          _buildFieldLabel(
            'E-mail',
          ),

          const SizedBox(
            height: 8,
          ),

          TextField(

            controller:
                _emailController,

            enabled:
                !_isSaving,

            keyboardType:
                TextInputType.emailAddress,

            style:
                const TextStyle(
              color:
                  textColor,
              fontSize: 14,
            ),

            decoration:
                _inputDecoration(
              hintText:
                  'Digite seu e-mail',
              icon:
                  Icons.email_outlined,
            ),
          ),

          const SizedBox(
            height: 30,
          ),

          _buildSectionTitle(
            icon:
                Icons.accessibility_new_rounded,
            title:
                'Acessibilidade',
            subtitle:
                'Essas informações ajudam a personalizar sua experiência.',
          ),

          const SizedBox(
            height: 16,
          ),

          _buildAccessibilityOption(
            title:
                'Dificuldade de mobilidade',
            description:
                'Tenho dificuldade para me locomover.',
            value:
                _mobility,
            icon:
                Icons.directions_walk_rounded,
            onChanged:
                _isSaving
                    ? null
                    : (value) {
                        setState(() {
                          _mobility =
                              value;
                        });
                      },
          ),

          const SizedBox(
            height: 10,
          ),

          _buildAccessibilityOption(
            title:
                'Comunicação pela fala',
            description:
                'Consigo me comunicar pela fala.',
            value:
                _speaks,
            icon:
                Icons.record_voice_over_outlined,
            onChanged:
                _isSaving
                    ? null
                    : (value) {
                        setState(() {
                          _speaks =
                              value;
                        });
                      },
          ),

          const SizedBox(
            height: 10,
          ),

          _buildAccessibilityOption(
            title:
                'Sensibilidade sensorial',
            description:
                'Tenho sensibilidade a sons, luzes, cheiros ou texturas.',
            value:
                _sensorySensitivity,
            icon:
                Icons.sensors_outlined,
            onChanged:
                _isSaving
                    ? null
                    : (value) {
                        setState(() {
                          _sensorySensitivity =
                              value;
                        });
                      },
          ),

          const SizedBox(
            height: 30,
          ),

          SizedBox(

            width:
                double.infinity,

            height:
                54,

            child:
                FilledButton(

              onPressed:
                  _isSaving
                      ? null
                      : _saveProfile,

              style:
                  FilledButton.styleFrom(
                backgroundColor:
                    primaryColor,
                foregroundColor:
                    Colors.white,
                disabledBackgroundColor:
                    primaryColor.withValues(
                  alpha: 0.45,
                ),
                elevation: 0,
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    15,
                  ),
                ),
              ),

              child:
                  _isSaving

                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color:
                                Colors.white,
                          ),
                        )

                      : const Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                          children: [

                            Icon(
                              Icons
                                  .save_rounded,
                              size: 20,
                            ),

                            SizedBox(
                              width: 8,
                            ),

                            Text(
                              'Salvar alterações',
                              style:
                                  TextStyle(
                                fontSize: 15,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ],
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

      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Container(

          width: 42,
          height: 42,

          decoration:
              BoxDecoration(
            color:
                primaryColor.withValues(
              alpha: 0.14,
            ),
            borderRadius:
                BorderRadius.circular(13),
            border:
                Border.all(
              color:
                  primaryColor.withValues(
                alpha: 0.16,
              ),
            ),
          ),

          child: Icon(
            icon,
            color:
                primaryColor,
            size: 21,
          ),
        ),

        const SizedBox(
          width: 12,
        ),

        Expanded(

          child: Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Text(
                title,
                style:
                    const TextStyle(
                  color:
                      textColor,
                  fontSize: 18,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),

              const SizedBox(
                height: 3,
              ),

              Text(
                subtitle,
                style:
                    const TextStyle(
                  color:
                      secondaryTextColor,
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

      padding:
          const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),

      decoration:
          BoxDecoration(
        color:
            inputColor,
        borderRadius:
            BorderRadius.circular(16),
        border:
            Border.all(
          color:
              Colors.white.withValues(
            alpha: 0.04,
          ),
        ),
      ),

      child: Row(

        children: [

          Container(

            width: 40,
            height: 40,

            decoration:
                BoxDecoration(
              color: value
                  ? primaryColor.withValues(
                      alpha: 0.15,
                    )
                  : Colors.white.withValues(
                      alpha: 0.05,
                    ),
              borderRadius:
                  BorderRadius.circular(12),
            ),

            child: Icon(
              icon,
              color: value
                  ? primaryColor
                  : secondaryTextColor,
              size: 20,
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          Expanded(

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  title,
                  style:
                      const TextStyle(
                    color:
                        textColor,
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),

                const SizedBox(
                  height: 3,
                ),

                Text(
                  description,
                  style:
                      const TextStyle(
                    color:
                        secondaryTextColor,
                    fontSize: 11,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            width: 8,
          ),

          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor:
                primaryColor,
            activeThumbColor:
                Colors.white,
          ),
        ],
      ),
    );
  }


  Widget _buildFieldLabel(
    String label,
  ) {

    return Text(
      label,
      style:
          const TextStyle(
        color:
            textColor,
        fontSize: 14,
        fontWeight:
            FontWeight.w600,
      ),
    );
  }


  InputDecoration _inputDecoration({
    required String hintText,
    required IconData icon,
  }) {

    return InputDecoration(

      hintText:
          hintText,

      hintStyle:
          const TextStyle(
        color:
            secondaryTextColor,
        fontSize: 14,
      ),

      prefixIcon:
          Icon(
        icon,
        color:
            secondaryTextColor,
        size: 21,
      ),

      filled:
          true,

      fillColor:
          inputColor,

      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),

      border:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(15),
        borderSide:
            BorderSide.none,
      ),

      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(15),
        borderSide:
            BorderSide(
          color:
              Colors.white.withValues(
            alpha: 0.04,
          ),
        ),
      ),

      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(15),
        borderSide:
            const BorderSide(
          color:
              primaryColor,
          width: 1.5,
        ),
      ),
    );
  }
}