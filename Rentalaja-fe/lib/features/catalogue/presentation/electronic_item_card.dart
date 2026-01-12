import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../domain/electronic_item.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../auth/domain/user.dart';
import 'catalogue_controller.dart';

class ElectronicItemCard extends ConsumerWidget {
  final ElectronicItem item;

  const ElectronicItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(authControllerProvider);
    final isAdmin = userState.value?.role == UserRole.admin;

    // Format: Rp 200.000
    final priceString = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(item.pricePerDay);

    final isAvailable = item.status == ItemStatus.available && item.stock > 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating Badge & Admin Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.averageRating != null && item.averageRating! > 0)
                      Icon(Icons.star, color: Colors.amber, size: 12),
                    if (item.averageRating != null && item.averageRating! > 0)
                      const SizedBox(width: 2),
                    Text(
                      (item.averageRating != null && item.averageRating! > 0)
                          ? item.averageRating!.toStringAsFixed(1)
                          : 'New',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (isAdmin)
                Row(
                  children: [
                    InkWell(
                      onTap: () =>
                          GoRouter.of(context).push('/edit-item/${item.id}'),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.edit, size: 16, color: Colors.blue),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Product'),
                            content: Text(
                              'Are you sure you want to delete ${item.name}?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  ref
                                      .read(
                                        transactionControllerProvider.notifier,
                                      )
                                      .deleteProduct(
                                        userState.value!.token!,
                                        item.id,
                                      );
                                },
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.delete, size: 16, color: Colors.red),
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Image
          Expanded(
            child: Center(
              child: Image.network(
                item.imageUrl,
                errorBuilder: (context, error, stackTrace) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.broken_image,
                        size: 24,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.imageUrl.split('/').last, // Show filename
                        style: const TextStyle(fontSize: 8, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 6),

          // Name
          Text(
            item.name,
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 15),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          // Price & Status Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  priceString,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF448AFF),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Bordered Compact Status
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isAvailable ? const Color(0xFF448AFF) : Colors.red,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isAvailable ? 'Avail' : 'Full',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isAvailable ? const Color(0xFF448AFF) : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Detail Button - Full Width & Slim
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to Detail Page
                GoRouter.of(context).push('/detail/${item.id}');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFC107), // Amber
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8),
                visualDensity: VisualDensity.compact,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                'Detail',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
