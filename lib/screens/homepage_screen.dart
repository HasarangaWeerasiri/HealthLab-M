import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'userprofile_screen.dart';
import 'create_experiments_screen.dart';
import 'experiment_details_screen.dart';
import '../widgets/experiment_details_modal.dart';
import 'my_experiments_screen.dart';
import 'qr_scanner_screen.dart';
import '../utils/theme_colors.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String? _selectedCategory;
  late final List<String> _categories;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _categories = const <String>[
      'Gym & Strength',
      'Nutrition & Food',
      'Sleep & Recovery',
      'Mental Wellness',
      'Daily Exercise',
      'Energy & Focus',
      'Heart & Health',
      'Hydration',
      'Supplements',
    ];
    _searchCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.backgroundColor(context),
      body: Column(
        children: [
          // Header Section
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return Container(
                decoration: BoxDecoration(
                  color: themeProvider.headerColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Scanner Icon Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Explore the Lab',
                          style: TextStyle(
                            color: themeProvider.headerTextColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const QrScannerScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.asset(
                              'assets/icons/qr-code.png',
                              width: 24,
                              height: 24,
                              color: themeProvider.headerTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Search Bar
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: themeProvider.searchBarColor,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: _searchCtrl,
                        decoration: InputDecoration(
                          hintText: 'Search experiments',
                          hintStyle: TextStyle(
                            color: themeProvider.searchTextColor,
                            fontSize: 16,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: themeProvider.searchTextColor,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                        ),
                        style: TextStyle(
                          color: themeProvider.searchTextColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
              );
            },
          ),
          // Main Content Area
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final selected = _selectedCategory == cat;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategory = selected ? null : cat),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: selected ? themeProvider.categorySelectedColor : themeProvider.categoryUnselectedColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.15)),
                          ),
                          child: Text(
                            cat,
                            style: TextStyle(
                              color: themeProvider.isDarkMode 
                                  ? Colors.white.withOpacity(0.9) 
                                  : Colors.black.withOpacity(0.7),
                              fontSize: 12
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _experimentsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Consumer<ThemeProvider>(
                    builder: (context, themeProvider, _) {
                      return Center(child: CircularProgressIndicator(color: themeProvider.buttonColor));
                    },
                  );
                }
                if (snapshot.hasError) {
                  return Consumer<ThemeProvider>(
                    builder: (context, themeProvider, _) {
                      return Center(
                        child: Text(
                          'Failed to load experiments: ${snapshot.error}',
                          style: TextStyle(color: themeProvider.textColor),
                        ),
                      );
                    },
                  );
                }
                if (!snapshot.hasData) {
                  return Consumer<ThemeProvider>(
                    builder: (context, themeProvider, _) {
                      return Center(child: Text('No experiments', style: TextStyle(color: themeProvider.textColor)));
                    },
                  );
                }
                final docs = snapshot.data!.docs;
                final query = _searchCtrl.text.trim().toLowerCase();
                final filtered = docs.where((d) {
                  final data = d.data();
                  // Filter out deleted experiments
                  if (data['deleted'] == true) return false;
                  
                  final title = (data['title'] as String? ?? '').toLowerCase();
                  final desc = (data['description'] as String? ?? '').toLowerCase();
                  if (_selectedCategory != null && data['category'] != _selectedCategory) return false;
                  if (query.isNotEmpty && !(title.contains(query) || desc.contains(query))) return false;
                  return true;
                }).toList();
                
                // Shuffle the filtered experiments for variety
                filtered.shuffle(_random);

                if (filtered.isEmpty) {
                  return Consumer<ThemeProvider>(
                    builder: (context, themeProvider, _) {
                      return Center(child: Text('No matching experiments', style: TextStyle(color: themeProvider.textColor)));
                    },
                  );
                }

                return Consumer<ThemeProvider>(
                  builder: (context, themeProvider, _) {
                    return RefreshIndicator(
                      onRefresh: _onRefresh,
                      color: themeProvider.categorySelectedColor,
                      backgroundColor: themeProvider.headerColor,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final doc = filtered[index];
                          final data = doc.data();
                          return _ExperimentCard(
                            data: {
                              'id': doc.id,
                              ...data,
                            },
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    // Add a small delay to show the refresh indicator
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // Trigger a rebuild to shuffle the experiments
    setState(() {
      // The shuffle will happen in the filtering logic
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _experimentsStream() {
    return FirebaseFirestore.instance
        .collection('experiments')
        .where('published', isEqualTo: true)
        .snapshots();
  }
}

class _ExperimentCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _ExperimentCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final title = (data['title'] as String?) ?? 'Untitled';
    final desc = (data['description'] as String?) ?? '';
    final emojisRaw = (data['emojis'] as List<dynamic>? ?? []);
    final emojis = emojisRaw
        .whereType<String>()
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    final emoji = emojis.isNotEmpty ? emojis.first : '🧪';
    // Build a display string that safely fits multiple emojis in the square area
    final emojiDisplay = emojis.isNotEmpty
        ? (emojis.length == 1 ? emojis.first : emojis.take(4).join(' '))
        : emoji;

  return Consumer<ThemeProvider>(
    builder: (context, themeProvider, _) {
      return GestureDetector(
        onTap: () => _navigateToExperimentDetails(context, data),
        child: Container(
          decoration: BoxDecoration(
            color: themeProvider.cardColor,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title across the top (left aligned)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: themeProvider.textSecondaryColor,
                    fontSize: 39,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
              ),
            const SizedBox(height: 14),
            // Two columns: left emoji (square), right description
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 4,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final side = constraints.biggest.shortestSide;
                        // Give a large baseline font size and let FittedBox scale it to fit
                        final baselineSize = side; // 1.0x of the square side
                        return Center(
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              emojiDisplay,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: baselineSize),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Flexible(
                  flex: 6,
                  child: Text(
                    desc,
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: themeProvider.textSecondaryColor,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            if ((data['category'] as String?) != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.white.withOpacity(0.28)),
                  ),
                  child: Text(
                    data['category'],
                    style: TextStyle(
                      color: themeProvider.textSecondaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
    },
  );
  }

  void _navigateToExperimentDetails(BuildContext context, Map<String, dynamic> data) {
    showExperimentDetailsModal(context, data);
  }
}
