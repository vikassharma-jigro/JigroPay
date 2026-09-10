import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../getx_controller/auth_controller.dart';
import 'app_colors.dart';
import 'font_family.dart';
import 'text_widget.dart';

class CmsHelper {
  static bool _isCmsLoading = false;
  static bool _isModalOpen = false;

  static Future<void> openCmsBottomSheet(
    BuildContext context,
    String pageTitle,
    String key,
  ) async {
    if (_isCmsLoading || _isModalOpen) {
      Fluttertoast.showToast(
        msg: "Please wait, loading details...",
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    _isCmsLoading = true;

    try {
      final AuthController authController = Get.isRegistered<AuthController>()
          ? Get.find<AuthController>()
          : Get.put(AuthController());

      var response = await authController.getCmsContentApi(
        context: context,
        key: key,
      );

      String content = "No content available.";
      String title = pageTitle;

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
          title = pageData['title']?.toString() ?? pageTitle;
          content = pageData['description']?.toString() ??
              pageData['content']?.toString() ??
              pageData['body']?.toString() ??
              content;
        }
      }

      content = content
          .replaceAll(RegExp(r'<[^>]*>'), '')
          .replaceAll('&nbsp;', ' ')
          .replaceAll('&amp;', '&')
          .replaceAll('&lt;', '<')
          .replaceAll('&gt;', '>')
          .trim();

      _isModalOpen = true;
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        builder: (ctx) {
          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.7,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView(
                  controller: scrollController,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: text(
                        title,
                        textColor: blackColor,
                        fontSize: 20,
                        fontFamily: FontFamily.plusJakartaSansBold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildRichTextWithLinks(content),
                  ],
                ),
              );
            },
          );
        },
      );
    } finally {
      _isCmsLoading = false;
      _isModalOpen = false;
    }
  }

  static Widget _buildRichTextWithLinks(String fullText) {
    if (fullText.trim().isEmpty) {
      return text(
        "No details provided.",
        textColor: blackColor.withOpacity(0.8),
        fontSize: 14,
        fontFamily: FontFamily.plusJakartaSansRegular,
      );
    }

    final RegExp urlRegExp = RegExp(
      r'(https?://[^\s]+|www\.[^\s]+|[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})',
      caseSensitive: false,
    );

    final List<InlineSpan> spans = [];
    int start = 0;

    for (final Match match in urlRegExp.allMatches(fullText)) {
      if (match.start > start) {
        spans.add(TextSpan(
          text: fullText.substring(start, match.start),
          style: TextStyle(
            color: blackColor.withOpacity(0.85),
            fontSize: 14,
            fontFamily: FontFamily.plusJakartaSansRegular,
            height: 1.5,
          ),
        ));
      }

      final String linkText = match.group(0)!;
      spans.add(TextSpan(
        text: linkText,
        style: const TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
          fontWeight: FontWeight.w600,
          fontSize: 14,
          fontFamily: FontFamily.plusJakartaSansMedium,
          height: 1.5,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () async {
            String url = linkText;
            if (url.contains('@') && !url.startsWith('mailto:')) {
              url = 'mailto:$url';
            } else if (!url.startsWith('http://') && !url.startsWith('https://')) {
              url = 'https://$url';
            }
            final Uri uri = Uri.parse(url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              Fluttertoast.showToast(msg: "Could not open $linkText");
            }
          },
      ));
      start = match.end;
    }

    if (start < fullText.length) {
      spans.add(TextSpan(
        text: fullText.substring(start),
        style: TextStyle(
          color: blackColor.withOpacity(0.85),
          fontSize: 14,
          fontFamily: FontFamily.plusJakartaSansRegular,
          height: 1.5,
        ),
      ));
    }

    return SelectableText.rich(
      TextSpan(children: spans),
    );
  }
}
