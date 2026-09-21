class CategoryUtils {
  /// Converts raw category/operator types like "mobile_operator", "electricity_bill", "cc_bill_pay"
  /// into clean, user-friendly Normal text like "Mobile Operator", "Electricity Bill", "Credit Card Bill".
  static String formatCategoryType(dynamic rawType) {
    if (rawType == null) return '';
    String clean = rawType.toString().trim();
    if (clean.isEmpty || clean.toLowerCase() == 'null') return '';

    // Direct mapping for known API category and operator types
    final Map<String, String> knownTypes = {
      // Mobile / Operators
      'mobile_operator': 'Mobile Operator',
      'mobile': 'Mobile Recharge',
      'mobile_recharge': 'Mobile Recharge',
      'prepaid': 'Prepaid Mobile',
      'postpaid': 'Postpaid Mobile',

      // Utilities & Bills
      'electricity': 'Electricity Bill',
      'electricity_bill': 'Electricity Bill',
      'water': 'Water Bill',
      'water_bill': 'Water Bill',
      'gas': 'Gas Bill',
      'piped_gas': 'Piped Gas',
      'lpg': 'LPG Gas Cylinder',
      'lpg_gas': 'LPG Gas Cylinder',
      'broadband': 'Broadband',
      'broadband_postpaid': 'Broadband',
      'landline': 'Landline',
      'landline_postpaid': 'Landline Bill',

      // DTH & Cable
      'dth': 'DTH Recharge',
      'dth_operator': 'DTH Operator',
      'cable': 'Cable TV',
      'cable_tv': 'Cable TV',

      // FASTag & Travel
      'fastag': 'FASTag Recharge',
      'fast_tag': 'FASTag Recharge',
      'train': 'Train Booking',
      'bus': 'Bus Booking',
      'hotel': 'Hotel Booking',
      'flight': 'Flight Booking',

      // Financial & Banking
      'credit_card': 'Credit Card Bill',
      'cc_bill_pay': 'Credit Card Bill',
      'emi_payment': 'Loan Repayment (EMI)',
      'loan_repayment': 'Loan Repayment',
      'insurance': 'Insurance Premium',
      'insurance_premium': 'Insurance Premium',
      'mutual_fund': 'Mutual Fund',
      'nps': 'NPS Contribution',
      'ncmc': 'NCMC Recharge',

      // Municipal & Society
      'municipal_taxes': 'Municipal Taxes',
      'municipal_services': 'Municipal Services',
      'housing': 'Housing Society',
      'housing_society': 'Housing Society',
      'club_association': 'Club & Association',
      'clubs_and_associations': 'Clubs & Associations',

      // Other services
      'hospital': 'Hospital Bill',
      'donation': 'Donation',
      'education': 'Education Fees',
      'education_fees': 'Education Fees',
      'subscription': 'Subscription',
    };

    String lower = clean.toLowerCase();
    if (knownTypes.containsKey(lower)) {
      return knownTypes[lower]!;
    }

    // If it already has uppercase letters and no underscores/hyphens, return as-is
    if (!clean.contains('_') &&
        !clean.contains('-') &&
        clean.contains(RegExp(r'[A-Z]'))) {
      return clean;
    }

    // Generic fallback: Split by underscore, hyphen, or multiple spaces
    List<String> words = clean
        .split(RegExp(r'[_\-\s]+'))
        .where((w) => w.isNotEmpty)
        .toList();
    if (words.isEmpty) return clean;

    return words.map((w) {
      String lw = w.toLowerCase();
      // Well-known uppercase acronyms
      if (lw == 'dth') return 'DTH';
      if (lw == 'emi') return 'EMI';
      if (lw == 'lpg') return 'LPG';
      if (lw == 'cc') return 'Credit Card';
      if (lw == 'fastag') return 'FASTag';
      if (lw == 'tv') return 'TV';
      if (lw == 'ncmc') return 'NCMC';
      if (lw == 'nps') return 'NPS';
      if (lw == 'bbps') return 'BBPS';
      if (lw == 'upi') return 'UPI';
      if (lw == 'rc') return 'Recharge';
      if (lw == 'id') return 'ID';

      return '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}';
    }).join(' ');
  }

  /// Helper to safely extract category / provider name from a transaction item map
  static String extractCategoryName(dynamic item) {
    if (item is! Map) return '';

    if (item['category'] is Map &&
        item['category']['name'] != null &&
        item['category']['name'].toString().trim().isNotEmpty) {
      return item['category']['name'].toString().trim();
    }
    if (item['category_model'] is Map &&
        item['category_model']['name'] != null &&
        item['category_model']['name'].toString().trim().isNotEmpty) {
      return item['category_model']['name'].toString().trim();
    }
    if (item['operator'] is Map &&
        item['operator']['name'] != null &&
        item['operator']['name'].toString().trim().isNotEmpty) {
      return item['operator']['name'].toString().trim();
    }
    if (item['category_name'] != null &&
        item['category_name'].toString().trim().isNotEmpty) {
      return item['category_name'].toString().trim();
    }
    if (item['biller_name'] != null &&
        item['biller_name'].toString().trim().isNotEmpty) {
      return item['biller_name'].toString().trim();
    }
    if (item['service_name'] != null &&
        item['service_name'].toString().trim().isNotEmpty) {
      return item['service_name'].toString().trim();
    }
    if (item['name'] != null &&
        item['name'].toString().trim().isNotEmpty) {
      return item['name'].toString().trim();
    }
    if (item['title'] != null &&
        item['title'].toString().trim().isNotEmpty) {
      return item['title'].toString().trim();
    }

    return '';
  }

  /// Helper to safely extract and format category type from a transaction item map
  static String extractAndFormatCategoryType(dynamic item) {
    if (item is! Map) return '';

    dynamic rawType;
    if (item['category'] is Map && item['category']['type'] != null) {
      rawType = item['category']['type'];
    } else if (item['category_model'] is Map && item['category_model']['type'] != null) {
      rawType = item['category_model']['type'];
    } else if (item['operator'] is Map && item['operator']['type'] != null) {
      rawType = item['operator']['type'];
    } else if (item['category_type'] != null) {
      rawType = item['category_type'];
    } else if (item['type'] != null) {
      rawType = item['type'];
    } else if (item['category'] != null && item['category'] is! Map) {
      rawType = item['category'];
    }

    return formatCategoryType(rawType);
  }

  /// Helper to safely extract an icon URL from a transaction item map
  static String extractIconUrl(dynamic item) {
    if (item is! Map) return '';

    if (item['icon_url'] != null &&
        item['icon_url'].toString().trim().isNotEmpty) {
      return item['icon_url'].toString().trim();
    }
    if (item['category'] is Map &&
        item['category']['icon_url'] != null &&
        item['category']['icon_url'].toString().trim().isNotEmpty) {
      return item['category']['icon_url'].toString().trim();
    }
    if (item['category_model'] is Map &&
        item['category_model']['icon_url'] != null &&
        item['category_model']['icon_url'].toString().trim().isNotEmpty) {
      return item['category_model']['icon_url'].toString().trim();
    }
    if (item['operator'] is Map &&
        item['operator']['icon_url'] != null &&
        item['operator']['icon_url'].toString().trim().isNotEmpty) {
      return item['operator']['icon_url'].toString().trim();
    }
    if (item['category_icon'] != null &&
        item['category_icon'].toString().trim().isNotEmpty) {
      return item['category_icon'].toString().trim();
    }
    if (item['biller_logo'] != null &&
        item['biller_logo'].toString().trim().isNotEmpty) {
      return item['biller_logo'].toString().trim();
    }
    if (item['image'] != null &&
        item['image'].toString().trim().isNotEmpty) {
      return item['image'].toString().trim();
    }
    if (item['icon'] != null &&
        item['icon'].toString().trim().isNotEmpty) {
      return item['icon'].toString().trim();
    }
    if (item['logo'] != null &&
        item['logo'].toString().trim().isNotEmpty) {
      return item['logo'].toString().trim();
    }
    if (item['operator'] is Map) {
      if (item['operator']['image'] != null &&
          item['operator']['image'].toString().trim().isNotEmpty) {
        return item['operator']['image'].toString().trim();
      }
      if (item['operator']['logo'] != null &&
          item['operator']['logo'].toString().trim().isNotEmpty) {
        return item['operator']['logo'].toString().trim();
      }
    }
    if (item['category'] is Map) {
      if (item['category']['image'] != null &&
          item['category']['image'].toString().trim().isNotEmpty) {
        return item['category']['image'].toString().trim();
      }
      if (item['category']['logo'] != null &&
          item['category']['logo'].toString().trim().isNotEmpty) {
        return item['category']['logo'].toString().trim();
      }
    }

    return '';
  }

  /// Helper to safely extract an operator code from a transaction item map
  static String extractOperatorCode(dynamic item) {
    if (item is! Map) return '';

    if (item['operator_code'] != null &&
        item['operator_code'].toString().trim().isNotEmpty) {
      return item['operator_code'].toString().trim();
    }
    if (item['opcode'] != null &&
        item['opcode'].toString().trim().isNotEmpty) {
      return item['opcode'].toString().trim();
    }
    if (item['op_code'] != null &&
        item['op_code'].toString().trim().isNotEmpty) {
      return item['op_code'].toString().trim();
    }
    if (item['category'] is Map &&
        item['category']['operator_code'] != null &&
        item['category']['operator_code'].toString().trim().isNotEmpty) {
      return item['category']['operator_code'].toString().trim();
    }
    if (item['operator'] is Map &&
        item['operator']['operator_code'] != null &&
        item['operator']['operator_code'].toString().trim().isNotEmpty) {
      return item['operator']['operator_code'].toString().trim();
    }

    return '';
  }
}
