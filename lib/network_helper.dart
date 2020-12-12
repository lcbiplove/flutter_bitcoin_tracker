import 'package:http/http.dart' as http;
import 'dart:convert';

const String kcoinApiURL = 'https://rest.coinapi.io/v1/exchangerate';
const String kapiKey = 'BFD69B9D-11FA-4DCD-9008-3D0ECEA32397';

class NetworkHelper {
  String cryptoUnit;
  Future<int> _getCurrencyRate(String currencyUnit) async {
    var response = await http
        .get('$kcoinApiURL/$cryptoUnit/$currencyUnit?apikey=$kapiKey');
    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      return (decodedData['rate']).toInt();
    } else {
      print(response.statusCode);
    }
    return null;
  }

  Future<int> getBTCRate(String currencyUnit) async {
    cryptoUnit = 'BTC';
    return _getCurrencyRate(currencyUnit);
  }

  Future<int> getETHRate(String currencyUnit) async {
    cryptoUnit = 'ETH';
    return _getCurrencyRate(currencyUnit);
  }

  Future<int> getLTCRate(String currencyUnit) async {
    cryptoUnit = 'LTC';
    return _getCurrencyRate(currencyUnit);
  }
}
