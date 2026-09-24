import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import 'empty_state_widget.dart';
import 'loading_overlay.dart';

/// Data model for a single operator/biller item.
class OperatorItem {
  const OperatorItem({
    required this.name,
    required this.opcode,
    this.iconUrl,
    this.extra,
  });

  final String name;
  final String opcode;
  final String? iconUrl;

  /// Additional fields from the raw API response (e.g. circle, category).
  final Map<String, dynamic>? extra;

  /// Constructs an [OperatorItem] from a raw API Map.
  /// Handles all known key variations from the existing API responses.
  factory OperatorItem.fromMap(Map<String, dynamic> map) {
    final name = map['name']?.toString() ??
        map['operator_name']?.toString() ??
        map['biller_name']?.toString() ??
        map['company']?.toString() ??
        map['company_name']?.toString() ??
        '';

    final opcode = map['operator_code']?.toString() ??
        map['opcode']?.toString() ??
        map['company_code']?.toString() ??
        map['biller_id']?.toString() ??
        map['id']?.toString() ??
        'A';

    final iconUrl = map['image']?.toString() ??
        map['icon']?.toString() ??
        map['logo']?.toString() ??
        map['operator_image']?.toString();

    return OperatorItem(
      name: name,
      opcode: opcode,
      iconUrl: (iconUrl != null && iconUrl.isNotEmpty) ? iconUrl : null,
      extra: Map<String, dynamic>.from(map),
    );
  }
}

// ── Config ────────────────────────────────────────────────────────────────────

/// Configures the appearance of [GenericOperatorListWidget].
class OperatorListConfig {
  const OperatorListConfig({
    this.title = 'Select Provider',
    this.searchHint = 'Search by provider name',
    this.emptyTitle = 'No Providers Found',
    this.emptySubtitle = 'Try a different search term.',
    this.fallbackIcon = Icons.business_outlined,
    this.fallbackIconColor,
  });

  final String title;
  final String searchHint;
  final String emptyTitle;
  final String emptySubtitle;
  final IconData fallbackIcon;
  final Color? fallbackIconColor;
}

// ── Widget ────────────────────────────────────────────────────────────────────

/// Generic reusable operator/biller list widget.
///
/// **Replaces** the copy-pasted operator list UI in:
/// - `WaterServiceScreen`
/// - `BroadbandServiceScreen`
/// - `InsuranceProviderScreen`
/// - `GasServicesScreen`
/// - `CableServiceScreen`
/// - `MunicipalScreen`
/// - `LandlineServiceScreen`
/// - `DthServiceScreen`
///
/// The parent screen passes [operators] (already fetched via its Cubit) and
/// provides [onOperatorSelected] to handle navigation.
///
/// **Lazy API loading**: This widget does NOT call any API itself.
/// The parent Cubit fetches data when the screen opens (in [initState]).
///
/// Usage:
/// ```dart
/// GenericOperatorListWidget(
///   operators: state.operators,
///   isLoading: state is OperatorsLoading,
///   onOperatorSelected: (op) => context.push('/water/pay', extra: op),
///   config: const OperatorListConfig(title: 'Water Providers'),
/// )
/// ```
class GenericOperatorListWidget extends StatefulWidget {
  const GenericOperatorListWidget({
    super.key,
    required this.operators,
    required this.onOperatorSelected,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
    this.config = const OperatorListConfig(),
    this.showAppBar = true,
    this.appBarLeading,
  });

  final List<OperatorItem> operators;
  final ValueChanged<OperatorItem> onOperatorSelected;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final OperatorListConfig config;
  final bool showAppBar;
  final Widget? appBarLeading;

  @override
  State<GenericOperatorListWidget> createState() =>
      _GenericOperatorListWidgetState();
}

class _GenericOperatorListWidgetState
    extends State<GenericOperatorListWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<OperatorItem> _filtered = [];

  @override
  void initState() {
    super.initState();
    _filtered = widget.operators;
    _searchController.addListener(_onSearch);
  }

  @override
  void didUpdateWidget(GenericOperatorListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.operators != widget.operators) {
      _applyFilter(_searchController.text);
    }
  }

  void _onSearch() => _applyFilter(_searchController.text);

  void _applyFilter(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? widget.operators
          : widget.operators
              .where((op) => op.name.toLowerCase().contains(q))
              .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: widget.showAppBar
          ? _buildAppBar(context)
          : null,
      body: LoadingOverlay(
        isLoading: widget.isLoading && widget.operators.isEmpty,
        child: Column(
          children: [
            _SearchBar(
              controller: _searchController,
              hint: widget.config.searchHint,
            ),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: widget.appBarLeading ??
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.black, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
      title: Text(widget.config.title, style: AppTypography.h3),
      centerTitle: true,
    );
  }

  Widget _buildBody() {
    if (widget.errorMessage != null) {
      return ErrorStateWidget(
        message: widget.errorMessage!,
        onRetry: widget.onRetry,
      );
    }

    if (widget.isLoading && widget.operators.isEmpty) {
      return const PageLoader();
    }

    if (_filtered.isEmpty) {
      return EmptyStateWidget(
        icon: widget.config.fallbackIcon,
        title: widget.config.emptyTitle,
        subtitle: widget.config.emptySubtitle,
        iconColor: widget.config.fallbackIconColor ??
            AppColors.primary.withValues(alpha: 0.5),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: _filtered.length,
      separatorBuilder: (_, __) => Divider(
          color: AppColors.lightGrey.withValues(alpha: 0.6), height: 1),
      itemBuilder: (context, index) => _OperatorTile(
        item: _filtered[index],
        onTap: () => widget.onOperatorSelected(_filtered[index]),
        fallbackIcon: widget.config.fallbackIcon,
        fallbackIconColor: widget.config.fallbackIconColor,
      ),
    );
  }
}

// ── Private sub-widgets ───────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.hint});
  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: TextField(
        controller: controller,
        style: AppTypography.inputText,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTypography.inputHint,
          prefixIcon:
              const Icon(Icons.search_rounded, color: AppColors.grey, size: 22),
          filled: true,
          fillColor: AppColors.lightWhite1,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.lightGrey, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.primary, width: 1.8),
          ),
        ),
      ),
    );
  }
}

class _OperatorTile extends StatelessWidget {
  const _OperatorTile({
    required this.item,
    required this.onTap,
    required this.fallbackIcon,
    this.fallbackIconColor,
  });

  final OperatorItem item;
  final VoidCallback onTap;
  final IconData fallbackIcon;
  final Color? fallbackIconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            // Logo
            _OperatorLogo(
              iconUrl: item.iconUrl,
              fallbackIcon: fallbackIcon,
              fallbackIconColor: fallbackIconColor,
            ),
            const SizedBox(width: 14),

            // Name
            Expanded(
              child: Text(
                item.name,
                style: AppTypography.label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Chevron
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _OperatorLogo extends StatelessWidget {
  const _OperatorLogo({
    this.iconUrl,
    required this.fallbackIcon,
    this.fallbackIconColor,
  });

  final String? iconUrl;
  final IconData fallbackIcon;
  final Color? fallbackIconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.lightWhite1,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.lightGrey, width: 0.8),
      ),
      child: iconUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                iconUrl!,
                width: 44,
                height: 44,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                  fallbackIcon,
                  size: 22,
                  color: fallbackIconColor ?? AppColors.primary,
                ),
              ),
            )
          : Icon(
              fallbackIcon,
              size: 22,
              color: fallbackIconColor ?? AppColors.primary,
            ),
    );
  }
}
