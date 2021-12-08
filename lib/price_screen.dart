import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bitcoin_ticker/coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';

  CupertinoPicker iOSPicker() {
    List<Text> items = [];
    for (String currency in currenciesList) {
      items.add(Text(
        currency,
        style: const TextStyle(
          color: Colors.white,
        ),
      ));
    }

    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        selectedCurrency = currenciesList[selectedIndex];
        updateRate(selectedCurrency, 'BTC');
      },
      children: items,
    );
  }

  DropdownButton<String> getDropdownButton() {
    List<DropdownMenuItem<String>> items = [];
    for (String currency in currenciesList) {
      items.add(DropdownMenuItem(
        child: Text(
          currency,
        ),
        value: currency,
      ));
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
          updateRate(selectedCurrency, 'BTC');
        });
      },
      items: items,
    );
  }

  Map rates = <String, double>{};

  void updateRate(String fiat, String coin) async {
    Map<String, double> rate = await CoinData().getCurrentRates(fiat: fiat);
    setState(() {
      rates = rate;
    });
  }

  @override
  void initState() {
    super.initState();

    //Get our current rate for USD
    updateRate(selectedCurrency, 'BTC');
  }

  List<Widget> getCoinDataWidgets() {
    List<Widget> coinDataWidgets = [];
    for (String coin in cryptoList) {
      coinDataWidgets.add(
        Card(
          color: Colors.lightBlueAccent,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
            child: Text(
              '1 $coin = ${rates[coin] == null ? 0.00 : rates[coin].toStringAsFixed(2)} $selectedCurrency',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }
    return coinDataWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: getCoinDataWidgets(),
              )),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Center(
              child: Platform.isIOS ? iOSPicker() : getDropdownButton(),
            ),
          ),
        ],
      ),
    );
  }
}
