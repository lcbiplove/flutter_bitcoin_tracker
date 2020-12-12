import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'network_helper.dart';
import 'package:loading_indicator/loading_indicator.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  var loadingIndicator = LoadingIndicator(
    indicatorType: Indicator.ballRotateChase,
    color: Colors.white,
  );
  int btcCoinValue = 0;
  int ethCoinValue = 0;
  int ltcCoinValue = 0;

  NetworkHelper networkHelper = NetworkHelper();

  CupertinoPicker iosPicker() {
    List<Text> pickerLists = [];
    for (String item in currenciesList) {
      pickerLists.add(Text(item));
    }
    return CupertinoPicker(
      itemExtent: 35.0,
      onSelectedItemChanged: (value) {
        //selectedCurrency = value;
      },
      children: pickerLists,
    );
  }

  DropdownButton androidDropDown() {
    List<DropdownMenuItem<String>> dropDownLists = [];
    for (String item in currenciesList) {
      var eachItem = DropdownMenuItem(
        child: Text(item),
        value: item,
      );
      dropDownLists.add(eachItem);
    }

    return DropdownButton(
      value: selectedCurrency,
      onChanged: (value) async {
        selectedCurrency = value;
        getAllCoinValues();
      },
      items: dropDownLists,
    );
  }

  void getAllCoinValues() async {
    btcCoinValue = await networkHelper.getBTCRate(selectedCurrency);
    ethCoinValue = await networkHelper.getETHRate(selectedCurrency);
    ltcCoinValue = await networkHelper.getLTCRate(selectedCurrency);
    setState(() {
      btcCoinValue;
      ethCoinValue;
      ltcCoinValue;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllCoinValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ReusableCard(
                  selectedCurrency: selectedCurrency,
                  coinValue: btcCoinValue,
                  cryptoUnit: 'BTC',
                ),
                ReusableCard(
                  coinValue: ethCoinValue,
                  selectedCurrency: selectedCurrency,
                  cryptoUnit: 'ETH',
                ),
                ReusableCard(
                  selectedCurrency: selectedCurrency,
                  coinValue: ltcCoinValue,
                  cryptoUnit: 'LTC',
                )
              ],
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker() : androidDropDown(),
          ),
        ],
      ),
    );
  }
}

class ReusableCard extends StatelessWidget {
  ReusableCard(
      {@required this.coinValue,
      @required this.selectedCurrency,
      @required this.cryptoUnit});

  final int coinValue;
  final String selectedCurrency;
  final String cryptoUnit;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlueAccent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
        child: Text(
          '1 $cryptoUnit = ${coinValue ?? '\`ERROR\`'} $selectedCurrency',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
