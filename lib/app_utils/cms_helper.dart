import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../getx_controller/auth_controller.dart';
import 'app_colors.dart';
import 'font_family.dart';
import 'text_widget.dart';

class CmsHelper {
  static bool _isModalOpen = false;

  /// Opens CMS bottom sheet with rich HTML rendering and proper alignment.
  static Future<void> openCmsBottomSheet(
    BuildContext context,
    String pageTitle,
    String key,
  ) async {
    if (_isModalOpen) return;
    _isModalOpen = true;

    try {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (ctx) {
          return CmsBottomSheetWidget(
            initialTitle: pageTitle,
            cmsKey: key,
          );
        },
      );
    } finally {
      _isModalOpen = false;
    }
  }

  /// Reusable HTML widget for properly rendering and aligning CMS HTML content.
  static Widget buildHtmlViewer(String htmlData) {
    if (htmlData.trim().isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: text(
            "No content available.",
            textColor: greyColor,
            fontSize: 14,
            fontFamily: FontFamily.plusJakartaSansMedium,
          ),
        ),
      );
    }

    return HtmlWidget(
      htmlData,
      textStyle: TextStyle(
        color: blackColor.withValues(alpha: 0.85),
        fontSize: 13.5,
        fontFamily: FontFamily.plusJakartaSansRegular,
        height: 1.6,
        letterSpacing: 0.15,
      ),
      customStylesBuilder: (element) {
        switch (element.localName) {
          case 'h1':
            return {
              'font-size': '20px',
              'font-weight': '700',
              'color': '#1b467d',
              'margin-top': '20px',
              'margin-bottom': '10px',
            };
          case 'h2':
            return {
              'font-size': '17px',
              'font-weight': '700',
              'color': '#1b467d',
              'margin-top': '18px',
              'margin-bottom': '8px',
            };
          case 'h3':
            return {
              'font-size': '15px',
              'font-weight': '700',
              'color': '#1b467d',
              'margin-top': '18px',
              'margin-bottom': '8px',
            };
          case 'h4':
          case 'h5':
          case 'h6':
            return {
              'font-size': '14px',
              'font-weight': '600',
              'color': '#212121',
              'margin-top': '14px',
              'margin-bottom': '6px',
            };
          case 'p':
            return {
              'margin-top': '0px',
              'margin-bottom': '12px',
              'line-height': '1.6',
              'text-align': 'left',
            };
          case 'a':
            return {
              'color': '#8c2ac4',
              'text-decoration': 'underline',
              'font-weight': '600',
            };
          case 'ul':
          case 'ol':
            return {
              'margin-top': '4px',
              'margin-bottom': '12px',
              'padding-left': '20px',
            };
          case 'li':
            return {
              'margin-bottom': '6px',
              'line-height': '1.5',
            };
          case 'strong':
          case 'b':
            return {
              'font-weight': '700',
              'color': '#111827',
            };
          default:
            return null;
        }
      },
      onTapUrl: (url) async {
        try {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
            return true;
          } else {
            Fluttertoast.showToast(msg: "Could not open link: $url");
          }
        } catch (e) {
          debugPrint("Failed to launch URL: $e");
          Fluttertoast.showToast(msg: "Could not open link");
        }
        return false;
      },
    );
  }
}

class CmsBottomSheetWidget extends StatefulWidget {
  final String initialTitle;
  final String cmsKey;

  const CmsBottomSheetWidget({
    super.key,
    required this.initialTitle,
    required this.cmsKey,
  });

  @override
  State<CmsBottomSheetWidget> createState() => _CmsBottomSheetWidgetState();
}

class _CmsBottomSheetWidgetState extends State<CmsBottomSheetWidget> {
  bool _isLoading = true;
  String _title = "";
  String _content = "";
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _title = widget.initialTitle;
    _fetchCms();
  }

  Future<void> _fetchCms() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final AuthController authController = Get.isRegistered<AuthController>()
          ? Get.find<AuthController>()
          : Get.put(AuthController());

      final response = await authController.getCmsContentApi(
        context: context,
        key: widget.cmsKey,
      );

      if (!mounted) return;

      if (response != null) {
        Map<String, dynamic>? pageData;
        if (response['page'] != null && response['page'] is Map) {
          pageData = Map<String, dynamic>.from(response['page']);
        } else if (response['data'] != null && response['data'] is Map) {
          pageData = Map<String, dynamic>.from(response['data']);
        } else if (response is Map) {
          pageData = Map<String, dynamic>.from(response);
        }

        if (pageData != null) {
          final fetchedTitle = pageData['title']?.toString();
          final fetchedContent = pageData['description']?.toString() ??
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
        _errorMessage = "No content available.";
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = "Failed to load content. Please try again.";
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
              // Top drag indicator bar
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 14),

              // Header bar with Title and Close button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: text(
                        _title,
                        textColor: blackColor,
                        fontSize: 18,
                        fontFamily: FontFamily.plusJakartaSansBold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 20,
                          color: blackColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, color: lightGreyColor),

              // Body content
              Expanded(
                child: _buildBody(scrollController),
              ),
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
            const CircularProgressIndicator(color: primaryColor),
            const SizedBox(height: 16),
            text(
              "Loading $_title...",
              textColor: greyColor,
              fontSize: 14,
              fontFamily: FontFamily.plusJakartaSansMedium,
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
              const Icon(Icons.info_outline, size: 48, color: greyColor),
              const SizedBox(height: 12),
              text(
                _errorMessage!,
                textColor: greyColor,
                fontSize: 14,
                fontFamily: FontFamily.plusJakartaSansMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchCms,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Retry",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CmsHelper.buildHtmlViewer(_content),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
