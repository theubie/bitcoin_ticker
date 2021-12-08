import 'dart:convert';

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
  'BTC',
  'ETH',
  'LTC',
];

const apiKey = '<API-KEY>'; //TODO: Add your coinapi.io API key here.

class CoinData {
  Future<dynamic> getCurrentRates({required String fiat}) async {
    String url =
        'https://rest.coinapi.io/v1/exchangerate/$fiat?invert=true&filter_asset_id=${cryptoList.join(';')}&apikey=$apiKey';

    http.Response response = await http.get(Uri.parse(url));

    var decodedBody = jsonDecode(response.body)['rates'];
    Map rates = <String, double>{};
    for (var r in decodedBody) {
      rates[r['asset_id_quote']] = r['rate'];
    }
    return rates;
  }
}
