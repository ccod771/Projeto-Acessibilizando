import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const primaryColor = Color(0xFF8A00C4);
  static const backgroundColor = Color(0xFF12121A);
  static const surfaceColor = Color(0xFF1A1921);
  static const inputColor = Color(0xFF24222C);
  static const textColor = Color(0xFFE7E3EA);
  static const secondaryTextColor = Color(0xFFB7B1BC);

  static const String baseUrl = 'http://192.168.1.66:8000';

  final AuthService _authService = AuthService();

  final TextEditingController _searchController =
      TextEditingController();

  String _userName = 'Usuário';

  bool _isLoadingUser = true;
  bool _isLoadingPlaces = true;

  String? _placesError;

  List<Map<String, dynamic>> _places = [];

  List<Map<String, dynamic>> get _filteredPlaces {
    final search = _searchController.text.trim().toLowerCase();

    if (search.isEmpty) {
      return _places;
    }

    return _places.where((place) {
      final name = place['name']?.toString().toLowerCase() ?? '';

      return name.contains(search);
    }).toList();
  }

  @override
  void initState() {
    super.initState();

    _loadUser();
    _loadPlaces();

    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  Future<void> _loadUser() async {
    final user = await _authService.getMe();

    if (!mounted) {
      return;
    }

    setState(() {
      if (user != null && user['name'] != null) {
        _userName = user['name'].toString();
      }

      _isLoadingUser = false;
    });
  }

  Future<void> _loadPlaces() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/places/'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (!mounted) {
        return;
      }

      if (response.statusCode != 200) {
        setState(() {
          _isLoadingPlaces = false;
          _placesError =
              'Não foi possível carregar os locais.';
        });

        return;
      }

      final data = jsonDecode(response.body);

      List<dynamic> results;

      if (data is List) {
        results = data;
      } else if (data is Map && data['results'] is List) {
        results = data['results'];
      } else {
        results = [];
      }

      setState(() {
        _places = results
            .whereType<Map>()
            .map(
              (place) => Map<String, dynamic>.from(place),
            )
            .toList();

        _isLoadingPlaces = false;
        _placesError = null;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingPlaces = false;
        _placesError =
            'Erro ao conectar com o servidor.';
      });

      print('========== ERRO PLACES ==========');
      print(e);
      print('=================================');
    }
  }

  void _openPlace(Map<String, dynamic> place) {
    final placeId = place['id'];

    print('Local selecionado: ${place['name']}');
    print('ID do local: $placeId');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Local selecionado: ${place['name']}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final places = _filteredPlaces;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text(
          'Acessibilizando',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadPlaces,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                const Text(
                  'Bem-vindo!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),

                const SizedBox(height: 6),

                _isLoadingUser
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: primaryColor,
                        ),
                      )
                    : Text(
                        _userName,
                        style: const TextStyle(
                          fontSize: 20,
                          color: secondaryTextColor,
                        ),
                      ),

                const SizedBox(height: 28),

                const Text(
                  'Encontre um local',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: _searchController,
                  style: const TextStyle(
                    color: textColor,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Buscar local...',
                    hintStyle: const TextStyle(
                      color: secondaryTextColor,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: secondaryTextColor,
                    ),
                    suffixIcon:
                        _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: secondaryTextColor,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                },
                              )
                            : null,
                    filled: true,
                    fillColor: inputColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: primaryColor,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                const Text(
                  'Locais cadastrados',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),

                const SizedBox(height: 12),

                if (_isLoadingPlaces)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    ),
                  )
                else if (_placesError != null)
                  _buildError()
                else if (places.isEmpty)
                  _buildEmptyPlaces()
                else
                  ...places.map(_buildPlaceCard),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceCard(
    Map<String, dynamic> place,
  ) {
    final name = place['name']?.toString() ?? 'Local';

    final averageRating =
        place['average_rating'];

    final reviewCount =
        place['review_count'] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          _openPlace(place);
        },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.location_on_outlined,
                  color: primaryColor,
                  size: 28,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 17,
                          color: Colors.amber,
                        ),

                        const SizedBox(width: 4),

                        Text(
                          averageRating != null
                              ? double.parse(
                                  averageRating.toString(),
                                ).toStringAsFixed(1)
                              : 'Sem avaliação',
                          style: const TextStyle(
                            color: secondaryTextColor,
                            fontSize: 14,
                          ),
                        ),

                        if (averageRating != null) ...[
                          const SizedBox(width: 6),

                          Text(
                            '($reviewCount avaliações)',
                            style: const TextStyle(
                              color: secondaryTextColor,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right,
                color: secondaryTextColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyPlaces() {
    final isSearching =
        _searchController.text.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.location_off_outlined,
            size: 48,
            color: primaryColor,
          ),

          const SizedBox(height: 12),

          Text(
            isSearching
                ? 'Nenhum local encontrado.'
                : 'Nenhum local cadastrado.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: secondaryTextColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.redAccent,
          ),

          const SizedBox(height: 12),

          const Text(
            'Não foi possível carregar os locais.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 16),

          FilledButton(
            onPressed: _loadPlaces,
            style: FilledButton.styleFrom(
              backgroundColor: primaryColor,
            ),
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }
}