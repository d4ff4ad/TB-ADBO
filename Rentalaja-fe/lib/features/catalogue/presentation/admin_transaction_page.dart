import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/auth_controller.dart';
import 'catalogue_controller.dart';
import '../../catalogue/domain/transaction.dart'
    as model; // Alias to avoid conflict if any

class AdminTransactionPage extends ConsumerWidget {
  const AdminTransactionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(authControllerProvider);
    final token = userState.value?.token ?? '';
    final user = userState.value; // Added to access user!.token! in new code

    final transactionsAsync = ref.watch(adminTransactionsProvider(token));

    final transactionState = ref.watch(transactionControllerProvider);
    final isLoading = transactionState.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Orders')),
      body: transactionsAsync.when(
        data: (transactions) {
          if (transactions.isEmpty) {
            return const Center(child: Text('No orders found'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order ID: ${transaction.id}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Product: ${transaction.product?.name ?? 'Unknown'}',
                      ),
                      Text('User: ${transaction.userId}'),
                      // If backend supports user name relation, we could show it if mapped
                      // Currently just ID or if we added user object to transaction json
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text('Status: '),
                          _buildStatusChip(transaction.status),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Dates: ${transaction.startDate.toIso8601String().split('T')[0]} - ${transaction.endDate.toIso8601String().split('T')[0]}',
                      ),
                      Text('Total Price: Rp ${transaction.totalPrice}'),
                      const SizedBox(height: 10),
                      if (transaction.paymentProof != null) ...[
                        const Text(
                          'Payment Proof:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => Dialog(
                                child: Image.network(
                                  transaction.paymentProof!,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.network(
                              transaction.paymentProof!,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, _, __) =>
                                  const Center(child: Icon(Icons.broken_image)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                      if (transaction.status == 'pending') ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      try {
                                        await ref
                                            .read(
                                              transactionControllerProvider
                                                  .notifier,
                                            )
                                            .updateStatus(
                                              token: user!.token!,
                                              id: transaction.id,
                                              status: 'cancelled',
                                            );
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Order rejected successfully',
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Failed to update status: $e',
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text('Reject'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      try {
                                        await ref
                                            .read(
                                              transactionControllerProvider
                                                  .notifier,
                                            )
                                            .updateStatus(
                                              token: user!.token!,
                                              id: transaction.id,
                                              status: 'active',
                                            );
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Order approved successfully',
                                              ),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Failed to update status: $e',
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text('Approve'),
                            ),
                          ],
                        ),
                      ],
                      if (transaction.status == 'active') ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      try {
                                        await ref
                                            .read(
                                              transactionControllerProvider
                                                  .notifier,
                                            )
                                            .updateStatus(
                                              token: user!.token!,
                                              id: transaction.id,
                                              status: 'finished',
                                            );
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Order marked as finished',
                                              ),
                                              backgroundColor: Colors.blue,
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Failed to update status: $e',
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text('Finish Order'),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'active':
        color = Colors.green;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      case 'finished':
        color = Colors.blue;
        break;
      case 'pending':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }
    return Chip(
      label: Text(
        status.toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
    );
  }
}
