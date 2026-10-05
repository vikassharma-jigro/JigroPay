import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:go_router/go_router.dart';
import 'package:jigrotech/core/mixins/safe_set_state_mixin.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../history/data/models/transaction_model.dart';
import '../../data/repositories/recharge_repository_impl.dart';
import '../../domain/usecases/get_recent_recharges_usecase.dart';
import '../cubit/recent_recharges_cubit.dart';
import '../cubit/recent_recharges_state.dart';

class MobileRechargeNumberScreen extends StatelessWidget {
  const MobileRechargeNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = RechargeRepositoryImpl();
    return BlocProvider(
      create: (context) => RecentRechargesCubit(
        getRecentRechargesUseCase: GetRecentRechargesUseCase(repo),
      )..loadRecentRecharges(),
      child: const _MobileRechargeNumberView(),
    );
  }
}

class _MobileRechargeNumberView extends StatefulWidget {
  const _MobileRechargeNumberView();

  @override
  State<_MobileRechargeNumberView> createState() =>
      _MobileRechargeNumberViewState();
}

class _MobileRechargeNumberViewState extends State<_MobileRechargeNumberView>
    with SafeSetStateMixin {
  final TextEditingController _searchController = TextEditingController();
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  bool _isLoadingContacts = true;
  bool _permissionDenied = false;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
    _searchController.addListener(_filterContacts);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterContacts);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchContacts() async {
    final status = await Permission.contacts.request();
    if (!status.isGranted) {
      if (mounted) {
        safeSetState(() {
          _permissionDenied = true;
          _isLoadingContacts = false;
        });
      }
      return;
    }

    try {
      final contacts = await FlutterContacts.getContacts(
        withProperties: true,
        withThumbnail: true,
      );
      if (mounted) {
        safeSetState(() {
          _contacts = contacts;
          _filteredContacts = contacts;
          _isLoadingContacts = false;
        });
      }
    } catch (_) {
      if (mounted) {
        safeSetState(() {
          _isLoadingContacts = false;
        });
      }
    }
  }

  void _filterContacts() {
    final query = _searchController.text.trim().toLowerCase();
    safeSetState(() {
      if (query.isEmpty) {
        _filteredContacts = _contacts;
      } else {
        _filteredContacts = _contacts.where((contact) {
          final name = contact.displayName.toLowerCase();
          final hasNumberMatch = contact.phones.any((p) {
            final clean = p.number.replaceAll(RegExp(r'\D'), '');
            return clean.contains(query);
          });
          return name.contains(query) || hasNumberMatch;
        }).toList();
      }
    });
  }

  void _navigateToPlan(String rawNumber, [String? contactName]) {
    if (_isNavigating) return;

    final clean = rawNumber.replaceAll(RegExp(r'\D'), '');

    final number = clean.length > 10
        ? clean.substring(clean.length - 10)
        : clean;

    if (number.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 10-digit mobile number'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    _isNavigating = true;

    FocusManager.instance.primaryFocus?.unfocus();

    context.push(
      '/recharge-plans',
      extra: {'mobileNumber': number, 'contactName': contactName},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Mobile Recharge',
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search / Number Input Field
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Enter mobile number or name',
                  hintStyle: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 14,
                    fontFamily: AppTypography.outfitRegular,
                  ),
                  prefixIcon: const Icon(Icons.search, color: AppColors.grey),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: AppColors.grey),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                onChanged: (value) {
                  safeSetState(() {});
                  final clean = value.replaceAll(RegExp(r'\D'), '');
                  if (clean.length == 10) {
                    _navigateToPlan(clean);
                  }
                },
              ),
            ),
          ),

          // Quick Proceed for valid 10-digit entered in search
          if (_searchController.text.replaceAll(RegExp(r'\D'), '').length == 10)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 4.0,
              ),
              child: InkWell(
                onTap: () => _navigateToPlan(_searchController.text),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.bolt,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Recharge ${_searchController.text.replaceAll(RegExp(r'\D'), '')}',
                          style: const TextStyle(
                            fontFamily: AppTypography.outfitBold,
                            color: AppColors.primary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Recent Recharges Strip
          BlocBuilder<RecentRechargesCubit, RecentRechargesState>(
            builder: (context, state) {
              if (state is RecentRechargesLoading) {
                return const SizedBox(
                  height: 48,
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                    ),
                  ),
                );
              }
              if (state is RecentRechargesLoaded &&
                  state.recharges.isNotEmpty) {
                return _buildRecentRechargesList(state.recharges);
              }
              return const SizedBox.shrink();
            },
          ),

          // Section Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Text(
              'Contacts',
              style: TextStyle(
                color: AppColors.black,
                fontSize: 16,
                fontFamily: AppTypography.outfitBold,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Contacts List
          Expanded(child: _buildContactsView()),
        ],
      ),
    );
  }

  Widget _buildRecentRechargesList(List<TransactionModel> recents) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Recharges',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 15,
                  fontFamily: AppTypography.outfitBold,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${recents.length}',
                style: const TextStyle(
                  color: AppColors.grey,
                  fontSize: 13,
                  fontFamily: AppTypography.outfitMedium,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 76,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: recents.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final item = recents[index];
              final itemNumber = item.number ?? '';
              final itemOperator = item.operator ?? '';
              return InkWell(
                onTap: () => _navigateToPlan(itemNumber, itemOperator),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 160,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        itemOperator.isNotEmpty ? itemOperator : itemNumber,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontFamily: AppTypography.outfitBold,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        itemNumber,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.grey,
                          fontFamily: AppTypography.outfitRegular,
                        ),
                      ),
                      if (item.amount > 0)
                        Text(
                          CurrencyFormatter.format(item.amount),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 6),
      ],
    );
  }

  Widget _buildContactsView() {
    if (_isLoadingContacts) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (_permissionDenied) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.contacts, size: 48, color: AppColors.grey),
            const SizedBox(height: 12),
            const Text(
              'Contact permission denied',
              style: TextStyle(
                fontFamily: AppTypography.outfitMedium,
                fontSize: 15,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => openAppSettings(),
              child: const Text('Open Settings'),
            ),
          ],
        ),
      );
    }

    if (_filteredContacts.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.contacts_outlined,
        title: 'No Contacts Found',
        subtitle: 'No contacts match your search query',
      );
    }

    return ListView.builder(
      itemCount: _filteredContacts.length,
      itemBuilder: (context, index) {
        final contact = _filteredContacts[index];
        final number = contact.phones.isNotEmpty
            ? contact.phones.first.number
            : 'No number';

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            backgroundImage: contact.thumbnail != null
                ? MemoryImage(contact.thumbnail!)
                : null,
            child: contact.thumbnail == null
                ? const Icon(Icons.person, color: AppColors.primary)
                : null,
          ),
          title: Text(
            contact.displayName,
            style: const TextStyle(
              fontSize: 15,
              fontFamily: AppTypography.outfitMedium,
              color: AppColors.black,
            ),
          ),
          subtitle: Text(
            number,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.grey,
              fontFamily: AppTypography.outfitRegular,
            ),
          ),
          onTap: () {
            if (contact.phones.isNotEmpty) {
              _navigateToPlan(contact.phones.first.number, contact.displayName);
            }
          },
        );
      },
    );
  }
}
