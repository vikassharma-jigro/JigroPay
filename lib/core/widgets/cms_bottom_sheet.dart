import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:jigrotech/core/mixins/ui_feedback_mixin.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_colors.dart';
import '../constants/app_endpoints.dart';
import '../constants/app_typography.dart';
import '../network/api_client.dart';

/// Bottom sheet widget to display CMS pages (Terms & Conditions, Privacy Policy).
class CmsBottomSheet {
  CmsBottomSheet._();

  static void show(
    BuildContext context, {
    required String title,
    required String pageKey,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CmsContentSheet(title: title, pageKey: pageKey),
    );
  }
}

class _CmsContentSheet extends StatefulWidget {
  const _CmsContentSheet({required this.title, required this.pageKey});

  final String title;
  final String pageKey;

  @override
  State<_CmsContentSheet> createState() => _CmsContentSheetState();
}

class _CmsContentSheetState extends State<_CmsContentSheet>
    with UiFeedbackMixin {
  bool _isLoading = true;
  String _title = '';
  String _content = '';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _title = widget.title;
    _fetchCms();
  }

  Future<void> _fetchCms() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final client = ApiClient.instance;
      final response = await client.get('${AppEndpoints.cms}${widget.pageKey}');
      final data = response.data;

      if (!mounted) return;

      if (data is Map) {
        final pageData = data['page'] ?? data['data'] ?? data;
        if (pageData is Map) {
          final fetchedTitle = pageData['title']?.toString();
          final fetchedContent =
              pageData['description']?.toString() ??
              pageData['content']?.toString() ??
              pageData['body']?.toString();

          if (fetchedContent != null && fetchedContent.trim().isNotEmpty) {
            setState(() {
              if (fetchedTitle != null && fetchedTitle.trim().isNotEmpty) {
                _title = fetchedTitle;
              }
              _content = fetchedContent;
              _isLoading = false;
            });
            return;
          }
        }
      }

      setState(() {
        _errorMessage = 'No content available.';
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Failed to load content. Please try again.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppTypography.outfitBold,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.lightWhite1,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 20,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, color: AppColors.border),
              Expanded(child: _buildBody(scrollController)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(ScrollController scrollController) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator.adaptive(),
            const SizedBox(height: 16),
            Text(
              'Loading $_title...',
              style: const TextStyle(
                color: AppColors.grey,
                fontSize: 14,
                fontFamily: AppTypography.outfitRegular,
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null && _content.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.info_outline, size: 48, color: AppColors.grey),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                style: const TextStyle(
                  color: AppColors.grey,
                  fontSize: 14,
                  fontFamily: AppTypography.outfitRegular,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchCms,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Retry',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: HtmlWidget(
        _content,
        onTapUrl: (url) async {
          try {
            final uri = Uri.parse(url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
              return true;
            } else {
              showErrorToast('Could not open link: $url');
            }
          } catch (e) {
            showErrorToast('Could not open link');
          }
          return false;
        },
      ),
    );
  }
}
