import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../catalogue/domain/electronic_item.dart';
import 'electronic_item_card.dart';
import 'catalogue_controller.dart';
import '../../auth/domain/user.dart';
import '../../auth/presentation/auth_controller.dart';

class CataloguePage extends ConsumerStatefulWidget {
  const CataloguePage({super.key});

  @override
  ConsumerState<CataloguePage> createState() => _CataloguePageState();
}

class _CataloguePageState extends ConsumerState<CataloguePage> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: _buildHomeView(),
    );
  }

  Widget _buildHomeView() {
    return SafeArea(
      child: Column(
        children: [
          // Header Section (Blue Background)
          Container(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            decoration: const BoxDecoration(
              color: Color(0xFF448AFF),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: Consumer(
              builder: (context, ref, child) {
                final user = ref.watch(authControllerProvider).value;
                final isAdmin = user?.role == UserRole.admin;
                final name = user?.name ?? 'User';

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isAdmin ? 'Selamat Datang, Admin' : 'E-Rent Aja',
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              isAdmin ? name : 'instant and easy rental!',
                              style: GoogleFonts.inter(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                context.push('/chats');
                              },
                              icon: const Icon(Icons.chat, color: Colors.white),
                            ),
                            const SizedBox(width: 8),
                            const CircleAvatar(
                              backgroundColor: Colors.white24,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Search Bar
                    TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Search',
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Content Section
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                return ref.refresh(productsProvider.future);
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Categories
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildCategoryChip('All'),
                          const SizedBox(width: 8),
                          _buildCategoryChip('Camera'),
                          const SizedBox(width: 8),
                          _buildCategoryChip('Phone'),
                          const SizedBox(width: 8),
                          _buildCategoryChip('Accessories'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Grid Grid
                    Expanded(
                      child: ref
                          .watch(productsProvider)
                          .when(
                            data: (items) {
                              if (items.isEmpty) {
                                return const Center(
                                  child: Text('No items available yet.'),
                                );
                              }
                              return GridView.builder(
                                physics:
                                    const AlwaysScrollableScrollPhysics(), // Ensure refresh works even if list is short
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio:
                                          0.75, // Adjusted for better fit
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                    ),
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  return ElectronicItemCard(item: items[index]);
                                },
                              );
                            },
                            error: (err, stack) => Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                    size: 48,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Error: $err',
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () =>
                                        ref.refresh(productsProvider),
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            ),
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    final isSelected = _selectedCategory == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF448AFF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
          ],
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
