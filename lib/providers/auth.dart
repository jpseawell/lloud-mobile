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

  String _token;
  DateTime _expiryDate;
  int _userId;
  int _accountId;
  User _user = User.empty();
  Account _account = Account.empty();

  int get userId => _userId;
  int get accountId => _accountId;
  User get user => _user;
  Account get account => _account;

  bool get isAuth {
    return token != null && _user != null && _account != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      Map<String, dynamic> credentials, String route) async {
    final url = '${Network.host}/api/v2/$route';
    final res = await http.post(url,
        headers: Network.headers(), body: json.encode(credentials));
    Map<String, dynamic> decodedResponse = json.decode(res.body);

    if (decodedResponse['status'] != 'success' &&
        decodedResponse['type'] != 'bearer')
      throw Exception('User authentication failed.');

    _token = route == 'register'
        ? res.headers['x-auth-token']
        : decodedResponse['token']; // TODO: Ensure token is valid

    try {
      await Future.wait([
        _extractAndSetTokenData(token),
        fetchAndSetUser(token),
        fetchAndSetAccount(token)
      ]);

      await Future.wait(
          [_storeTokenData(), _storeUserData(), _storeAccountData()]);
    } catch (err, stack) {
      await ErrorReportingService.report(err, stackTrace: stack);
    }
  }

  Future<void> _extractAndSetTokenData(String token) async {
    Map<String, dynamic> parsedToken = Jwt.parse(_token);
    _expiryDate =
        new DateTime.fromMillisecondsSinceEpoch(parsedToken['exp'] * 1000);
    notifyListeners();
  }

  Future<void> _storeTokenData() async {
    final storedTokenData = json.encode({
      'token': _token,
      'userId': _userId,
      'accountId': _accountId,
      'expiryDate': _expiryDate.toIso8601String()
    });

    await _storage.write(key: 'tokenData', value: storedTokenData);
  }

  Future<void> fetchAndSetUser(String token) async {
    const url = '${Network.host}/api/v2/me';
    final res = await http.get(url, headers: Network.headers(token: token));
    Map<String, dynamic> decodedRes = json.decode(res.body);

    if (res.statusCode != 200) {
      throw Exception('Could not retrieve user.');
    }

    print(decodedRes['data']);
    _user = User.fromJson(decodedRes['data']);
    _userId = _user.id;
    notifyListeners();
  }

  Future<List<dynamic>> updateUser(User user) async {
    final url = '${Network.host}/api/v2/users/$userId';
    final res = await http.patch(url,
        body: json.encode(User.toMap(user)),
        headers: Network.headers(token: token));

    if (res.statusCode == 401) throw Exception('Failed to update user.');

    Map<String, dynamic> decodedRes = json.decode(res.body);

    if (res.statusCode == 400) {
      return decodedRes['data'];
    }

    _user = User.fromJson(decodedRes['data']);
    notifyListeners();
    _storeUserData();

    return [];
  }

  Future<void> _storeUserData() async {
    await _storage.write(
        key: 'userData', value: json.encode(User.toMap(_user)));
  }

  Future<void> fetchAndSetAccount(String token) async {
    const url = '${Network.host}/api/v2/accounts/me';
    final res = await http.get(url, headers: Network.headers(token: token));
    Map<String, dynamic> decodedRes = json.decode(res.body);

    if (!decodedRes['success']) {
      throw Exception('Fetch account failed.');
    }

    _account = Account.fromJson(decodedRes['data']);
    _accountId = _account.id;
    notifyListeners();
  }

  Future<void> updateAccount(Account account) async {
    final url = '${Network.host}/api/v2/accounts/$accountId';
    final res = await http.put(url,
        body: json.encode(Account.toMap(account)),
        headers: Network.headers(token: token));

    if (res.statusCode != 200) throw Exception('Failed to update account.');

    Map<String, dynamic> decodedRes = json.decode(res.body);

    print(decodedRes);

    _account = Account.fromJson(decodedRes['data']);
    notifyListeners();
    _storeAccountData();
  }

  Future<void> _storeAccountData() async {
    await _storage.write(
        key: 'accountData', value: json.encode(Account.toMap(_account)));
  }

  Future<void> signup(Map<String, dynamic> userData) async {
    return _authenticate(userData, 'register');
  }

  Future<void> login(Map<String, dynamic> userData) async {
    return _authenticate(userData, 'login');
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _accountId = null;
    _expiryDate = null;
    _user = User.empty();
    _account = Account.empty();
    await _clearStoredData();
    notifyListeners();
  }

  Future<void> _clearStoredData() {
    return Future.wait([
      _storage.delete(key: 'tokenData'),
      _storage.delete(key: 'userData'),
      _storage.delete(key: 'accountData')
    ]);
  }

  Future<bool> tryAutoLogin() async {
    print('trying to auto login');
    final tokenData = await _storage.read(key: 'tokenData');
    print('token: $tokenData');
    if (tokenData == null) {
      return false;
    }

    final extractedTokenData = json.decode(tokenData) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedTokenData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedTokenData['token'];
    _userId = extractedTokenData['userId'];
    _accountId = extractedTokenData['accountId'];
    _expiryDate = expiryDate;

    final userData = await _storage.read(key: 'userData');
    print('user: $userData');
    if (userData == null) {
      return false;
    }

    _user = User.fromJson(json.decode(userData));

    final accountData = await _storage.read(key: 'accountData');
    print('account: $accountData');
    if (accountData == null) {
      return false;
    }

    _account = Account.fromJson(json.decode(accountData));

    print('auto logged in :)');
    notifyListeners();

    return true;
  }
}
