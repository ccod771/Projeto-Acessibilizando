import 'dart:async';

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../../services/auth_service.dart';

import 'place_detail_screen.dart';

import '../places/create_place_screen.dart';

import '../profile/edit_profile_screen.dart';

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

  static const String baseUrl =
      'http://192.168.1.66:8000';

  static const int _pageSize = 5;

  final AuthService _authService = AuthService();

  final TextEditingController _searchController =
      TextEditingController();

  Timer? _searchDebounce;

  String _userName = 'Usuário';

  bool _isLoadingUser = true;

  bool _isLoadingPlaces = true;

  String? _placesError;

  List<Map<String, dynamic>> _places = [];

  int _currentPage = 1;

  int _totalPages = 1;

  int _totalPlaces = 0;

  @override
  void initState() {
    super.initState();

    _loadUser();

    _loadPlaces();

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();

    _searchController.dispose();

    super.dispose();
  }

  void _onSearchChanged() {
    _searchDebounce?.cancel();

    _searchDebounce = Timer(
      const Duration(milliseconds: 400),
      () {
        if (!mounted) {
          return;
        }

        _loadPlaces(page: 1);
      },
    );

    setState(() {});
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

  // NOVO:
  // Abre a tela de edição de perfil.
  Future<void> _openEditProfile() async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const EditProfileScreen(),
      ),
    );

    // Se o usuário salvou o perfil,
    // atualiza o nome exibido na Home.
    if (updated == true && mounted) {
      await _loadUser();
    }
  }

  Future<void> _loadPlaces({
    int page = 1,
  }) async {
    setState(() {
      _isLoadingPlaces = true;

      _placesError = null;
    });

    try {
      final search = _searchController.text.trim();

      final queryParameters = <String, String>{
        'page': page.toString(),
        'page_size': _pageSize.toString(),
      };

      if (search.isNotEmpty) {
        queryParameters['search'] = search;
      }

      final uri = Uri.parse(
        '$baseUrl/api/places/',
      ).replace(
        queryParameters: queryParameters,
      );

      final response = await http.get(
        uri,
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

      int totalPlaces = 0;

      int totalPages = 1;

      if (data is List) {
        results = data;

        totalPlaces = data.length;

        totalPages =
            (totalPlaces / _pageSize).ceil();

        if (totalPages == 0) {
          totalPages = 1;
        }
      } else if (
          data is Map &&
          data['results'] is List) {
        results = data['results'];

        final count = data['count'];

        if (count is int) {
          totalPlaces = count;

          totalPages =
              (count / _pageSize).ceil();

          if (totalPages == 0) {
            totalPages = 1;
          }
        } else {
          totalPlaces = results.length;

          totalPages = 1;
        }
      } else {
        results = [];

        totalPlaces = 0;

        totalPages = 1;
      }

      setState(() {
        _places = results
            .whereType<Map>()
            .map(
              (place) =>
                  Map<String, dynamic>.from(place),
            )
            .toList();

        _currentPage = page;

        _totalPages = totalPages;

        _totalPlaces = totalPlaces;

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

  void _openPlace(
    Map<String, dynamic> place,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaceDetailScreen(
          place: place,
        ),
      ),
    );
  }

  Future<void> _openCreatePlace() async {
    final created = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const CreatePlaceScreen(),
      ),
    );

    if (created == true && mounted) {
      await _loadPlaces(page: 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final places = _places;

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: backgroundColor,

        elevation: 0,

        scrolledUnderElevation: 0,

        centerTitle: true,

        title: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 7,
          ),

          decoration: BoxDecoration(
            color: Colors.white.withValues(
              alpha: 0.10,
            ),

            borderRadius:
                BorderRadius.circular(18),

            border: Border.all(
              color: Colors.white.withValues(
                alpha: 0.12,
              ),
            ),
          ),

          child: Row(
            mainAxisSize: MainAxisSize.min,

            children: [
              Container(
                padding:
                    const EdgeInsets.all(5),

                decoration: BoxDecoration(
                  color:
                      Colors.white.withValues(
                    alpha: 0.16,
                  ),

                  borderRadius:
                      BorderRadius.circular(12),
                ),

                child: Image.asset(
                  'assets/logo.png',

                  width: 42,

                  height: 42,

                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(width: 10),

              const Text(
                'Acessibilizando',

                style: TextStyle(
                  color: Colors.white,

                  fontSize: 20,

                  fontWeight: FontWeight.w700,

                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),

        // NOVO:
        // Botão para acessar o perfil.
        actions: [
          Padding(
            padding:
                const EdgeInsets.only(
              right: 12,
            ),

            child: IconButton(
              tooltip: 'Meu perfil',

              onPressed: _openEditProfile,

              style: IconButton.styleFrom(
                backgroundColor:
                    Colors.white.withValues(
                  alpha: 0.07,
                ),
              ),

              icon: const Icon(
                Icons.person_outline_rounded,

                color: Colors.white,

                size: 23,
              ),
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: RefreshIndicator(
          color: primaryColor,

          onRefresh: () => _loadPlaces(
            page: _currentPage,
          ),

          child: SingleChildScrollView(
            physics:
                const AlwaysScrollableScrollPhysics(),

            padding:
                const EdgeInsets.fromLTRB(
              20,
              18,
              20,
              32,
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                _buildWelcome(),

                const SizedBox(height: 16),

                // NOVO BOTÃO
                SizedBox(
                  width: double.infinity,

                  height: 54,

                  child: OutlinedButton.icon(
                    onPressed:
                        _openCreatePlace,

                    style:
                        OutlinedButton.styleFrom(
                      foregroundColor:
                          Colors.white,

                      backgroundColor:
                          primaryColor
                              .withValues(
                        alpha: 0.08,
                      ),

                      side: BorderSide(
                        color: primaryColor
                            .withValues(
                          alpha: 0.55,
                        ),
                      ),

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          15,
                        ),
                      ),
                    ),

                    icon: const Icon(
                      Icons
                          .add_location_alt_rounded,

                      color: primaryColor,
                    ),

                    label: const Text(
                      'Cadastrar novo local',

                      style: TextStyle(
                        fontSize: 15,

                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                const Text(
                  'Encontre um local',

                  style: TextStyle(
                    fontSize: 21,

                    fontWeight:
                        FontWeight.w700,

                    color: textColor,

                    letterSpacing: -0.2,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Pesquise por um lugar para consultar sua acessibilidade.',

                  style: TextStyle(
                    color:
                        secondaryTextColor,

                    fontSize: 14,

                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 14),

                TextField(
                  controller:
                      _searchController,

                  style: const TextStyle(
                    color: textColor,
                  ),

                  decoration:
                      InputDecoration(
                    hintText:
                        'Buscar local...',

                    hintStyle:
                        const TextStyle(
                      color:
                          secondaryTextColor,
                    ),

                    prefixIcon:
                        const Icon(
                      Icons.search_rounded,

                      color:
                          secondaryTextColor,
                    ),

                    suffixIcon:
                        _searchController
                                .text
                                .isNotEmpty
                            ? IconButton(
                                icon:
                                    const Icon(
                                  Icons
                                      .close_rounded,

                                  color:
                                      secondaryTextColor,
                                ),

                                onPressed: () {
                                  _searchController
                                      .clear();
                                },
                              )
                            : null,

                    filled: true,

                    fillColor: inputColor,

                    contentPadding:
                        const EdgeInsets
                            .symmetric(
                      vertical: 17,

                      horizontal: 16,
                    ),

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        15,
                      ),

                      borderSide:
                          BorderSide.none,
                    ),

                    enabledBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        15,
                      ),

                      borderSide:
                          BorderSide(
                        color: Colors.white
                            .withValues(
                          alpha: 0.04,
                        ),
                      ),
                    ),

                    focusedBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        15,
                      ),

                      borderSide:
                          const BorderSide(
                        color: primaryColor,

                        width: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,

                  crossAxisAlignment:
                      CrossAxisAlignment.center,

                  children: [
                    const Text(
                      'Locais cadastrados',

                      style: TextStyle(
                        fontSize: 21,

                        fontWeight:
                            FontWeight.w700,

                        color: textColor,

                        letterSpacing: -0.2,
                      ),
                    ),

                    if (!_isLoadingPlaces &&
                        _totalPlaces > 0)
                      Container(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 10,

                          vertical: 5,
                        ),

                        decoration:
                            BoxDecoration(
                          color:
                              primaryColor
                                  .withValues(
                            alpha: 0.12,
                          ),

                          borderRadius:
                              BorderRadius
                                  .circular(
                            20,
                          ),
                        ),

                        child: Text(
                          '$_totalPlaces',

                          style:
                              const TextStyle(
                            color:
                                primaryColor,

                            fontSize: 13,

                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 14),

                if (_isLoadingPlaces)
                  const Center(
                    child: Padding(
                      padding:
                          EdgeInsets.all(40),

                      child:
                          CircularProgressIndicator(
                        color:
                            primaryColor,
                      ),
                    ),
                  )
                else if (_placesError != null)
                  _buildError()
                else if (places.isEmpty)
                  _buildEmptyPlaces()
                else
                  ...places.map(
                    _buildPlaceCard,
                  ),

                if (!_isLoadingPlaces &&
                    _placesError == null &&
                    _places.isNotEmpty &&
                    _totalPages > 1)
                  _buildPagination(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 12,
        bottom: 8,
      ),

      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [
          IconButton(
            onPressed: _currentPage > 1
                ? () {
                    _loadPlaces(
                      page: _currentPage - 1,
                    );
                  }
                : null,

            style: IconButton.styleFrom(
              backgroundColor:
                  _currentPage > 1
                      ? surfaceColor
                      : Colors.transparent,
            ),

            icon: const Icon(
              Icons.chevron_left_rounded,

              color: secondaryTextColor,
            ),
          ),

          const SizedBox(width: 8),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 9,
            ),

            decoration: BoxDecoration(
              color:
                  primaryColor.withValues(
                alpha: 0.12,
              ),

              borderRadius:
                  BorderRadius.circular(12),
            ),

            child: Text(
              '$_currentPage / $_totalPages',

              style: const TextStyle(
                color: primaryColor,

                fontSize: 14,

                fontWeight:
                    FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(width: 8),

          IconButton(
            onPressed:
                _currentPage < _totalPages
                    ? () {
                        _loadPlaces(
                          page:
                              _currentPage + 1,
                        );
                      }
                    : null,

            style: IconButton.styleFrom(
              backgroundColor:
                  _currentPage <
                          _totalPages
                      ? surfaceColor
                      : Colors.transparent,
            ),

            icon: const Icon(
              Icons.chevron_right_rounded,

              color: secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcome() {
    return Container(
      width: double.infinity,

      // Mais espaço interno para o bloco
      // de boas-vindas.
      padding:
          const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 26,
      ),

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

        borderRadius:
            BorderRadius.circular(22),

        border: Border.all(
          color: primaryColor.withValues(
            alpha: 0.15,
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

      child: Row(
        children: [
          Container(
            width: 58,

            height: 58,

            decoration: BoxDecoration(
              color:
                  primaryColor.withValues(
                alpha: 0.16,
              ),

              shape: BoxShape.circle,

              border: Border.all(
                color:
                    primaryColor.withValues(
                  alpha: 0.25,
                ),
              ),
            ),

            child: const Icon(
              Icons.waving_hand_rounded,

              color: primaryColor,

              size: 30,
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                const Text(
                  'Bem-vindo! 👋',

                  style: TextStyle(
                    color: textColor,

                    fontSize: 23,

                    fontWeight:
                        FontWeight.w700,

                    letterSpacing: -0.3,
                  ),
                ),

                const SizedBox(height: 7),

                _isLoadingUser
                    ? const SizedBox(
                        height: 18,

                        width: 18,

                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,

                          color:
                              primaryColor,
                        ),
                      )
                    : Text(
                        _userName,

                        maxLines: 1,

                        overflow:
                            TextOverflow
                                .ellipsis,

                        style:
                            const TextStyle(
                          color:
                              primaryColor,

                          fontSize: 17,

                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),

                const SizedBox(height: 5),

                const Text(
                  'Vamos encontrar um lugar acessível para você.',

                  style: TextStyle(
                    color:
                        secondaryTextColor,

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

  Widget _buildPlaceCard(
    Map<String, dynamic> place,
  ) {
    final name =
        place['name']?.toString() ??
            'Local';

    final averageRating =
        place['average_rating'];

    final reviewCount =
        place['review_count'] ?? 0;

    return Container(
      margin:
          const EdgeInsets.only(bottom: 12),

      decoration: BoxDecoration(
        color: surfaceColor,

        borderRadius:
            BorderRadius.circular(17),

        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.05,
          ),
        ),
      ),

      child: InkWell(
        borderRadius:
            BorderRadius.circular(17),

        onTap: () {
          _openPlace(place);
        },

        child: Padding(
          padding:
              const EdgeInsets.all(17),

          child: Row(
            children: [
              Container(
                width: 52,

                height: 52,

                decoration: BoxDecoration(
                  gradient:
                      LinearGradient(
                    begin:
                        Alignment.topLeft,

                    end: Alignment
                        .bottomRight,

                    colors: [
                      primaryColor
                          .withValues(
                        alpha: 0.20,
                      ),

                      primaryColor
                          .withValues(
                        alpha: 0.08,
                      ),
                    ],
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                ),

                child: const Icon(
                  Icons
                      .location_on_outlined,

                  color: primaryColor,

                  size: 28,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      name,

                      maxLines: 2,

                      overflow:
                          TextOverflow.ellipsis,

                      style:
                          const TextStyle(
                        fontSize: 17,

                        fontWeight:
                            FontWeight.w600,

                        color: textColor,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,

                          size: 17,

                          color: Colors.amber,
                        ),

                        const SizedBox(width: 4),

                        Text(
                          averageRating !=
                                  null
                              ? double.parse(
                                  averageRating
                                      .toString(),
                                ).toStringAsFixed(
                                  1,
                                )
                              : 'Sem avaliação',

                          style:
                              const TextStyle(
                            color:
                                secondaryTextColor,

                            fontSize: 14,

                            fontWeight:
                                FontWeight.w500,
                          ),
                        ),

                        if (averageRating !=
                            null) ...[
                          const SizedBox(
                            width: 6,
                          ),

                          Text(
                            '• $reviewCount avaliações',

                            style:
                                const TextStyle(
                              color:
                                  secondaryTextColor,

                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Container(
                width: 34,

                height: 34,

                decoration: BoxDecoration(
                  color:
                      Colors.white.withValues(
                    alpha: 0.04,
                  ),

                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons
                      .chevron_right_rounded,

                  color:
                      secondaryTextColor,

                  size: 21,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyPlaces() {
    final isSearching =
        _searchController.text
            .trim()
            .isNotEmpty;

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(28),

      decoration: BoxDecoration(
        color: surfaceColor,

        borderRadius:
            BorderRadius.circular(17),

        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.05,
          ),
        ),
      ),

      child: Column(
        children: [
          Container(
            width: 64,

            height: 64,

            decoration: BoxDecoration(
              color:
                  primaryColor.withValues(
                alpha: 0.10,
              ),

              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.location_off_outlined,

              size: 30,

              color: primaryColor,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            isSearching
                ? 'Nenhum local encontrado.'
                : 'Nenhum local cadastrado.',

            textAlign: TextAlign.center,

            style: const TextStyle(
              color: textColor,

              fontSize: 16,

              fontWeight:
                  FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          if (isSearching)
            const Text(
              'Tente buscar por outro nome.',

              textAlign: TextAlign.center,

              style: TextStyle(
                color: secondaryTextColor,

                fontSize: 13,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(28),

      decoration: BoxDecoration(
        color: surfaceColor,

        borderRadius:
            BorderRadius.circular(17),

        border: Border.all(
          color: Colors.redAccent
              .withValues(
            alpha: 0.15,
          ),
        ),
      ),

      child: Column(
        children: [
          Container(
            width: 60,

            height: 60,

            decoration: BoxDecoration(
              color: Colors.redAccent
                  .withValues(
                alpha: 0.10,
              ),

              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.error_outline_rounded,

              size: 30,

              color: Colors.redAccent,
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            'Não foi possível carregar os locais.',

            textAlign: TextAlign.center,

            style: TextStyle(
              color: textColor,

              fontSize: 16,

              fontWeight:
                  FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          FilledButton.icon(
            onPressed: _loadPlaces,

            style:
                FilledButton.styleFrom(
              backgroundColor:
                  primaryColor,

              foregroundColor:
                  Colors.white,

              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
              ),
            ),

            icon: const Icon(
              Icons.refresh_rounded,

              size: 19,
            ),

            label: const Text(
              'Tentar novamente',
            ),
          ),
        ],
      ),
    );
  }
}