import 'package:flutter_test/flutter_test.dart';
import 'package:jigrotech/features/auth/data/models/user_model.dart';
import 'package:jigrotech/features/recharge/data/models/operator_model.dart';
import 'package:jigrotech/features/recharge/data/models/recharge_plan_model.dart';
import 'package:jigrotech/features/recharge/data/models/order_model.dart';
import 'package:jigrotech/features/bill_payments/data/models/biller_model.dart';
import 'package:jigrotech/features/bill_payments/data/models/bill_details_model.dart';
import 'package:jigrotech/features/history/data/models/transaction_model.dart';
import 'package:jigrotech/features/notifications/data/models/notification_item_model.dart';
import 'package:jigrotech/features/help_support/data/models/faq_model.dart';
import 'package:jigrotech/features/home/data/models/banner_model.dart';

void main() {
  group('UserModel', () {
    test('parses from direct JSON correctly', () {
      final json = {
        'id': 101,
        'name': 'John Doe',
        'phone': '9876543210',
        'email': 'john@example.com',
        'wallet_balance': 250.75,
        'is_active': 1,
        'profile_image': 'https://example.com/avatar.png',
        'referral_code': 'REF123',
      };

      final user = UserModel.fromJson(json);

      expect(user.id, 101);
      expect(user.name, 'John Doe');
      expect(user.phone, '9876543210');
      expect(user.email, 'john@example.com');
      expect(user.walletBalance, 250.75);
      expect(user.isActive, true);
      expect(user.profileImageUrl, 'https://example.com/avatar.png');
      expect(user.referralCode, 'REF123');
    });

    test('parses from nested API response with "data"', () {
      final apiResponse = {
        'status': true,
        'message': 'Profile fetched',
        'data': {
          'id': '202',
          'full_name': 'Jane Doe',
          'mobile': '9876500000',
        },
      };

      final user = UserModel.fromApiResponse(apiResponse);
      expect(user.id, 202);
      expect(user.name, 'Jane Doe');
      expect(user.phone, '9876500000');
    });

    test('toJson and copyWith work as expected', () {
      const user = UserModel(
        id: 1,
        name: 'Alex',
        phone: '1234567890',
        email: 'alex@test.com',
      );

      final updated = user.copyWith(name: 'Alexander');
      expect(updated.name, 'Alexander');
      expect(updated.id, 1);

      final json = updated.toJson();
      expect(json['name'], 'Alexander');
      expect(json['phone'], '1234567890');
      expect(json['email'], 'alex@test.com');
    });
  });

  group('OperatorModel', () {
    test('parses with fallbacks for opcode and operator name', () {
      final json = {
        'company_code': 'AT',
        'company_name': 'Airtel',
        'circle_name': 'Delhi NCR',
        'circle_code': 'DL',
        'logo': 'https://example.com/airtel.png',
        'status': '1',
      };

      final op = OperatorModel.fromJson(json);
      expect(op.opcode, 'AT');
      expect(op.name, 'Airtel');
      expect(op.circle, 'Delhi NCR');
      expect(op.circleCode, 'DL');
      expect(op.imageUrl, 'https://example.com/airtel.png');
      expect(op.isActive, true);
    });

    test('equality compares opcode', () {
      const op1 = OperatorModel(opcode: 'JIO', name: 'Jio 1');
      const op2 = OperatorModel(opcode: 'JIO', name: 'Jio 2');
      expect(op1, equals(op2));
    });
  });

  group('RechargePlanModel & CategorisedPlans', () {
    test('parses single plan model properly', () {
      final json = {
        'id': 'plan_01',
        'rs': '299',
        'desc': '1.5GB/day + Unlimited calls',
        'validity': '28 Days',
        'data': '1.5 GB/Day',
        'type': 'Popular',
      };

      final plan = RechargePlanModel.fromJson(json);
      expect(plan.id, 'plan_01');
      expect(plan.amount, 299.0);
      expect(plan.description, '1.5GB/day + Unlimited calls');
      expect(plan.validity, '28 Days');
      expect(plan.data, '1.5 GB/Day');
      expect(plan.category, 'Popular');
    });

    test('CategorisedPlans handles map and list shapes', () {
      final mapResponse = {
        'data': {
          'Unlimited': [
            {'id': '1', 'rs': 199, 'desc': 'Plan 1'},
            {'id': '2', 'rs': 299, 'desc': 'Plan 2'},
          ],
          'Data': [
            {'id': '3', 'rs': 19, 'desc': '1 GB'},
          ],
        },
      };

      final categorised = CategorisedPlans.fromApiResponse(mapResponse);
      expect(categorised.categories, containsAll(['Unlimited', 'Data']));
      expect(categorised.forCategory('Unlimited').length, 2);
      expect(categorised.allPlans.length, 3);
    });
  });

  group('OrderModel & PaymentVerifyModel', () {
    test('OrderModel parses nested data', () {
      final json = {
        'status': true,
        'data': {
          'id': 'ord_123',
          'razorpay_order_id': 'rzp_ord_456',
          'amount': 399.0,
          'currency': 'INR',
          'key': 'rzp_test_xyz',
        },
      };

      final order = OrderModel.fromJson(json);
      expect(order.orderId, 'ord_123');
      expect(order.razorpayOrderId, 'rzp_ord_456');
      expect(order.amount, 399.0);
      expect(order.currency, 'INR');
      expect(order.razorpayKey, 'rzp_test_xyz');
    });

    test('PaymentVerifyModel determines success accurately', () {
      final jsonSuccess = {
        'status': true,
        'message': 'Transaction Approved',
        'data': {
          'txn_id': 'TXN999',
          'recharge_status': 'SUCCESS',
        },
      };

      final verify = PaymentVerifyModel.fromJson(jsonSuccess);
      expect(verify.success, isTrue);
      expect(verify.transactionId, 'TXN999');
      expect(verify.status, 'SUCCESS');
    });
  });

  group('BillerModel & BillDetailsModel', () {
    test('BillerModel parses required fields list', () {
      final json = {
        'operator_code': 'WBSEDCL',
        'name': 'WB State Electricity',
        'required_fields': ['consumer_id', 'mobile'],
        'supports_fetch': true,
      };

      final biller = BillerModel.fromJson(json);
      expect(biller.opcode, 'WBSEDCL');
      expect(biller.name, 'WB State Electricity');
      expect(biller.supportsFetch, isTrue);
      expect(biller.fetchRequiredFields, ['consumer_id', 'mobile']);
    });

    test('BillDetailsModel parses amounts and dates', () {
      final json = {
        'data': {
          'fetch_id': 'F12345',
          'consumer_name': 'Ramesh Kumar',
          'amount': 1520.50,
          'consumer_no': 'CON1009',
          'due_date': '2026-04-15',
        },
      };

      final details = BillDetailsModel.fromJson(json);
      expect(details.fetchId, 'F12345');
      expect(details.consumerName, 'Ramesh Kumar');
      expect(details.amount, 1520.50);
      expect(details.consumerNumber, 'CON1009');
      expect(details.dueDate, isNotNull);
    });
  });

  group('TransactionModel', () {
    test('parses status helpers correctly', () {
      final jsonSuccess = {
        'id': 'T001',
        'amount': 500,
        'status': 'Success',
        'date': '2026-03-01T10:00:00Z',
      };
      final tx = TransactionModel.fromJson(jsonSuccess);
      expect(tx.isSuccess, isTrue);
      expect(tx.isPending, isFalse);
      expect(tx.isFailed, isFalse);

      final jsonPending = {
        'id': 'T002',
        'amount': 100,
        'status': 'Processing',
      };
      final tx2 = TransactionModel.fromJson(jsonPending);
      expect(tx2.isPending, isTrue);
      expect(tx2.isSuccess, isFalse);
    });

    test('listFromApiResponse handles nested lists', () {
      final res = {
        'data': [
          {'id': '1', 'amount': 100, 'status': 'success'},
          {'id': '2', 'amount': 200, 'status': 'failed'},
        ],
      };
      final list = TransactionModel.listFromApiResponse(res);
      expect(list.length, 2);
    });
  });

  group('NotificationItemModel', () {
    test('parses notification items and copyWith handles read flag', () {
      final json = {
        'id': 10,
        'title': 'Payment Done',
        'body': 'Your recharge of ₹299 was successful',
        'is_read': false,
      };

      final notif = NotificationItemModel.fromJson(json);
      expect(notif.id, 10);
      expect(notif.isRead, isFalse);

      final readNotif = notif.copyWith(isRead: true);
      expect(readNotif.isRead, isTrue);
      expect(readNotif.title, 'Payment Done');
    });
  });

  group('FaqModel & FaqResponse', () {
    test('FaqModel strips HTML tags correctly from answer', () {
      final json = {
        'faq_id': 1,
        'question': 'How to recharge?',
        'answer': '<p>Go to the <b>Recharge</b> section &amp; select operator.</p>',
        'is_active': 1,
      };

      final faq = FaqModel.fromJson(json);
      expect(faq.question, 'How to recharge?');
      expect(faq.answer, 'Go to the Recharge section & select operator.');
      expect(faq.isActive, isTrue);
    });

    test('FaqResponse parses company details alongside FAQ list', () {
      final res = {
        'company_email': 'support@jigropay.com',
        'company_contact': '1800-123-456',
        'faqs': [
          {
            'faq_id': 1,
            'question': 'What is JigroPay?',
            'answer': 'A fintech utility application.',
            'is_active': true,
          },
        ],
      };

      final faqRes = FaqResponse.fromApiResponse(res);
      expect(faqRes.companyEmail, 'support@jigropay.com');
      expect(faqRes.companyContact, '1800-123-456');
      expect(faqRes.faqs.length, 1);
      expect(faqRes.faqs.first.question, 'What is JigroPay?');
    });
  });

  group('BannerModel', () {
    test('parses banners and filters out empty image banners', () {
      final res = {
        'data': [
          {
            'id': 1,
            'image': 'https://example.com/banner1.jpg',
            'title': 'Cashback Offer',
          },
          {
            'id': 2,
            'image': '',
            'title': 'Invalid Banner',
          },
        ],
      };

      final banners = BannerModel.listFromApiResponse(res);
      expect(banners.length, 1);
      expect(banners.first.id, 1);
      expect(banners.first.title, 'Cashback Offer');
    });
  });
}
