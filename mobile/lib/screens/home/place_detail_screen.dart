import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../../services/auth_service.dart';

class PlaceDetailScreen extends StatefulWidget {
  final Map<String, dynamic> place;

  const PlaceDetailScreen({
    super.key,
    required this.place,
  });

  @override
  State<PlaceDetailScreen> createState() =>
      _PlaceDetailScreenState();
}

class _PlaceDetailScreenState
    extends State<PlaceDetailScreen> {

  final AuthService _authService = AuthService();

  static const String baseUrl =
      'http://192.168.1.66:8000';

  bool _isSubmitting = false;

  bool _isLoadingReviews = true;

  String? _reviewsError;

  List<Map<String, dynamic>> _reviews = [];

  static const primaryColor = Color(0xFF8A00C4);

  static const backgroundColor = Color(0xFF12121A);

  static const surfaceColor = Color(0xFF1A1921);

  static const inputColor = Color(0xFF24222C);

  static const textColor = Color(0xFFE7E3EA);

  static const secondaryTextColor = Color(0xFFB7B1BC);

  final TextEditingController _commentController =
      TextEditingController();

  int _rating = 0;

  @override
  void initState() {
    super.initState();

    _loadReviews();
  }

  @override
  void dispose() {
    _commentController.dispose();

    super.dispose();
  }

  Future<void> _loadReviews() async {
    final placeId = widget.place['id'];

    if (placeId == null) {
      setState(() {
        _isLoadingReviews = false;

        _reviewsError =
            'Não foi possível identificar o local.';
      });

      return;
    }

    setState(() {
      _isLoadingReviews = true;

      _reviewsError = null;
    });

    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/api/reviews/?place=$placeId',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (!mounted) {
        return;
      }

      if (response.statusCode != 200) {
        setState(() {
          _isLoadingReviews = false;

          _reviewsError =
              'Não foi possível carregar as avaliações.';
        });

        return;
      }

      final data = jsonDecode(response.body);

      List<dynamic> results;

      if (data is List) {
        results = data;
      } else if (
          data is Map &&
          data['results'] is List
      ) {
        results = data['results'];
      } else {
        results = [];
      }

      setState(() {
        _reviews = results
            .whereType<Map>()
            .map(
              (review) =>
                  Map<String, dynamic>.from(review),
            )
            .toList();

        _isLoadingReviews = false;

        _reviewsError = null;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingReviews = false;

        _reviewsError =
            'Erro ao conectar com o servidor.';
      });

      print('========== ERRO REVIEWS ==========');
      print(e);
      print('==================================');
    }
  }

  @override
  Widget build(BuildContext context) {
    final name =
        widget.place['name']?.toString() ?? 'Local';

    final averageRating =
        widget.place['average_rating'];

    final reviewCount =
        widget.place['review_count'] ?? 0;

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

            borderRadius:
                BorderRadius.circular(18),

            border: Border.all(
              color: Colors.white.withValues(
                alpha: 0.12,
              ),
            ),
          ),

          child: const Text(
            'Avaliar local',

            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: RefreshIndicator(
          color: primaryColor,

          onRefresh: _loadReviews,

          child: SingleChildScrollView(
            physics:
                const AlwaysScrollableScrollPhysics(),

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

                _buildPlaceHeader(
                  name,
                  averageRating,
                  reviewCount,
                ),

                const SizedBox(height: 18),

                // NOVO
                _buildAccessibilityInfo(),

                const SizedBox(height: 30),

                const Text(
                  'Sua avaliação',

                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                    letterSpacing: -0.2,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'Compartilhe sua experiência para ajudar outras pessoas.',

                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 16),

                _buildReviewCard(),

                const SizedBox(height: 34),

                _buildCommunityReviews(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceHeader(
    String name,
    dynamic averageRating,
    dynamic reviewCount,
  ) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(24),

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

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Container(
                width: 58,
                height: 58,

                decoration: BoxDecoration(
                  color:
                      Colors.white.withValues(
                    alpha: 0.10,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),

                  border: Border.all(
                    color:
                        Colors.white.withValues(
                      alpha: 0.12,
                    ),
                  ),
                ),

                child: const Icon(
                  Icons.location_on_rounded,
                  color: primaryColor,
                  size: 31,
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

                      maxLines: 3,

                      overflow:
                          TextOverflow.ellipsis,

                      style:
                          const TextStyle(
                        color: textColor,
                        fontSize: 24,
                        fontWeight:
                            FontWeight.w700,
                        height: 1.15,
                        letterSpacing: -0.4,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Informações de acessibilidade',

                      style: TextStyle(
                        color:
                            secondaryTextColor,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          Container(
            width: double.infinity,

            padding:
                const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 13,
            ),

            decoration: BoxDecoration(
              color:
                  Colors.white.withValues(
                alpha: 0.06,
              ),

              borderRadius:
                  BorderRadius.circular(14),

              border: Border.all(
                color:
                    Colors.white.withValues(
                  alpha: 0.06,
                ),
              ),
            ),

            child: Row(
              children: [

                const Icon(
                  Icons.star_rounded,
                  color: Colors.amber,
                  size: 23,
                ),

                const SizedBox(width: 8),

                Text(
                  averageRating != null
                      ? double.parse(
                          averageRating.toString(),
                        ).toStringAsFixed(1)
                      : '—',

                  style: const TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),

                const SizedBox(width: 8),

                Text(
                  averageRating != null
                      ? 'média das avaliações'
                      : 'Ainda sem avaliações',

                  style: const TextStyle(
                    color:
                        secondaryTextColor,
                    fontSize: 13,
                  ),
                ),

                const Spacer(),

                if (averageRating != null)
                  Text(
                    '$reviewCount',

                    style:
                        const TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),

                if (averageRating != null)
                  const SizedBox(width: 4),

                if (averageRating != null)
                  const Text(
                    'avaliações',

                    style: TextStyle(
                      color:
                          secondaryTextColor,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INFORMAÇÕES DE ACESSIBILIDADE
  // ============================================================

  Widget _buildAccessibilityInfo() {
    final hasElevator =
        widget.place['has_elevator'] == true;

    final highMovement =
        widget.place['high_movement'] == true;

    final strongLights =
        widget.place['strong_lights'] == true;

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: surfaceColor,

        borderRadius:
            BorderRadius.circular(20),

        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.05,
          ),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.10,
            ),

            blurRadius: 15,

            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          const Row(
            children: [

              Icon(
                Icons.accessibility_new_rounded,
                color: primaryColor,
                size: 23,
              ),

              SizedBox(width: 9),

              Text(
                'Características do local',

                style: TextStyle(
                  color: textColor,
                  fontSize: 17,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _buildAccessibilityItem(
            icon: Icons.elevator_rounded,
            title: 'Elevador',
            description: hasElevator
                ? 'Possui elevador'
                : 'Não possui elevador',
            enabled: hasElevator,
          ),

          const SizedBox(height: 10),

          _buildAccessibilityItem(
            icon: Icons.groups_rounded,
            title: 'Movimentação',
            description: highMovement
                ? 'Muita movimentação'
                : 'Movimentação normal',
            enabled: highMovement,
          ),

          const SizedBox(height: 10),

          _buildAccessibilityItem(
            icon: Icons.light_mode_rounded,
            title: 'Iluminação',
            description: strongLights
                ? 'Possui luzes fortes'
                : 'Iluminação normal',
            enabled: strongLights,
          ),
        ],
      ),
    );
  }

  Widget _buildAccessibilityItem({
    required IconData icon,
    required String title,
    required String description,
    required bool enabled,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),

      decoration: BoxDecoration(
        color: enabled
            ? primaryColor.withValues(
                alpha: 0.08,
              )
            : Colors.white.withValues(
                alpha: 0.025,
              ),

        borderRadius:
            BorderRadius.circular(15),

        border: Border.all(
          color: enabled
              ? primaryColor.withValues(
                  alpha: 0.18,
                )
              : Colors.white.withValues(
                  alpha: 0.04,
                ),
        ),
      ),

      child: Row(
        children: [

          Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              color: enabled
                  ? primaryColor.withValues(
                      alpha: 0.12,
                    )
                  : Colors.white.withValues(
                      alpha: 0.05,
                    ),

              borderRadius:
                  BorderRadius.circular(12),
            ),

            child: Icon(
              icon,

              color: enabled
                  ? primaryColor
                  : secondaryTextColor,

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
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  description,

                  style: TextStyle(
                    color: enabled
                        ? textColor
                        : secondaryTextColor,

                    fontSize: 12.5,

                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Icon(
            enabled
                ? Icons.check_circle_rounded
                : Icons.remove_circle_outline_rounded,

            color: enabled
                ? primaryColor
                : secondaryTextColor.withValues(
                    alpha: 0.65,
                  ),

            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        color: surfaceColor,

        borderRadius:
            BorderRadius.circular(20),

        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.05,
          ),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.12,
            ),

            blurRadius: 16,

            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          const Text(
            'Como você avalia a acessibilidade?',

            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Escolha uma nota de 1 a 5 estrelas.',

            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 20),

          _buildRatingSelector(),

          const SizedBox(height: 28),

          const Text(
            'Comentário',

            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Descreva sua experiência neste local.',

            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: _commentController,

            maxLines: 5,

            enabled: !_isSubmitting,

            style: const TextStyle(
              color: textColor,
              fontSize: 14,
            ),

            decoration: InputDecoration(
              hintText:
                  'Conte um pouco sobre sua experiência...',

              hintStyle:
                  const TextStyle(
                color: secondaryTextColor,
                fontSize: 14,
              ),

              filled: true,

              fillColor: inputColor,

              contentPadding:
                  const EdgeInsets.all(16),

              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(15),

                borderSide:
                    BorderSide.none,
              ),

              enabledBorder:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(15),

                borderSide: BorderSide(
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
                  color: primaryColor,
                  width: 1.5,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,

            height: 54,

            child: FilledButton.icon(
              style:
                  FilledButton.styleFrom(
                backgroundColor:
                    primaryColor,

                foregroundColor:
                    Colors.white,

                elevation: 0,

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                ),
              ),

              onPressed: _isSubmitting
                  ? null
                  : _submitReview,

              icon: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,

                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.send_rounded,
                      size: 19,
                    ),

              label: Text(
                _isSubmitting
                    ? 'Enviando...'
                    : 'Enviar avaliação',

                style: const TextStyle(
                  fontSize: 15,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSelector() {
    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 12,
      ),

      decoration: BoxDecoration(
        color: inputColor,

        borderRadius:
            BorderRadius.circular(16),

        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.04,
          ),
        ),
      ),

      child: Column(
        children: [

          Row(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: List.generate(
              5,
              (index) {
                final star = index + 1;

                return GestureDetector(
                  onTap: _isSubmitting
                      ? null
                      : () {
                          setState(() {
                            _rating = star;
                          });
                        },

                  child: Padding(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 5,
                    ),

                    child: AnimatedScale(
                      scale:
                          star <= _rating
                              ? 1.08
                              : 1.0,

                      duration:
                          const Duration(
                        milliseconds: 150,
                      ),

                      child: Icon(
                        star <= _rating
                            ? Icons.star_rounded
                            : Icons
                                .star_outline_rounded,

                        size: 43,

                        color: star <= _rating
                            ? Colors.amber
                            : secondaryTextColor
                                .withValues(
                                alpha: 0.65,
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          AnimatedSwitcher(
            duration:
                const Duration(
              milliseconds: 180,
            ),

            child: Text(
              _rating == 0
                  ? 'Selecione uma nota'
                  : _rating == 1
                      ? 'Muito ruim'
                      : _rating == 2
                          ? 'Ruim'
                          : _rating == 3
                              ? 'Regular'
                              : _rating == 4
                                  ? 'Boa'
                                  : 'Excelente',

              key: ValueKey(_rating),

              style: TextStyle(
                color: _rating == 0
                    ? secondaryTextColor
                    : primaryColor,

                fontSize: 14,

                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityReviews() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Row(
          children: [

            const Expanded(
              child: Text(
                'Avaliações da comunidade',

                style: TextStyle(
                  fontSize: 22,
                  fontWeight:
                      FontWeight.w700,
                  color: textColor,
                  letterSpacing: -0.2,
                ),
              ),
            ),

            if (!_isLoadingReviews)
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),

                decoration: BoxDecoration(
                  color:
                      primaryColor.withValues(
                    alpha: 0.12,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),

                child: Text(
                  '${_reviews.length}',

                  style:
                      const TextStyle(
                    color: primaryColor,
                    fontSize: 13,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 6),

        const Text(
          'Veja o que outras pessoas disseram sobre este local.',

          style: TextStyle(
            color: secondaryTextColor,
            fontSize: 14,
            height: 1.4,
          ),
        ),

        const SizedBox(height: 16),

        if (_isLoadingReviews)
          const Center(
            child: Padding(
              padding:
                  EdgeInsets.all(30),

              child:
                  CircularProgressIndicator(
                color: primaryColor,
              ),
            ),
          )

        else if (_reviewsError != null)
          _buildReviewsError()

        else if (_reviews.isEmpty)
          _buildNoReviews()

        else
          Column(
            children: _reviews
                .map(
                  _buildCommunityReview,
                )
                .toList(),
          ),
      ],
    );
  }

  Widget _buildCommunityReview(
    Map<String, dynamic> review,
  ) {
    final userName = _getReviewUserName(
      review,
    );

    final rating =
        _getReviewRating(review);

    final comment =
        review['comment']?.toString().trim() ??
            '';

    return Container(
      width: double.infinity,

      margin:
          const EdgeInsets.only(bottom: 12),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: surfaceColor,

        borderRadius:
            BorderRadius.circular(18),

        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.05,
          ),
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Container(
                width: 44,
                height: 44,

                decoration: BoxDecoration(
                  color:
                      primaryColor.withValues(
                    alpha: 0.14,
                  ),

                  shape: BoxShape.circle,

                  border: Border.all(
                    color:
                        primaryColor.withValues(
                      alpha: 0.20,
                    ),
                  ),
                ),

                child: const Icon(
                  Icons.person_rounded,
                  color: primaryColor,
                  size: 23,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(
                      userName,

                      maxLines: 1,

                      overflow:
                          TextOverflow.ellipsis,

                      style:
                          const TextStyle(
                        color: textColor,
                        fontSize: 15,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Row(
                      children: [

                        ...List.generate(
                          5,
                          (index) {
                            final star =
                                index + 1;

                            return Icon(
                              star <= rating
                                  ? Icons
                                      .star_rounded
                                  : Icons
                                      .star_outline_rounded,

                              size: 17,

                              color:
                                  star <= rating
                                      ? Colors.amber
                                      : secondaryTextColor
                                          .withValues(
                                          alpha: 0.55,
                                        ),
                            );
                          },
                        ),

                        const SizedBox(width: 7),

                        Text(
                          '$rating/5',

                          style:
                              const TextStyle(
                            color:
                                secondaryTextColor,
                            fontSize: 12,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (comment.isNotEmpty) ...[
            const SizedBox(height: 15),

            Container(
              width: double.infinity,

              padding:
                  const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color:
                    Colors.white.withValues(
                  alpha: 0.035,
                ),

                borderRadius:
                    BorderRadius.circular(
                  13,
                ),
              ),

              child: Text(
                comment,

                style: const TextStyle(
                  color: textColor,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ]

          else ...[
            const SizedBox(height: 12),

            const Text(
              'Usuário não adicionou um comentário.',

              style: TextStyle(
                color: secondaryTextColor,
                fontSize: 13,
                fontStyle:
                    FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

String _getReviewUserName(
  Map<String, dynamic> review,
) {
  final user = review['user'];

  // O backend atual envia o nome diretamente como String.
  if (user is String && user.trim().isNotEmpty) {
    return user.trim();
  }

  // Mantém compatibilidade caso futuramente
  // o backend envie um objeto de usuário.
  if (user is Map) {
    if (user['name'] != null) {
      final name = user['name'].toString().trim();

      if (name.isNotEmpty) {
        return name;
      }
    }

    if (user['username'] != null) {
      final username =
          user['username'].toString().trim();

      if (username.isNotEmpty) {
        return username;
      }
    }

    if (user['email'] != null) {
      final email =
          user['email'].toString().trim();

      if (email.isNotEmpty) {
        return email;
      }
    }
  }

  if (review['user_name'] != null) {
    final userName =
        review['user_name'].toString().trim();

    if (userName.isNotEmpty) {
      return userName;
    }
  }

  if (review['username'] != null) {
    final username =
        review['username'].toString().trim();

    if (username.isNotEmpty) {
      return username;
    }
  }

  return 'Usuário';
}

  int _getReviewRating(
    Map<String, dynamic> review,
  ) {
    final value = review['rating'];

    if (value is int) {
      return value.clamp(1, 5);
    }

    if (value is double) {
      return value.round().clamp(1, 5);
    }

    return int.tryParse(
          value?.toString() ?? '',
        )?.clamp(1, 5) ??
        0;
  }

  Widget _buildNoReviews() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(28),

      decoration: BoxDecoration(
        color: surfaceColor,

        borderRadius:
            BorderRadius.circular(18),

        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.05,
          ),
        ),
      ),

      child: Column(
        children: [

          Container(
            width: 60,
            height: 60,

            decoration: BoxDecoration(
              color:
                  primaryColor.withValues(
                alpha: 0.10,
              ),

              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.rate_review_outlined,
              color: primaryColor,
              size: 29,
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            'Ainda não há avaliações',

            textAlign: TextAlign.center,

            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight:
                  FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Seja a primeira pessoa a avaliar este local.',

            textAlign: TextAlign.center,

            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsError() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        color: surfaceColor,

        borderRadius:
            BorderRadius.circular(18),

        border: Border.all(
          color: Colors.redAccent
              .withValues(
            alpha: 0.15,
          ),
        ),
      ),

      child: Column(
        children: [

          const Icon(
            Icons.error_outline_rounded,
            color: Colors.redAccent,
            size: 30,
          ),

          const SizedBox(height: 10),

          const Text(
            'Não foi possível carregar as avaliações.',

            textAlign: TextAlign.center,

            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight:
                  FontWeight.w600,
            ),
          ),

          const SizedBox(height: 14),

          TextButton.icon(
            onPressed: _loadReviews,

            icon: const Icon(
              Icons.refresh_rounded,
              size: 18,
            ),

            label: const Text(
              'Tentar novamente',
            ),

            style: TextButton.styleFrom(
              foregroundColor:
                  primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitReview() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Selecione uma nota de 1 a 5 estrelas.',
          ),
        ),
      );

      return;
    }

    if (_isSubmitting) {
      return;
    }

    final placeId = widget.place['id'];

    if (placeId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível identificar o local.',
          ),
        ),
      );

      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final token =
          await _authService.getAccessToken();

      if (token == null) {
        if (!mounted) {
          return;
        }

        setState(() {
          _isSubmitting = false;
        });

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Sua sessão expirou. Faça login novamente.',
            ),
          ),
        );

        return;
      }

      final response = await http.post(
        Uri.parse(
          '$baseUrl/api/reviews/',
        ),

        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },

        body: jsonEncode({
          'place': placeId,
          'rating': _rating,
          'comment':
              _commentController.text.trim(),
        }),
      );

      print(
        '========== REVIEW API ==========',
      );

      print(
        'Status: ${response.statusCode}',
      );

      print(
        'Resposta: ${response.body}',
      );

      print(
        '================================',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isSubmitting = false;
      });

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Avaliação enviada com sucesso!',
            ),
          ),
        );

        _commentController.clear();

        setState(() {
          _rating = 0;
        });

        await _loadReviews();

        return;
      }

      dynamic data;

      try {
        data = jsonDecode(response.body);
      } catch (_) {
        data = null;
      }

      String message =
          'Não foi possível enviar a avaliação.';

      if (data is Map) {

        if (data['rating'] is List) {
          message =
              data['rating'][0].toString();

        } else if (data['comment'] is List) {
          message =
              data['comment'][0].toString();

        } else if (data['place'] is List) {
          message =
              data['place'][0].toString();

        } else if (data['detail'] != null) {
          message =
              data['detail'].toString();
        }
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );

    } catch (e) {

      if (!mounted) {
        return;
      }

      setState(() {
        _isSubmitting = false;
      });

      print(
        '========== ERRO REVIEW ==========',
      );

      print(e);

      print(
        '=================================',
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao enviar avaliação: $e',
          ),
        ),
      );
    }
  }
}