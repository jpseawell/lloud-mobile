import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:lloud_mobile/models/account.dart';
import 'package:lloud_mobile/models/user.dart';
import 'package:lloud_mobile/services/error_reporting.dart';
import 'package:lloud_mobile/util/jwt.dart';
import 'package:lloud_mobile/util/network.dart';

class Auth with ChangeNotifier {
  static final _storage = FlutterSecureStorage();
  static final _storedDataKey = 'lloud_auth_data';

  String _token;
  DateTime _expiryDate;
  User _user = User.empty();
  Account _account = Account.empty();

  int get userId => _user.id;
  int get accountId => _account.id;
  User get user => _user;
  Account get account => _account;

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }

    return null;
  }

  bool get isAuth {
    return token != null && _user != null && _account != null;
  }

  Future<User> _fetchMe(String authToken) async {
    const url = '${Network.host}/api/v2/me';
    final res = await http.get(url, headers: Network.headers(token: authToken));
    Map<String, dynamic> decodedRes = json.decode(res.body);

    if (res.statusCode != 200) {
      throw Exception('Could not retrieve user.');
    }

    return User.fromJson(decodedRes['data']);
  }

  Future<List<dynamic>> updateUser(User updatedUser) async {
    final url = '${Network.host}/api/v2/users/$userId';
    final res = await http.patch(url,
        body: json.encode(User.toMap(updatedUser)),
        headers: Network.headers(token: token));

    if (![200, 400].contains(res.statusCode))
      throw Exception('Failed to update user.');

    Map<String, dynamic> decodedRes = json.decode(res.body);

    if (res.statusCode == 400) {
      return decodedRes['data'];
    }

    _user = User.fromJson(decodedRes['data']);
    notifyListeners();

    _storeData();

    // TODO: Fix results on error
    return [];
  }

  Future<Account> _fetchMyAccount(String authToken) async {
    const url = '${Network.host}/api/v2/accounts/me';
    final res = await http.get(url, headers: Network.headers(token: authToken));
    Map<String, dynamic> decodedRes = json.decode(res.body);

    if (!decodedRes['success']) {
      throw Exception('Fetch account failed.');
    }

    return Account.fromJson(decodedRes['data']);
  }

  Future<void> fetchAndSetAccount() async {
    _account = await _fetchMyAccount(_token);
    notifyListeners();
  }

  Future<void> updateAccount(Account updatedAccount) async {
    final url = '${Network.host}/api/v2/accounts/$accountId';
    final res = await http.put(url,
        body: json.encode(Account.toMap(updatedAccount)),
        headers: Network.headers(token: _token));

    if (res.statusCode != 200) throw Exception('Failed to update account.');

    Map<String, dynamic> decodedRes = json.decode(res.body);

    _account = Account.fromJson(decodedRes['data']);
    notifyListeners();

    _storeData();
  }

  Future<void> logout() async {
    _token = null;
    _expiryDate = null;
    _user = User.empty();
    _account = Account.empty();
    notifyListeners();
    _clearStoredData();
  }

  Future<void> signup(Map<String, dynamic> credentials) async {
    final url = '${Network.host}/api/v2/register';
    final res = await http.post(url,
        headers: Network.headers(), body: json.encode(credentials));

    if (res.statusCode != 201) throw Exception('User registration failed.');

    _initFromToken(res.headers['x-auth-token']);
  }

  Future<void> login(Map<String, dynamic> credentials) async {
    final url = '${Network.host}/api/v2/login';
    final res = await http.post(url,
        headers: Network.headers(), body: json.encode(credentials));

    if (res.statusCode != 200) throw Exception('User authentication failed.');

    Map<String, dynamic> decodedResponse = json.decode(res.body);

    _initFromToken(decodedResponse['token']);
  }

  Future<void> _initFromToken(String authToken) async {
    _token = authToken;

    Map<String, dynamic> parsedToken = Jwt.parse(authToken);
    _expiryDate =
        DateTime.fromMillisecondsSinceEpoch(parsedToken['exp'] * 1000);

    try {
      _user = await _fetchMe(authToken);
      _account = await _fetchMyAccount(authToken);
    } catch (err, stack) {
      ErrorReportingService.report(err, stackTrace: stack);
      return;
    }

    notifyListeners(); // Only notify listeners after ALL the data is loaded
    _storeData();
  }

  Future<void> _storeData() async {
    final storedData = json.encode({
      'token': _token,
      'expiryDate': _expiryDate.toIso8601String(),
      'user': User.toMap(_user),
      'account': Account.toMap(_account)
    });

    await _storage.write(key: _storedDataKey, value: storedData);
  }

  void _clearStoredData() {
    _storage.delete(key: _storedDataKey);
  }

  Future<Map<String, dynamic>> _extractStoredData() async {
    final extractedData = await _storage.read(key: _storedDataKey);
    if (extractedData == null) return null;

    final decodedData = json.decode(extractedData);

    return {
      'token': decodedData['token'],
      'expiryDate': DateTime.parse(decodedData['expiryDate']),
      'user': User.fromJson(decodedData['user']),
      'account': Account.fromJson(decodedData['account']),
    };
  }

  Future<bool> tryAutoLogin() async {
    final extractedData = await _extractStoredData();
    if (extractedData == null) return false;

    _expiryDate = extractedData['expiryDate'];
    if (_expiryDate.isBefore(DateTime.now())) return false;

    _token = extractedData['token'];
    _user = extractedData['user'];
    _account = extractedData['account'];

    notifyListeners();
    return true;
  }
}
