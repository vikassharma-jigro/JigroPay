import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../data/repositories/history_repository_impl.dart';
import '../../domain/usecases/get_transaction_history_usecase.dart';
import '../cubit/history_cubit.dart';
import '../cubit/history_state.dart';
import '../widgets/transaction_card_widget.dart';

import 'payment_details_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = HistoryRepositoryImpl();
    return BlocProvider(
      create: (context) => HistoryCubit(
        getTransactionHistoryUseCase: GetTransactionHistoryUseCase(repo),
      )..loadHistory(),
      child: const _HistoryView(),
    );
  }
}

class _HistoryView extends StatefulWidget {
  const _HistoryView();

  @override
  State<_HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<_HistoryView> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _filters = ['All', 'Success', 'Pending', 'Failed'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Transaction History',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 18,
            fontFamily: AppTypography.outfitBold,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (q) => context.read<HistoryCubit>().search(q),
                decoration: InputDecoration(
                  hintText: 'Search by operator, number, amount...',
                  hintStyle: const TextStyle(
                    fontFamily: AppTypography.outfitRegular,
                    fontSize: 13,
                    color: AppColors.grey,
                  ),
                  prefixIcon: const Icon(Icons.search, color: AppColors.grey),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            context.read<HistoryCubit>().search('');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),

          // 2. Filter Tabs
          BlocBuilder<HistoryCubit, HistoryState>(
            builder: (context, state) {
              final selectedFilter = state is HistoryLoaded
                  ? state.selectedFilter
                  : 'All';

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: _filters.map((filter) {
                    final isSelected = selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(
                          filter,
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: isSelected
                                ? AppTypography.outfitBold
                                : AppTypography.outfitRegular,
                            color: isSelected
                                ? AppColors.white
                                : AppColors.black,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.white,
                        showCheckmark: false,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.border,
                          ),
                        ),
                        onSelected: (_) =>
                            context.read<HistoryCubit>().filterByStatus(filter),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),

          // 3. Transactions List
          Expanded(
            child: BlocBuilder<HistoryCubit, HistoryState>(
              builder: (context, state) {
                if (state is HistoryLoading) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }

                if (state is HistoryError) {
                  return Center(
                    child: EmptyStateWidget(
                      icon: Icons.error_outline,
                      title: 'Failed to Load History',
                      subtitle: state.message,
                      actionLabel: 'Retry',
                      onAction: () =>
                          context.read<HistoryCubit>().loadHistory(),
                    ),
                  );
                }

                if (state is HistoryLoaded) {
                  final list = state.displayedTransactions;
                  if (list.isEmpty) {
                    return const EmptyStateWidget(
                      icon: Icons.receipt_long_outlined,
                      title: 'No Transactions Found',
                      subtitle:
                          'Your transaction records will appear here once you make payments.',
                    );
                  }

                  return RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () => context.read<HistoryCubit>().loadHistory(),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final tx = list[index];
                        return TransactionCardWidget(
                          transaction: tx,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentDetailsScreen(
                                  transactionData: tx.toJson(),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
