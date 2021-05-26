import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'const.dart';
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'DOGE',
  'BTC',
  'ETH',
];

class CoinData {
  Future getCoinData(
      {@required String selectedCurrency, @required String crypto}) async {
    print('Hi');
    http.Response response = await http.get(Uri.parse(
        'https://rest.coinapi.io/v1/exchangerate/$crypto/$selectedCurrency?apikey=$apiKey'));
    String data = response.body;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      String data = response.body;
      var decodedData = jsonDecode(data);
      print(decodedData['rate']);
      return decodedData['rate'];
    } else
      print(response.statusCode);
  }
}
