import 'package:flutter/foundation.dart';

class Account {
  int id;
  int userId;
  int accountTypeId;
  int pointsBalance;
  int likesBalance;

  Account({
    @required this.id,
    @required this.userId,
    @required this.accountTypeId,
    @required this.pointsBalance,
    @required this.likesBalance,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      userId: json['user_id'],
      accountTypeId: json['account_type_id'],
      pointsBalance: json['points_balance'],
      likesBalance: json['likes_balance'],
    );
  }
}
