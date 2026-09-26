import 'package:flutter/material.dart';

import '../../services/place_service.dart';

class CreatePlaceScreen extends StatefulWidget {
  const CreatePlaceScreen({super.key});

  @override
  State<CreatePlaceScreen> createState() =>
      _CreatePlaceScreenState();
}

class _CreatePlaceScreenState
    extends State<CreatePlaceScreen> {

  final PlaceService _placeService = PlaceService();

  final TextEditingController _nameController =
      TextEditingController();

  bool _isLoading = false;

  bool _hasElevator = false;
  bool _highMovement = false;
  bool _strongLights = false;

  static const primaryColor = Color(0xFF8A00C4);

  static const backgroundColor = Color(0xFF12121A);

  static const surfaceColor = Color(0xFF1A1921);

  static const inputColor = Color(0xFF24222C);

  static const textColor = Color(0xFFE7E3EA);

  static const secondaryTextColor = Color(0xFFB7B1BC);

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _createPlace() async {
    if (_isLoading) {
      return;
    }

    final name = _nameController.text.trim();

    if (name.isEmpty) {
      _showMessage(
        'Digite o nome do local.',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _placeService.createPlace(
        name: name,
        hasElevator: _hasElevator,
        highMovement: _highMovement,
        strongLights: _strongLights,
      );

      if (!mounted) {
        return;
      }

      if (result['success'] == true) {
        Navigator.pop(
          context,
          true,
        );
        return;
      }

      final data = result['data'];

      String message =
          'Não foi possível cadastrar o local.';

      if (data is Map) {
        if (data['name'] is List &&
            (data['name'] as List).isNotEmpty) {
          message = data['name'][0].toString();
        } else if (data['detail'] != null) {
          message = data['detail'].toString();
        } else if (data['message'] != null) {
          message = data['message'].toString();
        }
      }

      setState(() {
        _isLoading = false;
      });

      _showMessage(message);
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      _showMessage(
        'Erro ao cadastrar local.',
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
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(
              alpha: 0.10,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withValues(
                alpha: 0.12,
              ),
            ),
          ),
          child: const Text(
            'Cadastrar local',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            18,
            20,
            32,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              _buildHeader(),

              const SizedBox(height: 24),

              _buildFormCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withValues(
              alpha: 0.18,
            ),
            surfaceColor,
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: primaryColor.withValues(
            alpha: 0.14,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.09,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.add_location_alt_rounded,
              color: primaryColor,
              size: 29,
            ),
          ),

          const SizedBox(width: 15),

          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Novo local',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  'Cadastre um local para que outras pessoas possam avaliá-lo.',
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.05,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.15,
            ),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _buildLabel('Nome do local'),

          const SizedBox(height: 8),

          TextField(
            controller: _nameController,
            enabled: !_isLoading,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _createPlace(),
            style: const TextStyle(
              color: textColor,
              fontSize: 14,
            ),
            decoration: _inputDecoration(
              hintText: 'Ex.: Midway Mall',
              icon: Icons.storefront_outlined,
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            'O mesmo local não pode ser cadastrado novamente.',
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 12,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 26),

          _buildLabel(
            'Características do local',
          ),

          const SizedBox(height: 8),

          _buildCheckbox(
            title: 'Tem elevador',
            subtitle:
                'O local possui elevador disponível.',
            icon: Icons.elevator_rounded,
            value: _hasElevator,
            onChanged: (value) {
              setState(() {
                _hasElevator = value;
              });
            },
          ),

          const SizedBox(height: 8),

          _buildCheckbox(
            title: 'Muita movimentação',
            subtitle:
                'O local costuma ter grande circulação de pessoas.',
            icon: Icons.groups_rounded,
            value: _highMovement,
            onChanged: (value) {
              setState(() {
                _highMovement = value;
              });
            },
          ),

          const SizedBox(height: 8),

          _buildCheckbox(
            title: 'Luzes fortes',
            subtitle:
                'O local possui iluminação intensa.',
            icon: Icons.light_mode_rounded,
            value: _strongLights,
            onChanged: (value) {
              setState(() {
                _strongLights = value;
              });
            },
          ),

          const SizedBox(height: 26),

          SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton.icon(
              onPressed:
                  _isLoading ? null : _createPlace,
              style: FilledButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                disabledBackgroundColor:
                    primaryColor.withValues(
                  alpha: 0.45,
                ),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(15),
                ),
              ),
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2.3,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.add_location_alt_rounded,
                      size: 20,
                    ),
              label: Text(
                _isLoading
                    ? 'Cadastrando...'
                    : 'Cadastrar local',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckbox({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 180,
      ),
      decoration: BoxDecoration(
        color: value
            ? primaryColor.withValues(
                alpha: 0.10,
              )
            : inputColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: value
              ? primaryColor.withValues(
                  alpha: 0.35,
                )
              : Colors.white.withValues(
                  alpha: 0.04,
                ),
        ),
      ),
      child: CheckboxListTile(
        value: value,
        onChanged:
            _isLoading ? null : (value) {
              onChanged(value ?? false);
            },
        activeColor: primaryColor,
        checkColor: Colors.white,
        controlAffinity:
            ListTileControlAffinity.trailing,
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 5,
        ),
        secondary: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white.withValues(
              alpha: 0.07,
            ),
            borderRadius:
                BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: value
                ? primaryColor
                : secondaryTextColor,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(
            top: 3,
          ),
          child: Text(
            subtitle,
            style: const TextStyle(
              color: secondaryTextColor,
              fontSize: 11.5,
              height: 1.3,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
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
      filled: true,
      fillColor: inputColor,
      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(15),
        borderSide: BorderSide(
          color: Colors.white.withValues(
            alpha: 0.04,
          ),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: primaryColor,
          width: 1.5,
        ),
      ),
    );
  }
}