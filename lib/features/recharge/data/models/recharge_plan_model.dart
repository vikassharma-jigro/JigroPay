
class RechargePlanModel {
  const RechargePlanModel({
    required this.id,
    required this.amount,
    required this.description,
    this.validity,
    this.talktime,
    this.data,
    this.sms,
    this.category,
    this.opcode,
    this.circle,
    this.isPopular,
    this.tag,
  });

  final String id;
  final double amount;
  final String description;
  final String? validity;
  final String? talktime;
  final String? data;
  final String? sms;
  final String? category;
  final String? opcode;
  final String? circle;
  final bool? isPopular;
  final String? tag;

  factory RechargePlanModel.fromJson(Map<String, dynamic> json) {
    // Check if DTH PricingList exists with multiple prices
    final pricingList = json['PricingList'] ?? json['pricing_list'] ?? json['pricing'];
    Map<String, dynamic>? firstPricing;
    if (pricingList is List && pricingList.isNotEmpty && pricingList.first is Map) {
      firstPricing = Map<String, dynamic>.from(pricingList.first);
    }

    final planName = _str(json['PlanName'] ?? json['plan_name'] ?? json['name']);
    final channels = _str(json['Channels'] ?? json['channels']);
    final paidChannels = _str(json['PaidChannels'] ?? json['paid_channels']);
    final hdChannels = _str(json['HdChannels'] ?? json['hd_channels']);

    final List<String> channelParts = [];
    if (channels != null) channelParts.add(channels);
    if (paidChannels != null) channelParts.add(paidChannels);
    if (hdChannels != null && hdChannels != 'No HD Channels') {
      channelParts.add(hdChannels);
    }
    final channelSummary = channelParts.join(' • ');

    return RechargePlanModel(
      id: (json['id'] ?? json['plan_id'] ?? json['recharge_id'] ?? planName ?? '').toString(),
      amount: _double(
        json['rs'] ??
        json['amount'] ??
        json['Amount'] ??
        json['price'] ??
        json['Price'] ??
        json['recharge_amount'] ??
        firstPricing?['Amount'] ??
        firstPricing?['amount'] ??
        firstPricing?['rs'],
      ),
      description: (json['desc'] ??
              json['description'] ??
              json['plan_description'] ??
              (planName != null && channelSummary.isNotEmpty
                  ? '$planName\n$channelSummary'
                  : planName) ??
              json['details'] ??
              '')
          .toString(),
      validity: _str(
        json['validity'] ??
        json['plan_validity'] ??
        json['Month'] ??
        json['month'] ??
        firstPricing?['Month'] ??
        firstPricing?['month'],
      ),
      talktime: _str(json['talktime'] ?? json['talk_time'] ?? json['calling']),
      data: _str(
        json['data'] ??
        json['plan_data'] ??
        json['internet'] ??
        (channels != null && paidChannels != null
            ? '$channels ($paidChannels)'
            : channels),
      ),
      sms: _str(json['sms']),
      category: _str(json['type'] ?? json['category'] ?? json['plan_type'] ?? json['Language']),
      opcode: _str(json['opcode'] ?? json['operator_code']),
      circle: _str(json['circle'] ?? json['circle_code']),
      isPopular: _bool(json['is_popular'] ?? json['popular']),
      tag: _str(
        json['tag'] ??
        json['label'] ??
        json['badge'] ??
        (hdChannels != null && hdChannels != 'No HD Channels'
            ? hdChannels
            : channels),
      ),
    );
  }

  /// Parses a DTH plan JSON which may contain a [PricingList] with multiple durations.
  /// Expands each pricing tier into an individual selectable [RechargePlanModel].
  static List<RechargePlanModel> fromDthPlanJson(
    Map<String, dynamic> json, {
    String? category,
  }) {
    final planName = _str(json['PlanName'] ?? json['plan_name'] ?? json['name'] ?? json['desc']) ?? 'DTH Plan';
    final channels = _str(json['Channels'] ?? json['channels']);
    final paidChannels = _str(json['PaidChannels'] ?? json['paid_channels']);
    final hdChannels = _str(json['HdChannels'] ?? json['hd_channels']);
    final pricingList = json['PricingList'] ?? json['pricing_list'] ?? json['pricing'];

    final List<String> channelParts = [];
    if (channels != null) channelParts.add(channels);
    if (paidChannels != null) channelParts.add(paidChannels);
    if (hdChannels != null && hdChannels != 'No HD Channels') {
      channelParts.add(hdChannels);
    }
    final channelSummary = channelParts.join(' • ');

    final tag = (hdChannels != null && hdChannels != 'No HD Channels')
        ? hdChannels
        : channels;

    if (pricingList is List && pricingList.isNotEmpty) {
      final List<RechargePlanModel> plans = [];
      for (final p in pricingList) {
        if (p is Map<String, dynamic> || p is Map) {
          final pMap = Map<String, dynamic>.from(p as Map);
          final amount = _double(pMap['Amount'] ?? pMap['amount'] ?? pMap['rs']);
          final month = _str(pMap['Month'] ?? pMap['month'] ?? pMap['validity']);

          plans.add(
            RechargePlanModel(
              id: '${planName}_${month ?? amount}',
              amount: amount,
              description: channelSummary.isNotEmpty
                  ? '$planName\n$channelSummary'
                  : planName,
              validity: month,
              data: channels,
              category: category,
              tag: tag,
            ),
          );
        }
      }
      if (plans.isNotEmpty) return plans;
    }

    return [RechargePlanModel.fromJson(json)];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'description': description,
    if (validity != null) 'validity': validity,
    if (talktime != null) 'talktime': talktime,
    if (data != null) 'data': data,
    if (sms != null) 'sms': sms,
    if (category != null) 'category': category,
    if (opcode != null) 'opcode': opcode,
    if (circle != null) 'circle': circle,
    if (isPopular != null) 'is_popular': isPopular,
    if (tag != null) 'tag': tag,
  };

  @override
  bool operator ==(Object other) =>
      other is RechargePlanModel && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Holds categorised recharge plans (e.g. Talktime, Data, Combos, or DTH Languages).
class CategorisedPlans {
  const CategorisedPlans(this.plans);

  final Map<String, List<RechargePlanModel>> plans;

  bool get isEmpty => plans.isEmpty;
  bool get isNotEmpty => plans.isNotEmpty;

  List<String> get categories {
    final keys = plans.keys.toList();
    if (keys.length > 1 && !keys.contains('All Plans')) {
      return ['All Plans', ...keys];
    }
    return keys;
  }

  List<RechargePlanModel> get allPlans =>
      plans.values.expand((list) => list).toList();

  List<RechargePlanModel> forCategory(String category) {
    if (category == 'All Plans' && !plans.containsKey('All Plans')) {
      return allPlans;
    }
    return plans[category] ?? [];
  }

  /// Parses the API response into a [CategorisedPlans] object.
  /// Handles:
  /// - DTH Language groups: `[ { "Language": "Hindi", "Details": [ ... ] } ]`
  /// - Mobile category maps: `{ "Truly Unlimited": [ ... ], "Data": [ ... ] }`
  /// - Flat plan lists: `[ { "rs": 299, ... } ]`
  factory CategorisedPlans.fromApiResponse(Map<String, dynamic> response) {
    dynamic raw = response['data'] ?? response['records'] ?? response['plans'] ?? response;

    // If raw is a Map wrapping records/plans, unpack it
    if (raw is Map) {
      if (raw.containsKey('records') && raw['records'] is List) {
        raw = raw['records'];
      } else if (raw.length == 1 && raw.values.first is List) {
        final firstKey = raw.keys.first.toString().toLowerCase();
        if (firstKey == 'data' || firstKey == 'records' || firstKey == 'plans' || firstKey == 'details') {
          raw = raw.values.first;
        }
      }
    }

    final result = <String, List<RechargePlanModel>>{};

    // 1. Check if raw is a List
    if (raw is List) {
      for (final item in raw) {
        if (item is Map<String, dynamic> || item is Map) {
          final itemMap = Map<String, dynamic>.from(item as Map);
          final language = _str(itemMap['Language'] ?? itemMap['language'] ?? itemMap['category'] ?? itemMap['Category']);
          final details = itemMap['Details'] ?? itemMap['details'] ?? itemMap['plans'] ?? itemMap['Plans'];

          if (details is List) {
            // DTH Group by Language
            final categoryName = language ?? 'All Plans';
            final categoryPlans = <RechargePlanModel>[];

            for (final detail in details) {
              if (detail is Map<String, dynamic> || detail is Map) {
                final dMap = Map<String, dynamic>.from(detail as Map);
                categoryPlans.addAll(
                  RechargePlanModel.fromDthPlanJson(dMap, category: categoryName),
                );
              }
            }

            if (categoryPlans.isNotEmpty) {
              result.putIfAbsent(categoryName, () => []).addAll(categoryPlans);
            }
          } else {
            // Flat plan item in list
            final parsedPlans = RechargePlanModel.fromDthPlanJson(
              itemMap,
              category: language ?? 'All Plans',
            );
            result.putIfAbsent(language ?? 'All Plans', () => []).addAll(parsedPlans);
          }
        }
      }

      if (result.isNotEmpty) {
        return CategorisedPlans(result);
      }
    }

    // 2. Check if raw is a Map of categories -> lists
    if (raw is Map) {
      raw.forEach((key, value) {
        if (value is List) {
          final categoryPlans = <RechargePlanModel>[];
          for (final item in value) {
            if (item is Map<String, dynamic> || item is Map) {
              final itemMap = Map<String, dynamic>.from(item as Map);
              if (itemMap.containsKey('Details') && itemMap['Details'] is List) {
                final lang = _str(itemMap['Language']) ?? key.toString();
                final details = itemMap['Details'] as List;
                for (final d in details) {
                  if (d is Map) {
                    categoryPlans.addAll(
                      RechargePlanModel.fromDthPlanJson(Map<String, dynamic>.from(d), category: lang),
                    );
                  }
                }
              } else if (itemMap.containsKey('PricingList') || itemMap.containsKey('PlanName')) {
                categoryPlans.addAll(
                  RechargePlanModel.fromDthPlanJson(itemMap, category: key.toString()),
                );
              } else {
                categoryPlans.add(RechargePlanModel.fromJson(itemMap));
              }
            }
          }
          if (categoryPlans.isNotEmpty) {
            result[key.toString()] = categoryPlans;
          }
        }
      });
      return CategorisedPlans(result);
    }

    return const CategorisedPlans({});
  }
}

// ── Shared helpers ────────────────────────────────────────────────────────────

String? _str(dynamic v) {
  if (v == null) return null;
  final s = v.toString().trim();
  return (s.isEmpty || s == 'null') ? null : s;
}

bool? _bool(dynamic v) {
  if (v == null) return null;
  if (v is bool) return v;
  if (v == 1 || v == '1' || v == 'true') return true;
  if (v == 0 || v == '0' || v == 'false') return false;
  return null;
}

double _double(dynamic v) {
  if (v == null) return 0.0;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0.0;
}
