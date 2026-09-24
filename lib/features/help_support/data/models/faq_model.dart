/// Typed FAQ model.
///
/// Keys sourced from [AuthController.getFaqsApi] response parsing.
class FaqModel {
  const FaqModel({
    required this.question,
    required this.answer,
    this.id,
    this.category,
    this.isActive = true,
  });

  final String question;
  final String answer;
  final int? id;
  final String? category;
  final bool isActive;

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    // Strip HTML tags and decode entities — matches AuthController logic
    String rawAnswer = (json['answer'] ??
            json['description'] ??
            json['content'] ??
            json['faq_answer'] ??
            '')
        .toString();
    rawAnswer = rawAnswer
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .trim();

    final rawActive = json['is_active'];
    final isActive = !(rawActive == 0 || rawActive == '0' || rawActive == false);

    return FaqModel(
      question: (json['question'] ??
              json['title'] ??
              json['faq_question'] ??
              '')
          .toString(),
      answer: rawAnswer.isNotEmpty ? rawAnswer : 'No answer details available.',
      id: _int(json['id'] ?? json['faq_id']),
      category: _str(json['category'] ?? json['type']),
      isActive: isActive,
    );
  }

  static List<FaqModel> listFromApiResponse(dynamic response) {
    if (response == null) return [];

    List rawList = [];
    if (response is Map) {
      final dataField = response['data'];
      final faqsField = response['faqs'];

      if (faqsField is List) {
        rawList = faqsField;
      } else if (dataField is List) {
        rawList = dataField;
      } else if (dataField is Map) {
        final innerData = dataField['data'];
        final innerFaqs = dataField['faqs'];
        if (innerData is List) {
          rawList = innerData;
        } else if (innerFaqs is List) {
          rawList = innerFaqs;
        }
      }
    } else if (response is List) {
      rawList = response;
    }

    return rawList
        .whereType<Map>()
        .map((e) => FaqModel.fromJson(Map<String, dynamic>.from(e)))
        .where((faq) => faq.isActive && faq.question.isNotEmpty)
        .toList();
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'question': question,
    'answer': answer,
    if (category != null) 'category': category,
    'is_active': isActive,
  };

  @override
  bool operator ==(Object other) =>
      other is FaqModel && question == other.question;

  @override
  int get hashCode => question.hashCode;
}

/// FAQ API response — also carries company contact details.
class FaqResponse {
  const FaqResponse({
    required this.faqs,
    this.companyEmail,
    this.companyContact,
  });

  final List<FaqModel> faqs;
  final String? companyEmail;
  final String? companyContact;

  factory FaqResponse.fromApiResponse(dynamic response) {
    List<FaqModel> faqs = [];
    String? email;
    String? contact;

    if (response is Map) {
      email = _str(response['company_email'] ?? response['support_email'] ?? response['email']);
      contact = _str(response['company_contact'] ?? response['company_phone'] ?? response['support_contact'] ?? response['contact'] ?? response['phone']);

      if (email == null || contact == null) {
        final dataField = response['data'];
        if (dataField is Map) {
          email ??= _str(dataField['company_email'] ?? dataField['support_email'] ?? dataField['email']);
          contact ??= _str(dataField['company_contact'] ?? dataField['company_phone'] ?? dataField['support_contact'] ?? dataField['contact'] ?? dataField['phone']);
        }
      }
      faqs = FaqModel.listFromApiResponse(response);
    } else if (response is List) {
      faqs = FaqModel.listFromApiResponse(response);
    }

    return FaqResponse(
      faqs: faqs,
      companyEmail: email,
      companyContact: contact,
    );
  }
}

int? _int(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  return int.tryParse(v.toString());
}

String? _str(dynamic v) {
  if (v == null) return null;
  final s = v.toString().trim();
  return (s.isEmpty || s == 'null') ? null : s;
}
