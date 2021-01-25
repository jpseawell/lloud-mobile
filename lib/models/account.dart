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

  factory Account.empty() {
    return Account(
        id: 0, userId: 0, accountTypeId: 0, likesBalance: 0, pointsBalance: 0);
  }

  static Map toMap(Account account) {
    var map = new Map();
    map['id'] = account.id;
    map['user_id'] = account.userId;
    map['account_type_id'] = account.accountTypeId;
    map['points_balance'] = account.pointsBalance;
    map['likes_balance'] = account.likesBalance;
    return map;
  }
}
