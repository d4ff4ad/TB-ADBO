import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:cross_file/cross_file.dart';

import '../../catalogue/domain/electronic_item.dart';
import 'catalogue_controller.dart';
import '../../auth/presentation/auth_controller.dart';

class BookingPage extends ConsumerStatefulWidget {
  final ElectronicItem item;
  final DateTime startDate;
  final DateTime endDate;

  const BookingPage({
    super.key,
    required this.item,
    required this.startDate,
    required this.endDate,
  });

  @override
  ConsumerState<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends ConsumerState<BookingPage> {
  TimeOfDay? _pickupTime;
  TimeOfDay? _returnTime;
  String _paymentMethod = 'bank_transfer'; // 'bank_transfer' or 'qris'
  XFile? _paymentProof;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _paymentProof = image;
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final rentalDays = widget.endDate.difference(widget.startDate).inDays + 1;
    final totalPrice = widget.item.pricePerDay * rentalDays;
    final totalPriceString = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(totalPrice);

    final transactionState = ref.watch(transactionControllerProvider);

    // Listen to transaction result
    ref.listen(transactionControllerProvider, (previous, next) {
      next.when(
        data: (_) {
          if (previous?.isLoading == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Booking Berhasil! Silakan tunggu konfirmasi admin.',
                ),
                backgroundColor: Colors.green,
              ),
            );
            context.go('/home'); // Go back to Home/Catalogue
          }
        },
        error: (err, stack) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Booking Failed: $err'),
              backgroundColor: Colors.red,
            ),
          );
        },
        loading: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Konfirmasi Booking',
          style: GoogleFonts.poppins(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Summary Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.item.imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.item.name,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${rentalDays} Hari (${DateFormat('dd MMM').format(widget.startDate)} - ${DateFormat('dd MMM').format(widget.endDate)})',
                          style: GoogleFonts.inter(color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          totalPriceString,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF448AFF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Text(
              'Atur Jadwal',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),

            // Time Pickers
            Row(
              children: [
                Expanded(
                  child: _buildTimePicker(
                    'Jam Pengambilan',
                    _pickupTime,
                    (t) => setState(() => _pickupTime = t),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTimePicker(
                    'Jam Pengembalian',
                    _returnTime,
                    (t) => setState(() => _returnTime = t),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            Text(
              'Metode Pembayaran',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),

            // Payment Method Selection
            Column(
              children: [
                _buildPaymentOption(
                  'Transfer Bank (BCA)',
                  'bank_transfer',
                  Icons.account_balance,
                ),
                const SizedBox(height: 8),
                _buildPaymentOption('QRIS', 'qris', Icons.qr_code),
              ],
            ),

            const SizedBox(height: 16),
            // Payment Info Display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: _paymentMethod == 'bank_transfer'
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Silakan Transfer ke:',
                          style: GoogleFonts.inter(color: Colors.blue[800]),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'BCA 123-456-7890',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.blue[900],
                          ),
                        ),
                        Text(
                          'a.n Rental Tech',
                          style: GoogleFonts.inter(color: Colors.blue[800]),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        const Icon(Icons.qr_code_2, size: 100),
                        Text(
                          'Scan QRIS di atas',
                          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
            ),

            const SizedBox(height: 24),
            Text(
              'Bukti Pembayaran',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),

            // Upload Proof
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _paymentProof == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.cloud_upload_outlined,
                            size: 40,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap untuk upload bukti transfer',
                            style: GoogleFonts.inter(color: Colors.grey),
                          ),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: kIsWeb
                            ? Image.network(
                                _paymentProof!.path,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(_paymentProof!.path),
                                fit: BoxFit.cover,
                              ),
                      ),
              ),
            ),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed:
                    (_pickupTime != null &&
                        _returnTime != null &&
                        _paymentProof != null &&
                        !transactionState.isLoading)
                    ? () {
                        final user = ref.read(authControllerProvider).value;
                        if (user?.token == null) return;

                        ref
                            .read(transactionControllerProvider.notifier)
                            .createTransaction(
                              token: user!.token!,
                              productId: widget.item.id,
                              startDate: widget.startDate,
                              endDate: widget.endDate,
                              pickupTime: _pickupTime!,
                              returnTime: _returnTime!,
                              paymentMethod: _paymentMethod,
                              paymentProof: _paymentProof!,
                            );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF448AFF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: transactionState.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Konfirmasi Booking',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker(
    String label,
    TimeOfDay? selectedTime,
    Function(TimeOfDay) onSelect,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[700]),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final t = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (t != null) onSelect(t);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time, size: 18, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  selectedTime?.format(context) ?? '--:--',
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption(String label, String value, IconData icon) {
    return GestureDetector(
      onTap: () => setState(() => _paymentMethod = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: _paymentMethod == value
              ? Colors.blue.withOpacity(0.05)
              : Colors.white,
          border: Border.all(
            color: _paymentMethod == value ? Colors.blue : Colors.grey[300]!,
            width: _paymentMethod == value ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: _paymentMethod == value ? Colors.blue : Colors.grey,
            ),
            const SizedBox(width: 12),
            Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            const Spacer(),
            if (_paymentMethod == value)
              const Icon(Icons.check_circle, color: Colors.blue),
          ],
        ),
      ),
    );
  }
}
